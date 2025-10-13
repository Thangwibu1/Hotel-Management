<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="utils.IConstant" %>

<%
    // Lấy tất cả các attributes từ request mà controller đã gửi sang
    String fullName = (String) request.getAttribute("fullName");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    String dateOfBirth = (String) request.getAttribute("dateOfBirth");
    String address = (String) request.getAttribute("address");
    String idNumber = (String) request.getAttribute("idNumber");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Thành Công - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        :root {
            --primary-color: #007bff;
            --success-color: #28a745;
            --dark-text: #333;
            --light-gray: #f8f9fa;
        }
        body { font-family: Arial, sans-serif; background-color: var(--light-gray); color: var(--dark-text); line-height: 1.6; margin: 0; padding: 40px 20px; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .container { max-width: 600px; width: 100%; }
        .success-card { background: #fff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden; text-align: center; }
        .card-header { background: var(--success-color); color: white; padding: 30px 20px; }
        .card-header .icon { font-size: 4em; margin-bottom: 15px; }
        .card-header h1 { margin: 0; font-size: 2em; }
        .card-body { padding: 30px; }
        .card-body p { font-size: 1.1em; color: #555; margin-bottom: 25px; }
        .info-summary { text-align: left; background: #f9f9f9; border: 1px solid #eee; border-radius: 5px; padding: 20px; }
        .info-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .info-item:last-child { border-bottom: none; }
        .info-item strong { color: #333; }
        .card-footer { background: var(--light-gray); padding: 25px; }
        .btn { display: inline-block; padding: 12px 30px; border-radius: 5px; border: none; cursor: pointer; font-size: 1.1rem; text-decoration: none; font-weight: bold; transition: background-color 0.3s; }
        .btn-primary { background-color: var(--primary-color); color: white; }
        .btn-primary:hover { background-color: #0056b3; }
    </style>
</head>
<body>

<div class="container">
    <div class="success-card">
        <div class="card-header">
            <div class="icon"><i class="fa-solid fa-party-horn"></i></div>
            <h1>Đăng Ký Thành Công!</h1>
        </div>
        <div class="card-body">
            <p>
                Chào mừng <strong><%= fullName %></strong>, tài khoản của bạn đã được tạo thành công. <br>
                Vui lòng kiểm tra lại thông tin và đăng nhập để bắt đầu trải nghiệm.
            </p>

            <div class="info-summary">
                <div class="info-item">
                    <strong>Email:</strong>
                    <span><%= email %></span>
                </div>
                <% if (phone != null && !phone.isEmpty()) { %>
                <div class="info-item">
                    <strong>Số điện thoại:</strong>
                    <span><%= phone %></span>
                </div>
                <% } %>
                <% if (dateOfBirth != null && !dateOfBirth.isEmpty()) { %>
                <div class="info-item">
                    <strong>Ngày sinh:</strong>
                    <span><%= dateOfBirth %></span>
                </div>
                <% } %>
                <% if (address != null && !address.isEmpty()) { %>
                <div class="info-item">
                    <strong>Địa chỉ:</strong>
                    <span><%= address %></span>
                </div>
                <% } %>
                <% if (idNumber != null && !idNumber.isEmpty()) { %>
                <div class="info-item">
                    <strong>Số CMND/CCCD:</strong>
                    <span><%= idNumber %></span>
                </div>
                <% } %>
            </div>
        </div>
        <div class="card-footer">
            <a href="loginPage.jsp" class="btn btn-primary">Đi đến trang Đăng nhập</a>
        </div>
    </div>
</div>

</body>
</html>