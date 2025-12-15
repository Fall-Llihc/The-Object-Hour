package controller;

import service.ProductService;
import model.Product;
import model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * AdminProductController - Controller untuk manajemen produk (Admin)
 * Handles CRUD operations for products (Admin only)
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products", "/admin/products/*"})
public class AdminProductController extends HttpServlet {
    
    private ProductService productService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "list":
            case "":
                showProductList(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                showProductList(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "create":
                createProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                showProductList(request, response);
                break;
        }
    }
    
    /**
     * Show product list (admin view)
     */
    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> products = productService.getAllProducts();
        
        request.setAttribute("products", products);
        request.getRequestDispatcher("/Admin/products.jsp").forward(request, response);
    }
    
    /**
     * Show create product form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
    }
    
    /**
     * Show edit product form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("id");
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        try {
            Long productId = Long.parseLong(productIdStr);
            Product product = productService.getProductById(productId);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Produk tidak ditemukan");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Create new product
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String type = request.getParameter("type");
            String strapMaterial = request.getParameter("strapMaterial");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            
            Long productId = productService.createProduct(name, brand, type, strapMaterial, price, stock);
            
            if (productId != null) {
                request.getSession().setAttribute("success", "Produk berhasil ditambahkan");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("error", "Gagal menambahkan produk");
                request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Data tidak valid: " + e.getMessage());
            request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Update product
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            String brand = request.getParameter("brand");
            String type = request.getParameter("type");
            String strapMaterial = request.getParameter("strapMaterial");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            boolean isActive = "true".equals(request.getParameter("isActive"));
            
            Product product = productService.getProductById(id);
            if (product != null) {
                product.setName(name);
                product.setBrand(brand);
                product.setType(type);
                product.setStrapMaterial(strapMaterial);
                product.setPrice(price);
                product.setStock(stock);
                product.setActive(isActive);
                
                boolean success = productService.updateProduct(product);
                
                if (success) {
                    request.getSession().setAttribute("success", "Produk berhasil diupdate");
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                } else {
                    request.setAttribute("error", "Gagal mengupdate produk");
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Data tidak valid: " + e.getMessage());
            request.getRequestDispatcher("/Admin/product-form.jsp").forward(request, response);
        }
    }
    
    /**
     * Delete (deactivate) product
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("id");
        
        if (productIdStr != null && !productIdStr.trim().isEmpty()) {
            try {
                Long productId = Long.parseLong(productIdStr);
                boolean success = productService.deleteProduct(productId);
                
                if (success) {
                    request.getSession().setAttribute("success", "Produk berhasil dinonaktifkan");
                } else {
                    request.getSession().setAttribute("error", "Gagal menonaktifkan produk");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID produk tidak valid");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
    
    /**
     * Check if user is admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }
    
    /**
     * Get action from request path
     */
    private String getAction(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            return "";
        }
        return pathInfo.substring(1);
    }
}
