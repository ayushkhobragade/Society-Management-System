
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("role") == null ||
        !"MEMBER".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Complaint</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 30px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h2 {
            color: #263445;
        }

        label {
            display: block;
            margin-top: 18px;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        textarea {
            height: 130px;
            resize: vertical;
        }

        button {
            margin-top: 20px;
            background: #263445;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background: #40566f;
        }

        .success {
            color: green;
            font-weight: bold;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            color: #263445;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Submit Your Complaint</h2>

    <% if ("success".equals(request.getParameter("submitted"))) { %>
        <p class="success">Complaint submitted successfully!</p>
    <% } %>

    <form action="<%= request.getContextPath() %>/ComplaintSubmitServlet"
          method="post">

        <label>Complaint Subject</label>

        <input type="text"
               name="subject"
               maxlength="150"
               placeholder="Enter complaint subject"
               required>

        <label>Complaint Description</label>

        <textarea name="description"
                  placeholder="Describe your complaint..."
                  required></textarea>

        <button type="submit">Submit Complaint</button>

    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/member/dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>
