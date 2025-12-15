<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register | CMS</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- Internal CSS styling -->
    <style>
        body { 
        	font-family: 'Poppins', sans-serif; 
        	background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); 
        	height: 100vh; 
        	display: flex; 
        	align-items: center; 
        	justify-content: center;
         }
        .login-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
        .form-control, .form-select { border-radius: 50px; padding: 0.75rem 1.5rem; }
        .btn-reg { border-radius: 50px; padding: 0.75rem; background: #11998e; border: none; }
        .btn-reg:hover { background: #0e8076; }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
        
        <!-- Registration card -->
            <div class="card login-card p-4">
                <div class="text-center mb-4 mt-2">
                    <h3 class="fw-bold text-success">Create Account</h3>
                </div>
                
                <!-- Registration Form -->
                <form action="registerServlet" method="post">
                    <div class="mb-3"><input type="text" name="username" class="form-control" placeholder="Username" required></div>
                    <div class="mb-3"><input type="password" name="password" class="form-control" placeholder="Password" required></div>
                    <div class="mb-3">
                        <select name="role" class="form-select" required>
                            <option value="" disabled selected>Select Role</option>
                            <option value="student">Student</option>
                            <option value="teacher">Teacher</option>
                            <option value="admin">Admin</option>
                        </select>
                    </div>
                    
                    <!-- Submit button -->
                    <button type="submit" class="btn btn-success w-100 btn-reg fw-bold text-white">REGISTER</button>
                </form>
                
                <!-- Login page link  if already register-->
                <div class="mt-3 text-center">
                    <small>Already registered? <a href="Login.jsp" class="text-decoration-none fw-bold text-success">Login</a></small>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- get error message -->
<% if(request.getAttribute("error") != null) { %>

<!--  Then this block will show SweetAlert popup  -->
<script>
    Swal.fire({ icon: 'warning', title: 'Oops...', text: '<%= request.getAttribute("error") %>' });
</script>
<% } %>
</body>
</html>