package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class SalesReport {

    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private int totalPaidOrders = 0;
    private int totalProductsSold = 0;

    private List<Order> paidOrders = new ArrayList<>();
    private List<ReportEntry> productReport = new ArrayList<>();

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = (totalRevenue != null) ? totalRevenue : BigDecimal.ZERO;
    }

    public int getTotalPaidOrders() { return totalPaidOrders; }
    public void setTotalPaidOrders(int totalPaidOrders) { this.totalPaidOrders = totalPaidOrders; }

    public int getTotalProductsSold() { return totalProductsSold; }
    public void setTotalProductsSold(int totalProductsSold) { this.totalProductsSold = totalProductsSold; }

    public List<Order> getPaidOrders() { return paidOrders; }
    public void setPaidOrders(List<Order> paidOrders) {
        this.paidOrders = (paidOrders != null) ? paidOrders : new ArrayList<>();
    }

    public List<ReportEntry> getProductReport() { return productReport; }
    public void setProductReport(List<ReportEntry> productReport) {
        this.productReport = (productReport != null) ? productReport : new ArrayList<>();
    }
}
