
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> members =
        (List<Map<String, String>>) request.getAttribute("members");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Members List</title>

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

        .edit-btn {
            background: #243b64;
            color: white;
            padding: 7px 12px;
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

    <h2>Society Members List</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Flat Number</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Joining Date</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <%
            if (members != null && !members.isEmpty()) {
                for (Map<String, String> member : members) {
        %>

        <tr>
            <td><%= member.get("member_id") %></td>
            <td><%= member.get("full_name") %></td>
            <td><%= member.get("flat_number") %></td>
            <td><%= member.get("phone") %></td>
            <td><%= member.get("email") == null ? "-" : member.get("email") %></td>
            <td><%= member.get("joining_date") == null ? "-" : member.get("joining_date") %></td>
            <td><%= member.get("status") %></td>

            <td>
                <a class="edit-btn"
   href="<%= request.getContextPath() %>/MemberEditPageServlet?id=<%= member.get("member_id") %>">
    Edit
</a>
            </td>
        </tr>

        <%
                }
            } else {
        %>

        <tr>
            <td colspan="8">No members found.</td>
        </tr>

        <%
            }
        %>

    </table>

    <a class="back-btn" href="dashboard.jsp">
        ← Back to Dashboard
    </a>

</body>
</html>
