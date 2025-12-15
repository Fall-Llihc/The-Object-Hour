package controller;

import service.OrderService;
import model.Order;
import model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * OrderController - Controller untuk manajemen order
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "OrderController", urlPatterns = {"/orders", "/orders/*"})
public class OrderController extends HttpServlet {
    
    private OrderService orderService;
    
    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
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
            case "list":
            case "":
                showOrderList(request, response);
                break;
            case "view":
                showOrderDetail(request, response);
                break;
            case "cancel":
                cancelOrder(request, response);
                break;
            default:
                showOrderList(request, response);
                break;
        }
    }
    
    /**
     * Show order list
     */
    private void showOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        List<Order> orders = orderService.getOrdersByUser(userId);
        
        request.setAttribute("orders", orders);
        
        request.getRequestDispatcher("/Customer/orders.jsp").forward(request, response);
    }
    
    /**
     * Show order detail
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        
        try {
            Long orderId = Long.parseLong(orderIdStr);
            Order order = orderService.getOrderById(orderId);
            
            // Check if order belongs to user
            Long userId = getUserId(request);
            if (order != null && order.getUserId().equals(userId)) {
                request.setAttribute("order", order);
                request.getRequestDispatcher("/Customer/order-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Pesanan tidak ditemukan");
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
    
    /**
     * Cancel order
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            try {
                Long orderId = Long.parseLong(orderIdStr);
                Order order = orderService.getOrderById(orderId);
                
                // Check if order belongs to user
                Long userId = getUserId(request);
                if (order != null && order.getUserId().equals(userId)) {
                    boolean success = orderService.cancelOrder(orderId);
                    
                    if (success) {
                        request.getSession().setAttribute("success", "Pesanan berhasil dibatalkan");
                    } else {
                        request.getSession().setAttribute("error", "Gagal membatalkan pesanan");
                    }
                } else {
                    request.getSession().setAttribute("error", "Pesanan tidak ditemukan");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID pesanan tidak valid");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/orders");
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
