
<%@ page import="java.util.List,java.util.Map" %>
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
    <title>Add Maintenance Bill</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 7px;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            padding: 12px;
            width: 100%;
            background: #2563eb;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Maintenance Bill</h2>

    <% if ("success".equals(request.getParameter("added"))) { %>
        <p style="color:green;">Maintenance bill added successfully!</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/MaintenanceAddServlet"
          method="post">

        <label>Select Member</label>
        <select name="member_id" required>
            <option value="">-- Select Member --</option>

            <% if (members != null) {
                for (Map<String, String> member : members) { %>

                <option value="<%= member.get("member_id") %>">
                    <%= member.get("full_name") %> -
                    <%= member.get("flat_number") %>
                </option>

            <%  }
               } %>
        </select>

        <label>Billing Month</label>
        <input type="month" name="billing_month" required>

        <label>Amount (₹)</label>
        <input type="number" name="amount"
               min="0.01" step="0.01" required>

        <label>Due Date</label>
        <input type="date" name="due_date" required>

        <button type="submit">Create Maintenance Bill</button>
    </form>

    <p>
        <a href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
            Back to Dashboard
        </a>
    </p>
</div>

</body>
</html>
