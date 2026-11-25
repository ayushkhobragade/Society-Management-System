
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"MEMBER".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> bills =
        (List<Map<String, String>>) request.getAttribute("bills");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Maintenance Details</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 900px;
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
            padding: 13px;
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

        .paid {
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

    <h2>My Maintenance Details</h2>

    <% if (bills == null || bills.isEmpty()) { %>

        <p class="empty">No maintenance bills available.</p>

    <% } else { %>

        <table>
            <tr>
                <th>Billing Month</th>
                <th>Amount (₹)</th>
                <th>Due Date</th>
                <th>Payment Status</th>
            </tr>

            <% for (Map<String, String> bill : bills) { %>

                <tr>
                    <td><%= bill.get("billing_month") %></td>
                    <td>₹<%= bill.get("amount") %></td>
                    <td><%= bill.get("due_date") %></td>

                    <td class="<%= "PAID".equals(bill.get("payment_status")) ? "paid" : "pending" %>">
                        <%= bill.get("payment_status") %>
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
