package model;

import java.math.BigDecimal;

/**
 * PaymentMethod Interface
 * Demonstrates Polymorphism in payment processing
 * 
 * @author The Object Hour Team
 */
public interface PaymentMethod {
    
    /**
     * Process payment for an order
     * 
     * @param orderId Order ID
     * @param amount Payment amount
     * @return true if payment successful
     */
    boolean processPayment(Long orderId, BigDecimal amount);
    
    /**
     * Get payment method name
     * 
     * @return Payment method name
     */
    String getPaymentMethodName();
    
    /**
     * Get payment instructions for user
     * 
     * @return Payment instructions
     */
    String getPaymentInstructions();
    
    /**
     * Validate payment details
     * 
     * @param amount Payment amount
     * @return true if valid
     */
    boolean validatePayment(BigDecimal amount);
}
