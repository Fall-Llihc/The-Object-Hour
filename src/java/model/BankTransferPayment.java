package model;

import java.math.BigDecimal;

/**
 * Bank Transfer Payment Implementation
 * Implements PaymentMethod interface for bank transfer payments
 * 
 * @author The Object Hour Team
 */
public class BankTransferPayment implements PaymentMethod {
    
    private String bankName; // BCA, Mandiri, BNI, BRI, etc.
    private String accountNumber;
    private String accountName;

    public BankTransferPayment() {
        this.bankName = "Bank Transfer";
        this.accountNumber = "1234567890";
        this.accountName = "The Object Hour";
    }

    public BankTransferPayment(String bankName, String accountNumber, String accountName) {
        this.bankName = bankName;
        this.accountNumber = accountNumber;
        this.accountName = accountName;
    }

    @Override
    public boolean processPayment(Long orderId, BigDecimal amount) {
        // Simulasi proses pembayaran bank transfer
        System.out.println("Processing Bank Transfer payment for Order #" + orderId);
        System.out.println("Bank: " + bankName);
        System.out.println("Account: " + accountNumber + " - " + accountName);
        System.out.println("Amount: Rp " + amount);
        
        // Dalam implementasi nyata, ini akan menunggu konfirmasi transfer
        // Untuk sekarang, assume pembayaran berhasil
        return true;
    }

    @Override
    public String getPaymentMethodName() {
        return "BANK";
    }

    @Override
    public String getPaymentInstructions() {
        return "Silakan transfer ke rekening berikut:\n" +
               "Bank: " + bankName + "\n" +
               "No. Rekening: " + accountNumber + "\n" +
               "Atas Nama: " + accountName + "\n" +
               "Setelah transfer, mohon konfirmasi pembayaran.";
    }

    @Override
    public boolean validatePayment(BigDecimal amount) {
        // Validasi amount harus lebih dari 0 dan minimal transfer Rp 10.000
        return amount != null && amount.compareTo(new BigDecimal("10000")) >= 0;
    }

    // Getters and Setters
    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }
}
