import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;

@WebServlet("/MemberAddServlet")
public class MemberAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("full_name");
        String flatNumber = request.getParameter("flat_number");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String joiningDate = request.getParameter("joining_date");

        if (fullName == null || fullName.trim().isEmpty() ||
            flatNumber == null || flatNumber.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Name, Flat Number and Phone are required."
            );
            return;
        }

        String sql = "INSERT INTO members " +
                     "(full_name, flat_number, phone, email, joining_date) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, fullName.trim());
            ps.setString(2, flatNumber.trim());
            ps.setString(3, phone.trim());

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

            int result = ps.executeUpdate();

            if (result > 0) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println(
                    "<h2>Member added successfully!</h2>"
                );
            }

        } catch (Exception e) {
            throw new ServletException("Unable to add member.", e);
        }
    }
}