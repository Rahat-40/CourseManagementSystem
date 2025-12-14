package servlets;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class TeacherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        if ("viewStudents".equals(action)) {
            String courseId = req.getParameter("courseId");
            req.setAttribute("selectedCourseId", courseId);
            req.getRequestDispatcher("teacherStudentsByCourse.jsp").forward(req, res);
        } 
   //         else {
//            req.getRequestDispatcher("Teacher.jsp").forward(req, res);
//        }
    }
}