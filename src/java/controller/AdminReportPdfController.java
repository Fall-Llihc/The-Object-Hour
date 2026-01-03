package controller;

import model.SalesReport;
import model.User;
import service.ReportService;

import java.io.IOException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name="AdminReportPdfController", urlPatterns={"/admin/reports/pdf"})
public class AdminReportPdfController extends HttpServlet {

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

        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) type = "products";
        type = type.toLowerCase();

        Timestamp startTs = parseStart(request);
        Timestamp endTs = parseEnd(request);

        SalesReport report = "orders".equals(type)
                ? reportService.generateOrderSalesReport(startTs, endTs)
                : reportService.generateProductSalesReport(startTs, endTs);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "inline; filename=\"sales-report-" + type + ".pdf\"");

        reportService.exportReportToPdf(
                report, type,
                request.getParameter("startDate"),
                request.getParameter("endDate"),
                response.getOutputStream()
        );
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
        return Timestamp.valueOf(java.time.LocalDate.parse(start).atStartOfDay());
    }

    private Timestamp parseEnd(HttpServletRequest request) {
        String end = request.getParameter("endDate");
        if (end == null || end.isEmpty()) return null;
        return Timestamp.valueOf(java.time.LocalDate.parse(end).plusDays(1).atStartOfDay());
    }
}
