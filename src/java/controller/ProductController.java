package controller;

import service.ProductService;
import service.CartService;
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
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        cartService = new CartService();
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
        
        // Get filter parameters (multiple values)
        String[] types = request.getParameterValues("type");
        String[] brands = request.getParameterValues("brand");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String inStockStr = request.getParameter("inStock");
        String searchKeyword = request.getParameter("search");
        
        // Get pagination parameter
        String pageStr = request.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        // Items per page
        final int ITEMS_PER_PAGE = 12;
        
        // Start with all active products
        List<Product> allProducts = productService.getAllActiveProducts();
        
        // Apply search filter first
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            final String keyword = searchKeyword.trim().toLowerCase();
            allProducts = allProducts.stream()
                    .filter(p -> 
                        p.getName().toLowerCase().contains(keyword) ||
                        p.getBrand().toLowerCase().contains(keyword) ||
                        p.getType().toLowerCase().contains(keyword)
                    )
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // Apply filters
        if (types != null && types.length > 0) {
            // Filter by multiple types
            List<String> typeList = java.util.Arrays.asList(types);
            allProducts = allProducts.stream()
                    .filter(p -> typeList.contains(p.getType()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        if (brands != null && brands.length > 0) {
            // Filter by multiple brands
            List<String> brandList = java.util.Arrays.asList(brands);
            allProducts = allProducts.stream()
                    .filter(p -> brandList.contains(p.getBrand()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // Price range filter
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                java.math.BigDecimal minPrice = new java.math.BigDecimal(minPriceStr);
                allProducts = allProducts.stream()
                        .filter(p -> p.getPrice().compareTo(minPrice) >= 0)
                        .collect(java.util.stream.Collectors.toList());
            } catch (NumberFormatException e) {
                // Invalid price, skip filter
            }
        }
        
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                java.math.BigDecimal maxPrice = new java.math.BigDecimal(maxPriceStr);
                allProducts = allProducts.stream()
                        .filter(p -> p.getPrice().compareTo(maxPrice) <= 0)
                        .collect(java.util.stream.Collectors.toList());
            } catch (NumberFormatException e) {
                // Invalid price, skip filter
            }
        }
        
        // Stock filter
        if ("true".equals(inStockStr)) {
            allProducts = allProducts.stream()
                    .filter(p -> p.getStock() > 0)
                    .collect(java.util.stream.Collectors.toList());
        }
        
        // Calculate pagination
        int totalProducts = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);
        
        // Adjust current page if out of range
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        // Get products for current page
        int startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
        int endIndex = Math.min(startIndex + ITEMS_PER_PAGE, totalProducts);
        
        List<Product> products = totalProducts > 0 ? 
                allProducts.subList(startIndex, endIndex) : 
                java.util.Collections.emptyList();
        
        // Set attributes for JSP
        request.setAttribute("products", products);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("search", searchKeyword != null ? searchKeyword : "");
        request.setAttribute("selectedTypes", types != null ? java.util.Arrays.asList(types) : java.util.Collections.emptyList());
        request.setAttribute("selectedBrands", brands != null ? java.util.Arrays.asList(brands) : java.util.Collections.emptyList());
        request.setAttribute("minPrice", minPriceStr != null ? minPriceStr : "");
        request.setAttribute("maxPrice", maxPriceStr != null ? maxPriceStr : "");
        request.setAttribute("inStock", "true".equals(inStockStr));
        
        // Set cart count for navbar
        Long userId = getUserId(request);
        if (userId != null) {
            int cartCount = cartService.getCartItemsCount(userId);
            request.setAttribute("cartCount", cartCount);
        }
        
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
    
    /**
     * Get user ID from session
     */
    private Long getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Long) session.getAttribute("userId");
    }
}
