import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;

@WebServlet("/MemberEditServlet")
public class MemberEditServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECRETARY".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String memberId = request.getParameter("member_id");
        String fullName = request.getParameter("full_name");
        String flatNumber = request.getParameter("flat_number");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String joiningDate = request.getParameter("joining_date");
        String status = request.getParameter("status");

        if (memberId == null || !memberId.matches("[0-9]+") ||
            fullName == null || fullName.trim().isEmpty() ||
            flatNumber == null || flatNumber.trim().isEmpty() ||
            phone == null || !phone.matches("[0-9]{10}") ||
            status == null ||
            !(status.equals("ACTIVE") || status.equals("INACTIVE"))) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter valid member details."
            );
            return;
        }

        String sql = "UPDATE members SET full_name=?, flat_number=?, " +
                     "phone=?, email=?, joining_date=?, status=? " +
                     "WHERE member_id=?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, fullName.trim());
            ps.setString(2, flatNumber.trim());
            ps.setString(3, phone);

            if (email == null || email.trim().isEmpty()) {
                ps.setNull(4, Types.VARCHAR);
            } else {
                ps.setString(4, email.trim());
            }

            if (joiningDate == null || joiningDate.trim().isEmpty()) {
                ps.setNull(5, Types.DATE);
            } else {
                ps.setDate(5, java.sql.Date.valueOf(joiningDate));
            }

            ps.setString(6, status);
            ps.setInt(7, Integer.parseInt(memberId));

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect(
                    request.getContextPath() +
                    "/MemberListServlet?updated=success"
                );
            } else {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Member not found."
                );
            }

        } catch (IllegalArgumentException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid joining date."
            );
        } catch (Exception e) {
            throw new ServletException("Unable to update member.", e);
        }
    }
}