
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

@WebServlet("/MaintenancePageServlet")
public class MaintenancePageServlet extends HttpServlet {

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

        String sql = "SELECT member_id, full_name, flat_number " +
                     "FROM members WHERE status='ACTIVE' " +
                     "ORDER BY full_name";

        List<Map<String, String>> members = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, String> member = new HashMap<>();

                member.put("member_id", rs.getString("member_id"));
                member.put("full_name", rs.getString("full_name"));
                member.put("flat_number", rs.getString("flat_number"));

                members.add(member);
            }

            request.setAttribute("members", members);

            request.getRequestDispatcher(
                "/secretary/add-maintenance.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load members for maintenance.", e
            );
        }
    }
}
