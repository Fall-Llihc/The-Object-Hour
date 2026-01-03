/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Rei Sarah
 */
import config.JDBC;
import model.History;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoryDAO {

    public List<History> getUserHistory(long userId) {
        List<History> list = new ArrayList<>();

        String sql = """
            SELECT id, total_amount, payment_method, paid_at, shipping_address
            FROM orders
            WHERE user_id = ?
              AND status = 'PAID'
            ORDER BY paid_at DESC
        """;

        try (
            Connection conn = JDBC.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                History h = new History();
                h.setId(rs.getInt("id"));
                h.setTotalAmount(rs.getBigDecimal("total_amount"));
                h.setPaymentMethod(rs.getString("payment_method"));
                h.setPaidAt(rs.getObject("paid_at", java.time.OffsetDateTime.class));
                h.setShippingAddress(rs.getString("shipping_address"));

                list.add(h);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
