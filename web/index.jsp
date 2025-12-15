<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Redirect to login page
    response.sendRedirect(request.getContextPath() + "/auth/login");
%>
