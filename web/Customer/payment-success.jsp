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
        <a href="${pageContext.request.contextPath}/" 
           class="inline-flex items-center justify-center px-12 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white text-lg font-bold rounded-2xl hover:from-blue-700 hover:to-purple-700 transform hover:scale-105 transition-all duration-300 shadow-xl hover:shadow-2xl">
            <i class="bi bi-house-door-fill mr-3 text-2xl"></i>
            Kembali ke Halaman Utama
        </a>
    </div>
</body>
</html>
