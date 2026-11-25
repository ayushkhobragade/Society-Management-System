
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    String role = (String) session.getAttribute("role");

    if (role == null || !role.equals("MEMBER")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> notices =
        (List<Map<String, String>>) request.getAttribute("notices");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Society Notices</title>

    <style>
        * {
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            margin: 0;
            padding: 30px;
            background: #f4f6f9;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        h1 {
            color: #263445;
            margin-top: 0;
        }

        .notice {
            border: 1px solid #ddd;
            border-left: 5px solid #263445;
            border-radius: 6px;
            padding: 18px;
            margin: 18px 0;
        }

        .notice h3 {
            margin-top: 0;
            color: #263445;
        }

        .date {
            color: #777;
            font-size: 13px;
            margin-bottom: 12px;
        }

        .description {
            color: #444;
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 16px;
            background: #263445;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .empty {
            color: #777;
            padding: 20px 0;
        }
    </style>
</head>

<body>

<div class="container">

    <a class="back-btn" href="<%= request.getContextPath() %>/member/dashboard.jsp">
        ← Back to Dashboard
    </a>

    <h1>Society Notices</h1>
    <p>Latest announcements from your society secretary.</p>

    <% if (notices == null || notices.isEmpty()) { %>

        <p class="empty">No notices available right now.</p>

    <% } else { %>

        <% for (Map<String, String> notice : notices) { %>

            <div class="notice">

                <h3><%= notice.get("title") %></h3>

                <div class="date">
                    Notice Date: <%= notice.get("noticeDate") %>
                </div>

                <div class="description"><%= notice.get("description") %></div>

            </div>

        <% } %>

    <% } %>

</div>

</body>
</html>
