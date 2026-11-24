
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

@WebServlet("/MemberEditPageServlet")
public class MemberEditPageServlet extends HttpServlet {

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

        String id = request.getParameter("id");

        if (id == null || !id.matches("[0-9]+")) {
            response.sendError(400, "Invalid Member ID");
            return;
        }

        String sql = "SELECT * FROM members WHERE member_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, Integer.parseInt(id));

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    request.setAttribute("memberId",
                        rs.getString("member_id"));

                    request.setAttribute("fullName",
                        rs.getString("full_name"));

                    request.setAttribute("flatNumber",
                        rs.getString("flat_number"));

                    request.setAttribute("phone",
                        rs.getString("phone"));

                    request.setAttribute("email",
                        rs.getString("email"));

                    request.setAttribute("joiningDate",
                        rs.getString("joining_date"));

                    request.setAttribute("status",
                        rs.getString("status"));

                    request.getRequestDispatcher(
                        "/secretary/edit-member.jsp"
                    ).forward(request, response);

                } else {
                    response.sendError(404, "Member not found");
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load member details.", e
            );
        }
    }
}