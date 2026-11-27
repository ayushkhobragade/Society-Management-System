
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

@WebServlet("/MemberComplaintsServlet")
public class MemberComplaintsServlet extends HttpServlet {

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
            "SELECT c.complaint_id, c.subject, c.description, " +
            "c.complaint_date, c.status " +
            "FROM complaints c " +
            "JOIN members m ON c.member_id = m.member_id " +
            "WHERE m.user_id = ? " +
            "ORDER BY c.complaint_date DESC";

        List<Map<String, String>> complaints = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(userIdObject.toString()));

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, String> complaint = new HashMap<>();

                    complaint.put("complaint_id",
                                  rs.getString("complaint_id"));

                    complaint.put("subject",
                                  rs.getString("subject"));

                    complaint.put("description",
                                  rs.getString("description"));

                    complaint.put("complaint_date",
                                  rs.getString("complaint_date"));

                    complaint.put("status",
                                  rs.getString("status"));

                    complaints.add(complaint);
                }
            }

            request.setAttribute("complaints", complaints);

            request.getRequestDispatcher(
                "/member/my-complaints.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load member complaints.", e
            );
        }
    }
}
