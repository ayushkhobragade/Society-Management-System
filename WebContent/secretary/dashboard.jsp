<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession(false);

    if (userSession == null ||
        userSession.getAttribute("userId") == null ||
        !"SECRETARY".equals(userSession.getAttribute("role"))) {

        response.sendRedirect("../login.jsp");
        return;
    }

    String name = (String) userSession.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Secretary Dashboard</title>
</head>
<body>

    <h1>Society Management System</h1>

    <h2>Secretary Dashboard</h2>

    <h3>Welcome, <%= name %></h3>

    <hr>

    <h3>Dashboard Modules</h3>

    <ul>
        <li>Member Management</li>
        <li>Maintenance Management</li>
        <li>Complaint Management</li>
        <li>Notice Management</li>
        <li>Visitor Records</li>
        <li>Cleaning Staff Management</li>
    </ul>

</body>
</html>