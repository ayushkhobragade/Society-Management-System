
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null ||
        !"SECURITY_GUARD".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> visitors =
        (List<Map<String, Object>>) request.getAttribute("visitors");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Visitor Records</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 25px;
        }
        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }
        h2 { color: #263238; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: #263b55;
            color: white;
        }
        tr:nth-child(even) { background: #f2f2f2; }
        button {
            background: #198754;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .back {
            display: inline-block;
            margin-top: 20px;
            color: #1769aa;
            text-decoration: none;
        }
        .message { color: green; }
    </style>
</head>
<body>
<div class="container">

    <h2>Visitor Records</h2>

    <% if ("success".equals(request.getParameter("updated"))) { %>
        <p class="message">Visitor exit time updated successfully.</p>
    <% } %>

    <% if (visitors == null || visitors.isEmpty()) { %>
        <p>No visitor records found.</p>
    <% } else { %>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Phone</th>
            <th>Flat</th>
            <th>Purpose</th>
            <th>Entry Time</th>
            <th>Exit Time</th>
            <th>Action</th>
        </tr>

        <% for (Map<String, Object> v : visitors) { %>
        <tr>
            <td><%= v.get("visitorId") %></td>
            <td><%= v.get("visitorName") %></td>
            <td><%= v.get("phone") %></td>
            <td><%= v.get("flatNumber") %></td>
            <td><%= v.get("purpose") %></td>
            <td><%= v.get("entryTime") %></td>

            <td>
                <%= v.get("exitTime") == null
                    ? "Not exited" : v.get("exitTime") %>
            </td>

            <td>
                <% if (v.get("exitTime") == null) { %>
                    <form action="<%= request.getContextPath() %>/VisitorExitServlet"
                          method="post">
                        <input type="hidden" name="visitor_id"
                               value="<%= v.get("visitorId") %>">
                        <button type="submit">Mark Exit</button>
                    </form>
                <% } else { %>
                    Completed
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>

    <% } %>

    <a class="back" href="<%= request.getContextPath() %>/security/dashboard.jsp">
        Back to Dashboard
    </a>

</div>
</body>
</html>
