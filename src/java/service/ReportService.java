package service;

import config.JDBC;
import model.ReportEntry;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ReportService - Service layer untuk laporan penjualan
 * Menangani business logic untuk sales reports dan analytics
 * 
 * @author The Object Hour Team
 */
public class ReportService {
    
    /**
     * Get sales report by product
     * Aggregate data dari order_items untuk laporan penjualan per produk
     * 
     * @return List of report entries
     */
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
    
    /**
     * Get sales report by product for date range
     * 
     * @param startDate Start date
     * @param endDate End date
     * @return List of report entries
     */
    public List<ReportEntry> getSalesReportByProductAndDate(Timestamp startDate, Timestamp endDate) {
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
                     "LEFT JOIN orders o ON oi.order_id = o.id " +
                     "    AND o.status = 'PAID' " +
                     "    AND o.created_at BETWEEN ? AND ? " +
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
    
    /**
     * Get total revenue
     * 
     * @return Total revenue from all PAID orders
     */
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE status = 'PAID'";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get total revenue by date range
     * 
     * @param startDate Start date
     * @param endDate End date
     * @return Total revenue
     */
    public BigDecimal getTotalRevenueByDate(Timestamp startDate, Timestamp endDate) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total " +
                     "FROM orders " +
                     "WHERE status = 'PAID' AND created_at BETWEEN ? AND ?";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total revenue by date: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get total orders count
     * 
     * @return Total number of orders
     */
    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) as total FROM orders WHERE status = 'PAID'";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total orders count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get total products sold
     * 
     * @return Total quantity of products sold
     */
    public int getTotalProductsSold() {
        String sql = "SELECT COALESCE(SUM(oi.quantity), 0) as total " +
                     "FROM order_items oi " +
                     "JOIN orders o ON oi.order_id = o.id " +
                     "WHERE o.status = 'PAID'";
        
        try (Connection conn = JDBC.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total products sold: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get top selling products
     * 
     * @param limit Number of products to return
     * @return List of report entries
     */
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
}
