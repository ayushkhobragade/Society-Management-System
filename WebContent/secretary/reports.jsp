
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    long totalMembers = (Long) request.getAttribute("totalMembers");
    long activeMembers = (Long) request.getAttribute("activeMembers");
    long inactiveMembers = (Long) request.getAttribute("inactiveMembers");

    long totalStaff = (Long) request.getAttribute("totalStaff");
    long activeStaff = (Long) request.getAttribute("activeStaff");

    long pendingBills = (Long) request.getAttribute("pendingBills");
    long paidBills = (Long) request.getAttribute("paidBills");
    java.math.BigDecimal pendingAmount =
        (java.math.BigDecimal) request.getAttribute("pendingAmount");

    long totalComplaints = (Long) request.getAttribute("totalComplaints");
    long pendingComplaints = (Long) request.getAttribute("pendingComplaints");
    long inProgressComplaints = (Long) request.getAttribute("inProgressComplaints");
    long resolvedComplaints = (Long) request.getAttribute("resolvedComplaints");

    long totalVisitors = (Long) request.getAttribute("totalVisitors");
    long visitorsInside = (Long) request.getAttribute("visitorsInside");

    long totalNotices = (Long) request.getAttribute("totalNotices");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Society Reports</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 25px;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #333;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        h1 {
            margin: 0;
            color: #26374a;
        }

        .back-btn {
            background: #26374a;
            color: white;
            padding: 10px 16px;
            text-decoration: none;
            border-radius: 5px;
        }

        .section-title {
            margin: 28px 0 15px;
            color: #26374a;
            font-size: 21px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 16px;
        }

        .card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-left: 5px solid #3678c8;
        }

        .card h3 {
            margin: 0 0 12px;
            font-size: 15px;
            color: #666;
        }

        .number {
            font-size: 27px;
            font-weight: bold;
            color: #26374a;
        }

        .green {
            border-left-color: #249b63;
        }

        .orange {
            border-left-color: #e59b28;
        }

        .red {
            border-left-color: #d9534f;
        }

        .purple {
            border-left-color: #8055b5;
        }

        @media (max-width: 600px) {
            body {
                padding: 15px;
            }

            .header {
                gap: 15px;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <h1>Society Reports</h1>
        <a class="back-btn"
           href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
            Back to Dashboard
        </a>
    </div>

    <h2 class="section-title">Member Reports</h2>

    <div class="grid">
        <div class="card">
            <h3>Total Members</h3>
            <div class="number"><%= totalMembers %></div>
        </div>

        <div class="card green">
            <h3>Active Members</h3>
            <div class="number"><%= activeMembers %></div>
        </div>

        <div class="card red">
            <h3>Inactive Members</h3>
            <div class="number"><%= inactiveMembers %></div>
        </div>
    </div>

    <h2 class="section-title">Cleaning Staff Reports</h2>

    <div class="grid">
        <div class="card purple">
            <h3>Total Cleaning Staff</h3>
            <div class="number"><%= totalStaff %></div>
        </div>

        <div class="card green">
            <h3>Active Staff</h3>
            <div class="number"><%= activeStaff %></div>
        </div>
    </div>

    <h2 class="section-title">Maintenance Reports</h2>

    <div class="grid">
        <div class="card orange">
            <h3>Pending Maintenance Amount</h3>
            <div class="number">
                ₹<%= pendingAmount == null ? "0.00" : pendingAmount.toPlainString() %>
            </div>
        </div>

        <div class="card red">
            <h3>Pending Bills</h3>
            <div class="number"><%= pendingBills %></div>
        </div>

        <div class="card green">
            <h3>Paid Bills</h3>
            <div class="number"><%= paidBills %></div>
        </div>
    </div>

    <h2 class="section-title">Complaint Reports</h2>

    <div class="grid">
        <div class="card">
            <h3>Total Complaints</h3>
            <div class="number"><%= totalComplaints %></div>
        </div>

        <div class="card red">
            <h3>Pending Complaints</h3>
            <div class="number"><%= pendingComplaints %></div>
        </div>

        <div class="card orange">
            <h3>In Progress</h3>
            <div class="number"><%= inProgressComplaints %></div>
        </div>

        <div class="card green">
            <h3>Resolved Complaints</h3>
            <div class="number"><%= resolvedComplaints %></div>
        </div>
    </div>

    <h2 class="section-title">Visitor Reports</h2>

    <div class="grid">
        <div class="card">
            <h3>Total Visitors</h3>
            <div class="number"><%= totalVisitors %></div>
        </div>

        <div class="card orange">
            <h3>Currently Inside</h3>
            <div class="number"><%= visitorsInside %></div>
        </div>
    </div>

    <h2 class="section-title">Notice Reports</h2>

    <div class="grid">
        <div class="card purple">
            <h3>Total Notices</h3>
            <div class="number"><%= totalNotices %></div>
        </div>
    </div>

</div>

</body>
</html>
