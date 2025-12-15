<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page session="true" %>
<% 
    models.User currentUser = (models.User)session.getAttribute("currentUser");
    int teacherId = currentUser.getUserId();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Teacher Dashboard</title>
    
    <%-- External CSS: Bootstrap, DataTables, and Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    
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

<%-- navber section--%>
<nav class="navbar navbar-dark bg-success sticky-top">
  <div class="container-fluid">
     <span class="navbar-brand fw-bold ms-3">Teacher Portal</span>
     
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
    <div class="card shadow border-0">
        <div class="card-header bg-white py-3"><h5 class="m-0 fw-bold text-success">Your Assigned Courses</h5></div>
        <div class="card-body">
        
        <%-- table for show teacher assign courses --%>
            <table id="teacherTable" class="table table-hover align-middle">
                <thead class="table-success thead-color"><tr><th>ID</th><th>Course Name</th><th class="text-center">Action</th></tr></thead>
                <tbody>
                      <% try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement("SELECT * FROM courses WHERE teacher_id=?");
                            ps.setInt(1, teacherId); ResultSet rs = ps.executeQuery(); while(rs.next()){ %>
                    <tr>
                        <td class="fw-bold">#<%= rs.getInt("course_id") %></td>
                        <td><%= rs.getString("course_name") %></td>
                        
                        <%-- action for show students of a particular course --%>
                        <td class="text-center">
                            <a href="teacherServlet?action=viewStudents&courseId=<%= rs.getInt("course_id") %>" class="btn btn-outline-success btn-sm rounded-pill fw-bold"><i class="fa-solid fa-users me-1"></i> View Students</a>
                        </td>
                    </tr>
                    <% }} catch(Exception e) { e.printStackTrace(); } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>$(document).ready(function(){ $('#teacherTable').DataTable(); });</script>
</body>
</html>