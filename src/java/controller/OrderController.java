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
        
        System.out.println("OrderController.doGet - Path: " + request.getRequestURI());
        System.out.println("OrderController.doGet - PathInfo: " + request.getPathInfo());
        
        // Check if user is logged in
        Long userId = getUserId(request);
        if (userId == null) {
            System.out.println("OrderController.doGet - User not logged in, redirecting to login");
            HttpSession session = request.getSession(true);
            session.setAttribute("error", "Please login to view your orders");
            session.setAttribute("redirectAfterLogin", request.getRequestURI());
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        System.out.println("OrderController.doGet - User ID: " + userId);
        
        String action = getAction(request);
        System.out.println("OrderController.doGet - Action: " + action);
        
        switch (action) {
            case "list":
            case "":
                System.out.println("OrderController.doGet - Showing order list");
                showOrderList(request, response);
                break;
            case "view":
                System.out.println("OrderController.doGet - Showing order detail");
                showOrderDetail(request, response);
                break;
            case "cancel":
                System.out.println("OrderController.doGet - Cancelling order");
                cancelOrder(request, response);
                break;
            case "history":
                System.out.println("OrderController.doGet - Showing order history");
                showOrderHistory(request, response);
                break;
            default:
                System.out.println("OrderController.doGet - Unknown action, showing order list");
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
     * Show order history with items
     */
    private void showOrderHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long userId = getUserId(request);
        List<Order> orders = orderService.getOrdersByUser(userId);
        
        // Load order items for each order
        for (Order order : orders) {
            Order fullOrder = orderService.getOrderById(order.getId());
            if (fullOrder != null) {
                order.setItems(fullOrder.getItems());
            }
        }
        
        request.setAttribute("orders", orders);
        
        request.getRequestDispatcher("/Customer/history.jsp").forward(request, response);
    }
    
    /**
     * Get user ID from session
     * Uses getSession(true) to ensure session exists and is not accidentally invalidated
     */
    private Long getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        if (session == null) {
            return null;
        }
        
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            return null;
        }
        
        // Handle both Long and Integer types
        if (userIdObj instanceof Long) {
            return (Long) userIdObj;
        } else if (userIdObj instanceof Integer) {
            return ((Integer) userIdObj).longValue();
        }
        
        return null;
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
