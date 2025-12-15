package model;

import java.math.BigDecimal;

/**
 * Report Entry Model
 * Helper class untuk laporan penjualan admin
 * Tidak merepresentasikan tabel database, tapi hasil agregasi query
 * 
 * @author The Object Hour Team
 */
public class ReportEntry {
    private Long productId;
    private String productName;
    private String productBrand;
    private int totalQuantitySold;
    private BigDecimal totalRevenue;
    private int totalOrders;

    // Constructors
    public ReportEntry() {
    }

    public ReportEntry(Long productId, String productName, String productBrand, 
                      int totalQuantitySold, BigDecimal totalRevenue, int totalOrders) {
        this.productId = productId;
        this.productName = productName;
        this.productBrand = productBrand;
        this.totalQuantitySold = totalQuantitySold;
        this.totalRevenue = totalRevenue;
        this.totalOrders = totalOrders;
    }

    // Getters and Setters
    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductBrand() {
        return productBrand;
    }

    public void setProductBrand(String productBrand) {
        this.productBrand = productBrand;
    }

    public int getTotalQuantitySold() {
        return totalQuantitySold;
    }

    public void setTotalQuantitySold(int totalQuantitySold) {
        this.totalQuantitySold = totalQuantitySold;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    @Override
    public String toString() {
        return "ReportEntry{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", productBrand='" + productBrand + '\'' +
                ", totalQuantitySold=" + totalQuantitySold +
                ", totalRevenue=" + totalRevenue +
                ", totalOrders=" + totalOrders +
                '}';
    }
}
