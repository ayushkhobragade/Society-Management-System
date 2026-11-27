
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECURITY_GUARD".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String added = request.getParameter("added");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Visitor Entry</title>

    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 600px;
            margin: 30px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h2 {
            color: #263445;
            margin-bottom: 25px;
            text-align: center;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #263445;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        textarea {
            resize: vertical;
            min-height: 90px;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #263445;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background: #3d526b;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 18px;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 18px;
        }

        .back {
            display: inline-block;
            margin-top: 18px;
            color: #263445;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>New Visitor Entry</h2>

    <% if ("success".equals(added)) { %>
        <div class="success">
            Visitor entry saved successfully!
        </div>
    <% } %>

    <% if ("invalid".equals(error)) { %>
        <div class="error">
            Please enter valid visitor details. Phone must contain 10–15 digits.
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/VisitorAddServlet"
          method="post">

        <label>Visitor Name</label>
        <input type="text"
               name="visitor_name"
               maxlength="100"
               required>

        <label>Mobile Number</label>
        <input type="tel"
               name="phone"
               pattern="[0-9]{10,15}"
               maxlength="15"
               required>

        <label>Flat Number</label>
        <input type="text"
               name="flat_number"
               maxlength="20"
               placeholder="Example: A-101"
               required>

        <label>Purpose of Visit</label>
        <textarea name="purpose"
                  maxlength="255"
                  required></textarea>

        <button type="submit">Save Visitor Entry</button>

    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/security/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
