
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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/VisitorListServlet")
public class VisitorListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECURITY_GUARD".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Map<String, Object>> visitors = new ArrayList<>();

        String sql = "SELECT visitor_id, visitor_name, phone, flat_number, " +
                     "purpose, entry_time, exit_time " +
                     "FROM visitor_records ORDER BY entry_time DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> visitor = new HashMap<>();

                Timestamp entry = rs.getTimestamp("entry_time");
                Timestamp exit = rs.getTimestamp("exit_time");

                visitor.put("visitorId", rs.getInt("visitor_id"));
                visitor.put("visitorName", rs.getString("visitor_name"));
                visitor.put("phone", rs.getString("phone"));
                visitor.put("flatNumber", rs.getString("flat_number"));
                visitor.put("purpose", rs.getString("purpose"));
                visitor.put("entryTime", entry == null ? "" : entry.toString());
                visitor.put("exitTime", exit == null ? null : exit.toString());

                visitors.add(visitor);
            }

            request.setAttribute("visitors", visitors);

            request.getRequestDispatcher("/security/visitor-list.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load visitor records.", e);
        }
    }
}
