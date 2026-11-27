
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/CleaningStaffAddServlet")
public class CleaningStaffAddServlet extends HttpServlet {

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

        String name = request.getParameter("staff_name");
        String phone = request.getParameter("phone");
        String dutyTime = request.getParameter("duty_time");
        String salaryText = request.getParameter("salary");
        String joiningDate = request.getParameter("joining_date");

        if (name == null || name.trim().isEmpty() ||
            phone == null || !phone.matches("[0-9]{10,15}") ||
            dutyTime == null || dutyTime.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath()
                    + "/secretary/cleaning-staff-add.jsp?error=invalid");
            return;
        }

        try {
            double salary = 0;

            if (salaryText != null && !salaryText.trim().isEmpty()) {
                salary = Double.parseDouble(salaryText);

                if (salary < 0) {
                    throw new NumberFormatException();
                }
            }

            Date date = null;

            if (joiningDate != null && !joiningDate.trim().isEmpty()) {
                date = Date.valueOf(joiningDate);
            }

            String sql = "INSERT INTO cleaning_staff " +
                    "(staff_name, phone, duty_time, salary, joining_date) " +
                    "VALUES (?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name.trim());
                ps.setString(2, phone.trim());
                ps.setString(3, dutyTime.trim());
                ps.setDouble(4, salary);

                if (date == null) {
                    ps.setNull(5, java.sql.Types.DATE);
                } else {
                    ps.setDate(5, date);
                }

                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath()
                    + "/secretary/cleaning-staff-add.jsp?added=success");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/secretary/cleaning-staff-add.jsp?error=invalid");

        } catch (Exception e) {
            throw new ServletException("Unable to add cleaning staff.", e);
        }
    }
}
