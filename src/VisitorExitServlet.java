
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/VisitorExitServlet")
public class VisitorExitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECURITY_GUARD".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int visitorId;

        try {
            visitorId = Integer.parseInt(request.getParameter("visitor_id"));

            if (visitorId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/VisitorListServlet?error=invalid"
            );
            return;
        }

        String sql = "UPDATE visitor_records " +
                     "SET exit_time = CURRENT_TIMESTAMP " +
                     "WHERE visitor_id = ? AND exit_time IS NULL";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, visitorId);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                response.sendRedirect(
                    request.getContextPath() + "/VisitorListServlet?updated=success"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/VisitorListServlet?error=notfound"
                );
            }

        } catch (Exception e) {
            throw new ServletException("Unable to update visitor exit time.", e);
        }
    }
}


