
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
import java.math.BigDecimal;

@WebServlet("/SocietyReportsServlet")
public class SocietyReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECRETARY".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String sql =
            "SELECT " +

            "(SELECT COUNT(*) FROM members) AS totalMembers, " +
            "(SELECT COUNT(*) FROM members WHERE status='ACTIVE') AS activeMembers, " +
            "(SELECT COUNT(*) FROM members WHERE status='INACTIVE') AS inactiveMembers, " +

            "(SELECT COUNT(*) FROM cleaning_staff) AS totalStaff, " +
            "(SELECT COUNT(*) FROM cleaning_staff WHERE status='ACTIVE') AS activeStaff, " +

            "(SELECT COUNT(*) FROM maintenance WHERE payment_status='PENDING') AS pendingBills, " +
            "(SELECT COUNT(*) FROM maintenance WHERE payment_status='PAID') AS paidBills, " +
            "(SELECT COALESCE(SUM(amount),0) FROM maintenance WHERE payment_status='PENDING') AS pendingAmount, " +

            "(SELECT COUNT(*) FROM complaints) AS totalComplaints, " +
            "(SELECT COUNT(*) FROM complaints WHERE status='PENDING') AS pendingComplaints, " +
            "(SELECT COUNT(*) FROM complaints WHERE status='IN_PROGRESS') AS inProgressComplaints, " +
            "(SELECT COUNT(*) FROM complaints WHERE status='RESOLVED') AS resolvedComplaints, " +

            "(SELECT COUNT(*) FROM visitor_records) AS totalVisitors, " +
            "(SELECT COUNT(*) FROM visitor_records WHERE exit_time IS NULL) AS visitorsInside, " +

            "(SELECT COUNT(*) FROM notices) AS totalNotices";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                request.setAttribute("totalMembers",
                        rs.getLong("totalMembers"));

                request.setAttribute("activeMembers",
                        rs.getLong("activeMembers"));

                request.setAttribute("inactiveMembers",
                        rs.getLong("inactiveMembers"));

                request.setAttribute("totalStaff",
                        rs.getLong("totalStaff"));

                request.setAttribute("activeStaff",
                        rs.getLong("activeStaff"));

                request.setAttribute("pendingBills",
                        rs.getLong("pendingBills"));

                request.setAttribute("paidBills",
                        rs.getLong("paidBills"));

                BigDecimal pendingAmount =
                        rs.getBigDecimal("pendingAmount");

                request.setAttribute("pendingAmount",
                        pendingAmount);

                request.setAttribute("totalComplaints",
                        rs.getLong("totalComplaints"));

                request.setAttribute("pendingComplaints",
                        rs.getLong("pendingComplaints"));

                request.setAttribute("inProgressComplaints",
                        rs.getLong("inProgressComplaints"));

                request.setAttribute("resolvedComplaints",
                        rs.getLong("resolvedComplaints"));

                request.setAttribute("totalVisitors",
                        rs.getLong("totalVisitors"));

                request.setAttribute("visitorsInside",
                        rs.getLong("visitorsInside"));

                request.setAttribute("totalNotices",
                        rs.getLong("totalNotices"));
            }

            request.getRequestDispatcher(
                "/secretary/reports.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            throw new ServletException(
                "Unable to load society reports.", e
            );
        }
    }
}
