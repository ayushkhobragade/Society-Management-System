
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        String url = "jdbc:mysql://localhost:3306/society_management";
        String username = "root";
        String password = System.getenv("DB_PASSWORD");

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            url, username, password
        );

        return con;
    }
}
