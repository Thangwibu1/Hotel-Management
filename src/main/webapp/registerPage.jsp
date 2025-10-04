<%@ page import="utils.IConstant" %>
<%@ page import="javax.swing.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* --- 1. General Styles --- */
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --dark-bg: #222;
            --light-text: #fff;
            --dark-text: #333;
            --danger-color: #dc3545;
            --success-color: #28a745;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: var(--dark-text);
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
        }
        a { text-decoration: none; color: var(--primary-color); }
        a:hover { text-decoration: underline; }

        /* --- 2. Simple Header --- */
        .simple-header {
            background-color: var(--dark-bg);
            color: var(--light-text);
            padding: 1rem 0;
            text-align: center;
        }
        .simple-header .logo a {
            font-size: 1.8em;
            font-weight: bold;
            color: var(--light-text);
        }

        /* --- 3. Main Content & Register Form --- */
        .main-content {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        .register-container {
            background: #fff;
            padding: 2.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }
        .register-container h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--dark-text);
        }
        .form-group {
            margin-bottom: 1.25rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        .btn {
            display: inline-block;
            width: 100%;
            padding: 12px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: bold;
            text-align: center;
        }
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
            transition: background-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #666;
        }
        .message {
            text-align: center;
            padding: 10px;
            margin-bottom: 1rem;
            border-radius: 4px;
        }
        .error-message {
            color: var(--danger-color);
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            color: var(--success-color);
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>

<header class="simple-header">
    <div class="logo">
        <a href="home">Luxury Hotel</a>
    </div>
</header>

<main class="main-content">
    <div class="register-container">
        <h2>Đăng Ký Tài Khoản</h2>

        <%-- Hiển thị thông báo lỗi/thành công từ Servlet --%>
        <% String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { %>
        <div class="message error-message">
            <%= errorMessage %>
        </div>
        <% } %>
        <% String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) { %>
        <div class="message success-message">
            <%= successMessage %>
        </div>
        <% } %>

        <form id="registerForm" action=<%=IConstant.registerServlet%> method="post">
            <div class="form-group">
                <label for="fullName">Họ và Tên</label>
                <input type="text" id="fullName" name="fullName" required>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận Mật khẩu</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone">
            </div>
            <div class="form-group">
                <label for="dateOfBirth">Ngày sinh</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth">
            </div>
            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address">
            </div>
            <div class="form-group">
                <label for="idNumber">Số CMND/CCCD</label>
                <input type="text" id="idNumber" name="idNumber">
            </div>

            <button type="submit" class="btn btn-primary">Đăng Ký</button>
        </form>
        <p class="login-link">
            Đã có tài khoản? <a href=<%=IConstant.loginPage%>>Đăng nhập ngay</a>
        </p>
    </div>
</main>

<script>
    // JavaScript để kiểm tra mật khẩu có khớp không
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');

    function validatePassword() {
        if (passwordInput.value !== confirmPasswordInput.value) {
            confirmPasswordInput.setCustomValidity("Mật khẩu không khớp!");
        } else {
            confirmPasswordInput.setCustomValidity('');
        }
    }

    passwordInput.addEventListener('input', validatePassword);
    confirmPasswordInput.addEventListener('input', validatePassword);
</script>

</body>
</html>