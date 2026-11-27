
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/CleaningStaffListServlet")
public class CleaningStaffListServlet extends HttpServlet {

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

        List<Map<String, Object>> staffList = new ArrayList<>();

        String sql = "SELECT staff_id, staff_name, phone, duty_time, " +
                     "salary, joining_date, status " +
                     "FROM cleaning_staff ORDER BY staff_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> staff = new HashMap<>();

                staff.put("staffId", rs.getInt("staff_id"));
                staff.put("staffName", rs.getString("staff_name"));
                staff.put("phone", rs.getString("phone"));
                staff.put("dutyTime", rs.getString("duty_time"));
                staff.put("salary", rs.getBigDecimal("salary"));
                staff.put("joiningDate", rs.getDate("joining_date"));
                staff.put("status", rs.getString("status"));

                staffList.add(staff);
            }

            request.setAttribute("staffList", staffList);

            request.getRequestDispatcher(
                "/secretary/cleaning-staff-list.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load cleaning staff records.", e
            );
        }
    }
}
