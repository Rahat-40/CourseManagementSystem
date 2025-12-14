package servlets;

import java.io.IOException;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import utils.DBConnection;
import models.User;

public class LoginServlet extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String pass = req.getParameter("password");
		
		try(Connection con = DBConnection.getConnection()) {
			PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=?");
			ps.setString(1,username);
			ResultSet rs = ps.executeQuery();
			
            if(rs.next() && BCrypt.checkpw(pass, rs.getString("password"))) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));

                HttpSession session = req.getSession();
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30*60); 
				
				if(user.getRole().equals("admin")) resp.sendRedirect("Admin.jsp");
				else if(user.getRole().equals("student")) resp.sendRedirect("Student.jsp");
				else if(user.getRole().equals("teacher")) resp.sendRedirect("Teacher.jsp"); // Redirect to servlet to load dashboard logic
			} else {
				req.setAttribute("error", "Invalid username or password");
				req.getRequestDispatcher("Login.jsp").forward(req, resp);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}