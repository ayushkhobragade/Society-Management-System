
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
    <link rel="stylesheet" href="../css/secretary.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>

<div class="dashboard-container">

    <aside class="sidebar">

        <h2>Society MS</h2>

        <p class="menu-heading">MAIN MENU</p>

        <a href="dashboard.jsp" class="active">Dashboard</a>
        <a href="#">Members</a>
        <a href="#">Maintenance</a>
        <a href="#">Complaints</a>
        <a href="#">Notices</a>
        <a href="#">Visitors</a>
        <a href="#">Cleaning Staff</a>

        <div class="sidebar-footer">
            <a href="../LogoutServlet">Logout</a>
        </div>

    </aside>

    <main class="main-content">

        <header class="topbar">
            <h2>Secretary Dashboard</h2>
            <span>Secretary: <%= name %></span>
        </header>

        <section class="welcome-section">
            <h1>Welcome, <%= name %>!</h1>
            <p>Manage your society activities from one place.</p>
        </section>

        <section class="dashboard-section">

            <h2>Dashboard Overview</h2>

            <div class="card-container">

                <div class="dashboard-card">
                    <h3>Members</h3>
                    <p>Manage Society Members</p>
                </div>

                <div class="dashboard-card">
                    <h3>Maintenance</h3>
                    <p>Manage Maintenance Charges</p>
                </div>

                <div class="dashboard-card">
                    <h3>Complaints</h3>
                    <p>View and Manage Complaints</p>
                </div>

                <div class="dashboard-card">
                    <h3>Notices</h3>
                    <p>Create and Manage Notices</p>
                </div>

                <div class="dashboard-card">
                    <h3>Visitors</h3>
                    <p>View Visitor Records</p>
                </div>

                <div class="dashboard-card">
                    <h3>Cleaning Staff</h3>
                    <p>Manage Staff Information</p>
                </div>

            </div>

        </section>

    </main>

</div>

</body>
</html>
