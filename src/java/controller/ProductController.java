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
 * ProductController - Controller untuk manajemen produk
 * Handles product listing for customers and CRUD for admin
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "ProductController", urlPatterns = {"/products", "/products/*"})
public class ProductController extends HttpServlet {
    
    private ProductService productService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getAction(request);
        
        switch (action) {
            case "list":
            case "":
                showProductList(request, response);
                break;
            case "view":
                showProductDetail(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                showProductList(request, response);
                break;
        }
    }
    
    /**
     * Show product list (customer view)
     */
    private void showProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get filter parameters
        String type = request.getParameter("type");
        String brand = request.getParameter("brand");
        
        List<Product> products;
        
        if (type != null && !type.trim().isEmpty()) {
            products = productService.getProductsByType(type);
        } else if (brand != null && !brand.trim().isEmpty()) {
            products = productService.getProductsByBrand(brand);
        } else {
            products = productService.getAllActiveProducts();
        }
        
        request.setAttribute("products", products);
        request.setAttribute("selectedType", type);
        request.setAttribute("selectedBrand", brand);
        
        request.getRequestDispatcher("/Customer/products.jsp").forward(request, response);
    }
    
    /**
     * Show product detail
     */
    private void showProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdStr = request.getParameter("id");
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            Long productId = Long.parseLong(productIdStr);
            Product product = productService.getProductById(productId);
            
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/Customer/product-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Produk tidak ditemukan");
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
    
    /**
     * Search products
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        List<Product> products = productService.searchProducts(keyword);
        
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        
        request.getRequestDispatcher("/Customer/products.jsp").forward(request, response);
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
