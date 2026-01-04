package controller;

import model.Order;
import model.SalesReport;
import model.User;
import service.DataStore;
import service.ReportService;

import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * AdminReportController - Controller untuk laporan penjualan (Admin only)
 */
@WebServlet(name = "AdminReportController", urlPatterns = {"/admin/reports"})
public class AdminReportController extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        DataStore.getInstance().refreshAll();

        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) type = "products";
        type = type.toLowerCase();

        Timestamp startTs = parseStart(request);
        Timestamp endTs = parseEnd(request);

        // generate SalesReport 
        SalesReport report;
        if ("orders".equals(type)) {
            report = reportService.generateOrderSalesReport(startTs, endTs);

            // ====== DETAIL ORDER (optional via query param orderId) ======
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
                try {
                    Long orderId = Long.valueOf(orderIdParam);
                    Order selectedOrder = reportService.getPaidOrderWithItems(orderId);

                    boolean existsInReport = report.getPaidOrders() != null &&
                            report.getPaidOrders().stream().anyMatch(o -> o.getId().equals(orderId));

                    if (selectedOrder != null && existsInReport) {
                        request.setAttribute("selectedOrder", selectedOrder);
                    } else {
                        request.setAttribute("selectedOrder", null);
                    }
                } catch (NumberFormatException ignored) {
                    request.setAttribute("selectedOrder", null);
                }
            }

        } else {
            type = "products"; // normalize
            report = reportService.generateProductSalesReport(startTs, endTs);
        }

        request.setAttribute("type", type);
        request.setAttribute("report", report);

        request.setAttribute("startDate", request.getParameter("startDate"));
        request.setAttribute("endDate", request.getParameter("endDate"));

        request.getRequestDispatcher("/Admin/report.jsp").forward(request, response);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }

    private Timestamp parseStart(HttpServletRequest request) {
        String start = request.getParameter("startDate");
        if (start == null || start.isEmpty()) return null;

        // start: YYYY-MM-DD 00:00:00
        return Timestamp.valueOf(java.time.LocalDate.parse(start).atStartOfDay());
    }

    private Timestamp parseEnd(HttpServletRequest request) {
        String end = request.getParameter("endDate");
        if (end == null || end.isEmpty()) return null;

        // end inclusive: +1 hari, jadi BETWEEN start AND endPlus1
        return Timestamp.valueOf(java.time.LocalDate.parse(end).plusDays(1).atStartOfDay());
    }
}