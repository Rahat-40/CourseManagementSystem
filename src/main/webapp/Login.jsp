<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login | CMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100vh; display: flex; align-items: center; justify-content: center; }
        .login-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); overflow: hidden; }
        .card-header { background: #fff; border-bottom: none; padding-top: 2rem; }
        .form-control { border-radius: 50px; padding: 0.75rem 1.5rem; }
        .btn-login { border-radius: 50px; padding: 0.75rem; background: #764ba2; border: none; transition: 0.3s; }
        .btn-login:hover { background: #5a3780; transform: translateY(-2px); }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card login-card p-4">
                <div class="card-header text-center">
                    <h3 class="fw-bold text-primary">Welcome Back!</h3>
                    <p class="text-muted small">Please login to your account</p>
                </div>
                <div class="card-body">
                    <form action="loginServlet" method="post">
                        <div class="mb-3"><input type="text" name="username" class="form-control" placeholder="Username" required></div>
                        <div class="mb-3"><input type="password" name="password" class="form-control" placeholder="Password" required></div>
                        <button type="submit" class="btn btn-primary w-100 btn-login fw-bold text-white">LOGIN</button>
                    </form>
                    <div class="mt-4 text-center">
                        <small>Don't have an account? <a href="Register.jsp" class="text-decoration-none fw-bold">Register Here</a></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<% if(request.getAttribute("error") != null) { %>
<script>
    Swal.fire({ icon: 'error', title: 'Login Failed', text: '<%= request.getAttribute("error") %>', confirmButtonColor: '#764ba2' });
</script>
<% } %>
<% if(request.getAttribute("success") != null) { %>
<script>
    Swal.fire({ icon: 'success', title: 'Success!', text: '<%= request.getAttribute("success") %>', confirmButtonColor: '#764ba2' });
</script>
<% } %>
</body>
</html>