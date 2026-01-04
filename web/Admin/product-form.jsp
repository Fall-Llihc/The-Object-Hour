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
    <title>${empty product ? 'Add Product' : 'Edit Product'} - Admin</title>
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
        html.dark-mode input, html.dark-mode select, html.dark-mode textarea { background-color: #2e3440 !important; border-color: #3b4252 !important; color: #eceff4 !important; }
        html.dark-mode footer { background-color: #242933 !important; border-color: #3b4252 !important; }
        html.dark-mode .rounded-2xl, html.dark-mode .rounded-xl { background-color: #2a303c !important; border-color: #3d4555 !important; }
        html.dark-mode .text-blue-600 { color: #81a1c1 !important; }
        html.dark-mode .dropdown-menu { background-color: #242933 !important; border-color: #3b4252 !important; }
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
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 max-w-3xl">
            <!-- Back Link & Title -->
            <div class="mb-6">
                <a href="${pageContext.request.contextPath}/admin/products" class="text-blue-600 hover:text-blue-700 font-medium flex items-center mb-4">
                    <i class="bi bi-arrow-left mr-2"></i> Back to Products
                </a>
                <h1 class="text-2xl font-bold text-gray-900">
                    <i class="bi ${empty product ? 'bi-plus-circle' : 'bi-pencil-square'} text-blue-600 mr-2"></i>
                    ${empty product ? 'Add New Product' : 'Edit Product'}
                </h1>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-4 flex items-center justify-between">
                    <div class="flex items-center">
                        <i class="bi bi-exclamation-triangle-fill mr-2"></i>
                        ${error}
                    </div>
                    <button onclick="this.parentElement.remove()" class="text-red-600 hover:text-red-800">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
            </c:if>

            <!-- Form Card -->
            <div class="bg-white rounded-2xl border border-gray-200 p-6">
                <form action="${pageContext.request.contextPath}/admin/products/${empty product ? 'create' : 'edit'}" method="POST" enctype="multipart/form-data">
                    
                    <c:if test="${not empty product}">
                        <input type="hidden" name="id" value="${product.id}">
                    </c:if>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Product Name -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Product Name *</label>
                            <input type="text" name="name" value="${product.name}" required
                                   placeholder="e.g. Rolex Submariner"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                        </div>

                        <!-- Brand -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Brand *</label>
                            <input type="text" name="brand" value="${product.brand}" required
                                   placeholder="e.g. Rolex"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                        </div>

                        <!-- Movement Type -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Movement Type *</label>
                            <select name="type" required
                                    class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                                <option value="">Select Type</option>
                                <option value="ANALOG" ${product.type == 'ANALOG' ? 'selected' : ''}>Analog</option>
                                <option value="DIGITAL" ${product.type == 'DIGITAL' ? 'selected' : ''}>Digital</option>
                                <option value="SMARTWATCH" ${product.type == 'SMARTWATCH' ? 'selected' : ''}>Smartwatch</option>
                            </select>
                        </div>

                        <!-- Strap Material -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Strap Material *</label>
                            <input type="text" name="strapMaterial" value="${product.strapMaterial}" required
                                   placeholder="e.g. Stainless Steel"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                        </div>

                        <!-- Price -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Price (IDR) *</label>
                            <div class="relative">
                                <span class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-500">Rp</span>
                                <input type="number" name="price" value="${product.price}" required min="0" step="0.01"
                                       class="w-full pl-12 pr-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                            </div>
                        </div>

                        <!-- Stock -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Stock Quantity *</label>
                            <input type="number" name="stock" value="${product.stock}" required min="0"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                        </div>

                        <!-- Status (only for edit) -->
                        <c:if test="${not empty product}">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Product Status</label>
                                <select name="isActive"
                                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                                    <option value="true" ${product.active ? 'selected' : ''}>Active</option>
                                    <option value="false" ${!product.active ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>
                        </c:if>

                        <!-- Image Upload -->
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Product Image (PNG or JPG)</label>
                            <input type="file" name="image" id="imageInput" accept="image/png,image/jpeg"
                                   class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                            <p class="text-gray-500 text-sm mt-2">File akan dinamai otomatis menjadi "{brand} {name}.png" atau ".jpg" sesuai ekstensi upload.</p>
                            
                            <!-- Preview -->
                            <div class="mt-4 flex items-center gap-4">
                                <img id="imagePreview" src="${not empty product ? product.imageUrl : ''}" alt="Preview" 
                                     class="w-24 h-24 object-cover rounded-lg border border-gray-200"
                                     style="display: ${not empty product ? 'block' : 'none'};"
                                     onerror="this.style.display='none';document.getElementById('previewFallback').style.display='flex';">
                                <div id="previewFallback" class="w-24 h-24 bg-gray-100 rounded-lg flex items-center justify-center"
                                     style="display: ${not empty product ? 'none' : 'flex'};">
                                    <i class="bi bi-watch text-gray-400 text-3xl"></i>
                                </div>
                                <span class="text-gray-500 text-sm">Preview gambar produk</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex items-center justify-end gap-3 mt-8 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/admin/products" 
                           class="px-6 py-2.5 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50 transition">
                            Cancel
                        </a>
                        <button type="submit" 
                                class="px-6 py-2.5 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 transition flex items-center">
                            <i class="bi bi-save mr-2"></i>
                            ${empty product ? 'Create Product' : 'Save Changes'}
                        </button>
                    </div>
                </form>
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
        
        // Live preview for image input
        (function(){
            var input = document.getElementById('imageInput');
            var preview = document.getElementById('imagePreview');
            var fallback = document.getElementById('previewFallback');
            if (!input) return;
            input.addEventListener('change', function(e){
                var file = input.files && input.files[0];
                if (!file) {
                    preview.style.display = 'none';
                    fallback.style.display = 'flex';
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(ev){
                    preview.src = ev.target.result;
                    preview.style.display = 'block';
                    fallback.style.display = 'none';
                };
                reader.readAsDataURL(file);
            });
        })();
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill text-xl':'bi bi-moon-fill text-xl';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>