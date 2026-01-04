<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Page Not Found - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Dark Mode CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="text-center">
                    <h1 class="display-1 fw-bold text-primary">404</h1>
                    <p class="fs-3"><span class="text-danger">Oops!</span> Page not found.</p>
                    <p class="lead">The page you're looking for doesn't exist.</p>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
                    <a href="javascript:history.back()" class="btn btn-outline-secondary">Go Back</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>