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
            position: relative; /* Quan trọng cho việc định vị các ảnh nền */
            height: 600px; /* Chiều cao cố định cho hero section */
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            overflow: hidden; /* Đảm bảo ảnh không tràn ra ngoài */
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
            z-index: 2; /* Đảm bảo nội dung nằm trên ảnh nền */
            background: rgba(0, 0, 0, 0.4); /* Nền tối nhẹ để chữ dễ đọc */
            padding: 20px 40px;
            border-radius: 10px;
        }

        .hero-content h1 {
            font-size: 3em;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }

        .hero-content p {
            font-size: 1.5em;
            margin-bottom: 30px;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.7);
        }

        .booking-form-container {
            position: absolute;
            bottom: 50px; /* Đặt form ở dưới hero section */
            left: 50%;
            transform: translateX(-50%);
            z-index: 3; /* Đảm bảo form nằm trên mọi thứ */
            background: rgba(255, 255, 255, 0.9); /* Nền trắng trong suốt */
            padding: 25px 35px;
            border-radius: 8px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
            display: flex; /* Dùng flexbox để căn chỉnh form */
            align-items: center;
            gap: 20px; /* Khoảng cách giữa các form-group */
        }

        .booking-form .form-group {
            margin-bottom: 0; /* Bỏ margin-bottom cũ */
            text-align: left;
        }

        .booking-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: var(--dark-text);
        }

        .booking-form input,
        .booking-form select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            color: var(--dark-text);
            background-color: #f9f9f9;
        }

        .btn-search {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: bold;
            white-space: nowrap; /* Ngăn nút xuống dòng */
        }
        .btn-search:hover {
            background-color: #0056b3;
        }

        /* Đảm bảo hero-content không bị form che mất khi cuộn */
        .hero-content {
            margin-bottom: 200px; /* Khoảng cách đủ để form không chồng lên */
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
        </nav>
    </div>
</header>
<section class="hero">
    <div class="hero-slideshow" style="background-image: url('image/background1.jpg');"></div>
    <div class="hero-slideshow" style="background-image: url('image/background2.jpg');"></div>
    <div class="hero-slideshow" style="background-image: url('image/background3.jpg');"></div>
    <div class="hero-slideshow" style="background-image: url('image/background4.jpg');"></div>
    <div class="hero-content">
        <h1>Chào mừng đến với Luxury Hotel</h1>
        <p>Trải nghiệm đẳng cấp - Dịch vụ hoàn hảo</p>
    </div>
    <div class="booking-form-container" style="color: gray;">
        <form class="booking-form" action=<%=IConstant.searchController%>>
            <div class="form-group">
                <label for="check-in">Ngày nhận phòng</label>
                <input type="date" id="check-in" name="check-in">
            </div>
            <div class="form-group">
                <label for="check-out">Ngày trả phòng</label>
                <input type="date" id="check-out" name="check-out">
            </div>
            <div class="form-group">
                <label for="guests">Số người</label>
                <input type="number" id="guests" name="guests" value="2" min="1">
            </div>
            <div class="form-group">
                <label for="room-type">Loại phòng</label>
                <select id="room-type" name="room-type">
                    <option value="">Chọn loại phòng</option>
                    <%
                        if (roomTypes != null) {
                            for (RoomType rt : roomTypes) {
                    %>
                    <option value="<%= rt.getRoomTypeId() %>"><%= rt.getTypeName() %>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-search">Tìm kiếm phòng</button>
        </form>
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
                            if (room.getStatus().equalsIgnoreCase("available")) {

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
    });
</script>
</body>
</html>