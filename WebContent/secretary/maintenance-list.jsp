
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {
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
    <title>All Maintenance Bills</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 1200px;
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

        .paid {
            color: green;
            font-weight: bold;
        }

        select {
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .update-btn {
            background: #263445;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: 5px;
        }

        .update-btn:hover {
            background: #40566f;
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

        .success {
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>All Maintenance Bills</h2>

    <% if ("success".equals(request.getParameter("updated"))) { %>
        <p class="success">Payment status updated successfully!</p>
    <% } %>

    <% if (bills == null || bills.isEmpty()) { %>

        <p class="empty">No maintenance bills found.</p>

    <% } else { %>

        <table>
            <tr>
                <th>Bill ID</th>
                <th>Member Name</th>
                <th>Flat Number</th>
                <th>Billing Month</th>
                <th>Amount (₹)</th>
                <th>Due Date</th>
                <th>Payment Status</th>
                <th>Update Status</th>
            </tr>

            <% for (Map<String, String> bill : bills) { %>

                <tr>
                    <td><%= bill.get("maintenance_id") %></td>
                    <td><%= bill.get("full_name") %></td>
                    <td><%= bill.get("flat_number") %></td>
                    <td><%= bill.get("billing_month") %></td>
                    <td>₹<%= bill.get("amount") %></td>
                    <td><%= bill.get("due_date") %></td>

                    <td class="<%= "PAID".equals(bill.get("payment_status")) ? "paid" : "pending" %>">
                        <%= bill.get("payment_status") %>
                    </td>

                    <td>
                        <form action="<%= request.getContextPath() %>/MaintenanceStatusUpdateServlet"
                              method="post">

                            <input type="hidden"
                                   name="maintenance_id"
                                   value="<%= bill.get("maintenance_id") %>">

                            <select name="payment_status" required>
                                <option value="PENDING"
                                    <%= "PENDING".equals(bill.get("payment_status")) ? "selected" : "" %>>
                                    PENDING
                                </option>

                                <option value="PAID"
                                    <%= "PAID".equals(bill.get("payment_status")) ? "selected" : "" %>>
                                    PAID
                                </option>
                            </select>

                            <button type="submit" class="update-btn">
                                Update
                            </button>
                        </form>
                    </td>
                </tr>

            <% } %>

        </table>

    <% } %>

    <a class="back"
       href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
