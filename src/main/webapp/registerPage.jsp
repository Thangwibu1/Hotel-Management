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
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* --- 1. General Styles --- */
        :root {
            --font-heading: 'Cormorant Garamond', serif; 
            --font-body: 'Montserrat', sans-serif; 
            --color-gold: #c9ab81; 
            --color-charcoal: #000000; 
            --color-offwhite: #FAFAFA; 
            --color-grey: #666666;
            --primary-color: #c9ab81;
            --secondary-color: #6c757d;
            --dark-bg: #000000;
            --light-text: #fff;
            --dark-text: #333;
            --danger-color: #dc3545;
            --success-color: #28a745;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        html { scroll-behavior: smooth; }
        
        body {
            font-family: var(--font-body);
            line-height: 1.8;
            color: var(--dark-text);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
        }
        
        a { text-decoration: none; color: inherit; }

        /* --- 2. Header (giống home.jsp) --- */
        .header { 
            background-color: var(--color-charcoal); 
            border-bottom: 2px solid var(--color-gold); 
            color: #fff; 
            padding: 1.5rem 0; 
            position: fixed; 
            width: 100%; 
            top: 0; 
            z-index: 1000; 
        }
        
        .header .container { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .logo a { 
            font-family: var(--font-heading); 
            font-size: 2rem; 
            font-weight: 700; 
            letter-spacing: 2px; 
            text-transform: uppercase;
            color: #fff;
        }
        
        .logo a span { 
            color: var(--color-gold); 
        }
        
        .main-nav { 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }
        
        .btn { 
            display: inline-block; 
            padding: 0.75rem 2rem; 
            border: 2px solid; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 0.85rem; 
            text-align: center; 
            font-weight: 500; 
            transition: all 0.3s ease; 
            text-transform: uppercase; 
            letter-spacing: 1px; 
            font-family: var(--font-body); 
            background: transparent; 
        }
        
        .btn-primary { 
            background-color: var(--color-gold); 
            color: var(--color-charcoal); 
            border-color: var(--color-gold); 
            width: 100%;
        }
        
        .btn-primary:hover { 
            background-color: transparent; 
            color: var(--color-gold); 
        }
        
        .btn-secondary { 
            background-color: var(--secondary-color); 
            color: white; 
            border-color: var(--secondary-color);
        }
        
        .btn-secondary:hover { 
            background-color: transparent; 
            color: var(--secondary-color); 
        }

        /* --- 3. Main Content & Register Form --- */
        .main-content {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 120px 20px 60px;
            margin-top: 0;
        }
        
        .register-container {
            background: #fff;
            padding: 3rem 2.5rem;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 600px;
            animation: fadeInUp 0.6s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .register-container h2 {
            text-align: center;
            margin-bottom: 0.5rem;
            color: var(--color-charcoal);
            font-family: var(--font-heading);
            font-size: 2.8em;
            font-weight: 700;
        }
        
        .register-subtitle {
            text-align: center;
            color: var(--color-grey);
            margin-bottom: 2.5rem;
            font-size: 1rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 1.25rem;
        }
        
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--color-charcoal);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
        }
        
        .form-group input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            font-family: var(--font-body);
            transition: all 0.3s ease;
            background-color: #fafafa;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--color-gold);
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(201, 171, 129, 0.1);
        }
        
        .form-group input::placeholder {
            color: #aaa;
        }
        
        /* Validation styles */
        .form-group input.invalid {
            border-color: var(--danger-color);
            background-color: #fff5f5;
        }
        
        .form-group input.invalid:focus {
            border-color: var(--danger-color);
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
        }
        
        .form-group input.valid {
            border-color: var(--success-color);
            background-color: #f5fff5;
        }
        
        .error-text {
            color: var(--danger-color);
            font-size: 0.75rem;
            margin-top: 5px;
            display: none;
            font-weight: 500;
        }
        
        .error-text.show {
            display: block;
        }
        
        .submit-btn {
            margin-top: 1.5rem;
        }
        
        .login-link {
            text-align: center;
            margin-top: 2rem;
            color: var(--color-grey);
            font-size: 0.95rem;
        }
        
        .login-link a {
            color: var(--color-gold);
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .login-link a:hover {
            color: var(--color-charcoal);
            text-decoration: underline;
        }
        
        .message {
            text-align: center;
            padding: 15px 20px;
            margin-bottom: 1.5rem;
            border-radius: 10px;
            font-weight: 500;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .error-message {
            color: var(--danger-color);
            background-color: #ffe6e6;
            border: 2px solid #ffcccc;
        }
        
        .success-message {
            color: var(--success-color);
            background-color: #e6f9e6;
            border: 2px solid #c3e6c3;
        }
        
        /* Decorative elements */
        .register-container::before {
            content: '';
            position: absolute;
            top: -5px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 5px;
            background: linear-gradient(90deg, var(--color-gold), var(--color-charcoal));
            border-radius: 0 0 10px 10px;
        }
        
        .form-icon {
            color: var(--color-gold);
            margin-right: 8px;
        }
        
        /* === ERROR POPUP STYLES === */
        .error-popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 9999;
            animation: fadeIn 0.3s ease-in;
        }
        
        .error-popup-overlay.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-popup {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            padding: 40px;
            border-radius: 20px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            text-align: center;
            animation: slideDown 0.4s ease-out;
            position: relative;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        .error-popup-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        
        .error-popup-icon i {
            font-size: 3em;
            color: white;
        }
        
        .error-popup h2 {
            font-family: var(--font-heading);
            font-size: 2em;
            color: #e74c3c;
            margin-bottom: 15px;
        }
        
        .error-popup p {
            font-size: 1.1em;
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .error-popup-close {
            background: linear-gradient(135deg, var(--color-gold), #f4e4a6);
            color: #fff;
            border: none;
            padding: 12px 35px;
            border-radius: 50px;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(201, 171, 129, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .error-popup-close:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(201, 171, 129, 0.4);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .register-container {
                padding: 2rem 1.5rem;
            }
            
            .register-container h2 {
                font-size: 2.2em;
            }
            
            .error-popup {
                padding: 30px 20px;
            }
            
            .error-popup h2 {
                font-size: 1.6em;
            }
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo"><a href="home">LUXURY <span>HOTEL</span></a></div>
        <nav class="main-nav">
            <a href="<%=IConstant.loginPage%>" class="btn btn-secondary">Đăng nhập</a>
        </nav>
    </div>
</header>

<main class="main-content">
    <div class="register-container">
        <h2><i class="fa-solid fa-user-plus form-icon"></i>Đăng Ký Tài Khoản</h2>
        <p class="register-subtitle">Tạo tài khoản để trải nghiệm dịch vụ đẳng cấp</p>

        <%-- Hiển thị thông báo lỗi/thành công từ Servlet --%>
        <% String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { %>
        <div class="message error-message">
            <i class="fa-solid fa-circle-exclamation"></i> <%= errorMessage %>
        </div>
        <% } %>
        <% String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) { %>
        <div class="message success-message">
            <i class="fa-solid fa-circle-check"></i> <%= successMessage %>
        </div>
        <% } %>

        <form id="registerForm" action=<%=IConstant.registerServlet%> method="post" novalidate>
            <div class="form-group">
                <label for="fullName"><i class="fa-solid fa-user form-icon"></i>Họ và Tên</label>
                <input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A" required>
                <span class="error-text" id="fullName-error">Vui lòng nhập họ và tên</span>
            </div>
            
            <div class="form-group">
                <label for="email"><i class="fa-solid fa-envelope form-icon"></i>Email</label>
                <input type="email" id="email" name="email" placeholder="example@email.com" required>
                <span class="error-text" id="email-error">Vui lòng nhập email hợp lệ</span>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="password"><i class="fa-solid fa-lock form-icon"></i>Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required minlength="6">
                    <span class="error-text" id="password-error">Mật khẩu tối thiểu 6 ký tự</span>
                </div>
                <div class="form-group">
                    <label for="confirmPassword"><i class="fa-solid fa-lock form-icon"></i>Xác nhận</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
                    <span class="error-text" id="confirmPassword-error">Mật khẩu không khớp</span>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="phone"><i class="fa-solid fa-phone form-icon"></i>Số điện thoại</label>
                    <input type="tel" id="phone" name="phone" placeholder="0901234567">
                    <span class="error-text" id="phone-error">Số điện thoại không hợp lệ</span>
                </div>
                <div class="form-group">
                    <label for="dateOfBirth"><i class="fa-solid fa-cake-candles form-icon"></i>Ngày sinh <span style="color: #e74c3c;">*</span></label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" required>
                    <span class="error-text" id="dateOfBirth-error">Vui lòng chọn ngày sinh</span>
                </div>
            </div>
            
            <div class="form-group">
                <label for="address"><i class="fa-solid fa-location-dot form-icon"></i>Địa chỉ</label>
                <input type="text" id="address" name="address" placeholder="123 Đường ABC, Quận 1, TP.HCM">
                <span class="error-text" id="address-error">Vui lòng nhập địa chỉ</span>
            </div>
            
            <div class="form-group">
                <label for="idNumber"><i class="fa-solid fa-id-card form-icon"></i>Số CMND/CCCD</label>
                <input type="text" id="idNumber" name="idNumber" placeholder="001234567890">
                <span class="error-text" id="idNumber-error">Vui lòng nhập số CMND/CCCD</span>
            </div>

            <div class="submit-btn">
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-user-plus"></i> Đăng Ký Ngay
                </button>
            </div>
        </form>
        
        <p class="login-link">
            Đã có tài khoản? <a href=<%=IConstant.loginPage%>>Đăng nhập ngay</a>
        </p>
    </div>
</main>

<!-- ERROR POPUP -->
<div id="errorPopupOverlay" class="error-popup-overlay">
    <div class="error-popup">
        <div class="error-popup-icon">
            <i class="fa-solid fa-exclamation-triangle"></i>
        </div>
        <h2>Đăng Ký Thất Bại!</h2>
        <p id="errorMessage">Đã có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại sau hoặc liên hệ với chúng tôi để được hỗ trợ.</p>
        <button class="error-popup-close" onclick="closeErrorPopup()">Đã hiểu</button>
    </div>
</div>

<script>
    // === ERROR POPUP LOGIC ===
    function closeErrorPopup() {
        const overlay = document.getElementById('errorPopupOverlay');
        overlay.classList.remove('show');
        // Xóa param error khỏi URL
        const url = new URL(window.location);
        url.searchParams.delete('error');
        window.history.replaceState({}, '', url);
    }
    
    // Kiểm tra param error khi trang load
    const urlParams = new URLSearchParams(window.location.search);
    const errorParam = urlParams.get('error');
    
    if (errorParam) {
        const overlay = document.getElementById('errorPopupOverlay');
        const errorMessage = document.getElementById('errorMessage');
        
        // Tùy chỉnh message dựa trên error type
        if (errorParam.includes('Email') || errorParam.includes('ID number')) {
            errorMessage.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> Email hoặc số CMND/CCCD đã được sử dụng.<br>Vui lòng kiểm tra lại thông tin hoặc đăng nhập nếu bạn đã có tài khoản.';
        } else {
            errorMessage.textContent = decodeURIComponent(errorParam);
        }
        
        // Hiển thị popup
        overlay.classList.add('show');
    }
    
    // Đóng popup khi click bên ngoài
    document.getElementById('errorPopupOverlay').addEventListener('click', function(e) {
        if (e.target === this) {
            closeErrorPopup();
        }
    });
    
    // Đóng popup khi nhấn ESC
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            const overlay = document.getElementById('errorPopupOverlay');
            if (overlay.classList.contains('show')) {
                closeErrorPopup();
            }
        }
    });
    
    // === VALIDATION LOGIC ===
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const inputs = form.querySelectorAll('input[required]');
        
        // Set min and max date for date of birth
        const dateOfBirthInput = document.getElementById('dateOfBirth');
        if (dateOfBirthInput) {
            const today = new Date();
            const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());
            const minDate = new Date(today.getFullYear() - 120, today.getMonth(), today.getDate());
            
            dateOfBirthInput.max = maxDate.toISOString().split('T')[0];
            dateOfBirthInput.min = minDate.toISOString().split('T')[0];
        }
        
        // Validate individual field
        function validateField(input) {
            const errorElement = document.getElementById(input.id + '-error');
            let isValid = true;
            
            // Check if field is empty
            if (input.hasAttribute('required') && !input.value.trim()) {
                isValid = false;
                if (errorElement) {
                    errorElement.textContent = 'Vui lòng nhập ' + input.placeholder || 'trường này';
                }
            }
            // Check email format
            else if (input.type === 'email' && input.value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(input.value)) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Email không hợp lệ';
                    }
                }
            }
            // Check password length
            else if (input.id === 'password' && input.value) {
                if (input.value.length < 6) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Mật khẩu tối thiểu 6 ký tự';
                    }
                }
            }
            // Check password confirmation
            else if (input.id === 'confirmPassword' && input.value) {
                const password = document.getElementById('password').value;
                if (input.value !== password) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Mật khẩu không khớp';
                    }
                }
            }
            // Check phone number
            else if (input.id === 'phone' && input.value) {
                const phoneRegex = /^[0-9]{10,11}$/;
                if (!phoneRegex.test(input.value)) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Số điện thoại không hợp lệ (10-11 số)';
                    }
                }
            }
            // Check date of birth
            else if (input.id === 'dateOfBirth' && input.value) {
                const selectedDate = new Date(input.value);
                const today = new Date();
                const age = today.getFullYear() - selectedDate.getFullYear();
                const monthDiff = today.getMonth() - selectedDate.getMonth();
                const dayDiff = today.getDate() - selectedDate.getDate();
                
                // Check if date is in the future
                if (selectedDate > today) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Ngày sinh không thể là ngày tương lai';
                    }
                }
                // Check minimum age (18 years old)
                else if (age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Bạn phải đủ 18 tuổi để đăng ký';
                    }
                }
                // Check maximum age (120 years old)
                else if (age > 120) {
                    isValid = false;
                    if (errorElement) {
                        errorElement.textContent = 'Ngày sinh không hợp lệ';
                    }
                }
            }
            
            // Update UI
            if (isValid) {
                input.classList.remove('invalid');
                input.classList.add('valid');
                if (errorElement) {
                    errorElement.classList.remove('show');
                }
            } else {
                input.classList.remove('valid');
                input.classList.add('invalid');
                if (errorElement) {
                    errorElement.classList.add('show');
                }
            }
            
            return isValid;
        }
        
        // Add blur event to all inputs
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                validateField(this);
            });
            
            input.addEventListener('input', function() {
                if (this.classList.contains('invalid')) {
                    validateField(this);
                }
            });
        });
        
        // Also validate password match when typing in password fields
        document.getElementById('password').addEventListener('input', function() {
            const confirmPassword = document.getElementById('confirmPassword');
            if (confirmPassword.value) {
                validateField(confirmPassword);
            }
        });
        
        // Form submission
        form.addEventListener('submit', function(e) {
            let isFormValid = true;
            
            // Validate all required fields
            inputs.forEach(input => {
                if (!validateField(input)) {
                    isFormValid = false;
                }
            });
            
            // Prevent submission if form is invalid
            if (!isFormValid) {
                e.preventDefault();
                
                // Scroll to first invalid field
                const firstInvalid = form.querySelector('.invalid');
                if (firstInvalid) {
                    firstInvalid.focus();
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        });
    });
</script>

</body>
</html>