package controller;

import service.CartService;
import model.Cart;
import model.User;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * CartController - Controller untuk manajemen shopping cart
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart", "/cart/*"})
public class CartController extends HttpServlet {
    
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "view":
            case "":
                showCart(request, response);
                break;
            case "remove":
                removeItem(request, response);
                break;
            case "clear":
                clearCart(request, response);
                break;
            default:
                showCart(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String action = getAction(request);
        
        switch (action) {
            case "add":
                addToCart(request, response);
                break;
            case "update":
                updateQuantity(request, response);
                break;
            default:
                showCart(request, response);
                break;
        }
    }
    
    /**
     * Show cart
     */
    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        Cart cart = cartService.getCartWithItems(userId);
        BigDecimal total = cartService.getCartTotal(userId);
        
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/Customer/cart.jsp").forward(request, response);
    }
    
    /**
     * Add product to cart
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        
        try {
            Long productId = Long.parseLong(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            boolean success = cartService.addToCart(userId, productId, quantity);
            
            if (success) {
                request.getSession().setAttribute("success", "Produk berhasil ditambahkan ke keranjang");
            } else {
                request.getSession().setAttribute("error", "Gagal menambahkan produk ke keranjang");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Data tidak valid");
        }
        
        // Redirect back
        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
    
    /**
     * Update cart item quantity
     */
    private void updateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            boolean success = cartService.updateCartItemQuantity(cartItemId, quantity);
            
            if (success) {
                request.getSession().setAttribute("success", "Keranjang berhasil diupdate");
            } else {
                request.getSession().setAttribute("error", "Gagal mengupdate keranjang");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Data tidak valid");
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    /**
     * Remove item from cart
     */
    private void removeItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Long cartItemId = Long.parseLong(request.getParameter("id"));
            
            boolean success = cartService.removeFromCart(cartItemId);
            
            if (success) {
                request.getSession().setAttribute("success", "Item berhasil dihapus");
            } else {
                request.getSession().setAttribute("error", "Gagal menghapus item");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Data tidak valid");
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    /**
     * Clear cart
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        boolean success = cartService.clearCart(userId);
        
        if (success) {
            request.getSession().setAttribute("success", "Keranjang berhasil dikosongkan");
        } else {
            request.getSession().setAttribute("error", "Gagal mengosongkan keranjang");
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
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
