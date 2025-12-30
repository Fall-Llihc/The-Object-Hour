<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Redirect to HomeController which will load products
    response.sendRedirect(request.getContextPath() + "/home");
%>
