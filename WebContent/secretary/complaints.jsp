
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {

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
    <title>Manage Complaints</title>

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

        select {
            padding: 7px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 8px 12px;
            background: #263445;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background: #3d526b;
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

    <h2>Manage Member Complaints</h2>

    <% if (complaints == null || complaints.isEmpty()) { %>

        <p class="empty">No complaints have been submitted yet.</p>

    <% } else { %>

        <table>
            <tr>
                <th>ID</th>
                <th>Member Name</th>
                <th>Flat</th>
                <th>Subject</th>
                <th>Description</th>
                <th>Date</th>
                <th>Status</th>
                <th>Update Status</th>
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
                    <td><%= complaint.get("full_name") %></td>
                    <td><%= complaint.get("flat_number") %></td>
                    <td><%= complaint.get("subject") %></td>
                    <td><%= complaint.get("description") %></td>
                    <td><%= complaint.get("complaint_date") %></td>

                    <td class="<%= statusClass %>">
                        <%= status %>
                    </td>

                    <td>
                        <form method="post"
                              action="<%= request.getContextPath() %>/ComplaintStatusUpdateServlet">

                            <input type="hidden"
                                   name="complaint_id"
                                   value="<%= complaint.get("complaint_id") %>">

                            <select name="status" required>
                                <option value="PENDING"
                                    <%= "PENDING".equals(status) ? "selected" : "" %>>
                                    PENDING
                                </option>

                                <option value="IN_PROGRESS"
                                    <%= "IN_PROGRESS".equals(status) ? "selected" : "" %>>
                                    IN_PROGRESS
                                </option>

                                <option value="RESOLVED"
                                    <%= "RESOLVED".equals(status) ? "selected" : "" %>>
                                    RESOLVED
                                </option>
                            </select>

                            <button type="submit">Update</button>
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
