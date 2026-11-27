
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"MEMBER".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> complaints =
        (List<Map<String, String>>) request.getAttribute("complaints");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Complaints</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h2 {
            color: #263445;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #263445;
            color: white;
        }

        tr:nth-child(even) {
            background: #f4f6f9;
        }

        .pending {
            color: #d97706;
            font-weight: bold;
        }

        .in-progress {
            color: #2563eb;
            font-weight: bold;
        }

        .resolved {
            color: green;
            font-weight: bold;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            background: #263445;
            color: white;
            padding: 10px 16px;
            border-radius: 5px;
            text-decoration: none;
        }

        .empty {
            color: #666;
            padding: 15px 0;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>My Complaints</h2>

    <% if (complaints == null || complaints.isEmpty()) { %>

        <p class="empty">You have not submitted any complaints yet.</p>

    <% } else { %>

        <table>
            <tr>
                <th>Complaint ID</th>
                <th>Subject</th>
                <th>Description</th>
                <th>Complaint Date</th>
                <th>Status</th>
            </tr>

            <% for (Map<String, String> complaint : complaints) {
                String status = complaint.get("status");
                String statusClass = "pending";

                if ("IN_PROGRESS".equals(status)) {
                    statusClass = "in-progress";
                } else if ("RESOLVED".equals(status)) {
                    statusClass = "resolved";
                }
            %>

                <tr>
                    <td><%= complaint.get("complaint_id") %></td>
                    <td><%= complaint.get("subject") %></td>
                    <td><%= complaint.get("description") %></td>
                    <td><%= complaint.get("complaint_date") %></td>
                    <td class="<%= statusClass %>">
                        <%= status %>
                    </td>
                </tr>

            <% } %>

        </table>

    <% } %>

    <a class="back"
       href="<%= request.getContextPath() %>/member/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
