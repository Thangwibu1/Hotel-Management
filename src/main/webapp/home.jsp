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
    <title>Luxury Hotel - Trang Chủ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">

    <style>
        /* (Toàn bộ CSS của bạn được giữ nguyên, không thay đổi) */
        :root { --font-heading: 'Playfair Display', serif; --font-body: 'Lato', sans-serif; --color-gold: #c9ab81; --color-charcoal: #1a1a1a; --color-offwhite: #f8f7f5; --color-grey: #666; --primary-color: #007bff; --secondary-color: #6c757d; --info-color: #17a2b8; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html { scroll-behavior: smooth; }
        body { font-family: var(--font-body); line-height: 1.8; color: var(--dark-text); background-color: #fff; }
        .container { max-width: 1200px; margin: auto; padding: 0 20px; }
        a { text-decoration: none; color: inherit; }
        .section { padding: 100px 0; }
        .section-title { font-family: var(--font-heading); font-size: 3em; color: var(--color-charcoal); text-align: center; margin-bottom: 20px; }
        .section-subtitle { text-align: center; font-size: 1.2em; color: var(--color-grey); margin-bottom: 60px; max-width: 600px; margin-left: auto; margin-right: auto; }
        .header { background-color: rgba(26, 26, 26, 0.85); backdrop-filter: blur(10px); color: #fff; padding: 1rem 0; position: fixed; width: 100%; top: 0; z-index: 1000; }
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo a { font-family: var(--font-heading); font-size: 1.5em; letter-spacing: 1px; }
        .main-nav { display: flex; align-items: center; gap: 10px; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: 5px; border: 1px solid transparent; cursor: pointer; font-size: 0.9rem; text-align: center; font-weight: 700; transition: all 0.3s ease; }
        .btn-primary { background-color: var(--color-gold); color: #fff; border-color: var(--color-gold); }
        .btn-primary:hover { background-color: transparent; color: var(--color-gold); }
        .btn-secondary { background-color: var(--secondary-color); color: white; border-color: var(--secondary-color);}
        .btn-info { background-color: transparent; border-color: var(--color-gold); color: var(--color-gold); }
        .btn-info:hover { background-color: var(--color-gold); color: #fff; }
        #headerSearchIcon { background: transparent; border: 1px solid #fff; padding: 8px 15px; }
        #headerSearchIcon:hover { background: var(--color-gold); border-color: var(--color-gold); }
        .hero { position: relative; height: 100vh; display: flex; align-items: center; justify-content: center; text-align: center; color: #fff; overflow: hidden; }
        .hero-slide { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-size: cover; background-position: center; opacity: 0; transition: opacity 1.5s ease-in-out, transform 10s linear; transform: scale(1.15); z-index: 1; }
        .hero-slide.active { opacity: 1; transform: scale(1); }
        .hero-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6); z-index: 2; }
        .hero-content { position: relative; z-index: 3; }
        .hero-content h1 { font-family: var(--font-heading); font-size: 5em; margin-bottom: 20px; text-shadow: 2px 2px 10px rgba(0,0,0,0.5); }
        .hero-content p { font-size: 1.5em; font-weight: 300; margin-bottom: 40px; }
        .btn-hero { padding: 15px 40px; font-size: 1.1em; font-weight: 700; background-color: var(--color-gold); color: #fff; border-radius: 30px; border: none; cursor: pointer; }
        .slide-nav { position: absolute; top: 50%; transform: translateY(-50%); z-index: 4; background: rgba(0,0,0,0.3); color: white; border: 1px solid rgba(255,255,255,0.5); border-radius: 50%; width: 50px; height: 50px; cursor: pointer; font-size: 1.5rem; transition: all 0.3s ease; }
        .slide-nav:hover { background: rgba(0,0,0,0.6); }
        .prev-slide { left: 30px; }
        .next-slide { right: 30px; }
        .slide-dots { position: absolute; bottom: 30px; left: 50%; transform: translateX(-50%); z-index: 4; display: flex; gap: 15px; }
        .dot { width: 12px; height: 12px; background: rgba(255,255,255,0.5); border-radius: 50%; cursor: pointer; transition: all 0.3s ease; }
        .dot.active { background: white; transform: scale(1.3); }
        .about-section, .amenities-section { background: var(--color-offwhite); }
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center; }
        .about-image img { width: 100%; height: 100%; object-fit: cover; border-radius: 10px; box-shadow: 0 15px 40px rgba(0,0,0,0.15); }
        .about-content h2 { font-family: var(--font-heading); font-size: 2.5em; margin-bottom: 20px; text-align: left;}
        .featured-room { display: grid; grid-template-columns: 1fr 1fr; gap: 50px; align-items: center; margin-bottom: 80px; }
        .featured-room:nth-child(even) .room-image { grid-column: 2; }
        .featured-room:nth-child(even) .room-info { grid-column: 1; grid-row: 1; text-align: right; }
        .room-image { overflow: hidden; border-radius: 10px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .room-image img { width: 100%; transition: transform 0.6s ease; }
        .room-image:hover img { transform: scale(1.1); }
        .room-info .room-type { color: var(--color-grey); text-transform: uppercase; letter-spacing: 2px; font-weight: 700; margin-bottom: 10px; }
        .room-info h3 { font-family: var(--font-heading); font-size: 2.8em; margin-bottom: 20px; }
        .amenities-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 40px; }
        .amenity-card { text-align: center; }
        .amenity-icon { font-size: 3em; color: var(--color-gold); margin-bottom: 15px; }
        .cta-section { padding: 120px 0; background-image: url('https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=1920'); background-attachment: fixed; text-align: center; position: relative; color: #fff; }
        .cta-section::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); }
        .cta-content { position: relative; }
        .cta-content h2 { font-family: var(--font-heading); font-size: 3.5em; margin-bottom: 30px; }
        .search-modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.85); backdrop-filter: blur(10px); align-items: center; justify-content: center; }
        .search-modal-content { background: #1a1a1a; padding: 30px 40px; border-radius: 15px; width: 90%; max-width: 800px; box-shadow: 0 10px 40px rgba(0,0,0,0.5); position: relative; color: white; }
        .close-modal { position: absolute; top: 15px; right: 20px; font-size: 2.5rem; font-weight: bold; cursor: pointer; color: #fff; }
        .close-modal:hover { color: #ccc; }
        .booking-form-modal h2 { text-align: center; font-family: var(--font-heading); margin-bottom: 30px; }
        .booking-form-modal .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .booking-form-modal .form-group label { display: block; margin-bottom: 8px; text-transform: uppercase; font-size: 0.9em; letter-spacing: 1px; }
        .booking-form-modal input, .booking-form-modal select { width: 100%; padding: 12px; border: 1px solid #555; border-radius: 5px; background: #333; color: white; }
        .reveal { opacity: 0; transform: translateY(50px); transition: opacity 0.8s ease-out, transform 0.8s ease-out; }
        .reveal.active { opacity: 1; transform: translateY(0); }
        /* --- ROOM FEATURE (ZIGZAG) --- */
        .room-feature {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            margin-bottom: 100px;
            overflow: hidden; /* To contain animations */
        }

        .room-feature-image, .room-feature-content {
            opacity: 0;
            transform: translateY(50px);
            transition: opacity 1s ease-out, transform 1s ease-out;
        }

        .room-feature.active .room-feature-image,
        .room-feature.active .room-feature-content {
            opacity: 1;
            transform: translateY(0);
        }

        /* Stagger the animation */
        .room-feature.active .room-feature-content {
            transition-delay: 0.2s;
        }


        .room-feature-image img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }

        /* Zigzag layout */
        .room-feature:nth-child(even) .room-feature-image {
            grid-column: 2;
        }
        .room-feature:nth-child(even) .room-feature-content {
            grid-column: 1;
            grid-row: 1;
            text-align: right;
        }

        .room-feature-content h3 {
            font-family: var(--font-heading);
            font-size: 2.8em;
            margin-bottom: 20px;
            color: var(--color-charcoal);
        }

        .room-feature-content .room-type-subtitle {
            color: var(--color-grey);
            text-transform: uppercase;
            letter-spacing: 2px;
            font-weight: 700;
            margin-bottom: 15px;
            display: block;
        }

        .room-feature-content p {
            margin-bottom: 30px;
            font-size: 1.1em;
            line-height: 1.7;
        }

        .btn-feature {
            padding: 12px 35px;
            font-size: 1rem;
            font-weight: 700;
            background-color: var(--color-gold);
            color: #fff;
            border-radius: 5px;
            border: 1px solid var(--color-gold);
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .btn-feature:hover {
            background-color: transparent;
            color: var(--color-gold);
        }
        /* --- FOOTER --- */
        .footer {
            background: var(--color-charcoal);
            color: #ccc;
            padding: 80px 0 0;
        }
        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            padding-bottom: 40px;
        }
        .footer-col h3 {
            font-family: var(--font-heading);
            font-size: 1.4em;
            color: #fff;
            margin-bottom: 20px;
            letter-spacing: 1px;
        }
        .footer-col p,
        .footer-col li {
            margin-bottom: 10px;
        }
        .footer-col ul {
            list-style: none;
        }
        .footer-col a {
            transition: all 0.3s ease;
        }
        .footer-col a:hover {
            color: var(--color-gold);
            padding-left: 5px;
        }
        .footer-col i {
            margin-right: 10px;
            color: var(--color-gold);
        }
        .footer-bottom {
            text-align: center;
            padding: 30px 0;
            margin-top: 40px;
            border-top: 1px solid #444;
            color: var(--color-grey);
            font-size: 0.9em;
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
        }
        
        .error-popup-close:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(201, 171, 129, 0.4);
        }
    </style>
</head>
<body>

<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    Guest guest = (Guest) session.getAttribute("userGuest");
    String username = "";
    int guestId = 0;
    boolean isLogin = (session.getAttribute("isLogin") != null && (Boolean)session.getAttribute("isLogin"));

    if(isLogin) {
        if(guest != null) {
            username = guest.getFullName();
            guestId = guest.getGuestId();
        } else if (session.getAttribute("userStaff") != null) {
            username = ((Staff)session.getAttribute("userStaff")).getFullName();
        }
    }
%>

<header class="header">
    <div class="container">
        <div class="logo"><a href="#">LUXURY HOTEL</a></div>
        <nav class="main-nav">
            <% if (isLogin) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>
            <% if (guestId > 0) { %>
            <form action="<%= IConstant.viewBookingServlet %>" method="post" style="display: inline;">
                <input type="hidden" name="guestId" value="<%= guestId %>">
                <button type="submit" class="btn btn-info">Phòng đã đặt</button>
            </form>
            <% } %>
            <form action="logout" method="get" style="display: inline;">
                <button type="submit" class="btn btn-secondary">Đăng xuất</button>
            </form>
            <% } else { %>
            <a href="loginPage.jsp" class="btn btn-secondary">Đăng nhập</a>
            <a href="registerPage.jsp" class="btn btn-primary">Đăng ký</a>
            <% } %>
            <button class="btn" id="headerSearchIcon" title="Tìm kiếm phòng"><i class="fa-solid fa-magnifying-glass"></i></button>
        </nav>
    </div>
</header>

<section class="hero">
    <div class="hero-overlay"></div>
    <%
        if (rooms != null && !rooms.isEmpty()) {
            int slideCount = Math.min(5, rooms.size());
            for (int i = 0; i < slideCount; i++) {
                Room room = rooms.get(i);
                RoomType rt = null;
                // === THÊM KIỂM TRA NULL TẠI ĐÂY ===
                if (roomTypes != null) {
                    for(RoomType tempRt : roomTypes) {
                        if(tempRt.getRoomTypeId() == room.getRoomTypeId()) {
                            rt = tempRt;
                            break;
                        }
                    }
                }
                String roomTypeName = (rt != null) ? rt.getTypeName() : "Phòng nghỉ dưỡng";
    %>
    <div class="hero-slide <%= (i == 0) ? "active" : "" %>"
         style="background-image: url('image/<%= room.getRoomNumber() %>.jpg');"
         data-title="<%= roomTypeName %>"
         data-subtitle="Phòng <%= room.getRoomNumber() %>">
    </div>
    <%
            }
        }
    %>
    <div class="hero-content">
        <h1 id="hero-title">Chốn Dừng Chân Của Sự Tinh Tế</h1>
        <p id="hero-subtitle">Nơi mỗi khoảnh khắc đều là một trải nghiệm thượng lưu</p>
        <button id="openSearchModalBtn" class="btn btn-hero">Tìm Phòng Ngay</button>
    </div>
    <button class="slide-nav prev-slide" id="prevSlide">&#10094;</button>
    <button class="slide-nav next-slide" id="nextSlide">&#10095;</button>
    <div class="slide-dots" id="slideDots"></div>
</section>

<section class="section about-section reveal">
    <div class="container">
        <div class="about-grid">
            <div class="about-content">
                <h2 class="section-title" style="text-align: left;">Khám Phá Luxury Hotel</h2>
                <p>Tọa lạc tại trái tim của thành phố, Luxury Hotel không chỉ là một nơi để nghỉ ngơi, mà là một điểm đến của những trải nghiệm đẳng cấp. Chúng tôi tự hào mang đến sự kết hợp hoàn hảo giữa kiến trúc tân cổ điển sang trọng và dịch vụ cá nhân hóa tận tâm, kiến tạo nên một không gian nghỉ dưỡng lý tưởng.</p>
            </div>
            <div class="about-image">
                <img src="https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=1200" alt="Sảnh khách sạn">
            </div>
        </div>
    </div>
</section>

<section class="section" id="room-types-section">
    <div class="container">
        <h2 class="section-title">Không Gian Nghỉ Dưỡng Đa Dạng</h2>
        <p class="section-subtitle">Từ những căn phòng ấm cúng đến các suite tổng thống sang trọng, mỗi không gian đều là một tuyên ngôn về sự tinh tế.</p>
        
        <% 
            if (roomTypes != null) {
                String[] images = {
                    "image/background1.jpg",
                    "image/background2.jpg",
                    "image/background3.jpg",
                    "image/background4.jpg",
                    "image/background1.jpg"
                };
                String[] descriptions = {
                    "Lý tưởng cho du khách một mình hoặc các cặp đôi, phòng Standard mang đến một không gian nghỉ ngơi ấm cúng và đầy đủ tiện nghi, đảm bảo một kỳ nghỉ thoải mái và thư giãn.",
                    "Với không gian rộng rãi hơn và tầm nhìn hướng thành phố, phòng Deluxe là sự lựa chọn hoàn hảo để bạn tận hưởng sự sang trọng và tiện nghi đẳng cấp.",
                    "Được thiết kế cho các gia đình, Family Suite có nhiều không gian sinh hoạt chung và các phòng ngủ riêng biệt, mang lại sự thoải mái và kết nối cho mọi thành viên.",
                    "Trải nghiệm đỉnh cao của sự xa hoa với phòng Presidential Suite. Không gian sống tráng lệ, phòng ngủ master sang trọng và dịch vụ quản gia riêng biệt sẽ định nghĩa lại kỳ nghỉ của bạn.",
                    "Một không gian sang trọng với các tiện nghi được lựa chọn cẩn thận, mang đến cho bạn một nơi ẩn náu yên tĩnh và thư thái sau một ngày dài khám phá."
                };
                int itemIndex = 0;
                for (RoomType rt : roomTypes) {
                    String imageUrl = (itemIndex < images.length) ? images[itemIndex] : images[0];
                    String description = (itemIndex < descriptions.length) ? descriptions[itemIndex] : "Tận hưởng không gian nghỉ dưỡng sang trọng và tiện nghi với thiết kế tinh tế và dịch vụ chuyên nghiệp.";
        %>
        <div class="room-feature reveal">
            <div class="room-feature-image">
                <img src="<%= imageUrl %>" alt="<%= rt.getTypeName() %>">
            </div>
            <div class="room-feature-content">
                <span class="room-type-subtitle"><%= String.format("%,.0f", rt.getPricePerNight()) %> VNĐ / đêm</span>
                <h3><%= rt.getTypeName() %></h3>
                <p><%= description %></p>
                <div class="room-feature-details" style="margin-bottom: 30px; text-align: inherit; font-size: 1.1em; color: var(--color-grey);">
                    <span><i class="fa-solid fa-user-group" style="color: var(--color-gold);"></i> Sức chứa: <%= rt.getCapacity() %> người</span>
                </div>
                <a href="#" onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;" class="btn btn-feature">Tìm hiểu thêm</a>
            </div>
        </div>
        <% 
                    itemIndex++;
                }
            }
        %> 
    </div>
</section>

<section class="section amenities-section reveal">
    <div class="container">
        <h2 class="section-title">Dịch Vụ & Tiện Ích</h2>
        <div class="amenities-grid">
            <div class="amenity-card"><div class="amenity-icon"><i class="fa-solid fa-utensils"></i></div><h4>Ẩm thực Tinh hoa</h4></div>
            <div class="amenity-card"><div class="amenity-icon"><i class="fa-solid fa-spa"></i></div><h4>Spa & Trị liệu</h4></div>
            <div class="amenity-card"><div class="amenity-icon"><i class="fa-solid fa-person-swimming"></i></div><h4>Hồ bơi Vô cực</h4></div>
            <div class="amenity-card"><div class="amenity-icon"><i class="fa-solid fa-dumbbell"></i></div><h4>Trung tâm Thể hình</h4></div>
        </div>
    </div>
</section>

<section class="section cta-section">
    <div class="cta-content reveal">
        <h2>Kỳ nghỉ trong mơ của bạn đang chờ đợi.</h2>
        <button id="openSearchModalBtnBottom" class="btn btn-hero">Bắt đầu tìm kiếm</button>
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
        <p>&copy; 2025 Luxury Hotel. Bảo lưu mọi quyền.</p>
    </div>
</footer>

<div id="searchModal" class="search-modal">
    <div class="search-modal-content">
        <span class="close-modal" id="closeModal">&times;</span>
        <form class="booking-form-modal" action="<%=IConstant.searchController%>" method="get">
            <h2><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm phòng</h2>
            <div class="form-row">
                <div class="form-group"><label for="modal-check-in">Ngày nhận phòng</label><input type="date" id="modal-check-in" name="check-in" required></div>
                <div class="form-group"><label for="modal-check-out">Ngày trả phòng</label><input type="date" id="modal-check-out" name="check-out" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label for="modal-guests">Số người</label><input type="number" id="modal-guests" name="guests" value="2" min="1"></div>
                <div class="form-group"><label for="modal-room-type">Loại phòng</label>
                    <select id="modal-room-type" name="room-type">
                        <option value="">Tất cả loại phòng</option>
                        <% if (roomTypes != null) { for (RoomType rt : roomTypes) { %><option value="<%= rt.getRoomTypeId() %>"><%= rt.getTypeName() %></option><% } } %>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 15px; margin-top: 10px;">Tìm phòng</button>
        </form>
    </div>
</div>

<!-- ERROR POPUP -->
<div id="errorPopupOverlay" class="error-popup-overlay">
    <div class="error-popup">
        <div class="error-popup-icon">
            <i class="fa-solid fa-exclamation-triangle"></i>
        </div>
        <h2>Đặt Phòng Thất Bại!</h2>
        <p id="errorMessage">Đã có lỗi xảy ra trong quá trình đặt phòng. Vui lòng thử lại sau hoặc liên hệ với chúng tôi để được hỗ trợ.</p>
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
        if (errorParam === 'booking_failed') {
            errorMessage.textContent = 'Giao dịch đặt phòng không thành công. Hệ thống đã hoàn tác tất cả thay đổi. Vui lòng thử lại sau.';
        } else {
            errorMessage.textContent = 'Đã có lỗi xảy ra. Vui lòng thử lại sau hoặc liên hệ với chúng tôi để được hỗ trợ.';
        }
        
        // Hiển thị popup
        overlay.classList.add('show');
    }
    
    // === EXISTING SCRIPTS ===
    document.addEventListener("DOMContentLoaded", function() {
        // --- LOGIC CHO HERO SLIDESHOW ---
        const slides = document.querySelectorAll('.hero-slide');
        if (slides.length > 0) {
            const heroTitle = document.getElementById('hero-title');
            const heroSubtitle = document.getElementById('hero-subtitle');
            const prevBtn = document.getElementById('prevSlide');
            const nextBtn = document.getElementById('nextSlide');
            const dotsContainer = document.getElementById('slideDots');
            let currentSlide = 0;
            let slideInterval;

            slides.forEach((_, index) => {
                const dot = document.createElement('div');
                dot.classList.add('dot');
                dot.addEventListener('click', () => { showSlide(index); resetInterval(); });
                dotsContainer.appendChild(dot);
            });
            const dots = dotsContainer.querySelectorAll('.dot');

            function updateContent(n) {
                const activeSlide = slides[n];
                heroTitle.textContent = activeSlide.dataset.title;
                heroSubtitle.textContent = activeSlide.dataset.subtitle;
                dots.forEach(dot => dot.classList.remove('active'));
                dots[n].classList.add('active');
            }
            function showSlide(n) {
                slides.forEach(slide => slide.classList.remove('active'));
                slides[n].classList.add('active');
                updateContent(n);
                currentSlide = n;
            }
            function nextSlide() { showSlide((currentSlide + 1) % slides.length); }
            function prevSlide() { showSlide((currentSlide - 1 + slides.length) % slides.length); }
            function startInterval() { slideInterval = setInterval(nextSlide, 7000); }
            function resetInterval() { clearInterval(slideInterval); startInterval(); }

            showSlide(0); startInterval();
            nextBtn.addEventListener('click', () => { nextSlide(); resetInterval(); });
            prevBtn.addEventListener('click', () => { prevSlide(); resetInterval(); });
        }

        // --- LOGIC CHO SEARCH MODAL ---
        const modal = document.getElementById('searchModal');
        const openModalButtons = document.querySelectorAll('#openSearchModalBtn, #headerSearchIcon, #openSearchModalBtnBottom');
        const closeModal = document.getElementById('closeModal');

        if (modal) {
            openModalButtons.forEach(btn => {
                btn.addEventListener('click', () => { modal.style.display = 'flex'; });
            });
            if (closeModal) closeModal.addEventListener('click', () => { modal.style.display = 'none'; });
            window.addEventListener('click', (e) => { if (e.target === modal) { modal.style.display = 'none'; } });
            document.addEventListener('keydown', (e) => { if (e.key === "Escape") { modal.style.display = 'none'; } });
        }

        // --- LOGIC CHO HIỆU ỨNG KHI CUỘN TRANG ---
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) { entry.target.classList.add('active'); }
            });
        }, { threshold: 0.15 });

        document.querySelectorAll('.reveal').forEach(el => { observer.observe(el); });

        // --- LOGIC CHO VALIDATE NGÀY TRONG MODAL TÌM KIẾM ---
        const checkInInput = document.getElementById('modal-check-in');
        const checkOutInput = document.getElementById('modal-check-out');

        if (checkInInput && checkOutInput) {
            // 1. Set ngày nhận phòng tối thiểu là ngày mai
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            const tomorrowString = tomorrow.toISOString().split('T')[0];
            checkInInput.min = tomorrowString;

            // 2. Khi ngày nhận phòng thay đổi, cập nhật ngày trả phòng
            checkInInput.addEventListener('change', function() {
                // Ngày trả phòng không được nhỏ hơn ngày nhận phòng
                checkOutInput.min = this.value;
                // Nếu ngày trả phòng hiện tại nhỏ hơn ngày nhận phòng mới, hãy đặt lại nó
                if (checkOutInput.value < this.value) {
                    checkOutInput.value = this.value;
                }
            });
        }
    });
</script>

</body>
</html>