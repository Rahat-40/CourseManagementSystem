package servlets;
import utils.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        if(action == null) action = "";

        try (Connection con = DBConnection.getConnection()) {
            if(action.equals("addCourse")){
            	// Inside your "addCourse" if block
            	String cname = req.getParameter("course_name");

            	// 1. Check if it exists first
            	PreparedStatement checkPs = con.prepareStatement("SELECT COUNT(*) FROM courses WHERE course_name = ?");
            	checkPs.setString(1, cname);
            	ResultSet rs = checkPs.executeQuery();
            	rs.next();

            	if (rs.getInt(1) > 0) {
            	    // Redirect with a specific error code
            	    res.sendRedirect("Admin.jsp?error=duplicate");
            	} else {
            	    // 2. Proceed with Insertion
            	    PreparedStatement ps = con.prepareStatement("INSERT INTO courses(course_name) VALUES (?)");
            	    ps.setString(1, cname);
            	    ps.executeUpdate();
            	    res.sendRedirect("Admin.jsp?msg=CourseAdded");
            	}
            	
            } else if(action.equals("assignTeacher")){
                int cid = Integer.parseInt(req.getParameter("course_id"));
                int tid = Integer.parseInt(req.getParameter("teacher_id"));
                PreparedStatement ps = con.prepareStatement("UPDATE courses SET teacher_id=? WHERE course_id=?");
                ps.setInt(1, tid);
                ps.setInt(2, cid);
                ps.executeUpdate();
                res.sendRedirect("Admin.jsp?msg=TeacherAssigned");
            } else {
                res.sendRedirect("Admin.jsp");
            }
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("Admin.jsp?error=1"); }
    }
}