<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Security check: redirect to login if not logged in or not admin --%>
<c:if test="${empty sessionScope.userId or sessionScope.role != 'ADMIN'}">
    <c:redirect url="/auth/login">
        <c:param name="error" value="Silakan login sebagai admin untuk mengakses halaman ini"/>
    </c:redirect>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Mode CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>
        if (localStorage.getItem('darkMode') === 'true') {
            document.documentElement.classList.add('dark-mode');
        }
    </script>
    <style>
        /* Dark Mode Styles - Same as Customer */
        html.dark-mode body { background-color: #1a1d24 !important; color: #d8dee9 !important; }
        html.dark-mode nav, html.dark-mode .bg-white { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .bg-gray-50 { background-color: #1a1d24 !important; }
        html.dark-mode .bg-gray-100 { background-color: #2a303c !important; }
        html.dark-mode .text-gray-900, html.dark-mode .text-gray-800 { color: #eceff4 !important; }
        html.dark-mode .text-gray-700 { color: #d8dee9 !important; }
        html.dark-mode .text-gray-600, html.dark-mode .text-gray-500 { color: #9aa5b5 !important; }
        html.dark-mode .border-gray-200, html.dark-mode .border-b { border-color: #3b4252 !important; }
        html.dark-mode input, html.dark-mode select { background-color: #2e3440 !important; border-color: #3b4252 !important; color: #eceff4 !important; }
        html.dark-mode footer { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .rounded-2xl, html.dark-mode .rounded-xl { background-color: #2a303c !important; border-color: #3d4555 !important; }
        html.dark-mode .text-blue-600 { color: #81a1c1 !important; }
        html.dark-mode .dropdown-menu { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .bg-blue-50 { background-color: rgba(94, 129, 172, 0.15) !important; }
        html.dark-mode .bg-green-50 { background-color: rgba(163, 190, 140, 0.15) !important; }
        html.dark-mode .bg-purple-50 { background-color: rgba(180, 142, 173, 0.15) !important; }
        html.dark-mode .bg-orange-50 { background-color: rgba(208, 135, 112, 0.15) !important; }
        html.dark-mode .bg-blue-100 { background-color: rgba(94, 129, 172, 0.2) !important; }
        html.dark-mode .bg-green-100 { background-color: rgba(163, 190, 140, 0.2) !important; }
    </style>
    <style>
        * { 
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html { height: 100%; }
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: #f5f5f5;
        }
        main { flex: 1 0 auto; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #c1c1c1; border-radius: 3px; }
    </style>
</head>
<body>
    <!-- Navbar - Same style as Customer -->
    <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <!-- Logo -->
                <a href="${pageContext.request.contextPath}/admin/products" class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <span class="font-bold text-xl text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
                    <span class="bg-blue-100 text-blue-700 text-xs font-semibold px-2 py-1 rounded-full ml-2">ADMIN</span>
                </a>
                
                <!-- Admin Navigation Links -->
                <div class="hidden md:flex items-center space-x-1">
                    <a href="${pageContext.request.contextPath}/admin/products" 
                       class="px-4 py-2 rounded-lg text-gray-700 hover:bg-gray-100 font-medium transition">
                        <i class="bi bi-box-seam mr-1"></i> Products
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reports" 
                       class="px-4 py-2 rounded-lg text-gray-700 hover:bg-gray-100 font-medium transition">
                        <i class="bi bi-graph-up mr-1"></i> Reports
                    </a>
                </div>
                
                <!-- Right Actions -->
                <div class="flex items-center space-x-3">
                    <!-- Dark Mode Toggle -->
                    <button type="button" class="dark-mode-toggle p-2 text-gray-600 hover:bg-gray-100 rounded-lg transition" title="Toggle Dark Mode">
                        <i class="bi bi-moon-fill text-xl"></i>
                    </button>
                    
                    <!-- User Menu -->
                    <div class="relative" id="userMenuContainer">
                        <button onclick="toggleUserMenu()" class="flex items-center space-x-2 px-3 py-2 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                            <i class="bi bi-person-circle text-gray-600 text-xl"></i>
                            <span class="hidden sm:inline text-gray-700 font-medium">${sessionScope.user.name}</span>
                            <i class="bi bi-chevron-down text-gray-400 text-sm" id="userMenuChevron"></i>
                        </button>
                        
                        <!-- Dropdown Menu -->
                        <div id="userDropdown" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 overflow-hidden z-50">
                            <a href="${pageContext.request.contextPath}/" 
                               class="block px-4 py-3 text-gray-700 hover:bg-gray-50 transition flex items-center">
                                <i class="bi bi-shop mr-3 text-blue-600"></i>
                                View Store
                            </a>
                            <div class="border-t border-gray-200"></div>
                            <a href="${pageContext.request.contextPath}/auth/logout" 
                               class="block px-4 py-3 text-red-600 hover:bg-red-50 transition flex items-center">
                                <i class="bi bi-box-arrow-right mr-3"></i>
                                Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="py-8">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
            <!-- Page Header -->
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-900 mb-2">
                    <i class="bi bi-speedometer2 text-blue-600 mr-2"></i>Admin Dashboard
                </h1>
                <p class="text-gray-600">Welcome back, ${sessionScope.user.name}! Manage your store from here.</p>
            </div>
            
            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-2xl p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Total Products</p>
                            <p class="text-3xl font-bold text-gray-900 mt-1">${totalProducts != null ? totalProducts : '0'}</p>
                        </div>
                        <div class="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
                            <i class="bi bi-box-seam text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Total Orders</p>
                            <p class="text-3xl font-bold text-gray-900 mt-1">${totalOrders != null ? totalOrders : '0'}</p>
                        </div>
                        <div class="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
                            <i class="bi bi-bag-check text-green-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Total Revenue</p>
                            <p class="text-3xl font-bold text-gray-900 mt-1">
                                <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                            </p>
                        </div>
                        <div class="w-12 h-12 bg-purple-50 rounded-xl flex items-center justify-center">
                            <i class="bi bi-currency-dollar text-purple-600 text-xl"></i>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-2xl p-6 border border-gray-200">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-gray-500 text-sm font-medium">Low Stock Items</p>
                            <p class="text-3xl font-bold text-gray-900 mt-1">${lowStockCount != null ? lowStockCount : '0'}</p>
                        </div>
                        <div class="w-12 h-12 bg-orange-50 rounded-xl flex items-center justify-center">
                            <i class="bi bi-exclamation-triangle text-orange-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <a href="${pageContext.request.contextPath}/admin/products" class="bg-white rounded-2xl p-6 border border-gray-200 hover:border-blue-300 hover:shadow-lg transition group">
                    <div class="flex items-center space-x-4">
                        <div class="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center group-hover:bg-blue-200 transition">
                            <i class="bi bi-box-seam text-blue-600 text-2xl"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold text-gray-900">Manage Products</h3>
                            <p class="text-gray-500 text-sm">Add, edit, or remove products from catalog</p>
                        </div>
                        <i class="bi bi-chevron-right text-gray-400 ml-auto text-xl"></i>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin/reports" class="bg-white rounded-2xl p-6 border border-gray-200 hover:border-blue-300 hover:shadow-lg transition group">
                    <div class="flex items-center space-x-4">
                        <div class="w-14 h-14 bg-green-100 rounded-xl flex items-center justify-center group-hover:bg-green-200 transition">
                            <i class="bi bi-graph-up text-green-600 text-2xl"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold text-gray-900">View Reports</h3>
                            <p class="text-gray-500 text-sm">Sales analytics and order reports</p>
                        </div>
                        <i class="bi bi-chevron-right text-gray-400 ml-auto text-xl"></i>
                    </div>
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 py-6 mt-auto">
        <div class="container mx-auto px-4 text-center">
            <div class="flex items-center justify-center space-x-2 mb-2">
                <i class="bi bi-watch text-blue-600 text-xl"></i>
                <span class="font-bold text-gray-900">The <span class="text-blue-600">Object Hour</span></span>
                <span class="text-gray-400">|</span>
                <span class="text-gray-500 text-sm">Admin Panel</span>
            </div>
            <p class="text-gray-500 text-sm">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>

    <script>
        // User dropdown toggle
        function toggleUserMenu() {
            const dropdown = document.getElementById('userDropdown');
            const chevron = document.getElementById('userMenuChevron');
            dropdown.classList.toggle('hidden');
            
            if (!dropdown.classList.contains('hidden')) {
                chevron.style.transform = 'rotate(180deg)';
            } else {
                chevron.style.transform = 'rotate(0deg)';
            }
        }
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const userMenuContainer = document.getElementById('userMenuContainer');
            const dropdown = document.getElementById('userDropdown');
            
            if (userMenuContainer && !userMenuContainer.contains(event.target)) {
                dropdown.classList.add('hidden');
                document.getElementById('userMenuChevron').style.transform = 'rotate(0deg)';
            }
        });
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill text-xl':'bi bi-moon-fill text-xl';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
