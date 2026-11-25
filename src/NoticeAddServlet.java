
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

@WebServlet("/NoticeAddServlet")
public class NoticeAddServlet extends HttpServlet {

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

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String noticeDate = request.getParameter("notice_date");

        if (title == null || title.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            noticeDate == null || noticeDate.trim().isEmpty()) {

            response.sendError(400, "All fields are required.");
            return;
        }

        Object userId = session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String sql = "INSERT INTO notices " +
                     "(title, description, notice_date, created_by) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setDate(3, Date.valueOf(noticeDate));
            ps.setInt(4, Integer.parseInt(userId.toString()));

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() +
                "/NoticeListServlet?added=success"
            );

        } catch (IllegalArgumentException e) {
            response.sendError(400, "Invalid notice date or user ID.");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to add notice.", e
            );
        }
    }
}
