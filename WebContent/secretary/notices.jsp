
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> notices =
        (List<Map<String, String>>) request.getAttribute("notices");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Society Notices</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 25px;
        }

        h2 {
            color: #243b64;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background: #243b64;
            color: white;
        }

        tr:nth-child(even) {
            background: #f2f5fa;
        }

        .add-btn {
            display: inline-block;
            background: #243b64;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 4px;
        }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            color: #243b64;
            text-decoration: none;
        }
    </style>
</head>

<body>

    <h2>Society Notices</h2>

    <a class="add-btn"
       href="<%= request.getContextPath() %>/secretary/add-notice.jsp">
        + Add New Notice
    </a>

    <table>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Notice Date</th>
        </tr>

        <%
            if (notices != null && !notices.isEmpty()) {
                for (Map<String, String> notice : notices) {
        %>

        <tr>
            <td><%= notice.get("notice_id") %></td>
            <td><%= notice.get("title") %></td>
            <td><%= notice.get("description") %></td>
            <td><%= notice.get("notice_date") %></td>
        </tr>

        <%
                }
            } else {
        %>

        <tr>
            <td colspan="4">No notices found.</td>
        </tr>

        <%
            }
        %>

    </table>

    <a class="back-btn" href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
    ← Back to Dashboard
</a>

</body>
</html>
