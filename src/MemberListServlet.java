
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

@WebServlet("/MemberListServlet")
public class MemberListServlet extends HttpServlet {

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

        String sql = "SELECT member_id, full_name, flat_number, " +
                     "phone, email, joining_date, status " +
                     "FROM members ORDER BY member_id DESC";

        List<Map<String, String>> members = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Map<String, String> member = new HashMap<>();

                member.put("member_id", rs.getString("member_id"));
                member.put("full_name", rs.getString("full_name"));
                member.put("flat_number", rs.getString("flat_number"));
                member.put("phone", rs.getString("phone"));
                member.put("email", rs.getString("email"));
                member.put("joining_date", rs.getString("joining_date"));
                member.put("status", rs.getString("status"));

                members.add(member);
            }

            request.setAttribute("members", members);

            request.getRequestDispatcher(
                "/secretary/members.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to fetch member records.", e
            );
        }
    }
}