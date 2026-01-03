package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;


/**
 * Order Entity Model
 * Represents orders table in database
 * 
 * @author The Object Hour Team
 */
public class Order implements IReportable{
    private Long id;
    private Long userId;
    private Long cartId;
    private String paymentMethod; // 'EWALLET', 'BANK', 'CASH'
    private String status; // 'PENDING', 'PAID', 'CANCELLED'
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;
    
    // Shipping Information
    private String shippingName;
    private String shippingPhone;
    private String shippingAddress;
    private String shippingCity;
    private String shippingState;
    private String shippingPostalCode;
    private String notes;
    
    // Transient fields - not in database
    private List<OrderItem> items;
    private User user;

    // Constructors
    public Order() {
        this.items = new ArrayList<>();
    }

    public Order(Long id, Long userId, Long cartId, String paymentMethod, String status, 
                 BigDecimal totalAmount, LocalDateTime createdAt, LocalDateTime paidAt) {
        this.id = id;
        this.userId = userId;
        this.cartId = cartId;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.totalAmount = totalAmount;
        this.createdAt = createdAt;
        this.paidAt = paidAt;
        this.items = new ArrayList<>();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCartId() {
        return cartId;
    }

    public void setCartId(Long cartId) {
        this.cartId = cartId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    /**
     * Get formatted createdAt for JSP display
     * @return formatted date string "dd MMMM yyyy, HH:mm"
     */
    public String getCreatedAtFormatted() {
        if (createdAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy, HH:mm");
        return createdAt.format(formatter);
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }
    
    /**
     * Get formatted paidAt for JSP display
     * @return formatted date string "dd MMMM yyyy, HH:mm"
     */
    public String getPaidAtFormatted() {
        if (paidAt == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy, HH:mm");
        return paidAt.format(formatter);
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getShippingName() {
        return shippingName;
    }

    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingCity() {
        return shippingCity;
    }

    public void setShippingCity(String shippingCity) {
        this.shippingCity = shippingCity;
    }

    public String getShippingState() {
        return shippingState;
    }

    public void setShippingState(String shippingState) {
        this.shippingState = shippingState;
    }

    public String getShippingPostalCode() {
        return shippingPostalCode;
    }

    public void setShippingPostalCode(String shippingPostalCode) {
        this.shippingPostalCode = shippingPostalCode;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Helper methods
    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(this.status);
    }

    public boolean isPaid() {
        return "PAID".equalsIgnoreCase(this.status);
    }

    public boolean isCancelled() {
        return "CANCELLED".equalsIgnoreCase(this.status);
    }

    public void markAsPaid() {
        this.status = "PAID";
        this.paidAt = LocalDateTime.now();
    }

    public void cancel() {
        this.status = "CANCELLED";
    }
    
    /**
     * Get formatted created date for JSP display
     * @return Formatted date string "dd MMM yyyy, HH:mm"
     */
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "-";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
        return createdAt.format(formatter);
    }
    
    /**
     * Get formatted paid date for JSP display
     * @return Formatted date string "dd MMM yyyy, HH:mm"
     */
    public String getFormattedPaidAt() {
        if (paidAt == null) return "-";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
        return paidAt.format(formatter);
    }
    
    @Override
    public String getReportLabel() {
        return "Order #" + id;
    }

    @Override
    public BigDecimal getReportRevenue() {
        return (totalAmount != null) ? totalAmount : BigDecimal.ZERO;
    }

    @Override
    public LocalDateTime getReportDate() {
        // Untuk laporan, biasanya pakai paidAt kalau ada
        return (paidAt != null) ? paidAt : createdAt;
    }

    @Override
    public String getReportStatus() {
        return status;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", status='" + status + '\'' +
                ", totalAmount=" + totalAmount +
                ", createdAt=" + createdAt +
                ", paidAt=" + paidAt +
                '}';
    }
}
