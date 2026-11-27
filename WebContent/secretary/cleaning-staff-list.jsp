
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> staffList =
        (List<Map<String, Object>>) request.getAttribute("staffList");
%>

<!DOCTYPE html>
<html>
<head>

    <title>Cleaning Staff Records</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 25px;
            margin: 0;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        h2 {
            color: #263b55;
            margin-bottom: 20px;
        }

        .top-buttons {
            margin-bottom: 20px;
        }

        .add-btn {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 10px 16px;
            text-decoration: none;
            border-radius: 5px;
        }

        .add-btn:hover {
            background: #1d4ed8;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            min-width: 850px;
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

        tr:nth-child(even) {
            background: #f2f2f2;
        }

        .edit-btn {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 8px 14px;
            border-radius: 5px;
            text-decoration: none;
            margin: 2px;
        }

        .edit-btn:hover {
            background: #1d4ed8;
        }

        .delete-btn {
            background: #dc2626;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
            margin: 2px;
            font-size: 14px;
        }

        .delete-btn:hover {
            background: #b91c1c;
        }

        .delete-form {
            display: inline;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            color: #1769aa;
            text-decoration: none;
        }

        .active {
            color: green;
            font-weight: bold;
        }

        .inactive {
            color: red;
            font-weight: bold;
        }

        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
        }

    </style>

</head>

<body>

<div class="container">

    <h2>Cleaning Staff Records</h2>

    <% if ("success".equals(request.getParameter("deleted"))) { %>

        <div class="success-message">
            Cleaning staff record deleted successfully!
        </div>

    <% } %>

    <% if ("success".equals(request.getParameter("updated"))) { %>

        <div class="success-message">
            Cleaning staff details updated successfully!
        </div>

    <% } %>

    <% if ("invalid".equals(request.getParameter("error"))) { %>

        <div class="error-message">
            Invalid request. Please try again.
        </div>

    <% } %>

    <% if ("notfound".equals(request.getParameter("error"))) { %>

        <div class="error-message">
            Staff record not found.
        </div>

    <% } %>

    <div class="top-buttons">

        <a class="add-btn"
           href="<%= request.getContextPath() %>/secretary/cleaning-staff-add.jsp">
            + Add Cleaning Staff
        </a>

    </div>

    <% if (staffList == null || staffList.isEmpty()) { %>

        <p>No cleaning staff records found.</p>

    <% } else { %>

    <div class="table-wrapper">

        <table>

            <tr>
                <th>Staff ID</th>
                <th>Name</th>
                <th>Phone</th>
                <th>Duty Time</th>
                <th>Salary</th>
                <th>Joining Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <% for (Map<String, Object> staff : staffList) { %>

            <tr>

                <td><%= staff.get("staffId") %></td>

                <td><%= staff.get("staffName") %></td>

                <td><%= staff.get("phone") %></td>

                <td><%= staff.get("dutyTime") %></td>

                <td>
                    <%= staff.get("salary") == null
                        ? "-" : staff.get("salary") %>
                </td>

                <td>
                    <%= staff.get("joiningDate") == null
                        ? "-" : staff.get("joiningDate") %>
                </td>

                <td>

                    <% if ("ACTIVE".equals(staff.get("status"))) { %>

                        <span class="active">ACTIVE</span>

                    <% } else { %>

                        <span class="inactive">INACTIVE</span>

                    <% } %>

                </td>

                <td>

                    <a class="edit-btn"
                       href="<%= request.getContextPath() %>/CleaningStaffEditServlet?id=<%= staff.get("staffId") %>">
                        Edit
                    </a>

                    <form class="delete-form"
                          action="<%= request.getContextPath() %>/CleaningStaffDeleteServlet"
                          method="post"
                          onsubmit="return confirm('Are you sure you want to delete this staff record?');">

                        <input type="hidden"
                               name="staff_id"
                               value="<%= staff.get("staffId") %>">

                        <button type="submit" class="delete-btn">
                            Delete
                        </button>

                    </form>

                </td>

            </tr>

            <% } %>

        </table>

    </div>

    <% } %>

    <a class="back"
       href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
