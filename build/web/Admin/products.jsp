<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
        body { background-color: #f9fafb; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .table-actions { white-space: nowrap; }
        .card { border-radius: 12px; box-shadow: 0 6px 18px rgba(22,33,62,0.06); }
        .card .card-body { padding: 1.25rem; }
        .card-header-gradient { background: linear-gradient(90deg, #6b46c1 0%, #b794f4 100%); color: #fff; border-radius: 12px 12px 0 0; padding: 1rem 1.25rem; }
        .product-thumb { width: 64px; height: 64px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(0,0,0,0.06); }
        .table-hover tbody tr:hover { background: linear-gradient(90deg, rgba(102,126,234,0.03), rgba(118,75,162,0.03)); }
        .btn-theme { background: linear-gradient(90deg,#667eea,#764ba2); color: #fff; border: none; }
        .fallback-icon { display: inline-flex; align-items: center; justify-content: center; width:64px; height:64px; background:#eef2ff; color:#4c51bf; border-radius:8px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-watch"></i> The Object Hour - Admin
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
                    <li class="nav-item">
                        <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
                            <i class="bi bi-moon-fill"></i>
                        </button>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0"><i class="bi bi-box-seam"></i> Product Management</h2>
                <small class="text-muted">Manage your catalog and product images</small>
            </div>
            <a href="${pageContext.request.contextPath}/admin/products/create" class="btn btn-theme">
                <i class="bi bi-plus-circle"></i> Add New Product
            </a>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                <c:remove var="success" scope="session"/>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header-gradient">
                <strong>Products</strong>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Image</th>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Brand</th>
                                <th>Type</th>
                                <th>Strap</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${products}" var="product">
                                <tr>
                                    <td>
                                        <img src="${product.imageUrl}" alt="${product.name}" class="product-thumb" onerror="if(this.src !== '${product.imageUrlJpg}') { this.src = '${product.imageUrlJpg}'; } else { this.style.display='none'; this.nextElementSibling.style.display='inline-flex'; }">
                                        <span class="fallback-icon" style="display:none;"><i class="bi bi-watch" style="font-size:1.25rem"></i></span>
                                    </td>
                                    <td>${product.id}</td>
                                    <td>${product.name}</td>
                                    <td>${product.brand}</td>
                                    <td><span class="badge bg-info">${product.type}</span></td>
                                    <td>${product.strapMaterial}</td>
                                    <td><fmt:formatNumber value="${product.price}" type="currency" currencyCode="IDR"/></td>
                                    <td>
                                        <c:if test="${product.stock > 10}">
                                            <span class="badge bg-success">${product.stock}</span>
                                        </c:if>
                                        <c:if test="${product.stock > 0 && product.stock <= 10}">
                                            <span class="badge bg-warning">${product.stock}</span>
                                        </c:if>
                                        <c:if test="${product.stock <= 0}">
                                            <span class="badge bg-danger">${product.stock}</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${product.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:if>
                                        <c:if test="${!product.active}">
                                            <span class="badge bg-secondary">Inactive</span>
                                        </c:if>
                                    </td>
                                    <td class="table-actions">
                                    <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}" 
                                       class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-pencil"></i> Edit
                                    </a>

                                    <c:choose>
                                        <c:when test="${product.active}">
                                            <a href="${pageContext.request.contextPath}/admin/products/delete?id=${product.id}" 
                                               class="btn btn-sm btn-outline-danger"
                                               onclick="return confirm('Nonaktifkan produk ini?')">
                                                <i class="bi bi-x-circle"></i> Deactivate
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/admin/products/activate?id=${product.id}" 
                                               class="btn btn-sm btn-outline-success">
                                                <i class="bi bi-check-circle"></i> Activate
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/admin/products/hard-delete?id=${product.id}" 
                                        class="btn btn-sm btn-danger" 
                                        onclick="return confirm('PERINGATAN: Data akan dihapus selamanya dari database. Lanjutkan?')">
                                        <i class="bi bi-trash-fill"></i> Delete
                                     </a>
                                </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty products}">
                    <div class="alert alert-info text-center">
                        <i class="bi bi-info-circle"></i> No products found
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>
