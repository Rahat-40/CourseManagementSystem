package servlets;
import utils.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class StudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        try (Connection con = DBConnection.getConnection()) {
            if("register".equals(req.getParameter("action"))){
                int studentId = Integer.parseInt(req.getParameter("student_id"));
                int courseId = Integer.parseInt(req.getParameter("course_id"));
                
                PreparedStatement chk = con.prepareStatement("SELECT * FROM registrations WHERE student_id=? AND course_id=?");
                chk.setInt(1, studentId); chk.setInt(2, courseId);
                if(chk.executeQuery().next()){
                    req.setAttribute("error", "You are already registered for this course!");
                    req.getRequestDispatcher("Student.jsp").forward(req, res);
                    return;
                }
                PreparedStatement ps = con.prepareStatement("INSERT INTO registrations(student_id,course_id) VALUES (?,?)");
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                ps.executeUpdate();
                res.sendRedirect("Student.jsp?msg=Registered");
            }
        } catch(Exception e){ e.printStackTrace(); res.sendRedirect("Student.jsp?error=1"); }
    }
}