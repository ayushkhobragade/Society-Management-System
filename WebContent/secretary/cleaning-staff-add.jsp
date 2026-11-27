
<%@ page session="true" %>

<%
    if (session.getAttribute("userId") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Cleaning Staff</title>

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
            box-shadow: 0 2px 10px #ccc;
        }

        h2 {
            text-align: center;
            color: #263b55;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 22px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #1769aa;
            text-decoration: none;
        }

        .success { color: green; text-align: center; }
        .error { color: red; text-align: center; }
    </style>
</head>

<body>

<div class="container">

    <h2>Add Cleaning Staff</h2>

    <% if ("success".equals(request.getParameter("added"))) { %>
        <p class="success">Cleaning staff added successfully!</p>
    <% } %>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <p class="error">Please enter valid staff details.</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/CleaningStaffAddServlet"
          method="post">

        <label>Staff Name</label>
        <input type="text" name="staff_name" required maxlength="100">

        <label>Phone Number</label>
        <input type="tel" name="phone"
               pattern="[0-9]{10,15}" required>

        <label>Duty Time</label>
        <input type="text" name="duty_time"
               placeholder="Example: 8 AM - 12 PM" required>

        <label>Monthly Salary</label>
        <input type="number" name="salary"
               min="0" step="0.01">

        <label>Joining Date</label>
        <input type="date" name="joining_date">

        <button type="submit">Add Staff</button>

    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/secretary/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
