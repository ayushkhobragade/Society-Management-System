
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/MaintenanceStatusUpdateServlet")
public class MaintenanceStatusUpdateServlet extends HttpServlet {

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

        String idValue = request.getParameter("maintenance_id");
        String status = request.getParameter("payment_status");

        int maintenanceId;

        try {
            maintenanceId = Integer.parseInt(idValue);

            if (maintenanceId <= 0) {
                throw new NumberFormatException();
            }

        } catch (Exception e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid maintenance ID."
            );
            return;
        }

        if (!"PAID".equals(status) && !"PENDING".equals(status)) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid payment status."
            );
            return;
        }

        String sql =
            "UPDATE maintenance SET payment_status = ? " +
            "WHERE maintenance_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, maintenanceId);

            int updated = ps.executeUpdate();

            if (updated == 0) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Maintenance bill not found."
                );
                return;
            }

            response.sendRedirect(
                request.getContextPath() +
                "/SecretaryMaintenanceListServlet?updated=success"
            );

        } catch (Exception e) {
            throw new ServletException(
                "Unable to update payment status.", e
            );
        }
    }
}
