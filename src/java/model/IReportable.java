package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public interface IReportable {
    String getReportLabel();          // label baris (Order #id / Brand - Product)
    BigDecimal getReportRevenue();    // nilai uang (total order / revenue produk)

    // untuk report ORDER 
    default LocalDateTime getReportDate() { return null; }  // paidAt/createdAt
    default String getReportStatus() { return null; }       // PAID/PENDING/...

    // untuk report PRODUK
    default int getReportQuantity() { return 0; }           // qty terjual
}
