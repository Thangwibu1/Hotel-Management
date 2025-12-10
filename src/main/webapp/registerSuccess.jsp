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
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* === LUXURY THEME === */
        :root { 
            --font-heading: 'Cormorant Garamond', serif; 
            --font-body: 'Montserrat', sans-serif;
            --gold: #c9ab81;
            --black: #000000;
            --gray: #666666;
            --light-gray: #f8f8f8;
            --border: #e0e0e0;
            --success-color: #28a745;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: var(--font-body);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: var(--black);
            line-height: 1.6;
            min-height: 100vh;
            padding: 40px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container { 
            max-width: 700px; 
            margin: auto;
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .success-card { 
            background: #ffffff;
            border-radius: 20px; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            border: 1px solid var(--border);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card-header { 
            background: var(--black);
            color: #ffffff;
            padding: 50px 30px;
            text-align: center;
            border-bottom: 3px solid var(--gold);
            position: relative;
        }
        
        .success-checkmark {
            width: 100px;
            height: 100px;
            margin: 0 auto 20px;
            background: var(--gold);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .card-header .icon { 
            font-size: 3.5em; 
            color: var(--black);
        }
        
        .card-header h1 { 
            margin: 0 0 15px 0;
            font-size: 2.5em;
            font-weight: 700;
            font-family: var(--font-heading);
            letter-spacing: 1px;
        }
        
        .card-header p {
            font-size: 1.05em;
            opacity: 0.95;
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .card-body { 
            padding: 40px;
            background: #ffffff;
        }
        
        .welcome-message {
            text-align: center;
            font-size: 1.15em;
            color: var(--gray);
            margin-bottom: 35px;
            line-height: 1.8;
        }
        
        .welcome-message strong {
            color: var(--gold);
            font-weight: 600;
        }
        
        .detail-section { 
            background: var(--light-gray);
            padding: 30px;
            border-radius: 10px;
            border-left: 4px solid var(--gold);
        }
        
        .detail-section h2 { 
            font-size: 1.4em;
            color: var(--black);
            border-bottom: 2px solid var(--gold);
            padding-bottom: 15px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            font-family: var(--font-heading);
        }
        
        .detail-section h2 i {
            color: var(--gold);
            font-size: 1.2em;
        }
        
        .info-item { 
            display: flex; 
            justify-content: space-between;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid var(--border);
        }
        
        .info-item:last-child { border-bottom: none; }
        
        .info-item strong { 
            color: var(--gray);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95em;
        }
        
        .info-item strong i {
            color: var(--gold);
            width: 20px;
            font-size: 1.1em;
        }
        
        .info-item span {
            color: var(--black);
            font-weight: 600;
            font-size: 1em;
        }
        
        .card-footer { 
            background: var(--light-gray);
            padding: 30px;
            text-align: center;
            border-top: 2px solid var(--border);
        }
        
        .btn { 
            display: inline-block; 
            padding: 14px 40px;
            border-radius: 8px;
            border: 2px solid var(--gold);
            cursor: pointer;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-family: var(--font-body);
        }
        
        .btn-primary { 
            background: var(--gold);
            color: var(--black);
        }
        
        .btn-primary:hover { 
            background: transparent;
            color: var(--gold);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(201, 171, 129, 0.3);
        }
        
        .btn i {
            margin-right: 8px;
        }
        
        /* Confetti Animation */
        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: var(--gold);
            opacity: 0;
            animation: confetti-fall 3s ease-out infinite;
        }
        
        @keyframes confetti-fall {
            0% { transform: translateY(-100px) rotate(0deg); opacity: 1; }
            100% { transform: translateY(500px) rotate(360deg); opacity: 0; }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .card-header {
                padding: 40px 20px;
            }
            
            .card-header h1 {
                font-size: 2em;
            }
            
            .card-body {
                padding: 30px 20px;
            }
            
            .detail-section {
                padding: 20px;
            }
            
            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="success-card">
        <div class="card-header">
            <div class="success-checkmark">
                <i class="fa-solid fa-check-circle icon"></i>
            </div>
            <h1>🎉 Đăng Ký Thành Công!</h1>
            <p>Chúc mừng! Tài khoản của bạn đã được tạo thành công. Hãy đăng nhập để trải nghiệm dịch vụ đẳng cấp tại Luxury Hotel.</p>
        </div>
        
        <div class="card-body">
            <div class="welcome-message">
                Xin chào <strong><%= fullName %></strong>! 👋<br>
                Cảm ơn bạn đã tham gia cộng đồng Luxury Hotel. Hãy kiểm tra email của bạn để biết thêm thông tin chi tiết.
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-user-circle"></i> Thông Tin Tài Khoản</h2>
                
                <div class="info-item">
                    <strong><i class="fa-solid fa-user"></i> Họ và tên:</strong>
                    <span><%= fullName %></span>
                </div>
                
                <div class="info-item">
                    <strong><i class="fa-solid fa-envelope"></i> Email:</strong>
                    <span><%= email %></span>
                </div>
                
                <% if (phone != null && !phone.isEmpty()) { %>
                <div class="info-item">
                    <strong><i class="fa-solid fa-phone"></i> Số điện thoại:</strong>
                    <span><%= phone %></span>
                </div>
                <% } %>
                
                <% if (dateOfBirth != null && !dateOfBirth.isEmpty()) { %>
                <div class="info-item">
                    <strong><i class="fa-solid fa-cake-candles"></i> Ngày sinh:</strong>
                    <span><%= dateOfBirth %></span>
                </div>
                <% } %>
                
                <% if (address != null && !address.isEmpty()) { %>
                <div class="info-item">
                    <strong><i class="fa-solid fa-location-dot"></i> Địa chỉ:</strong>
                    <span><%= address %></span>
                </div>
                <% } %>
                
                <% if (idNumber != null && !idNumber.isEmpty()) { %>
                <div class="info-item">
                    <strong><i class="fa-solid fa-id-card"></i> Số CMND/CCCD:</strong>
                    <span><%= idNumber %></span>
                </div>
                <% } %>
            </div>
        </div>
        
        <div class="card-footer">
            <a href="<%=IConstant.loginPage%>" class="btn btn-primary">
                <i class="fa-solid fa-right-to-bracket"></i> Đăng Nhập Ngay
            </a>
        </div>
    </div>
</div>

</body>
</html>