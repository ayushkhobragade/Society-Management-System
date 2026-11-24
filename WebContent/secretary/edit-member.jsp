
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String id = (String) request.getAttribute("memberId");

    if (id == null) {
        response.sendError(400, "Member details not available.");
        return;
    }

    String fullName = (String) request.getAttribute("fullName");
    String flatNumber = (String) request.getAttribute("flatNumber");
    String phone = (String) request.getAttribute("phone");
    String email = (String) request.getAttribute("email");
    String joiningDate = (String) request.getAttribute("joiningDate");
    String status = (String) request.getAttribute("status");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Member</title>

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
            box-shadow: 0 3px 12px #ddd;
        }

        h2 {
            color: #243b64;
            text-align: center;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background: #243b64;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #243b64;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Edit Member Details</h2>

    <form action="<%= request.getContextPath() %>/MemberEditServlet" method="post">

        <input type="hidden" name="member_id" value="<%= id %>">

        <label>Full Name</label>
        <input type="text" name="full_name"
               value="<%= fullName == null ? "" : fullName %>" required>

        <label>Flat Number</label>
        <input type="text" name="flat_number"
               value="<%= flatNumber == null ? "" : flatNumber %>" required>

        <label>Phone Number</label>
        <input type="tel" name="phone"
               value="<%= phone == null ? "" : phone %>"
               pattern="[0-9]{10}" maxlength="10" required>

        <label>Email</label>
        <input type="email" name="email"
               value="<%= email == null ? "" : email %>">

        <label>Joining Date</label>
        <input type="date" name="joining_date"
               value="<%= joiningDate == null ? "" : joiningDate %>">

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

        <button type="submit">Update Member</button>

    </form>

    <a href="<%= request.getContextPath() %>/MemberListServlet">
        Back to Members List
    </a>

</div>

</body>
</html>
