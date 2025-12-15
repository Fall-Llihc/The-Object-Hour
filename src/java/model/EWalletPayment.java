package model;

import java.math.BigDecimal;

/**
 * E-Wallet Payment Implementation
 * Implements PaymentMethod interface for e-wallet payments (GoPay, OVO, Dana, etc.)
 * 
 * @author The Object Hour Team
 */
public class EWalletPayment implements PaymentMethod {
    
    private String walletProvider; // GoPay, OVO, Dana, ShopeePay, etc.
    private String phoneNumber;

    public EWalletPayment() {
        this.walletProvider = "E-Wallet";
    }

    public EWalletPayment(String walletProvider, String phoneNumber) {
        this.walletProvider = walletProvider;
        this.phoneNumber = phoneNumber;
    }

    @Override
    public boolean processPayment(Long orderId, BigDecimal amount) {
        // Simulasi proses pembayaran e-wallet
        System.out.println("Processing E-Wallet payment for Order #" + orderId);
        System.out.println("Provider: " + walletProvider);
        System.out.println("Amount: Rp " + amount);
        
        // Dalam implementasi nyata, ini akan memanggil API payment gateway
        // Untuk sekarang, assume pembayaran berhasil
        return true;
    }

    @Override
    public String getPaymentMethodName() {
        return "EWALLET";
    }

    @Override
    public String getPaymentInstructions() {
        return "Silakan scan QR Code dengan aplikasi " + walletProvider + 
               " Anda atau masukkan nomor HP: " + (phoneNumber != null ? phoneNumber : "089123456789");
    }

    @Override
    public boolean validatePayment(BigDecimal amount) {
        // Validasi amount harus lebih dari 0
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }

    // Getters and Setters
    public String getWalletProvider() {
        return walletProvider;
    }

    public void setWalletProvider(String walletProvider) {
        this.walletProvider = walletProvider;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
