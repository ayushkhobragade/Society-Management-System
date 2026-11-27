
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/VisitorAddServlet")
public class VisitorAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"SECURITY_GUARD".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (userIdObject == null) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Security Guard account not found."
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String visitorName = request.getParameter("visitor_name");
        String phone = request.getParameter("phone");
        String flatNumber = request.getParameter("flat_number");
        String purpose = request.getParameter("purpose");

        if (visitorName == null || visitorName.trim().isEmpty() ||
            phone == null || !phone.matches("[0-9]{10,15}") ||
            flatNumber == null || flatNumber.trim().isEmpty() ||
            purpose == null || purpose.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath() +
                "/security/visitor-entry.jsp?error=invalid"
            );
            return;
        }

        String sql =
            "INSERT INTO visitor_records " +
            "(visitor_name, phone, flat_number, purpose, recorded_by) " +
            "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, visitorName.trim());
            ps.setString(2, phone.trim());
            ps.setString(3, flatNumber.trim());
            ps.setString(4, purpose.trim());
            ps.setInt(5, Integer.parseInt(userIdObject.toString()));

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() +
                "/security/visitor-entry.jsp?added=success"
            );

        } catch (Exception e) {

            throw new ServletException(
                "Unable to save visitor record.", e
            );
        }
    }
}

