package servlets;

import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import utils.DBConnection;

public class RegisterServlet extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		// get parameter from request
		String username = req.getParameter("username");
		String pass = req.getParameter("password");
		String role = req.getParameter("role");

		// if user or password is empty send error
        if(username.isEmpty() || pass.isEmpty()) {
            req.setAttribute("error", "Username and password cannot be empty");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
            return;
        }
		try(Connection con = DBConnection.getConnection()) {
            PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE username=?");
            check.setString(1, username);
            ResultSet rsCheck = check.executeQuery();
            
            // check user already exist or not
            if(rsCheck.next()) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("Register.jsp").forward(req, resp);
                return;
            }
            
            // store password using bcript
            String hashedPassword = BCrypt.hashpw(pass, BCrypt.gensalt());
			PreparedStatement ps = con.prepareStatement("INSERT INTO users (username,password,role) VALUES (?,?,?)");
			ps.setString(1,username);
			ps.setString(2, hashedPassword);
			ps.setString(3, role);
			ps.executeUpdate();
			
			// if registation success send success message and redirect to login page
            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
		} catch(Exception e) {
			//handle error if occure
			e.printStackTrace();
			req.setAttribute("error", "Server error occurred");
            req.getRequestDispatcher("Register.jsp").forward(req, resp);
		}
	}
}