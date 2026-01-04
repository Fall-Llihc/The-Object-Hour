<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Admin</title>

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

        .card { border-radius: 12px; box-shadow: 0 6px 18px rgba(22,33,62,0.06); }
        .card .card-body { padding: 1.25rem; }
        .card-header-gradient {
            background: linear-gradient(90deg, #6b46c1 0%, #b794f4 100%);
            color: #fff;
            border-radius: 12px 12px 0 0;
            padding: 1rem 1.25rem;
        }

        .btn-theme { background: linear-gradient(90deg,#667eea,#764ba2); color:#fff; border:none; }
        .btn-theme:hover { opacity: 0.95; color:#fff; }

        .table-hover tbody tr:hover {
            background: linear-gradient(90deg, rgba(102,126,234,0.03), rgba(118,75,162,0.03));
        }

        .summary-value { font-size: 1.4rem; font-weight: 800; }
        .summary-label { color: #6B7280; font-size: 0.9rem; }
    </style>
</head>

<body>
    <!-- Navbar (SAMA dengan Admin/products.jsp) -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-watch"></i> The Object Hour - Admin
            </a>

            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/products">Products</a>
                    </li>

                    <!-- active di Reports -->
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports">Reports</a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                    
                    <!-- Dark Mode Toggle -->
                    <li class="nav-item ms-2">
                        <button type="button" class="dark-mode-toggle" title="Toggle Dark Mode">
                            <i class="bi bi-moon-fill"></i>
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0"><i class="bi bi-graph-up-arrow"></i> Reports</h2>
                <small class="text-muted">Sales & order analytics</small>
            </div>

            <div class="d-flex gap-2">
                <!-- Export PDF -->
                <a class="btn btn-success"
                   href="${pageContext.request.contextPath}/admin/reports/pdf?type=${type}<c:if test='${not empty startDate}'>&startDate=${startDate}</c:if><c:if test='${not empty endDate}'>&endDate=${endDate}</c:if>">
                    <i class="bi bi-file-earmark-pdf"></i> Export PDF
                </a>

                <a class="btn btn-outline-primary"
                   href="${pageContext.request.contextPath}/admin/products">
                    <i class="bi bi-arrow-left"></i> Back to Products
                </a>
            </div>
        </div>

        <!-- Tabs -->
        <div class="d-flex gap-2 mb-3">
            <a class="btn ${type == 'orders' ? 'btn-outline-primary' : 'btn-theme'}"
               href="${pageContext.request.contextPath}/admin/reports?type=products">
                Product Report
            </a>
            <a class="btn ${type == 'orders' ? 'btn-theme' : 'btn-outline-primary'}"
               href="${pageContext.request.contextPath}/admin/reports?type=orders">
                Order Report
            </a>
        </div>

        <!-- Filter Card -->
        <div class="card mb-4">
            <div class="card-header-gradient">
                <strong>Filter</strong>
            </div>
            <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/admin/reports" class="row g-3 align-items-end">
                    <input type="hidden" name="type" value="${type}">

                    <div class="col-md-3">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" value="${startDate}" class="form-control">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" value="${endDate}" class="form-control">
                    </div>

                    <div class="col-md-6 d-flex gap-2">
                        <button class="btn btn-theme" type="submit">
                            <i class="bi bi-funnel"></i> Generate
                        </button>

                        <a class="btn btn-outline-secondary"
                           href="${pageContext.request.contextPath}/admin/reports?type=${type}">
                            Reset
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Summary -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <div class="summary-label">Total Revenue</div>
                        <div class="summary-value text-primary">
                            <fmt:formatNumber value="${report.totalRevenue}" type="currency" currencySymbol="Rp"
                                              groupingUsed="true" maxFractionDigits="0"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <div class="summary-label">Total Paid Orders</div>
                        <div class="summary-value">${report.totalPaidOrders}</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <div class="summary-label">Products Sold</div>
                        <div class="summary-value">${report.totalProductsSold}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Report Table -->
        <c:if test="${type == 'products'}">
            <div class="card mb-4">
                <div class="card-header-gradient">
                    <strong>Product Report</strong>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Product</th>
                                    <th>Brand</th>
                                    <th class="text-end">Qty Sold</th>
                                    <th class="text-end">Revenue</th>
                                    <th class="text-end">Orders</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${report.productReport}" var="r">
                                    <tr>
                                        <td>${r.productName}</td>
                                        <td>${r.productBrand}</td>
                                        <td class="text-end">${r.totalQuantitySold}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${r.totalRevenue}" type="currency" currencySymbol="Rp"
                                                              groupingUsed="true" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-end">${r.totalOrders}</td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty report.productReport}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="bi bi-info-circle"></i> No product report data.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Order Report Table -->
        <c:if test="${type == 'orders'}">
            <div class="card mb-4">
                <div class="card-header-gradient">
                    <strong>Order Report</strong>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Order</th>
                                    <th>Customer</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${report.paidOrders}" var="o">
                                    <tr>
                                        <td>#${o.id}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty o.user}">
                                                    ${o.user.name}
                                                </c:when>
                                                <c:otherwise>
                                                    UserID: ${o.userId}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge bg-success">${o.status}</span></td>
                                        <td>${o.paidAt}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="Rp"
                                                              groupingUsed="true" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty report.paidOrders}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            <i class="bi bi-info-circle"></i> No paid orders.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty store}">
            <div class="text-muted small mb-4">
                Snapshot DataStore: Orders = ${store.orders.size()} | Products = ${store.products.size()}
            </div>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>