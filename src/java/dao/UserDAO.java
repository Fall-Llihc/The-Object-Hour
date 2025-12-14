//logika query pindah ke sini. Ini lebih aman karena pakai PreparedStatement
package dao;
import config.JDBC;
import model.User;
import java.sql.*;

public class UserDAO {

    public User login(String username, String password) {
        User user = null;
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        
        try (Connection con = JDBC.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                user = new User();
                // ... set atribut
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}
