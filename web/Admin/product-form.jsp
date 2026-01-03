<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty product ? 'Add Product' : 'Edit Product'} - Admin</title>
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
        .form-card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
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

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <h2 class="mt-2">
                        <i class="bi ${empty product ? 'bi-plus-circle' : 'bi-pencil-square'}"></i> 
                        ${empty product ? 'Add New Product' : 'Edit Product'}
                    </h2>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="card form-card">
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/admin/products/${empty product ? 'create' : 'edit'}" method="POST" enctype="multipart/form-data">
                            
                            <c:if test="${not empty product}">
                                <input type="hidden" name="id" value="${product.id}">
                            </c:if>

                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" name="name" class="form-control" value="${product.name}" required placeholder="e.g. Rolex Submariner">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Brand</label>
                                    <input type="text" name="brand" class="form-control" value="${product.brand}" required placeholder="e.g. Rolex">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Movement Type</label>
                                    <select name="type" class="form-select" required>
                                        <option value="">Select Type</option>
                                        <option value="ANALOG" ${product.type == 'ANALOG' ? 'selected' : ''}>Analog</option>
                                        <option value="DIGITAL" ${product.type == 'DIGITAL' ? 'selected' : ''}>Digital</option>
                                        <option value="SMARTWATCH" ${product.type == 'SMARTWATCH' ? 'selected' : ''}>Smartwatch</option>
                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Strap Material</label>
                                    <input type="text" name="strapMaterial" class="form-control" value="${product.strapMaterial}" required placeholder="e.g. Stainless Steel">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Price (IDR)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">Rp</span>
                                        <input type="number" name="price" class="form-control" value="${product.price}" required min="0" step="0.01">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Stock Quantity</label>
                                    <input type="number" name="stock" class="form-control" value="${product.stock}" required min="0">
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label">Product Image (PNG or JPG)</label>
                                    <input type="file" name="image" id="imageInput" class="form-control" accept="image/png,image/jpeg">
                                    <div class="form-text">File akan dinamai otomatis menjadi "{brand} {name}.png" atau ".jpg" sesuai ekstensi upload.</div>
                                    <div class="mt-3 d-flex align-items-center gap-3">
                                        <img id="imagePreview" src="${not empty product ? product.imageUrl : ''}" alt="Preview" style="width:96px;height:96px;object-fit:cover;border-radius:8px;border:1px solid rgba(0,0,0,0.06);display:${not empty product ? 'inline-block' : 'none'};" onerror="this.style.display='none';document.getElementById('previewFallback').style.display='inline-flex';">
                                        <div id="previewFallback" class="fallback-icon" style="display:${not empty product ? 'none' : 'inline-flex'};">
                                            <i class="bi bi-watch" style="font-size:1.5rem;color:#4c51bf"></i>
                                        </div>
                                        <div class="text-muted">Preview gambar produk. Jika kosong, akan menampilkan icon default.</div>
                                    </div>
                                </div>

                                <c:if test="${not empty product}">
                                    <div class="col-md-6">
                                        <label class="form-label">Product Status</label>
                                        <select name="isActive" class="form-select">
                                            <option value="true" ${product.active ? 'selected' : ''}>Active</option>
                                            <option value="false" ${!product.active ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                </c:if>
                            </div>

                            <hr class="my-4">

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-light">Cancel</a>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-save"></i> ${empty product ? 'Create Product' : 'Save Changes'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
                    fallback.style.display = 'inline-flex';
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(ev){
                    preview.src = ev.target.result;
                    preview.style.display = 'inline-block';
                    fallback.style.display = 'none';
                };
                reader.readAsDataURL(file);
            });
        })();
    </script>
    <script>(function(){function u(){var d=document.documentElement.classList.contains('dark-mode'),b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){var c=b[i].getElementsByTagName('i')[0];if(c)c.className=d?'bi bi-sun-fill':'bi bi-moon-fill';}}function t(){var h=document.documentElement;if(h.classList.contains('dark-mode')){h.classList.remove('dark-mode');localStorage.setItem('darkMode','false');}else{h.classList.add('dark-mode');localStorage.setItem('darkMode','true');}u();}var b=document.getElementsByClassName('dark-mode-toggle');for(var i=0;i<b.length;i++){b[i].onclick=t;}u();window.toggleDarkMode=t;})();</script>
</body>
</html>