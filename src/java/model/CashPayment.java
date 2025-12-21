package model;

import java.math.BigDecimal;

/**
 * Cash Payment Implementation
 * Implements PaymentMethod interface for cash on delivery (COD) payments
 * 
 * @author The Object Hour Team
 */
public class CashPayment implements PaymentMethod {
    
    private String deliveryAddress;
    private String contactPerson;
    private String phoneNumber;

    public CashPayment() {
        this.contactPerson = "Customer";
    }

    public CashPayment(String deliveryAddress, String contactPerson, String phoneNumber) {
        this.deliveryAddress = deliveryAddress;
        this.contactPerson = contactPerson;
        this.phoneNumber = phoneNumber;
    }

    @Override
    public boolean processPayment(Long orderId, BigDecimal amount) {
        // Simulasi proses pembayaran cash
        System.out.println("Processing Cash payment for Order #" + orderId);
        System.out.println("Delivery Address: " + deliveryAddress);
        System.out.println("Contact: " + contactPerson + " - " + phoneNumber);
        System.out.println("Amount to be paid: Rp " + amount);
        
        // Cash payment akan dibayar saat barang diterima
        // Status order akan tetap PENDING sampai konfirmasi pembayaran
        return true;
    }

    @Override
    public String getPaymentMethodName() {
        return "CASH";
    }

    @Override
    public String getPaymentInstructions() {
        return "Pembayaran tunai (Cash on Delivery).\n" +
               "Anda akan membayar saat barang diterima.\n" +
               "Pastikan alamat pengiriman sudah benar:\n" +
               (deliveryAddress != null ? deliveryAddress : "Belum ada alamat") + "\n" +
               "Kurir akan menghubungi: " + (phoneNumber != null ? phoneNumber : "Nomor HP");
    }

    @Override
    public boolean validatePayment(BigDecimal amount) {
        // Validasi amount harus lebih dari 0
        // Bisa juga ada batas maksimal untuk COD
        BigDecimal maxCashAmount = new BigDecimal("5000000"); // Max 5 juta untuk COD
        return amount != null && 
               amount.compareTo(BigDecimal.ZERO) > 0 && 
               amount.compareTo(maxCashAmount) <= 0;
    }

    // Getters and Setters
    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
