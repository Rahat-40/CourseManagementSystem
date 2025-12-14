package utils;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Connection;

public class DBConnection {
    // UPDATE THESE IF NEEDED
	private static final String URL = "jdbc:mysql://localhost:3306/courseManagement_db";
	private static final String USER = "myuser";
	private static final String PASS = "R@h@t201243";
	
	public static Connection getConnection() throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.cj.jdbc.Driver");
		return DriverManager.getConnection(URL,USER,PASS);
	}
}