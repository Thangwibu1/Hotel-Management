<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Luxury Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* Additional styles for login page */
        .login-hero {
            height: 100vh;
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('images/hero-bg.jpg') no-repeat center center/cover;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--light-text-color);
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 400px;
            color: var(--text-color);
        }
        
        .login-title {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary-color);
        }
        
        .login-title h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .login-title p {
            color: #777;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(51, 51, 51, 0.1);
        }
        
        .form-group-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-right: 8px;
        }
        
        .checkbox-group label {
            margin: 0;
            font-weight: normal;
            font-size: 14px;
        }
        
        .forgot-password {
            color: var(--primary-color);
            font-size: 14px;
            text-decoration: none;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .login-btn {
            width: 100%;
            padding: 14px;
            background-color: var(--primary-color);
            color: var(--light-text-color);
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 20px;
        }
        
        .login-btn:hover {
            background-color: #555;
        }
        
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .register-link p {
            color: #777;
            margin-bottom: 10px;
        }
        
        .register-link a {
            color: var(--primary-color);
            font-weight: bold;
            text-decoration: none;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        /* Alert message styles */
        .alert {
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-error {
            background-color: #ffe6e6;
            color: #d8000c;
            border: 1px solid #ffcdd2;
        }
        
        .alert-success {
            background-color: #e8f5e8;
            color: #4caf50;
            border: 1px solid #c8e6c9;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="home">Luxury Hotel</a>
        </div>
        <nav class="main-nav">
            <a href="home">Trang chủ</a>
            <a href="./registerPage.jsp">Đăng ký</a>
        </nav>
    </div>
</header>

<section class="login-hero">
    <div class="login-container">
        <div class="login-title">
            <h2>Đăng nhập</h2>
            <p>Chào mừng quay trở lại!</p>
        </div>
        
        <!-- Display error message if exists -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fa-solid fa-exclamation-triangle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- Display success message if exists -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fa-solid fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
<%--form đăng nhập--%>
        <form action="login" method="post">
            <div class="form-group">
                <label for="username">
                    <i class="fa-solid fa-user"></i>
                    Tên đăng nhập
                </label>
                <input type="text" id="username" name="username" required
                       placeholder="Nhập tên đăng nhập của bạn"
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
            </div>

            <div class="form-group">
                <label for="password">
                    <i class="fa-solid fa-lock"></i>
                    Mật khẩu
                </label>
                <input type="password" id="password" name="password" required
                       placeholder="Nhập mật khẩu của bạn">
            </div>

            <button type="submit" class="login-btn">
                <i class="fa-solid fa-sign-in-alt"></i>
                Đăng nhập
            </button>
        </form>

        <div class="register-link">
            <p>Chưa có tài khoản?</p>
            <a href="./registerPage.jsp">Đăng ký ngay</a>
        </div>
    </div>
</section>

<footer class="footer">
    <div class="container footer-grid">
        <div class="footer-col">
            <h3>Luxury Hotel</h3>
            <p>Chất lượng sang trọng hàng đầu với dịch vụ chất lượng cao và các tiện ích tốt.</p>
        </div>
        <div class="footer-col">
            <h3>Liên hệ</h3>
            <p><i class="fa-solid fa-location-dot"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
            <p><i class="fa-solid fa-phone"></i> (028) 1234-5678</p>
            <p><i class="fa-solid fa-envelope"></i> info@luxuryhotel.com</p>
        </div>
        <div class="footer-col">
            <h3>Dịch vụ</h3>
            <ul>
                <li><a href="#">Nhà hàng & Bar</a></li>
                <li><a href="#">Spa & Trị liệu</a></li>
                <li><a href="#">Bể bơi Rooftop</a></li>
                <li><a href="#">Phòng gym hiện đại</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2024 Luxury Hotel. Bảo lưu mọi quyền.</p>
    </div>
</footer>

<script>
    // Auto-hide alert messages after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 300);
            }, 5000);
        });
    });
</script>

</body>
</html>
