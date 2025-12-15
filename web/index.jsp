<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session.getAttribute("user") != null) {
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/Customer/home.jsp");
    } else {
        // Redirect to home page for guest
        response.sendRedirect(request.getContextPath() + "/Customer/home.jsp");
    }
%>
