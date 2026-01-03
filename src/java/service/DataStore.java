package service;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;
import model.Order;
import model.Product;
import model.SalesReport;
import model.User;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * DataStore - Menyimpan snapshot data aplikasi (orders, products, users)
 * dan menyimpan snapshot report terakhir.
 */
public class DataStore {

    private static final DataStore INSTANCE = new DataStore();

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final UserDAO userDAO = new UserDAO();

    private List<Order> orders = new ArrayList<>();
    private List<Product> products = new ArrayList<>();
    private List<User> users = new ArrayList<>();

    private SalesReport lastReport = new SalesReport();

    private DataStore() {}

    public static DataStore getInstance() {
        return INSTANCE;
    }

    /**
     * Refresh seluruh data aplikasi (snapshot).
     */
    public synchronized void refreshAll() {
        this.orders = orderDAO.findAll();
        this.products = productDAO.findAll();
    }

    public synchronized void refreshOrders() {
        this.orders = orderDAO.findAll();
    }

    public synchronized void refreshProducts() {
        this.products = productDAO.findAll();
    }

    public List<Order> getOrders() {
        return Collections.unmodifiableList(orders);
    }

    public List<Product> getProducts() {
        return Collections.unmodifiableList(products);
    }

    public List<User> getUsers() {
        return Collections.unmodifiableList(users);
    }

    public SalesReport getLastReport() {
        return lastReport;
    }

    public synchronized void saveReport(SalesReport report) {
        this.lastReport = (report != null) ? report : new SalesReport();
    }
}
