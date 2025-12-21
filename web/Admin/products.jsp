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
    <style>
        body { background-color: #f9fafb; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .table-actions { white-space: nowrap; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-watch"></i> The Object Hour - Admin
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right"></i> Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-box-seam"></i> Product Management</h2>
            <a href="${pageContext.request.contextPath}/admin/products/create" class="btn btn-primary">
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
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
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
                                        <a href="${pageContext.request.contextPath}/admin/products/delete?id=${product.id}" 
                                           class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Deactivate this product?')">
                                            <i class="bi bi-trash"></i> Delete
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
</body>
</html>
