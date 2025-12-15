<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page session="true" %>
<% 
    models.User currentUser = (models.User)session.getAttribute("currentUser");
    int studentId = currentUser.getUserId(); 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Student Dashboard</title>
    
    <%-- External CSS: Bootstrap, DataTables, and Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <%-- custom css --%>
    <style>body{font-family:'Poppins',sans-serif;background:#f8f9fa;}
    
            .bg-emerald {
            background-color: #148b4b !important; 
            color: white !important; 
        }
        .thead-color th {
            color: #116530 !important; 
           background-color: #a3ebb1 !important; 
        }
    </style>
    
</head>
<body>
<nav class="navbar navbar-dark bg-success sticky-top">
  <div class="container-fluid">
     <span class="navbar-brand fw-bold ms-3">Student Portal</span>
     
     <div class="d-flex align-items-center me-0">
        
         <div class="text-end me-3">
             <span class="d-block text-white fw-bold"><%= currentUser.getUsername() %></span>
             <small class="d-block text-warning" style="font-size: 0.75rem;"><%= currentUser.getRole().toUpperCase() %></small>
         </div>
          <i class="fa-solid fa-circle-user fa-2x text-light opacity-75 me-3"></i> 
         <form action="logoutServlet" method="post" class="m-0">
            <button class="btn btn-danger btn-sm rounded-pill px-3" type="submit">Logout</button>
         </form>
     </div>
     </div>
</nav>
<div class="container mt-4">
    <div class="row">
        <div class="col-md-4">
             <div class="card shadow border-0 mb-4">
                <div class="card-header bg-primary text-white text-center fw-bold"><i class="fa-solid fa-file-signature me-1"></i> Register New Course</div>
                <div class="card-body">
                
                <%-- course registation form --%>
                    <form action="studentServlet" method="post">
                        <input type="hidden" name="action" value="register">
                        <input type="hidden" name="student_id" value="<%= studentId %>">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Select Course</label>
                            <select name="course_id" class="form-select" required>
                                <option value="" disabled selected>Select a Course </option>
                                <% 
                                    try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()){
                                        ResultSet rsCourses = st.executeQuery("SELECT course_id, course_name FROM courses ORDER BY course_name");
                                        while(rsCourses.next()){ 
                                %>
                                    <option value="<%= rsCourses.getInt("course_id") %>">
                                        ID <%= rsCourses.getInt("course_id") %>: <%= rsCourses.getString("course_name") %>
                                    </option>
                                <% 
                                    }
                                    } catch(Exception e){ /* Handle exception */ }
                                %>
                            </select>
                        </div>
                        <button class="btn btn-primary w-100">Register Now</button>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-8">
            <div class="card shadow border-0">
                <div class="card-header fw-bold bg-emerald">My Registered Courses</div>
                <div class="card-body">
                
                <%--  table for show register courses --%>
                    <table id="myCourses" class="table table-hover">
                        <thead class="table-primary thead-color"><tr><th>ID</th><th>Course Name</th><th>Teacher</th></tr></thead>
                        <tbody>
                            <% try(Connection con=DBConnection.getConnection()){
                                PreparedStatement ps=con.prepareStatement("SELECT c.course_id,c.course_name,u.username FROM courses c JOIN registrations r ON c.course_id=r.course_id LEFT JOIN users u ON c.teacher_id=u.user_id WHERE r.student_id=?");
                                ps.setInt(1, studentId); ResultSet rs=ps.executeQuery(); while(rs.next()){ %>
                            <tr><td><%= rs.getInt("course_id") %></td><td><%= rs.getString("course_name") %></td><td><%= rs.getString("username")!=null?rs.getString("username"):"TBA" %></td></tr>
                            <% }} catch(Exception e){} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <div class="card mt-4 shadow border-0">
        <div class="card-header bg-white fw-bold bg-emerald">Available Course</div>
        <div class="card-body">
        
        <%-- table for show all available courses --%>
             <table id="allCourses" class="table table-hover">
                <thead class= "thead-color"><tr><th>ID</th><th>Course Name</th><th>Instructor</th></tr></thead>
                <tbody>
                    <% try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()){
                       ResultSet rs=st.executeQuery("SELECT c.course_id, c.course_name, u.username FROM courses c LEFT JOIN users u ON c.teacher_id=u.user_id");
                       while(rs.next()){ %>
                    <tr><td><%= rs.getInt("course_id") %></td><td><%= rs.getString("course_name") %></td><td><%= rs.getString("username")!=null?rs.getString("username"):"Not Assign" %></td></tr>
                    <% }} catch(Exception e){} %>
                </tbody>
             </table>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>$(document).ready(function(){ $('#myCourses').DataTable(); $('#allCourses').DataTable(); });</script>

// show error and success popup
<% if(request.getAttribute("error")!=null){ %> <script>Swal.fire('Error', '<%= request.getAttribute("error") %>', 'error');</script> <% } %>
<% if(request.getParameter("msg")!=null){ %> <script>Swal.fire('Success', 'Registration Successful!', 'success');</script> <% } %>
</body>
</html>