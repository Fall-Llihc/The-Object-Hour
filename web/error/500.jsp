<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Internal Server Error - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Dark Mode CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="text-center">
                    <h1 class="display-1 fw-bold text-danger">500</h1>
                    <p class="fs-3"><span class="text-danger">Oops!</span> Something went wrong.</p>
                    <p class="lead">We're experiencing some technical difficulties. Please try again later.</p>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">Go Back</a>
                    </div>
                    
                    <% if (request.getAttribute("javax.servlet.error.exception") != null) { %>
                    <div class="mt-4">
                        <details class="text-start">
                            <summary class="btn btn-outline-danger btn-sm">Technical Details</summary>
                            <div class="mt-2 p-3 bg-light border rounded">
                                <pre><%= request.getAttribute("javax.servlet.error.exception") %></pre>
                            </div>
                        </details>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>