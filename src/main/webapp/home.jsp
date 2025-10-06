<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>
<%@ page import="utils.IConstant" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* CSS cho slideshow */
        .hero {
            position: relative;
            height: 700px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            overflow: hidden;
        }

        .hero-slideshow {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            transition: opacity 1.5s ease-in-out; /* Hiệu ứng fade */
            opacity: 0; /* Mặc định ẩn tất cả ảnh */
            z-index: 1; /* Đảm bảo các slide nằm dưới nội dung */
        }

        /* Đặt ảnh đầu tiên visible mặc định */
        .hero-slideshow:first-child {
            opacity: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            animation: fadeInUp 1.2s ease-out;
            max-width: 800px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-content h1 {
            font-size: 4.5em;
            margin-bottom: 25px;
            text-shadow: 3px 3px 12px rgba(0, 0, 0, 0.8);
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
        }

        .hero-content p {
            font-size: 1.8em;
            margin-bottom: 40px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.8);
            font-weight: 300;
            letter-spacing: 1px;
        }

        .booking-form-container {
            position: absolute;
            bottom: -80px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 150;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            padding: 35px 45px;
            border-radius: 15px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: flex-end;
            gap: 25px;
            border: 1px solid #404040;
            width: 90%;
            max-width: 1150px;
        }

        .booking-form .form-group {
            margin-bottom: 0;
            text-align: left;
            flex: 1;
        }

        .booking-form label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #ffffff;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .booking-form input,
        .booking-form select {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #404040;
            border-radius: 8px;
            font-size: 1rem;
            color: #fff;
            background-color: rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .booking-form input:focus,
        .booking-form select:focus {
            outline: none;
            border-color: #666;
            background-color: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
        }

        .booking-form input::placeholder {
            color: #999;
        }

        .btn-search {
            background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%);
            color: white;
            padding: 14px 35px;
            border: 2px solid #fff;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 700;
            white-space: nowrap;
            transition: all 0.4s ease;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }
        
        .btn-search:hover {
            background: #fff;
            color: #1a1a1a;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.3);
        }

        .btn-search i {
            margin-right: 8px;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0, 0, 0, 0.65) 0%, rgba(26, 26, 26, 0.55) 100%);
            z-index: 1;
        }

        /* Features Section */
        .features {
            padding: 80px 0 80px 0;
            background: linear-gradient(to bottom, #ffffff 0%, #f5f5f5 100%);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-top: 50px;
        }

        .feature-card {
            text-align: center;
            padding: 40px 30px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            transition: all 0.4s ease;
            border: 1px solid #e0e0e0;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #1a1a1a 0%, #666 100%);
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }

        .feature-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            border-color: #1a1a1a;
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-icon {
            font-size: 4em;
            color: #1a1a1a;
            margin-bottom: 25px;
            transition: transform 0.4s ease;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.1) rotateY(360deg);
        }

        .feature-card h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
            color: #333;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        .section-title {
            text-align: center;
            font-size: 3em;
            margin-bottom: 20px;
            color: #1a1a1a;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            position: relative;
            padding-bottom: 20px;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #1a1a1a 0%, #666 100%);
        }

        .section-subtitle {
            text-align: center;
            font-size: 1.3em;
            color: #666;
            margin-bottom: 50px;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        /* Room Listings */
        .main-content {
            background: #fff;
            padding: 80px 0;
        }

        .room-listings h2 {
            font-size: 3em;
            color: #1a1a1a;
            text-align: center;
            margin-bottom: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            position: relative;
            padding-bottom: 20px;
        }

        .room-listings h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, #1a1a1a 0%, #666 100%);
        }

        .room-listings > p {
            text-align: center;
            font-size: 1.2em;
            color: #666;
            margin-bottom: 60px;
            font-weight: 300;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 40px;
        }

        .room-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.4s ease;
            border: 1px solid #e0e0e0;
            position: relative;
        }

        .room-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.3) 100%);
            opacity: 0;
            transition: opacity 0.4s ease;
            z-index: 1;
            pointer-events: none;
        }

        .room-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            border-color: #1a1a1a;
        }

        .room-card:hover::before {
            opacity: 1;
        }

        .room-image {
            position: relative;
            height: 280px;
            overflow: hidden;
        }

        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease;
        }

        .room-card:hover .room-image img {
            transform: scale(1.15);
        }

        .room-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.85em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            z-index: 2;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.3);
        }

        .room-details {
            padding: 30px;
        }

        .room-details h3 {
            font-size: 1.8em;
            color: #1a1a1a;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .room-description {
            color: #666;
            margin-bottom: 25px;
            line-height: 1.8;
            font-size: 1em;
        }

        .room-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
        }

        .room-amenities span {
            color: #555;
            font-size: 0.9em;
            display: flex;
            align-items: center;
        }

        .room-amenities i {
            color: #1a1a1a;
            margin-right: 6px;
            font-size: 1.1em;
        }

        .room-price {
            font-size: 2em;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 25px;
            display: flex;
            align-items: baseline;
        }

        .room-price span {
            font-size: 0.5em;
            color: #999;
            font-weight: 400;
            margin-left: 8px;
        }

        .btn-book {
            width: 100%;
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: white;
            padding: 15px 20px;
            border: 2px solid #1a1a1a;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            transition: all 0.4s ease;
        }

        .btn-book:hover {
            background: #fff;
            color: #1a1a1a;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: #fff;
            padding: 60px 0 20px 0;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
        }

        .footer-col h3 {
            font-size: 1.5em;
            margin-bottom: 20px;
            color: #fff;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .footer-col p {
            color: #ccc;
            margin-bottom: 10px;
            line-height: 1.8;
        }

        .footer-col ul li {
            margin-bottom: 10px;
        }

        .footer-col ul li a {
            color: #ccc;
            transition: color 0.3s ease;
        }

        .footer-col ul li a:hover {
            color: #fff;
            padding-left: 5px;
        }

        .footer-col i {
            margin-right: 10px;
            color: #fff;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #404040;
            color: #999;
        }

        /* Scroll animations */
        @keyframes fadeInOnScroll {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-on-scroll {
            animation: fadeInOnScroll 0.8s ease-out;
        }

        /* Search Modal */
        .search-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.85);
            backdrop-filter: blur(10px);
            align-items: center;
            justify-content: center;
            animation: fadeIn 0.3s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .search-modal-content {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            padding: 0;
            border-radius: 20px;
            width: 90%;
            max-width: 700px;
            box-shadow: 0 20px 80px rgba(0, 0, 0, 0.6);
            border: 1px solid #404040;
            animation: slideDown 0.4s ease-out;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .search-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 40px;
            border-bottom: 1px solid #404040;
        }

        .search-modal-header h2 {
            color: #fff;
            font-size: 1.8em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 0;
        }

        .search-modal-header h2 i {
            margin-right: 12px;
            color: #fff;
        }

        .close-modal {
            background: transparent;
            border: 2px solid #fff;
            color: #fff;
            font-size: 2em;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            line-height: 1;
        }

        .close-modal:hover {
            background: #fff;
            color: #1a1a1a;
            transform: rotate(90deg);
        }

        .booking-form-modal {
            padding: 40px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .booking-form-modal .form-group {
            display: flex;
            flex-direction: column;
        }

        .booking-form-modal label {
            color: #fff;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .booking-form-modal input,
        .booking-form-modal select {
            padding: 14px 18px;
            border: 2px solid #404040;
            border-radius: 10px;
            font-size: 1rem;
            color: #fff;
            background-color: rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .booking-form-modal input:focus,
        .booking-form-modal select:focus {
            outline: none;
            border-color: #fff;
            background-color: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
        }

        .btn-modal-search {
            width: 100%;
            background: linear-gradient(135deg, #fff 0%, #f0f0f0 100%);
            color: #1a1a1a;
            padding: 16px 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            transition: all 0.4s ease;
            margin-top: 15px;
        }

        .btn-modal-search:hover {
            background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(255, 255, 255, 0.3);
        }

        .btn-modal-search i {
            margin-right: 10px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .booking-form-container {
                width: 95%;
                padding: 25px 30px;
                gap: 15px;
                flex-wrap: wrap;
            }

            .booking-form .form-group {
                flex: 1 1 calc(50% - 10px);
                min-width: 200px;
            }

            .btn-search {
                flex: 1 1 100%;
            }

            .hero-content h1 {
                font-size: 3em;
            }
        }

        @media (max-width: 768px) {
            .booking-form-container {
                padding: 20px;
                gap: 15px;
                bottom: -100px;
            }

            .booking-form {
                flex-direction: column;
                gap: 15px;
            }

            .booking-form .form-group {
                width: 100%;
            }

            .hero-content h1 {
                font-size: 2.5em;
            }

            .hero-content p {
                font-size: 1.3em;
            }

            .features {
                padding: 60px 0 60px 0;
            }

            .section-title {
                font-size: 2.2em;
            }

            .room-grid {
                grid-template-columns: 1fr;
            }

            /* Modal responsive */
            .search-modal-content {
                width: 95%;
                max-width: 500px;
            }

            .search-modal-header {
                padding: 20px 25px;
            }

            .search-modal-header h2 {
                font-size: 1.3em;
            }

            .booking-form-modal {
                padding: 25px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .close-modal {
                width: 38px;
                height: 38px;
                font-size: 1.5em;
            }
        }

    </style>
</head>
<body>

<%-- Lấy danh sách rooms và roomTypes từ request attributes --%>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
%>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="#">Luxury Hotel</a>
        </div>
        <%
            // Lấy thuộc tính từ request, nếu không có sẽ là null
            Boolean isLogin = (Boolean) request.getAttribute("isLogin");
            Staff loginStaff = (Staff) request.getAttribute("userStaff");
            Guest loginGuest = (Guest) request.getAttribute("userGuest");

            String username = "";
            int guestId = 0;
            boolean isStaff = false;
            boolean isAdmin = false;
            // Kiểm tra isLogin để tránh NullPointerException
            if (isLogin != null && isLogin == true) {
                if (loginStaff != null) {
                    username = loginStaff.getFullName(); // Lấy tên đầy đủ cho thân thiện
                    isStaff = true;
                    // Kiểm tra role của staff
                    if ("admin".equalsIgnoreCase(loginStaff.getRole())) {
                        isAdmin = true;
                    }
                } else if (loginGuest != null) {
                    guestId = loginGuest.getGuestId();
                    username = loginGuest.getFullName();
                }
            }
        %>
        <nav class="main-nav">
            <% if (isLogin != null && isLogin == true) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>

            <%-- ================== NÚT MỚI ĐƯỢC THÊM TẠI ĐÂY ================== --%>
            <form action="<%= IConstant.viewBookingServlet %>" method="post" style="display: inline;">
                <input type="hidden" name="guestId" value="<%= guestId %>">
                <input type="submit" class="btn btn-secondary" name="viewBooking" value="Xem Phòng Đã Đặt">


            </form>
            <%-- ================================================================= --%>

            <form style="display: inline;">
                <button class="btn btn-secondary">
                    <a href="logout" style="color: white; text-decoration: none;">Đăng xuất</a>
                </button>
            </form>

            <% } else { %>
            <form style="display: inline;">
                <button class="btn btn-secondary">
                    <a href="./loginPage.jsp" style="color: white; text-decoration: none;">Đăng nhập</a>
                </button>
            </form>
            <form style="display: inline;">
                <button class="btn btn-primary">
                    <a href=<%=IConstant.registerPage%> style="color: white; text-decoration: none;">Đăng ký</a>
                </button>
            </form>
            <% } %>
            
            <!-- Icon tìm kiếm (luôn hiển thị) -->
            <button class="btn btn-secondary" id="searchIcon" style="margin-left: 10px;">
                <i class="fa-solid fa-magnifying-glass"></i> Tìm phòng
            </button>
        </nav>
    </div>
</header>
<section class="hero">
    <div class="hero-slideshow" style="background-image: url('https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1920');"></div>
    <div class="hero-slideshow" style="background-image: url('https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=1920');"></div>
    <div class="hero-slideshow" style="background-image: url('https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=1920');"></div>
    <div class="hero-slideshow" style="background-image: url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=1920');"></div>
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Chào mừng đến với Luxury Hotel</h1>
        <p>Trải nghiệm đẳng cấp - Dịch vụ hoàn hảo</p>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="container">
        <h2 class="section-title">Tại sao chọn chúng tôi?</h2>
        <p class="section-subtitle">Trải nghiệm dịch vụ 5 sao với đầy đủ tiện nghi hiện đại</p>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-wifi"></i></div>
                <h3>WiFi Tốc Độ Cao</h3>
                <p>Kết nối internet miễn phí với tốc độ cao trong toàn bộ khách sạn</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-utensils"></i></div>
                <h3>Nhà Hàng 5 Sao</h3>
                <p>Thưởng thức ẩm thực đa dạng từ đầu bếp nổi tiếng thế giới</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-spa"></i></div>
                <h3>Spa & Massage</h3>
                <p>Thư giãn với dịch vụ spa cao cấp và massage chuyên nghiệp</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-swimming-pool"></i></div>
                <h3>Bể Bơi Vô Cực</h3>
                <p>Bể bơi rooftop với view toàn cảnh thành phố tuyệt đẹp</p>
            </div>
        </div>
    </div>
</section>

<main class="main-content">
    <div class="container">
        <section class="room-listings">
            <h2>Phòng khách sạn</h2>
            <p>Khám phá các loại phòng đa dạng với kiến trúc hiện đại</p>

            <div class="room-grid">
                <%
                    if (rooms != null && !rooms.isEmpty()) {
                        for (Room room : rooms) {
                            // Tìm RoomType tương ứng với roomTypeId của room này
                                RoomType currentRoomType = null;
                                if (roomTypes != null) {
                                    for (RoomType rt : roomTypes) {
                                        if (rt.getRoomTypeId() == room.getRoomTypeId()) {
                                            currentRoomType = rt;
                                            break; // Tìm thấy rồi thì thoát loop
                                        }
                                    }
                                }

                                // Lấy thông tin từ RoomType hoặc dùng default

                                String typeName = currentRoomType != null ? currentRoomType.getTypeName() : "Standard";
                                String price = currentRoomType != null ? String.format("%,.0f", currentRoomType.getPricePerNight()) : "1,500,000";
                                int capacity = currentRoomType != null ? currentRoomType.getCapacity() : 2;
                %>
                <div class="room-card">
                    <div class="room-image">
                        <img src="image/<%= room.getRoomNumber() %>.jpg" alt="Phòng <%= room.getRoomNumber() %>">
                        <span class="room-badge <%= typeName.toLowerCase() %>"><%= typeName %></span>
                    </div>
                    <div class="room-details">
                        <h3>Phòng <%= room.getRoomNumber() %>
                        </h3>
                        <p class="room-description">
                            <%= room.getDescription() != null ? room.getDescription() : "Phòng thoải mái với đầy đủ tiện nghi hiện đại." %>
                        </p>
                        <div class="room-amenities">
                            <span><i class="fa-solid fa-user-group"></i> Tối đa <%= capacity %> người</span>
                            <span><i class="fa-solid fa-bed"></i> Giường <%= typeName %></span>
                            <%
                                // Thêm tiện ích dựa trên giá phòng
                                if (currentRoomType != null && currentRoomType.getPricePerNight().doubleValue() > 2000000) {
                            %>
                            <span><i class="fa-solid fa-mug-saucer"></i> Breakfast</span>
                            <span><i class="fa-solid fa-car"></i> Parking</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="room-price"><%= price %> VNĐ <span>/đêm</span></div>

                        <%-- Chỉ hiển thị nút "Đặt phòng" nếu người dùng không phải là nhân viên --%>
                        <% if (true) { %>
                        <form action=<%=IConstant.rentalServlet%> method="post">
                            <input type="hidden" value="<%= room.getRoomId() %>" name="roomId">
                            <input type="hidden" value="<%= room.getRoomTypeId()%>" name="roomTypeId">
                            <input type="submit" class="btn btn-book" value="Đặt phòng ngay">
                        </form>
                        <% } %>

                    </div>
                </div>
                <%
                        }
                } else {
                %>
                <p>Hiện không có phòng nào để hiển thị.</p>
                <%
                    }
                %>
            </div>
        </section>
    </div>
</main>

<footer class="footer">
    <div class="container footer-grid">
        <div class="footer-col">
            <h3>Luxury Hotel</h3>
            <p>Chất lượng sang trọng hàng đầu với dịch vụ chất lượng cao và các tiện ích tốt.</p>
        </div>
        <div class="footer-col">
            <h3>Liên hệ</h3>
            <p><i class="fa-solid fa-location-dot"></i> 123 Đường ABC, Quận 1, TP.HCM</p>
            <p><i class="fa-solid fa-phone"></i> (028) 1234-567</p>
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

<!-- Search Modal -->
<div id="searchModal" class="search-modal">
    <div class="search-modal-content">
        <div class="search-modal-header">
            <h2><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm phòng</h2>
            <button class="close-modal" id="closeModal">&times;</button>
        </div>
        <form class="booking-form-modal" action="<%=IConstant.searchController%>">
            <div class="form-row">
                <div class="form-group">
                    <label for="modal-check-in">Ngày nhận phòng</label>
                    <input type="date" id="modal-check-in" name="check-in" required>
                </div>
                <div class="form-group">
                    <label for="modal-check-out">Ngày trả phòng</label>
                    <input type="date" id="modal-check-out" name="check-out" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="modal-guests">Số người</label>
                    <input type="number" id="modal-guests" name="guests" value="2" min="1" max="10">
                </div>
                <div class="form-group">
                    <label for="modal-room-type">Loại phòng</label>
                    <select id="modal-room-type" name="room-type">
                        <option value="">Tất cả loại phòng</option>
                        <%
                            if (roomTypes != null) {
                                for (RoomType rt : roomTypes) {
                        %>
                        <option value="<%= rt.getRoomTypeId() %>"><%= rt.getTypeName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn-modal-search">
                <i class="fa-solid fa-magnifying-glass"></i> TÌM KIẾM PHÒNG
            </button>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const slides = document.querySelectorAll('.hero-slideshow');
        let currentSlide = 0;

        function showSlide(n) {
            // Ẩn tất cả slide
            slides.forEach(slide => slide.style.opacity = '0');
            // Hiện slide hiện tại
            slides[n].style.opacity = '1';
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % slides.length;
            showSlide(currentSlide);
        }

        // Khởi tạo hiển thị slide đầu tiên
        showSlide(currentSlide);

        // Tự động chuyển slide sau mỗi 5 giây (5000ms)
        setInterval(nextSlide, 5000);

        // Modal control
        const modal = document.getElementById('searchModal');
        const searchIcon = document.getElementById('searchIcon');
        const closeModal = document.getElementById('closeModal');

        // Mở modal khi click vào icon search
        searchIcon.addEventListener('click', function() {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Prevent scroll
        });

        // Đóng modal khi click vào nút close
        closeModal.addEventListener('click', function() {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        });

        // Đóng modal khi click bên ngoài
        window.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });

        // Đóng modal khi nhấn ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.style.display === 'flex') {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    });
</script>
</body>
</html>