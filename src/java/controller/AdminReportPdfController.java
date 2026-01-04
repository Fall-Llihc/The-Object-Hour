package controller;

import model.SalesReport;
import model.User;
import service.ReportService;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name="AdminReportPdfController", urlPatterns={"/admin/reports/pdf"})
public class AdminReportPdfController extends HttpServlet {

    private ReportService reportService;
    private boolean pdfLibraryAvailable = true;

    @Override
    public void init() throws ServletException {
        reportService = new ReportService();
        
        // Check if OpenPDF library is available
        try {
            Class.forName("com.lowagie.text.Document");
        } catch (ClassNotFoundException e) {
            pdfLibraryAvailable = false;
            System.err.println("WARNING: OpenPDF library not found. PDF export will be disabled.");
            System.err.println("Please add openpdf-1.3.26.jar to lib/ and WEB-INF/lib/ folders.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        // Check if PDF library is available
        if (!pdfLibraryAvailable) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>PDF Export Error</title>");
            out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
            out.println("</head><body class='bg-light'>");
            out.println("<div class='container py-5'>");
            out.println("<div class='alert alert-danger'>");
            out.println("<h4 class='alert-heading'><i class='bi bi-exclamation-triangle'></i> PDF Library Not Found</h4>");
            out.println("<p>The OpenPDF library is not installed. PDF export is currently unavailable.</p>");
            out.println("<hr>");
            out.println("<p class='mb-0'><strong>Solution:</strong></p>");
            out.println("<ol>");
            out.println("<li>Download <code>openpdf-1.3.26.jar</code> from Maven Central</li>");
            out.println("<li>Copy to <code>lib/</code> and <code>web/WEB-INF/lib/</code> folders</li>");
            out.println("<li>Restart the server</li>");
            out.println("</ol>");
            out.println("<a href='" + request.getContextPath() + "/admin/reports' class='btn btn-primary'>Back to Reports</a>");
            out.println("</div></div></body></html>");
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

        try {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "inline; filename=\"sales-report-" + type + ".pdf\"");

            reportService.exportReportToPdf(
                    report, type,
                    request.getParameter("startDate"),
                    request.getParameter("endDate"),
                    response.getOutputStream()
            );
        } catch (NoClassDefFoundError | Exception e) {
            // Handle case where PDF library fails at runtime
            response.reset();
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>PDF Export Error</title>");
            out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
            out.println("</head><body class='bg-light'>");
            out.println("<div class='container py-5'>");
            out.println("<div class='alert alert-danger'>");
            out.println("<h4 class='alert-heading'>PDF Generation Failed</h4>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            out.println("<hr>");
            out.println("<p class='mb-0'><strong>Possible solutions:</strong></p>");
            out.println("<ol>");
            out.println("<li>Ensure <code>openpdf-1.3.26.jar</code> is in <code>lib/</code> and <code>WEB-INF/lib/</code></li>");
            out.println("<li>Clean and rebuild the project</li>");
            out.println("<li>Restart the server</li>");
            out.println("</ol>");
            out.println("<a href='" + request.getContextPath() + "/admin/reports' class='btn btn-primary'>Back to Reports</a>");
            out.println("</div></div></body></html>");
        }
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
