
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

@WebServlet("/MemberMaintenanceServlet")
public class MemberMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"MEMBER".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (userIdObject == null) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Member account is not linked."
            );
            return;
        }

        String sql =
            "SELECT m.billing_month, m.amount, m.due_date, " +
            "m.payment_status " +
            "FROM maintenance m " +
            "JOIN members mem ON m.member_id = mem.member_id " +
            "WHERE mem.user_id = ? " +
            "ORDER BY m.due_date DESC";

        List<Map<String, String>> bills = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(userIdObject.toString()));

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, String> bill = new HashMap<>();

                    bill.put("billing_month",
                             rs.getString("billing_month"));

                    bill.put("amount",
                             rs.getString("amount"));

                    bill.put("due_date",
                             rs.getString("due_date"));

                    bill.put("payment_status",
                             rs.getString("payment_status"));

                    bills.add(bill);
                }
            }

            request.setAttribute("bills", bills);

            request.getRequestDispatcher(
                "/member/maintenance.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load maintenance details.", e
            );
        }
    }
}
