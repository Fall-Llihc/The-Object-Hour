<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pemesanan Berhasil - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
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
        * { font-family: 'Inter', sans-serif; }
        @keyframes checkmark {
            0% { transform: scale(0) rotate(-45deg); }
            50% { transform: scale(1.2) rotate(-45deg); }
            100% { transform: scale(1) rotate(-45deg); }
        }
        .checkmark {
            animation: checkmark 0.6s ease-in-out;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 via-white to-purple-50 min-h-screen flex items-center justify-center p-4">
    <!-- Dark Mode Toggle -->
    <div style="position: fixed; top: 1rem; right: 1rem; z-index: 1000;">
        <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
            <i class="bi bi-moon-fill"></i>
        </button>
    </div>
    
    <div class="text-center max-w-lg w-full">
        <!-- Success Icon -->
        <div class="mb-8 flex justify-center">
            <div class="w-32 h-32 bg-gradient-to-br from-green-400 to-green-600 rounded-full flex items-center justify-center shadow-2xl">
                <i class="bi bi-check-lg text-white checkmark" style="font-size: 5rem; font-weight: bold;"></i>
            </div>
        </div>
        
        <!-- Success Message -->
        <h1 class="text-5xl font-bold text-gray-900 mb-4">Pemesanan Berhasil!</h1>
        <p class="text-xl text-gray-600 mb-12">Terima kasih telah berbelanja di The Object Hour</p>
        
        <!-- Action Button -->
        <a href="${pageContext.request.contextPath}/products" 
           class="inline-flex items-center justify-center px-12 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white text-lg font-bold rounded-2xl hover:from-blue-700 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 shadow-xl hover:shadow-2xl">
            <i class="bi bi-shop mr-3 text-2xl"></i>
            Lanjut Belanja
        </a>
    </div>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
