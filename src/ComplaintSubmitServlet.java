
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ComplaintSubmitServlet")
public class ComplaintSubmitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
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

        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        if (subject == null || subject.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Subject and description are required."
            );
            return;
        }

        String sql =
            "INSERT INTO complaints " +
            "(member_id, subject, description) " +
            "SELECT member_id, ?, ? FROM members WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, subject.trim());
            ps.setString(2, description.trim());
            ps.setInt(3, Integer.parseInt(userIdObject.toString()));

            int inserted = ps.executeUpdate();

            if (inserted == 0) {
                response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No member record is linked to this account."
                );
                return;
            }

            response.sendRedirect(
                request.getContextPath() +
                "/member/complaint.jsp?submitted=success"
            );

        } catch (Exception e) {
            throw new ServletException(
                "Unable to submit complaint.", e
            );
        }
    }
}
