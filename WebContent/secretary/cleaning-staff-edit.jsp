
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    HttpSession userSession = request.getSession(false);

    if (userSession == null ||
        !"SECRETARY".equals(userSession.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer staffId = (Integer) request.getAttribute("staffId");
    String staffName = (String) request.getAttribute("staffName");
    String phone = (String) request.getAttribute("phone");
    String dutyTime = (String) request.getAttribute("dutyTime");

    java.math.BigDecimal salary =
        (java.math.BigDecimal) request.getAttribute("salary");

    java.sql.Date joiningDate =
        (java.sql.Date) request.getAttribute("joiningDate");

    String status = (String) request.getAttribute("status");

    if (staffId == null) {
        response.sendRedirect(request.getContextPath()
                + "/CleaningStaffListServlet");
        return;
    }

    String dateValue = "";

    if (joiningDate != null) {
        dateValue = new SimpleDateFormat("yyyy-MM-dd")
                .format(joiningDate);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Cleaning Staff</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 15px;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }

        .form-container {
            max-width: 600px;
            margin: 20px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        h2 {
            text-align: center;
            color: #26344a;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 7px;
            font-weight: bold;
            color: #333;
        }

        input, select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        button {
            width: 100%;
            margin-top: 25px;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #2563eb;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="form-container">

    <h2>Edit Cleaning Staff</h2>

    <!-- Correct form opening tag -->
    <form action="<%= request.getContextPath() %>/CleaningStaffEditServlet"
          method="post">

        <input type="hidden" name="staff_id"
               value="<%= staffId %>">

        <label>Staff Name</label>
        <input type="text" name="staff_name"
               value="<%= staffName == null ? "" : staffName %>"
               maxlength="100" required>

        <label>Phone Number</label>
        <input type="tel" name="phone"
               value="<%= phone == null ? "" : phone %>"
               pattern="[0-9]{10,15}" required>

        <label>Duty Time</label>
        <input type="text" name="duty_time"
               value="<%= dutyTime == null ? "" : dutyTime %>"
               maxlength="50" required>

        <label>Salary</label>
        <input type="number" name="salary"
               value="<%= salary == null ? "" : salary.toPlainString() %>"
               min="0" step="0.01">

        <label>Joining Date</label>
        <input type="date" name="joining_date"
               value="<%= dateValue %>">

        <label>Status</label>
        <select name="status" required>

            <option value="ACTIVE"
                <%= "ACTIVE".equals(status) ? "selected" : "" %>>
                ACTIVE
            </option>

            <option value="INACTIVE"
                <%= "INACTIVE".equals(status) ? "selected" : "" %>>
                INACTIVE
            </option>

        </select>

        <button type="submit">Update Staff</button>

    </form>

    <a class="back-link"
       href="<%= request.getContextPath() %>/CleaningStaffListServlet">
        Back to Staff Records
    </a>

</div>

</body>
</html>
