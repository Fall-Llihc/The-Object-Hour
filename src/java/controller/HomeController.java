package controller;

import dao.ProductDAO;
import model.Product;
import service.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * HomeController - Handle homepage requests
 * Load featured products for display
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "HomeController", urlPatterns = {"", "/", "/home"})
public class HomeController extends HttpServlet {
    
    private ProductDAO productDAO;
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.productDAO = new ProductDAO();
        this.cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get active products only
            List<Product> featuredProducts = productDAO.findAllActive();
            
            // Limit to 8 products for featured section
            if (featuredProducts.size() > 8) {
                featuredProducts = featuredProducts.subList(0, 8);
            }
            
            // Set products as request attribute
            request.setAttribute("featuredProducts", featuredProducts);
            
            // Set cart count for navbar
            Long userId = getUserId(request);
            if (userId != null) {
                int cartCount = cartService.getCartItemsCount(userId);
                request.setAttribute("cartCount", cartCount);
            }
            
            // Forward to home page
            request.getRequestDispatcher("/Customer/home.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load featured products: " + e.getMessage());
            request.getRequestDispatcher("/Customer/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Get userId from session
     */
    private Long getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Long) session.getAttribute("userId");
    }
}
