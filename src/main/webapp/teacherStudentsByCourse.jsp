<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page session="true" %>
<% 
    // Retrieve the course ID passed from the TeacherServlet
    String cidStr = (String)request.getAttribute("selectedCourseId");
    int courseId = 0;
    String cName = "Unknown";
    
    // Convert String ID to integer, handling potential errors
    try {
        if (cidStr != null) {
            courseId = Integer.parseInt(cidStr);
        }
    } catch (NumberFormatException e) {
        
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Class List</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family:'Poppins',sans-serif; background:#f8f9fa; }
        .card-header { border-radius: 10px 10px 0 0 !important; }
    </style>
</head>
<body>
<div class="container mt-5">
    <% 
    // Check if a valid Course ID was successfully extracted
    if(courseId != 0) {
        try(Connection con = DBConnection.getConnection()){
            // Get the course name for the header
            PreparedStatement psN = con.prepareStatement("SELECT course_name FROM courses WHERE course_id=?"); 
            psN.setInt(1, courseId); 
            ResultSet rsN = psN.executeQuery();
            if(rsN.next()) {
                cName = rsN.getString("course_name");
            }
    %>
    <div class="card shadow border-0">
        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="fa-solid fa-users-viewfinder me-2"></i> Students List for: **<%= cName %>** (ID: <%= courseId %>)</h5>
            <a href="Teacher.jsp" class="btn btn-light btn-sm rounded-pill fw-bold"><i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard</a>
        </div>
        <div class="card-body">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                    <tr><th><i class="fa-solid fa-id-badge"></i> Student ID</th><th><i class="fa-solid fa-user-graduate"></i> Name</th></tr>
                </thead>
                <tbody>
                    <% 
                        // Query to retrieve all registered students for this course
                        PreparedStatement ps = con.prepareStatement("SELECT r.student_id, u.username FROM registrations r JOIN users u ON r.student_id=u.user_id WHERE r.course_id=?");
                        ps.setInt(1, courseId); 
                        ResultSet rs = ps.executeQuery(); 
                        boolean found = false; 
                        while(rs.next()){ 
                            found = true; 
                    %>
                    <tr>
                        <td><%= rs.getInt("student_id") %></td>
                        <td class="fw-bold"><%= rs.getString("username") %></td>
                    </tr>
                    <% 
                        } 
                        if(!found){ 
                    %> 
                    <tr><td colspan="2" class="text-center text-muted py-4"><i class="fa-solid fa-circle-exclamation me-1"></i> No students enrolled yet.</td></tr> 
                    <% 
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <% 
        // Close the try-with-resources for the connection
        } catch(Exception e){
            
            out.println("<div class='alert alert-danger mt-4'>Database Error: Could not load students. Please check the logs.");
 
            out.println("</div>");
        } 
    } else { 
    %>
    <div class="alert alert-warning text-center shadow-sm">
        <h4 class="alert-heading"><i class="fa-solid fa-triangle-exclamation me-2"></i> Invalid Course ID</h4>
        <p>The course ID was not provided or was invalid. Please return to the dashboard.</p>
        <a href="Teacher.jsp" class="btn btn-warning fw-bold">Go to Dashboard</a>
    </div>
    <% } %>
</div>
</body>
</html>