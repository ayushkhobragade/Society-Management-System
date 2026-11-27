
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ComplaintStatusUpdateServlet")
public class ComplaintStatusUpdateServlet extends HttpServlet {

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

        String complaintId = request.getParameter("complaint_id");
        String status = request.getParameter("status");

        if (complaintId == null || status == null ||
            !status.matches("PENDING|IN_PROGRESS|RESOLVED")) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid complaint ID or status."
            );
            return;
        }

        try {
            int id = Integer.parseInt(complaintId);

            String sql =
                "UPDATE complaints SET status = ? WHERE complaint_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setInt(2, id);

                int updated = ps.executeUpdate();

                if (updated == 0) {
                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Complaint not found."
                    );
                    return;
                }
            }

            response.sendRedirect(
                request.getContextPath() +
                "/SecretaryComplaintsServlet?updated=success"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid complaint ID."
            );

        } catch (Exception e) {

            throw new ServletException(
                "Unable to update complaint status.", e
            );
        }
    }
}
