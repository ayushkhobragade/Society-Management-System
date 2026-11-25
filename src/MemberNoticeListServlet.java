
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

@WebServlet("/MemberNoticeListServlet")
public class MemberNoticeListServlet extends HttpServlet {

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

        List<Map<String, String>> notices = new ArrayList<>();

        String sql = "SELECT notice_id, title, description, notice_date " +
                     "FROM notices ORDER BY notice_date DESC, notice_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> notice = new HashMap<>();

                notice.put("title", rs.getString("title"));
                notice.put("description", rs.getString("description"));
                notice.put("noticeDate", rs.getString("notice_date"));

                notices.add(notice);
            }

            request.setAttribute("notices", notices);

            request.getRequestDispatcher(
                "/member/notices.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load society notices.", e
            );
        }
    }
}
