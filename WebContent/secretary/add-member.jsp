<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession(false);

    if (userSession == null ||
        userSession.getAttribute("userId") == null ||
        !"SECRETARY".equals(userSession.getAttribute("role"))) {

        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Society Member</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fc;
            margin: 0;
            padding: 30px;
        }

        .form-container {
            max-width: 600px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        h2 {
            color: #173b67;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccd5e0;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            background: #2465a5;
            color: white;
            border: none;
            padding: 13px 22px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background: #173b67;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #2465a5;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="form-container">

    <h2>Add New Society Member</h2>

    <form action="../MemberAddServlet" method="post">

        <label>Full Name *</label>
        <input type="text" name="full_name" required>

        <label>Flat Number *</label>
        <input type="text" name="flat_number" required>

        <label>Phone Number *</label>
        <input type="tel" name="phone"
               pattern="[0-9]{10}"
               maxlength="10" required>

        <label>Email</label>
        <input type="email" name="email">

        <label>Joining Date</label>
        <input type="date" name="joining_date">

        <button type="submit">Add Member</button>

    </form>

    <a href="dashboard.jsp" class="back-link">
        Back to Dashboard
    </a>

</div>

</body>
</html>