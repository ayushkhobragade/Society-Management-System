
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/MaintenanceAddServlet")
public class MaintenanceAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
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

        request.setCharacterEncoding("UTF-8");

        String memberId = request.getParameter("member_id");
        String billingMonth = request.getParameter("billing_month");
        String amount = request.getParameter("amount");
        String dueDate = request.getParameter("due_date");

        if (memberId == null || memberId.trim().isEmpty() ||
            billingMonth == null || billingMonth.trim().isEmpty() ||
            amount == null || amount.trim().isEmpty() ||
            dueDate == null || dueDate.trim().isEmpty()) {

            response.sendError(400, "All fields are required.");
            return;
        }

        try {
            int id = Integer.parseInt(memberId);
            BigDecimal billAmount = new BigDecimal(amount);

            if (id <= 0 || billAmount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendError(400, "Invalid member or amount.");
                return;
            }

            if (!billingMonth.matches("\\d{4}-\\d{2}")) {
                response.sendError(400, "Invalid billing month.");
                return;
            }

            String sql = "INSERT INTO maintenance " +
                         "(member_id, billing_month, amount, due_date) " +
                         "VALUES (?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);
                ps.setString(2, billingMonth);
                ps.setBigDecimal(3, billAmount);
                ps.setDate(4, Date.valueOf(dueDate));

                ps.executeUpdate();
            }

            response.sendRedirect(
                request.getContextPath() +
                "/secretary/add-maintenance.jsp?added=success"
            );

       } catch (IllegalArgumentException e) {
            response.sendError(400, "Invalid input. Please check the details.");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to add maintenance bill.", e
            );
        }
    }
}
