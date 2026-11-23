
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

import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "SELECT user_id, name, password, role " +
                     "FROM users " +
                     "WHERE username = ? AND status = 'ACTIVE'";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    String storedHash = rs.getString("password");

                    if (BCrypt.checkpw(password, storedHash)) {

                        String role = rs.getString("role");

                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getInt("user_id"));
                        session.setAttribute("name", rs.getString("name"));
                        session.setAttribute("role", role);

                        if ("SECRETARY".equals(role)) {

                            response.sendRedirect(
                                request.getContextPath() +
                                "/secretary/dashboard.jsp"
                            );

                        } else if ("MEMBER".equals(role)) {

                            response.sendRedirect(
                                request.getContextPath() +
                                "/member/dashboard.jsp"
                            );

                        } else if ("SECURITY_GUARD".equals(role)) {

                            response.sendRedirect(
                                request.getContextPath() +
                                "/security/dashboard.jsp"
                            );

                        } else {
                            session.invalidate();
                            response.sendError(
                                HttpServletResponse.SC_FORBIDDEN
                            );
                        }

                    } else {
                        response.sendRedirect(
                            request.getContextPath() +
                            "/login.jsp?error=invalid"
                        );
                    }

                } else {
                    response.sendRedirect(
                        request.getContextPath() +
                        "/login.jsp?error=invalid"
                    );
                }
            }

        } catch (Exception e) {
            throw new ServletException("Login process failed.", e);
        }
    }
}
