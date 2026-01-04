package service;

import config.JDBC;
import dao.OrderDAO;
import model.Order;
import model.ReportEntry;
import model.SalesReport;
import dao.OrderItemDAO;
import model.OrderItem;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import java.io.OutputStream;
import java.time.LocalDateTime;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ReportService - Service layer untuk laporan penjualan
 */
public class ReportService {

    private final OrderDAO orderDAO = new OrderDAO();

    public List<ReportEntry> getSalesReportByProduct() {
        List<ReportEntry> reports = new ArrayList<>();

        String sql = "SELECT " +
                "    p.id as product_id, " +
                "    p.name as product_name, " +
                "    p.brand as product_brand, " +
                "    COALESCE(SUM(oi.quantity), 0) as total_quantity, " +
                "    COALESCE(SUM(oi.subtotal), 0) as total_revenue, " +
                "    COUNT(DISTINCT o.id) as total_orders " +
                "FROM products p " +
                "LEFT JOIN order_items oi ON p.id = oi.product_id " +
                "LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'PAID' " +
                "GROUP BY p.id, p.name, p.brand " +
                "ORDER BY total_revenue DESC";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ReportEntry entry = new ReportEntry();
                entry.setProductId(rs.getLong("product_id"));
                entry.setProductName(rs.getString("product_name"));
                entry.setProductBrand(rs.getString("product_brand"));
                entry.setTotalQuantitySold(rs.getInt("total_quantity"));
                entry.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                entry.setTotalOrders(rs.getInt("total_orders"));
                reports.add(entry);
            }

        } catch (SQLException e) {
            System.err.println("Error getting sales report: " + e.getMessage());
            e.printStackTrace();
        }

        return reports;
    }

    public List<ReportEntry> getSalesReportByProductAndDate(Timestamp startDate, Timestamp endDate) {
        List<ReportEntry> reports = new ArrayList<>();

        String sql = "SELECT " +
                "    p.id as product_id, " +
                "    p.name as product_name, " +
                "    p.brand as product_brand, " +
                "    SUM(oi.quantity) as total_quantity, " +
                "    SUM(oi.subtotal) as total_revenue, " +
                "    COUNT(DISTINCT o.id) as total_orders " +
                "FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.id " +
                "JOIN products p ON p.id = oi.product_id " +
                "WHERE o.status = 'PAID' " +
                "  AND o.created_at >= ? AND o.created_at < ? " +
                "GROUP BY p.id, p.name, p.brand " +
                "ORDER BY total_revenue DESC";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportEntry entry = new ReportEntry();
                entry.setProductId(rs.getLong("product_id"));
                entry.setProductName(rs.getString("product_name"));
                entry.setProductBrand(rs.getString("product_brand"));
                entry.setTotalQuantitySold(rs.getInt("total_quantity"));
                entry.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                entry.setTotalOrders(rs.getInt("total_orders"));
                reports.add(entry);
            }

        } catch (SQLException e) {
            System.err.println("Error getting sales report by date: " + e.getMessage());
            e.printStackTrace();
        }

        return reports;
    }


    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE status = 'PAID'";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getBigDecimal("total");

        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    public BigDecimal getTotalRevenueByDate(Timestamp startDate, Timestamp endDate) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total " +
                "FROM orders WHERE status = 'PAID' AND created_at BETWEEN ? AND ?";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getBigDecimal("total");

        } catch (SQLException e) {
            System.err.println("Error getting total revenue by date: " + e.getMessage());
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE status = 'PAID'";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting total orders count: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public int getTotalOrdersCountByDate(Timestamp startDate, Timestamp endDate) {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE status = 'PAID' AND created_at BETWEEN ? AND ?";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting total orders count by date: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public int getTotalProductsSold() {
        String sql = "SELECT COALESCE(SUM(oi.quantity), 0) as total " +
                "FROM order_items oi JOIN orders o ON oi.order_id = o.id WHERE o.status = 'PAID'";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting total products sold: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public int getTotalProductsSoldByDate(Timestamp startDate, Timestamp endDate) {
        String sql = "SELECT COALESCE(SUM(oi.quantity), 0) as total " +
                "FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.id " +
                "WHERE o.status = 'PAID' AND o.created_at BETWEEN ? AND ?";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("total");

        } catch (SQLException e) {
            System.err.println("Error getting total products sold by date: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public List<ReportEntry> getTopSellingProducts(int limit) {
        List<ReportEntry> reports = new ArrayList<>();

        String sql = "SELECT " +
                "    p.id as product_id, " +
                "    p.name as product_name, " +
                "    p.brand as product_brand, " +
                "    SUM(oi.quantity) as total_quantity, " +
                "    SUM(oi.subtotal) as total_revenue, " +
                "    COUNT(DISTINCT o.id) as total_orders " +
                "FROM products p " +
                "JOIN order_items oi ON p.id = oi.product_id " +
                "JOIN orders o ON oi.order_id = o.id AND o.status = 'PAID' " +
                "GROUP BY p.id, p.name, p.brand " +
                "ORDER BY total_quantity DESC " +
                "LIMIT ?";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ReportEntry entry = new ReportEntry();
                entry.setProductId(rs.getLong("product_id"));
                entry.setProductName(rs.getString("product_name"));
                entry.setProductBrand(rs.getString("product_brand"));
                entry.setTotalQuantitySold(rs.getInt("total_quantity"));
                entry.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                entry.setTotalOrders(rs.getInt("total_orders"));
                reports.add(entry);
            }

        } catch (SQLException e) {
            System.err.println("Error getting top selling products: " + e.getMessage());
            e.printStackTrace();
        }

        return reports;
    }

    public List<ReportEntry> getTopSellingProductsByDate(Timestamp startDate, Timestamp endDate, int limit) {
        List<ReportEntry> reports = new ArrayList<>();

        String sql = "SELECT " +
                "    p.id as product_id, " +
                "    p.name as product_name, " +
                "    p.brand as product_brand, " +
                "    SUM(oi.quantity) as total_quantity, " +
                "    SUM(oi.subtotal) as total_revenue, " +
                "    COUNT(DISTINCT o.id) as total_orders " +
                "FROM products p " +
                "JOIN order_items oi ON p.id = oi.product_id " +
                "JOIN orders o ON oi.order_id = o.id " +
                "WHERE o.status = 'PAID' AND o.created_at BETWEEN ? AND ? " +
                "GROUP BY p.id, p.name, p.brand " +
                "ORDER BY total_quantity DESC " +
                "LIMIT ?";

        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);
            stmt.setInt(3, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReportEntry entry = new ReportEntry();
                entry.setProductId(rs.getLong("product_id"));
                entry.setProductName(rs.getString("product_name"));
                entry.setProductBrand(rs.getString("product_brand"));
                entry.setTotalQuantitySold(rs.getInt("total_quantity"));
                entry.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                entry.setTotalOrders(rs.getInt("total_orders"));
                reports.add(entry);
            }

        } catch (SQLException e) {
            System.err.println("Error getting top selling products by date: " + e.getMessage());
            e.printStackTrace();
        }

        return reports;
    }

    /**
     * Report untuk TAB "products"
     */
    public SalesReport generateProductSalesReport(Timestamp startDate, Timestamp endDate) {
        SalesReport report = new SalesReport();

        if (startDate != null && endDate != null) {
            report.setProductReport(getSalesReportByProductAndDate(startDate, endDate));
            report.setTotalRevenue(getTotalRevenueByDate(startDate, endDate));
            report.setTotalPaidOrders(getTotalOrdersCountByDate(startDate, endDate));
            report.setTotalProductsSold(getTotalProductsSoldByDate(startDate, endDate));
        } else {
            report.setProductReport(getSalesReportByProduct());
            report.setTotalRevenue(getTotalRevenue());
            report.setTotalPaidOrders(getTotalOrdersCount());
            report.setTotalProductsSold(getTotalProductsSold());
        }

        DataStore.getInstance().saveReport(report);
        return report;
    }

    /**
     * Report untuk TAB "orders"
     */
    public SalesReport generateOrderSalesReport(Timestamp startDate, Timestamp endDate) {
        SalesReport report = new SalesReport();

        List<Order> paidOrders;

        if (startDate != null && endDate != null) {
            paidOrders = orderDAO.findByDateRange(startDate, endDate)
                    .stream()
                    .filter(Order::isPaid)
                    .collect(Collectors.toList());

            report.setTotalRevenue(getTotalRevenueByDate(startDate, endDate));
            report.setTotalPaidOrders(paidOrders.size());
            report.setTotalProductsSold(getTotalProductsSoldByDate(startDate, endDate));
        } else {
            paidOrders = orderDAO.findPaidOrders();

            report.setTotalRevenue(getTotalRevenue());
            report.setTotalPaidOrders(paidOrders.size());
            report.setTotalProductsSold(getTotalProductsSold());
        }

        report.setPaidOrders(paidOrders);

        DataStore.getInstance().saveReport(report);
        return report;
    }
    
    public void exportReportToPdf(model.SalesReport report, String type, String startDate, String endDate, OutputStream out) {
        Document doc = new Document(PageSize.A4, 36, 36, 36, 36);

        try {
            PdfWriter.getInstance(doc, out);
            doc.open();

            Font titleFont = new Font(Font.HELVETICA, 16, Font.BOLD);
            Font normal = new Font(Font.HELVETICA, 10, Font.NORMAL);
            Font bold = new Font(Font.HELVETICA, 10, Font.BOLD);

            doc.add(new Paragraph("The Object Hour - Sales Report", titleFont));
            doc.add(new Paragraph("Type: " + type.toUpperCase(), bold));
            doc.add(new Paragraph("Generated: " + LocalDateTime.now(), normal));

            if ((startDate != null && !startDate.isEmpty()) || (endDate != null && !endDate.isEmpty())) {
                doc.add(new Paragraph("Date Range: " + (startDate == null ? "-" : startDate) + " to " + (endDate == null ? "-" : endDate), normal));
            }
            doc.add(Chunk.NEWLINE);

            PdfPTable summary = new PdfPTable(3);
            summary.setWidthPercentage(100);

            summary.addCell(cell("Total Revenue", bold));
            summary.addCell(cell("Total Paid Orders", bold));
            summary.addCell(cell("Products Sold", bold));

            summary.addCell(cell(String.valueOf(report.getTotalRevenue()), normal));
            summary.addCell(cell(String.valueOf(report.getTotalPaidOrders()), normal));
            summary.addCell(cell(String.valueOf(report.getTotalProductsSold()), normal));

            doc.add(summary);
            doc.add(Chunk.NEWLINE);

            if ("products".equals(type)) {
                doc.add(new Paragraph("Product Report", bold));
                doc.add(Chunk.NEWLINE);

                PdfPTable table = new PdfPTable(5);
                table.setWidthPercentage(100);
                table.setWidths(new float[]{3f, 2f, 1.2f, 2f, 1.2f});

                table.addCell(cell("Product", bold));
                table.addCell(cell("Brand", bold));
                table.addCell(cell("Qty Sold", bold));
                table.addCell(cell("Revenue", bold));
                table.addCell(cell("Orders", bold));

                if (report.getProductReport() != null) {
                    for (model.ReportEntry r : report.getProductReport()) {
                        table.addCell(cell(r.getProductName(), normal));
                        table.addCell(cell(r.getProductBrand(), normal));
                        table.addCell(cell(String.valueOf(r.getTotalQuantitySold()), normal));
                        table.addCell(cell(String.valueOf(r.getTotalRevenue()), normal));
                        table.addCell(cell(String.valueOf(r.getTotalOrders()), normal));
                    }
                }

                doc.add(table);
            } else {
                doc.add(new Paragraph("Paid Orders", bold));
                doc.add(Chunk.NEWLINE);

                PdfPTable table = new PdfPTable(5);
                table.setWidthPercentage(100);
                table.setWidths(new float[]{1.2f, 2.5f, 1.4f, 2.2f, 2f});

                table.addCell(cell("Order", bold));
                table.addCell(cell("Customer", bold));
                table.addCell(cell("Status", bold));
                table.addCell(cell("Paid At", bold));
                table.addCell(cell("Total", bold));

                if (report.getPaidOrders() != null) {
                    for (model.Order o : report.getPaidOrders()) {
                        table.addCell(cell("#" + o.getId(), normal));
                        String cust = (o.getUser() != null) ? o.getUser().getName() : ("UserID: " + o.getUserId());
                        table.addCell(cell(cust, normal));
                        table.addCell(cell(String.valueOf(o.getStatus()), normal));
                        table.addCell(cell(String.valueOf(o.getPaidAt()), normal));
                        table.addCell(cell(String.valueOf(o.getTotalAmount()), normal));
                    }
                }

                doc.add(table);
            }

            doc.close();
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate PDF: " + e.getMessage(), e);
        }
    }

    private PdfPCell cell(String text, Font font) {
        PdfPCell c = new PdfPCell(new Phrase(text == null ? "" : text, font));
        c.setPadding(6);
        return c;
    }
    
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    /**
     * Ambil order PAID + items + product detail untuk panel detail report.
     */
    public Order getPaidOrderWithItems(Long orderId) {
        if (orderId == null) return null;

        Order order = orderDAO.findById(orderId);
        if (order == null) return null;

        // hanya boleh tampilkan detail untuk order PAID
        if (!order.isPaid()) return null;

        List<OrderItem> items = orderItemDAO.findAllByOrderId(orderId);
        order.setItems(items);

        return order;
    }
}
