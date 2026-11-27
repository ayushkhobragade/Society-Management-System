
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/CleaningStaffDeleteServlet")
public class CleaningStaffDeleteServlet extends HttpServlet {

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

        String id = request.getParameter("staff_id");

        if (id == null || !id.matches("\\d+")) {
            response.sendRedirect(
                request.getContextPath()
                + "/CleaningStaffListServlet?error=invalid"
            );
            return;
        }

        String sql = "DELETE FROM cleaning_staff WHERE staff_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(id));

            int deleted = ps.executeUpdate();

            if (deleted > 0) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/CleaningStaffListServlet?deleted=success"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath()
                    + "/CleaningStaffListServlet?error=notfound"
                );
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to delete cleaning staff record.", e
            );
        }
    }
}
