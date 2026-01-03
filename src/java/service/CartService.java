package service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import dao.CartDAO;
import dao.CartItemDAO;
import dao.ProductDAO;
import model.Cart;
import model.CartItem;
import model.Product;

/**
 * CartService - Service layer untuk manajemen keranjang belanja
 * Menangani business logic untuk cart operations
 * 
 * @author The Object Hour Team
 */
public class CartService {
    
    private CartDAO cartDAO;
    private CartItemDAO cartItemDAO;
    private ProductDAO productDAO;
    
    public CartService() {
        this.cartDAO = new CartDAO();
        this.cartItemDAO = new CartItemDAO();
        this.productDAO = new ProductDAO();
    }
    
    /**
     * Get or create active cart for user
     * 
     * @param userId User ID
     * @return Cart object
     */
    public Cart getOrCreateCart(Long userId) {
        if (userId == null) {
            System.out.println("User ID is required");
            return null;
        }
        
        return cartDAO.findOrCreateActiveCartByUserId(userId);
    }
    
    /**
     * Get cart with items
     * 
     * @param userId User ID
     * @return Cart object with items
     */
    public Cart getCartWithItems(Long userId) {
        Cart cart = getOrCreateCart(userId);
        
        if (cart != null) {
            List<CartItem> items = cartItemDAO.findAllByCartId(cart.getId());
            cart.setItems(items);
        }
        
        return cart;
    }
    
    /**
     * Get cart with specific selected items only
     * 
     * @param userId User ID
     * @param selectedItemIds Comma-separated string of cart item IDs
     * @return Cart object with only selected items
     */
    public Cart getCartWithSelectedItems(Long userId, String selectedItemIds) {
        Cart cart = getOrCreateCart(userId);
        
        if (cart != null && selectedItemIds != null && !selectedItemIds.trim().isEmpty()) {
            List<CartItem> allItems = cartItemDAO.findAllByCartId(cart.getId());
            List<CartItem> selectedItems = new ArrayList<>();
            
            // Parse selected item IDs
            String[] itemIds = selectedItemIds.split(",");
            Set<Long> selectedIdSet = new HashSet<>();
            
            for (String idStr : itemIds) {
                try {
                    selectedIdSet.add(Long.parseLong(idStr.trim()));
                } catch (NumberFormatException e) {
                    System.err.println("Invalid cart item ID: " + idStr);
                }
            }
            
            // Filter items based on selected IDs
            for (CartItem item : allItems) {
                if (selectedIdSet.contains(item.getId())) {
                    selectedItems.add(item);
                }
            }
            
            cart.setItems(selectedItems);
        }
        
        return cart;
    }
    
    /**
     * Calculate total for specific cart items
     * 
     * @param cart Cart with filtered items
     * @return Total amount
     */
    public BigDecimal calculateCartTotal(Cart cart) {
        BigDecimal total = BigDecimal.ZERO;
        
        if (cart != null && cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                if (item.getSubtotal() != null) {
                    total = total.add(item.getSubtotal());
                } else {
                    total = total.add(item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())));
                }
            }
        }
        
        return total;
    }
    
    /**
     * Add product to cart
     * 
     * @param userId User ID
     * @param productId Product ID
     * @param quantity Quantity to add
     * @return true jika berhasil
     */
    public boolean addToCart(Long userId, Long productId, int quantity) {
        // Validasi input
        if (userId == null || productId == null) {
            System.out.println("User ID and Product ID are required");
            return false;
        }
        
        if (quantity <= 0) {
            System.out.println("Quantity must be greater than 0");
            return false;
        }
        
        // Cek product availability
        Product product = productDAO.findById(productId);
        if (product == null) {
            System.out.println("Product not found: " + productId);
            return false;
        }
        
        if (!product.isActive()) {
            System.out.println("Product is not active: " + productId);
            return false;
        }
        
        if (product.getStock() < quantity) {
            System.out.println("Insufficient stock. Available: " + product.getStock());
            return false;
        }
        
        // Get or create cart
        Cart cart = getOrCreateCart(userId);
        if (cart == null) {
            System.out.println("Failed to get/create cart");
            return false;
        }
        
        // Check if product already in cart
        CartItem existingItem = cartItemDAO.findByCartAndProduct(cart.getId(), productId);
        
        if (existingItem != null) {
            // Update quantity
            int newQuantity = existingItem.getQuantity() + quantity;
            
            // Check stock lagi
            if (product.getStock() < newQuantity) {
                System.out.println("Insufficient stock for total quantity. Available: " + product.getStock());
                return false;
            }
            
            existingItem.setQuantity(newQuantity);
            existingItem.calculateSubtotal();
            
            return cartItemDAO.updateItem(existingItem);
            
        } else {
            // Add new item
            CartItem newItem = new CartItem();
            newItem.setCartId(cart.getId());
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            newItem.setUnitPrice(product.getPrice());
            newItem.calculateSubtotal();
            
            Long itemId = cartItemDAO.addItem(newItem);
            
            if (itemId != null) {
                System.out.println("Product added to cart: " + product.getName());
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Update cart item quantity
     * 
     * @param cartItemId Cart Item ID
     * @param newQuantity New quantity
     * @return true jika berhasil
     */
    public boolean updateCartItemQuantity(Long cartItemId, int newQuantity) {
        if (newQuantity <= 0) {
            // If quantity is 0 or negative, remove the item
            return removeFromCart(cartItemId);
        }
        
        // Get cart item
        CartItem cartItem = cartItemDAO.findById(cartItemId);
        if (cartItem == null) {
            System.out.println("Cart item not found: " + cartItemId);
            return false;
        }
        
        // Check product stock
        Product product = productDAO.findById(cartItem.getProductId());
        if (product == null || product.getStock() < newQuantity) {
            System.out.println("Insufficient stock");
            return false;
        }
        
        return cartItemDAO.updateQuantity(cartItemId, newQuantity);
    }
    
    /**
     * Remove item from cart
     * 
     * @param cartItemId Cart Item ID
     * @return true jika berhasil
     */
    public boolean removeFromCart(Long cartItemId) {
        boolean success = cartItemDAO.deleteItem(cartItemId);
        
        if (success) {
            System.out.println("Item removed from cart");
        }
        
        return success;
    }
    
    /**
     * Clear cart (remove all items)
     * 
     * @param userId User ID
     * @return true jika berhasil
     */
    public boolean clearCart(Long userId) {
        Cart cart = cartDAO.findActiveCartByUserId(userId);
        
        if (cart == null) {
            System.out.println("No active cart found");
            return false;
        }
        
        return cartItemDAO.deleteAllByCartId(cart.getId());
    }
    
    /**
     * Calculate cart total
     * 
     * @param userId User ID
     * @return Total amount
     */
    public BigDecimal getCartTotal(Long userId) {
        Cart cart = getCartWithItems(userId);
        
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart.getItems()) {
            if (item.getSubtotal() != null) {
                total = total.add(item.getSubtotal());
            }
        }
        
        return total;
    }
    
    /**
     * Get total items count in cart
     * 
     * @param userId User ID
     * @return Total items count
     */
    public int getCartItemsCount(Long userId) {
        Cart cart = cartDAO.findActiveCartByUserId(userId);
        
        if (cart == null) {
            return 0;
        }
        
        return cartItemDAO.getItemsCount(cart.getId());
    }
    
    /**
     * Validate cart before checkout
     * 
     * @param userId User ID
     * @return true if cart is valid for checkout
     */
    public boolean validateCartForCheckout(Long userId) {
        Cart cart = getCartWithItems(userId);
        
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            System.out.println("Cart is empty");
            return false;
        }
        
        // Check each item
        for (CartItem item : cart.getItems()) {
            Product product = productDAO.findById(item.getProductId());
            
            if (product == null) {
                System.out.println("Product not found: " + item.getProductId());
                return false;
            }
            
            if (!product.isActive()) {
                System.out.println("Product is no longer active: " + product.getName());
                return false;
            }
            
            if (product.getStock() < item.getQuantity()) {
                System.out.println("Insufficient stock for: " + product.getName() + 
                                 " (Available: " + product.getStock() + ", Required: " + item.getQuantity() + ")");
                return false;
            }
        }
        
        return true;
    }
}
