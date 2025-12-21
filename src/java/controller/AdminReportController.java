package controller;

import service.ReportService;
import service.OrderService;
import model.ReportEntry;
import model.Order;
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
 * AdminReportController - Controller untuk laporan penjualan (Admin only)
 * 
 * @author The Object Hour Team
 */
@WebServlet(name = "AdminReportController", urlPatterns = {"/admin/reports", "/admin/reports/*"})
public class AdminReportController extends HttpServlet {
    
    private ReportService reportService;
    private OrderService orderService;
    
    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        orderService = new OrderService();
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
            case "sales":
            case "":
                showSalesReport(request, response);
                break;
            case "orders":
                showOrdersReport(request, response);
                break;
            default:
                showSalesReport(request, response);
                break;
        }
    }
    
    /**
     * Show sales report
     */
    private void showSalesReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get sales report by product
        List<ReportEntry> salesReport = reportService.getSalesReportByProduct();
        
        // Get summary statistics
        BigDecimal totalRevenue = reportService.getTotalRevenue();
        int totalOrders = reportService.getTotalOrdersCount();
        int totalProductsSold = reportService.getTotalProductsSold();
        
        // Get top selling products
        List<ReportEntry> topProducts = reportService.getTopSellingProducts(10);
        
        request.setAttribute("salesReport", salesReport);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalProductsSold", totalProductsSold);
        request.setAttribute("topProducts", topProducts);
        
        request.getRequestDispatcher("/Admin/reports.jsp").forward(request, response);
    }
    
    /**
     * Show orders report
     */
    private void showOrdersReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all orders
        List<Order> allOrders = orderService.getAllOrders();
        
        // Get paid orders
        List<Order> paidOrders = orderService.getOrdersByStatus("PAID");
        
        // Get pending orders
        List<Order> pendingOrders = orderService.getOrdersByStatus("PENDING");
        
        request.setAttribute("allOrders", allOrders);
        request.setAttribute("paidOrders", paidOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        
        request.getRequestDispatcher("/Admin/orders-report.jsp").forward(request, response);
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
