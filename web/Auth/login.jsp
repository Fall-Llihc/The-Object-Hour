<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - The Object Hour</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Dark Mode -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>if(localStorage.getItem('darkMode')==='true'){document.documentElement.classList.add('dark-mode');}</script>
    <style>
        html.dark-mode body{background-color:#1a1d24!important;color:#d8dee9!important}
        html.dark-mode nav,html.dark-mode .navbar,html.dark-mode .bg-white,html.dark-mode .bg-light{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .bg-gray-50{background-color:#1a1d24!important}
        html.dark-mode .bg-gray-100{background-color:#242933!important}
        html.dark-mode .text-gray-900,html.dark-mode .text-gray-800,html.dark-mode .text-dark{color:#eceff4!important}
        html.dark-mode .text-gray-700{color:#d8dee9!important}
        html.dark-mode .text-gray-600,html.dark-mode .text-gray-500,html.dark-mode .text-muted{color:#8892a2!important}
        html.dark-mode .border-gray-200,html.dark-mode .border-b{border-color:#3b4252!important}
        html.dark-mode input,html.dark-mode select,html.dark-mode textarea,html.dark-mode .form-control{background-color:#2e3440!important;border-color:#3b4252!important;color:#eceff4!important}
        html.dark-mode footer,html.dark-mode .card{background-color:#242933!important;border-color:#3b4252!important}
        html.dark-mode .table{color:#d8dee9!important}html.dark-mode .table thead th{background-color:#2e3440!important}
        html.dark-mode .modal-content{background-color:#242933!important}
        html.dark-mode .text-blue-600{color:#5e81ac!important}
    </style>
    <style>
        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .login-container {
            max-width: 480px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .brand-header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fadeInDown 0.6s ease-out;
        }
        
        .brand-header .logo {
            background: white;
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .brand-header .logo i {
            font-size: 2.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .brand-header h1 {
            color: white;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        
        .brand-header p {
            color: rgba(255,255,255,0.95);
            font-size: 1rem;
            font-weight: 400;
        }
        
        .login-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 2.5rem;
            animation: fadeInUp 0.6s ease-out;
        }
        
        .login-card h2 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1F2937;
            margin-bottom: 0.5rem;
        }
        
        .login-card .subtitle {
            color: #6B7280;
            margin-bottom: 2rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        
        .form-control {
            border: 2px solid #E5E7EB;
            border-radius: 12px;
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .input-group-text {
            background: #F3F4F6;
            border: 2px solid #E5E7EB;
            border-right: none;
            border-radius: 12px 0 0 12px;
            color: #6B7280;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }
        
        .input-group:focus-within .input-group-text {
            border-color: #667eea;
            background: #EEF2FF;
            color: #667eea;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            padding: 0.875rem;
            font-weight: 600;
            font-size: 1rem;
            color: white;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }
        
        .divider {
            text-align: center;
            margin: 1.5rem 0;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #E5E7EB;
        }
        
        .divider span {
            background: white;
            padding: 0 1rem;
            position: relative;
            color: #9CA3AF;
            font-size: 0.875rem;
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .alert {
            border-radius: 12px;
            border: none;
            margin-bottom: 1.5rem;
        }
        
        .alert-danger {
            background: #FEE2E2;
            color: #991B1B;
        }
        
        .alert-success {
            background: #D1FAE5;
            color: #065F46;
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .auth-top-bar {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 1000;
        }
    </style>
</head>
<body>
    <!-- Dark Mode Toggle -->
    <div class="auth-top-bar">
        <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
            <i class="bi bi-moon-fill"></i>
        </button>
    </div>
    
    <div class="container">
        <div class="login-container">
            <a href="${pageContext.request.contextPath}/products" class="text-decoration-none">
                <div class="brand-header" style="cursor: pointer;">
                    <div class="logo">
                        <i class="bi bi-watch"></i>
                    </div>
                    <h1>The Object Hour</h1>
                    <p>Premium Watch Collection</p>
                </div>
            </a>

            <div class="login-card">
                <h2>Welcome Back</h2>
                <p class="subtitle">Login to continue to your account</p>
                
                <!-- Show session error (e.g., from redirect when not logged in) -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.error}
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                
                <!-- Show request error (e.g., login failed) -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                    </div>
                </c:if>
                
                <form action="${pageContext.request.contextPath}/auth/login" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person-fill"></i>
                            </span>
                            <input type="text" class="form-control" id="username" name="username" 
                                   placeholder="Enter your username" required autofocus>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock-fill"></i>
                            </span>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Enter your password" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                    </button>
                </form>
                
                <div class="divider">
                    <span>OR</span>
                </div>
                
                <div class="register-link">
                    <p class="mb-0">Don't have an account? 
                        <a href="${pageContext.request.contextPath}/auth/register">
                            Create Account <i class="bi bi-arrow-right"></i>
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>