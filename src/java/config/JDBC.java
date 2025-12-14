package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;
public class JDBC {
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            
            Properties props = new Properties();
            InputStream in = JDBC.class.getClassLoader().getResourceAsStream("/config/db.properties"); 
            
            if (in == null) {
                System.out.println("File db.properties tidak ditemukan, cek path!");
                return null;
            }
            props.load(in);
            
            String url = "jdbc:postgresql://" + props.getProperty("db.host") + ":" 
                       + props.getProperty("db.port") + "/" 
                       + props.getProperty("db.name") 
                       + "?sslmode=require";
            
            con = DriverManager.getConnection(url, props.getProperty("db.user"), props.getProperty("db.password"));
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}
