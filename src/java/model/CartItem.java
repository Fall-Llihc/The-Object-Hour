package classes;

public class CartItem {
    private int id;
    private int cartId;
    private Jam product;
    private int quantity;
    private double unitPrice;
    private double subtotal;

    public CartItem() {}

    public CartItem(int cartId, Jam product, int quantity) {
        this.cartId = cartId;
        this.product = product;
        this.quantity = quantity;
        this.unitPrice = product.getHarga();
        calculateSubtotal();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public Jam getProduct() {
        return product;
    }

    public void setProduct(Jam product) {
        this.product = product;
        this.unitPrice = product.getHarga();
        calculateSubtotal();
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateSubtotal();
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public double getSubtotal() {
        return subtotal;
    }

    private void calculateSubtotal() {
        this.subtotal = this.unitPrice * this.quantity;
    }
}

