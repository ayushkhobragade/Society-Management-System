
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null ||
        !"SECURITY_GUARD".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String name = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Security Guard Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            margin: 0;
            padding: 30px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
        }
        h1 { color: #1f2937; }
        .card {
            background: #eef2ff;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
        }
        a {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 5px;
        }
        .logout { background: #dc2626; }
    </style>
</head>
<body>
<div class="container">
    <h1>Security Guard Dashboard</h1>
    <p>Welcome, <%= name == null ? "Security Guard" : name %>!</p>

    <div class="card">
        <h3>Visitor Entry</h3>
        <p>Register new visitors entering the society.</p>
        <a href="<%= request.getContextPath() %>/security/visitor-entry.jsp">
            Add Visitor
        </a>
    </div>

    <div class="card">
        <h3>Visitor Records</h3>
        <p>View visitor details and entry/exit records.</p>
        <a href="<%= request.getContextPath() %>/VisitorListServlet">
            View Visitors
        </a>
    </div>

    <a class="logout" href="<%= request.getContextPath() %>/LogoutServlet">
        Logout
    </a>
</div>
</body>
</html>

