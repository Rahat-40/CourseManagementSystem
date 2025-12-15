<%@ page import="java.sql.*, utils.DBConnection" %>
<% models.User currentUser = (models.User)session.getAttribute("currentUser"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f4f6f9; }
        .card-box { border: none; border-radius: 10px; transition: transform 0.3s; color:white; }
        .card-box:hover { transform: translateY(-5px); }
        .bg-p { background: linear-gradient(45deg, #4e73df, #224abe); }
        .bg-s { background: linear-gradient(45deg, #1cc88a, #13855c); }
        .bg-i { background: linear-gradient(45deg, #36b9cc, #258391); }
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
<nav class="navbar navbar-expand-lg navbar-dark bg-success sticky-top">
  <div class="container-fluid">
     <span class="navbar-brand fw-bold ms-3">CMS Admin</span>
     
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
    <div class="row mb-4">
        <% 
            int u=0, c=0;
            try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()) {
                ResultSet rs1=st.executeQuery("SELECT COUNT(*) FROM users"); if(rs1.next()) u=rs1.getInt(1);
                ResultSet rs2=st.executeQuery("SELECT COUNT(*) FROM courses"); if(rs2.next()) c=rs2.getInt(1);
            } catch(Exception e){}
        %>
        <div class="col-md-4"><div class="card card-box bg-p p-3 mb-3 shadow"><h3><%= u %></h3><small>Total Users</small></div></div>
        <div class="col-md-4"><div class="card card-box bg-s p-3 mb-3 shadow"><h3><%= c %></h3><small>Active Courses</small></div></div>
        <div class="col-md-4"><div class="card card-box bg-i p-3 mb-3 shadow"><h5>Quick Actions</h5><small>Manage System</small></div></div>
    </div>

    <div class="row">
        <div class="col-md-4">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-white fw-bold"><i class="fa-solid fa-plus-circle text-success me-1"></i> Add New Course</div>
                <div class="card-body">
                
                <%-- form for add new course --%>
                    <form action="adminServlet" method="post">
                        <input type="hidden" name="action" value="addCourse">
                        <input type="text" name="course_name" class="form-control mb-3" placeholder="Course Name" required>
                        <button class="btn btn-success w-100">Create</button>
                    </form>
                </div>
            </div>
            
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white fw-bold"><i class="fa-solid fa-chalkboard-user text-primary me-1"></i> Assign Teacher</div>
                <div class="card-body">
                
                <%-- form for assign new teacher for a particular course--%>
                    <form action="adminServlet" method="post">
                        <input type="hidden" name="action" value="assignTeacher">
                        
                        <div class="mb-3">
                            <label class="form-label small">Select Course to Assign</label>
                            <select name="course_id" class="form-select" required>
                                <option value="" disabled selected>Select Course (ID: Name)</option>
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
                        
                        <%--select teacher for assign a particular course --%>
                        
                        <div class="mb-3">
                            <label class="form-label small">Select Teacher</label>
                            <select name="teacher_id" class="form-select" required>
                                <option value="" disabled selected>Select Teacher (ID: Username) </option>
                                <% 
                                    try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()){
                                        ResultSet rsTeachers = st.executeQuery("SELECT user_id, username FROM users WHERE role='teacher' ORDER BY username");
                                        while(rsTeachers.next()){ 
                                %>
                                    <option value="<%= rsTeachers.getInt("user_id") %>">
                                        ID <%= rsTeachers.getInt("user_id") %>: <%= rsTeachers.getString("username") %>
                                    </option>
                                <% 
                                    }
                                    } catch(Exception e){ /* Handle exception */ }
                                %>
                            </select>
                        </div>
                        
                        <button class="btn btn-primary w-100"><i class="fa-solid fa-link me-1"></i> Assign Teacher</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card mb-4 border-0 shadow-sm">
                <div class="card-header bg-emerald">All Users</div>
                <div class="card-body">
                
                <%-- table for all user --%>
                    <table id="usersTable" class="table table-hover">
                        <thead class="table-light thead-color ">
                            <tr><th>ID</th><th>Username</th><th>Role</th></tr>
                        </thead>
                        <tbody>
                            <% try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()){
                                ResultSet rs=st.executeQuery("SELECT * FROM users"); while(rs.next()){ %>
                            <tr><td><%= rs.getInt("user_id") %></td><td><%= rs.getString("username") %></td><td><%= rs.getString("role") %></td></tr>
                            <% }} catch(Exception e){} %>
                        </tbody>
                    </table>
                </div>
            </div>
             <div class="card border-0 shadow-sm">
                <div class="card-header bg-emerald">All Courses</div>
                <div class="card-body">
                
                <%-- table for all courses --%>
                    <table id="coursesTable" class="table table-hover">
                        <thead class="table-light thead-color">
                            <tr><th>ID</th><th>Course</th><th>Teacher</th></tr>
                        </thead>
                        <tbody>
                            <% try(Connection con=DBConnection.getConnection(); Statement st=con.createStatement()){
                                ResultSet rs=st.executeQuery("SELECT c.course_id,c.course_name,u.username FROM courses c LEFT JOIN users u ON c.teacher_id=u.user_id"); while(rs.next()){ %>
                            <tr><td><%= rs.getInt("course_id") %></td><td><%= rs.getString("course_name") %></td><td><%= rs.getString("username")!=null?rs.getString("username"):"Unassigned" %></td></tr>
                            <% }} catch(Exception e){} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function(){ 
        $('#usersTable').DataTable({pageLength:5}); 
        $('#coursesTable').DataTable({pageLength:5}); 
    });

    // Handle Success Messages
    <% if(request.getParameter("msg") != null) { %> 
        Swal.fire('Success', 'Action Completed Successfully', 'success'); 
    <% } %>

    // Handle Error Messages
    <% if("duplicate".equals(request.getParameter("error"))) { %>
        Swal.fire({
            icon: 'error',
            title: 'Duplicate Entry',
            text: 'This course name already exists in the system.'
        });
    <% } else if("1".equals(request.getParameter("error"))) { %>
        Swal.fire('Error', 'An unexpected system error occurred.', 'error');
    <% } %>
</script>
</body>
</html>