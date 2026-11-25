
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");

    if (role == null || !role.equals("MEMBER")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String name = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member Dashboard</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6f9;
        }

        .sidebar {
            width: 240px;
            height: 100vh;
            background: #263445;
            color: white;
            position: fixed;
            padding: 25px 15px;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 35px;
        }

        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 14px;
            margin-bottom: 10px;
            border-radius: 5px;
        }

        .sidebar a:hover {
            background: #3d526b;
        }

        .main {
            margin-left: 240px;
            padding: 35px;
        }

        .welcome {
            margin-bottom: 30px;
        }

        .welcome h1 {
            color: #263445;
            margin-bottom: 10px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .card h3 {
            color: #263445;
            margin-bottom: 12px;
        }

        .card p {
            color: #666;
            margin-bottom: 18px;
        }

        .card a {
            display: inline-block;
            background: #263445;
            color: white;
            padding: 10px 16px;
            border-radius: 5px;
            text-decoration: none;
        }

        .card a:hover {
            background: #3d526b;
        }

        .coming {
            color: #888;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h2>Society Portal</h2>

    <a href="dashboard.jsp">Dashboard</a>
    <a href="<%= request.getContextPath() %>/MemberNoticeListServlet">Notices</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
</div>

<div class="main">

    <div class="welcome">
        <h1>Welcome, <%= name != null ? name : "Member" %>!</h1>
        <p>Member Dashboard - Society Management System</p>
    </div>

    <div class="cards">

        <div class="card">
            <h3>Society Notices</h3>
            <p>View the latest notices published by the society secretary.</p>
            <a href="<%= request.getContextPath() %>/MemberNoticeListServlet">
                View Notices
            </a>
        </div>

        <div class="card">
            <h3>Maintenance Details</h3>
            <p>View your society maintenance charges and payment details.</p>
            <span class="coming">Coming Soon</span>
        </div>

        <div class="card">
            <h3>Society Information</h3>
            <p>View important society-related information.</p>
            <span class="coming">Coming Soon</span>
        </div>

    </div>

</div>

</body>
</html>
