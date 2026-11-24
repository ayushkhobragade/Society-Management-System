
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/MemberDeleteServlet")
public class MemberDeleteServlet extends HttpServlet {

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

        String id = request.getParameter("member_id");

        if (id == null || !id.matches("[0-9]+")) {
            response.sendError(400, "Invalid Member ID");
            return;
        }

        String sql = "DELETE FROM members WHERE member_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(id));

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect(
                    request.getContextPath() +
                    "/MemberListServlet?deleted=success"
                );
            } else {
                response.sendError(404, "Member not found");
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to delete member.", e
            );
        }
    }
}
