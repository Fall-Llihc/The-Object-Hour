<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

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
    <title>Manage Products - Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Dark Mode -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/darkmode.css">
    <script>if(localStorage.getItem('darkMode')==='true'){document.documentElement.classList.add('dark-mode');}</script>
    <style>
        /* Dark Mode Styles - Same as Customer */
        html.dark-mode body { background-color: #1a1d24 !important; color: #d8dee9 !important; }
        html.dark-mode nav, html.dark-mode .bg-white { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .bg-gray-50 { background-color: #1a1d24 !important; }
        html.dark-mode .bg-gray-100 { background-color: #2a303c !important; }
        html.dark-mode .text-gray-900, html.dark-mode .text-gray-800 { color: #eceff4 !important; }
        html.dark-mode .text-gray-700 { color: #d8dee9 !important; }
        html.dark-mode .text-gray-600, html.dark-mode .text-gray-500 { color: #9aa5b5 !important; }
        html.dark-mode .border-gray-200, html.dark-mode .border-b, html.dark-mode .border { border-color: #3b4252 !important; }
        html.dark-mode input, html.dark-mode select { background-color: #2e3440 !important; border-color: #3b4252 !important; color: #eceff4 !important; }
        html.dark-mode footer { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .rounded-2xl, html.dark-mode .rounded-xl { background-color: #2a303c !important; border-color: #3d4555 !important; }
        html.dark-mode .text-blue-600 { color: #81a1c1 !important; }
        html.dark-mode .dropdown-menu { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode table { color: #d8dee9 !important; }
        html.dark-mode thead { background-color: #2e3440 !important; }
        html.dark-mode tbody tr { border-color: #3b4252 !important; }
        html.dark-mode tbody tr:hover { background-color: #2e3542 !important; }
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
        .product-thumb {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid rgba(0,0,0,0.06);
        }
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
                       class="px-4 py-2 rounded-lg bg-blue-50 text-blue-600 font-medium transition">
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
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">
                        <i class="bi bi-box-seam text-blue-600 mr-2"></i>Product Management
                    </h1>
                    <p class="text-gray-500 text-sm mt-1">Manage your catalog and product images</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/products/create" 
                   class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition flex items-center">
                    <i class="bi bi-plus-circle mr-2"></i> Add New Product
                </a>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty sessionScope.success}">
                <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-4 flex items-center justify-between">
                    <div class="flex items-center">
                        <i class="bi bi-check-circle-fill mr-2"></i>
                        ${sessionScope.success}
                    </div>
                    <button onclick="this.parentElement.remove()" class="text-green-600 hover:text-green-800">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <!-- Products Table -->
            <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Image</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">ID</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Name</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Brand</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Type</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Strap</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Price</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Stock</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                                <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach items="${products}" var="product">
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="px-4 py-3">
                                        <img src="${product.imageUrl}" alt="${product.name}" class="product-thumb" 
                                             onerror="if(this.src !== '${product.imageUrlJpg}') { this.src = '${product.imageUrlJpg}'; } else { this.style.display='none'; this.nextElementSibling.style.display='flex'; }">
                                        <div class="hidden w-14 h-14 bg-gray-100 rounded-lg items-center justify-center">
                                            <i class="bi bi-watch text-gray-400 text-xl"></i>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-sm text-gray-500">${product.id}</td>
                                    <td class="px-4 py-3 font-medium text-gray-900">${product.name}</td>
                                    <td class="px-4 py-3 text-gray-700">${product.brand}</td>
                                    <td class="px-4 py-3">
                                        <span class="px-2 py-1 text-xs font-medium rounded-full bg-blue-100 text-blue-700">${product.type}</span>
                                    </td>
                                    <td class="px-4 py-3 text-gray-700">${product.strapMaterial}</td>
                                    <td class="px-4 py-3 font-medium text-gray-900">
                                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="Rp " maxFractionDigits="0"/>
                                    </td>
                                    <td class="px-4 py-3">
                                        <c:choose>
                                            <c:when test="${product.stock > 10}">
                                                <span class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-700">${product.stock}</span>
                                            </c:when>
                                            <c:when test="${product.stock > 0}">
                                                <span class="px-2 py-1 text-xs font-medium rounded-full bg-yellow-100 text-yellow-700">${product.stock}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-1 text-xs font-medium rounded-full bg-red-100 text-red-700">${product.stock}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3">
                                        <c:choose>
                                            <c:when test="${product.active}">
                                                <span class="px-2 py-1 text-xs font-medium rounded-full bg-green-100 text-green-700">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2 py-1 text-xs font-medium rounded-full bg-gray-200 text-gray-600">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3">
                                        <div class="flex items-center space-x-2">
                                            <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}" 
                                               class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition" title="Edit">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <c:choose>
                                                <c:when test="${product.active}">
                                                    <a href="${pageContext.request.contextPath}/admin/products/delete?id=${product.id}" 
                                                       class="p-2 text-orange-600 hover:bg-orange-50 rounded-lg transition"
                                                       onclick="return confirm('Nonaktifkan produk ini?')" title="Deactivate">
                                                        <i class="bi bi-x-circle"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/products/activate?id=${product.id}" 
                                                       class="p-2 text-green-600 hover:bg-green-50 rounded-lg transition" title="Activate">
                                                        <i class="bi bi-check-circle"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="${pageContext.request.contextPath}/admin/products/hard-delete?id=${product.id}" 
                                               class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition"
                                               onclick="return confirm('PERINGATAN: Data akan dihapus selamanya dari database. Lanjutkan?')" title="Delete Permanently">
                                                <i class="bi bi-trash-fill"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty products}">
                    <div class="text-center py-12">
                        <i class="bi bi-inbox text-gray-300 text-5xl mb-3"></i>
                        <p class="text-gray-500">No products found</p>
                        <a href="${pageContext.request.contextPath}/admin/products/create" 
                           class="inline-block mt-4 text-blue-600 hover:text-blue-700 font-medium">
                            <i class="bi bi-plus-circle mr-1"></i> Add your first product
                        </a>
                    </div>
                </c:if>
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
