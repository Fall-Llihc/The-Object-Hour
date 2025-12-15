<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - The Object Hour</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Navbar -->
    <nav class="bg-white shadow-sm sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-2">
                    <i class="bi bi-watch text-blue-600 text-2xl"></i>
                    <span class="text-xl font-bold">The <span class="text-blue-600">Object Hour</span></span>
                </div>
                
                <div class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <i class="bi bi-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" placeholder="Search watches, brands..." 
                               class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                </div>
                
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/cart" class="relative">
                        <i class="bi bi-cart3 text-gray-700 text-xl"></i>
                        <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">3</span>
                    </a>
                    <button class="text-gray-700 hover:text-blue-600 font-medium">Login</button>
                    <button class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 font-medium">Register</button>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex gap-8">
            <!-- Sidebar Filter -->
            <aside class="w-64 flex-shrink-0">
                <div class="bg-white rounded-xl shadow-sm p-6 sticky top-24">
                    <h3 class="font-bold text-lg mb-4">Filters</h3>
                    
                    <!-- Category Filter -->
                    <div class="mb-6">
                        <h4 class="font-semibold text-sm text-gray-700 mb-3">Category</h4>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">All Watches</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Analog</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Digital</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Smartwatch</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Brand Filter -->
                    <div class="mb-6">
                        <h4 class="font-semibold text-sm text-gray-700 mb-3">Brand</h4>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Casio</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Samsung</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">Xiaomi</span>
                            </label>
                            <label class="flex items-center">
                                <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                                <span class="ml-2 text-sm">DanielW</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Price Range -->
                    <div class="mb-6">
                        <h4 class="font-semibold text-sm text-gray-700 mb-3">Price Range</h4>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="radio" name="price" class="w-4 h-4 text-blue-600">
                                <span class="ml-2 text-sm">Under Rp500K</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="price" class="w-4 h-4 text-blue-600">
                                <span class="ml-2 text-sm">Rp500K - Rp1M</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="price" class="w-4 h-4 text-blue-600">
                                <span class="ml-2 text-sm">Above Rp1M</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Stock Status -->
                    <div class="mb-6">
                        <h4 class="font-semibold text-sm text-gray-700 mb-3">Availability</h4>
                        <label class="flex items-center">
                            <input type="checkbox" class="w-4 h-4 text-blue-600 rounded">
                            <span class="ml-2 text-sm">In Stock Only</span>
                        </label>
                    </div>
                    
                    <button class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 font-medium">
                        Apply Filters
                    </button>
                </div>
            </aside>

            <!-- Products Grid -->
            <main class="flex-1">
                <div class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-900">Featured Watches</h1>
                        <p class="text-gray-600">Handpicked selection just for you</p>
                    </div>
                    <select class="border border-gray-300 rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option>Sort by: Popular</option>
                        <option>Price: Low to High</option>
                        <option>Price: High to Low</option>
                        <option>Newest</option>
                    </select>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <!-- Product Card -->
                    <c:forEach begin="1" end="8">
                    <div class="bg-white border border-gray-200 rounded-xl overflow-hidden hover:shadow-lg transition">
                        <div class="bg-gray-100 h-48 flex items-center justify-center">
                            <i class="bi bi-watch text-6xl text-gray-300"></i>
                        </div>
                        <div class="p-4">
                            <p class="text-xs text-gray-500 uppercase mb-1">CASIO</p>
                            <h3 class="font-semibold text-gray-900 mb-2">MTP-1730 SL</h3>
                            <div class="flex items-center mb-2">
                                <i class="bi bi-star-fill text-yellow-400 text-sm"></i>
                                <span class="text-sm text-gray-600 ml-1">4.5 (128 reviews)</span>
                            </div>
                            <p class="text-blue-600 font-bold text-lg mb-3">Rp750.000</p>
                            <button class="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition font-medium">
                                Add to Cart
                            </button>
                        </div>
                    </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <div class="flex justify-center mt-8 space-x-2">
                    <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">Previous</button>
                    <button class="px-4 py-2 bg-blue-600 text-white rounded-lg">1</button>
                    <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">2</button>
                    <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">3</button>
                    <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">Next</button>
                </div>
            </main>
        </div>
    </div>

    <footer class="bg-gray-900 text-white py-8 mt-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p class="text-gray-400">&copy; 2025 The Object Hour. Premium Watch E-Commerce.</p>
        </div>
    </footer>
</body>
</html>
