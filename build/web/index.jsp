<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Debug info for troubleshooting
    String debug = request.getParameter("debug");
    if ("true".equals(debug)) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Info - PBO-Project</title>
</head>
<body>
    <h1>Debug Information</h1>
    <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
    <p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
    <p><strong>Servlet Context Name:</strong> <%= application.getServletContextName() %></p>
    <br>
    <p><strong>Expected Admin Reports URL:</strong> 
       <a href="<%= request.getContextPath() %>/admin/reports">
           <%= request.getContextPath() %>/admin/reports
       </a>
    </p>
    <p><strong>Expected Home URL:</strong> 
       <a href="<%= request.getContextPath() %>/home">
           <%= request.getContextPath() %>/home
       </a>
    </p>
    <p><strong>Expected Login URL:</strong> 
       <a href="<%= request.getContextPath() %>/auth/login">
           <%= request.getContextPath() %>/auth/login
       </a>
    </p>
    <br>
    <a href="<%= request.getContextPath() %>/">Continue to Home</a>
</body>
</html>
<%
    } else {
        // Redirect to HomeController which will load products
        response.sendRedirect(request.getContextPath() + "/home");
    }
%>
