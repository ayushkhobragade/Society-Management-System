
<%@ page import="java.time.LocalDate" %>

<%
    if (session.getAttribute("role") == null ||
        !"SECRETARY".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Notice</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 25px;
        }

        h2 {
            color: #243b64;
        }

        .notice-form {
            background: white;
            padding: 25px;
            max-width: 600px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 7px;
            color: #243b64;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        textarea {
            min-height: 130px;
            resize: vertical;
        }

        .submit-btn {
            background: #243b64;
            color: white;
            padding: 11px 20px;
            border: none;
            border-radius: 4px;
            margin-top: 20px;
            cursor: pointer;
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

    <h2>Add Society Notice</h2>

    <div class="notice-form">

        <form action="<%= request.getContextPath() %>/NoticeAddServlet"
              method="post">

            <label>Notice Title</label>
            <input type="text"
                   name="title"
                   maxlength="150"
                   placeholder="Enter notice title"
                   required>

            <label>Notice Description</label>
            <textarea name="description"
                      placeholder="Enter notice details"
                      required></textarea>

            <label>Notice Date</label>
            <input type="date"
                   name="notice_date"
                   value="<%= LocalDate.now() %>"
                   required>

            <button type="submit" class="submit-btn">
                Add Notice
            </button>

        </form>

    </div>

    <a class="back-btn" href="dashboard.jsp">
        ← Back to Dashboard
    </a>

</body>
</html>
