
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/CleaningStaffEditServlet")
public class CleaningStaffEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECRETARY".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("id");

        if (id == null || !id.matches("\\d+")) {
            response.sendRedirect(request.getContextPath()
                    + "/CleaningStaffListServlet?error=invalid");
            return;
        }

        String sql = "SELECT * FROM cleaning_staff WHERE staff_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(id));

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    request.setAttribute("staffId", rs.getInt("staff_id"));
                    request.setAttribute("staffName", rs.getString("staff_name"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("dutyTime", rs.getString("duty_time"));
                    request.setAttribute("salary", rs.getBigDecimal("salary"));
                    request.setAttribute("joiningDate", rs.getDate("joining_date"));
                    request.setAttribute("status", rs.getString("status"));

                    request.getRequestDispatcher(
                            "/secretary/cleaning-staff-edit.jsp"
                    ).forward(request, response);

                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/CleaningStaffListServlet?error=notfound");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load staff details.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECRETARY".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String id = request.getParameter("staff_id");
        String name = request.getParameter("staff_name");
        String phone = request.getParameter("phone");
        String duty = request.getParameter("duty_time");
        String salaryText = request.getParameter("salary");
        String date = request.getParameter("joining_date");
        String status = request.getParameter("status");

        if (id == null || !id.matches("\\d+") ||
            name == null || name.trim().isEmpty() ||
            phone == null || !phone.matches("\\d{10,15}") ||
            duty == null || duty.trim().isEmpty() ||
            status == null ||
            !(status.equals("ACTIVE") || status.equals("INACTIVE"))) {

            response.sendRedirect(request.getContextPath()
                    + "/CleaningStaffListServlet?error=invalid");
            return;
        }

        try {
            double salary = 0;

            if (salaryText != null && !salaryText.trim().isEmpty()) {
                salary = Double.parseDouble(salaryText);

                if (!Double.isFinite(salary) || salary < 0) {
                    throw new IllegalArgumentException("Invalid salary");
                }
            }

            String sql = "UPDATE cleaning_staff SET staff_name=?, phone=?, " +
                    "duty_time=?, salary=?, joining_date=?, status=? " +
                    "WHERE staff_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name.trim());
                ps.setString(2, phone.trim());
                ps.setString(3, duty.trim());
                ps.setDouble(4, salary);

                if (date == null || date.trim().isEmpty()) {
                    ps.setNull(5, java.sql.Types.DATE);
                } else {
                    ps.setDate(5, java.sql.Date.valueOf(date));
                }

                ps.setString(6, status);
                ps.setInt(7, Integer.parseInt(id));

                int updated = ps.executeUpdate();

                if (updated > 0) {
                    response.sendRedirect(request.getContextPath()
                            + "/CleaningStaffListServlet?updated=success");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/CleaningStaffListServlet?error=notfound");
                }
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/CleaningStaffListServlet?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Unable to update staff details.", e);
        }
    }
}
