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
    <title>Kết quả tìm kiếm - Luxury Hotel</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        .search-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            text-align: center;
        }

        .search-header h1 {
            margin: 0 0 20px 0;
            font-size: 2.5em;
        }

        .search-info {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            display: inline-block;
            margin-top: 20px;
        }

        .search-info-item {
            display: inline-block;
            margin: 0 20px;
            font-size: 1.1em;
        }

        .search-info-item i {
            margin-right: 8px;
        }

        .results-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .results-summary {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .results-count {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
        }

        .back-button {
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #5a6268;
        }

        .no-results {
            text-align: center;
            padding: 60px 20px;
            background: #f8f9fa;
            border-radius: 10px;
            margin: 40px 0;
        }

        .no-results i {
            font-size: 4em;
            color: #ccc;
            margin-bottom: 20px;
        }

        .no-results h2 {
            color: #666;
            margin-bottom: 10px;
        }

        .no-results p {
            color: #999;
            font-size: 1.1em;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .room-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .room-image {
            position: relative;
            height: 250px;
            overflow: hidden;
        }

        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .room-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }

        .room-details {
            padding: 25px;
        }

        .room-details h3 {
            margin: 0 0 15px 0;
            color: #333;
            font-size: 1.5em;
        }

        .room-description {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .room-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .room-amenities span {
            color: #555;
            font-size: 0.9em;
        }

        .room-amenities i {
            color: #667eea;
            margin-right: 5px;
        }

        .room-price {
            font-size: 1.8em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 20px;
        }

        .room-price span {
            font-size: 0.5em;
            color: #999;
            font-weight: normal;
        }

        .btn-book {
            width: 100%;
            background-color: #667eea;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn-book:hover {
            background-color: #5568d3;
        }

        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .filter-section h3 {
            margin: 0 0 15px 0;
            color: #333;
        }
    </style>
</head>
<body>

<%-- Lấy thông tin từ request attributes --%>
<%
    List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    Integer guests = (Integer) request.getAttribute("guests");
    String roomType = (String) request.getAttribute("roomType");
    
    // Lấy thông tin user
    Boolean isLogin = (Boolean) request.getAttribute("isLogin");
    Staff loginStaff = (Staff) request.getAttribute("userStaff");
    Guest loginGuest = (Guest) request.getAttribute("userGuest");

    String username = "";
    int guestId = 0;
    boolean isStaff = false;
    boolean isAdmin = false;
    
    if (isLogin != null && isLogin == true) {
        if (loginStaff != null) {
            username = loginStaff.getFullName();
            isStaff = true;
            if ("admin".equalsIgnoreCase(loginStaff.getRole())) {
                isAdmin = true;
            }
        } else if (loginGuest != null) {
            guestId = loginGuest.getGuestId();
            username = loginGuest.getFullName();
        }
    }
    
    // Tìm tên loại phòng được chọn
    String selectedRoomTypeName = "Tất cả";
    if (roomType != null && !roomType.isEmpty() && roomTypes != null) {
        for (RoomType rt : roomTypes) {
            if (String.valueOf(rt.getRoomTypeId()).equals(roomType)) {
                selectedRoomTypeName = rt.getTypeName();
                break;
            }
        }
    }
%>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="home">Luxury Hotel</a>
        </div>
        <nav class="main-nav">
            <% if (isLogin != null && isLogin == true) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>
            
            <% if (!isStaff) { %>
            <form action="<%= IConstant.viewBookingServlet %>" method="post" style="display: inline;">
                <input type="hidden" name="guestId" value="<%= guestId %>">
                <input type="submit" class="btn btn-secondary" name="viewBooking" value="Xem Phòng Đã Đặt">
            </form>
            <% } %>
            
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
                    <a href="<%=IConstant.registerPage%>" style="color: white; text-decoration: none;">Đăng ký</a>
                </button>
            </form>
            <% } %>
        </nav>
    </div>
</header>

<section class="search-header">
    <div class="container">
        <h1><i class="fa-solid fa-magnifying-glass"></i> Kết quả tìm kiếm phòng</h1>
        <div class="search-info">
            <div class="search-info-item">
                <i class="fa-solid fa-calendar-check"></i>
                <strong>Nhận phòng:</strong> <%= checkIn %>
            </div>
            <div class="search-info-item">
                <i class="fa-solid fa-calendar-xmark"></i>
                <strong>Trả phòng:</strong> <%= checkOut %>
            </div>
            <div class="search-info-item">
                <i class="fa-solid fa-user-group"></i>
                <strong>Số người:</strong> <%= guests %>
            </div>
            <div class="search-info-item">
                <i class="fa-solid fa-bed"></i>
                <strong>Loại phòng:</strong> <%= selectedRoomTypeName %>
            </div>
        </div>
    </div>
</section>

<main class="results-container">
    <div class="results-summary">
        <div class="results-count">
            <i class="fa-solid fa-door-open"></i>
            Tìm thấy <%= availableRooms != null ? availableRooms.size() : 0 %> phòng trống
        </div>
        <a href="home" class="back-button">
            <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
        </a>
    </div>

    <%
        if (availableRooms != null && !availableRooms.isEmpty()) {
    %>
    <div class="room-grid">
        <%
            for (Room room : availableRooms) {
                // Tìm RoomType tương ứng
                RoomType currentRoomType = null;
                if (roomTypes != null) {
                    for (RoomType rt : roomTypes) {
                        if (rt.getRoomTypeId() == room.getRoomTypeId()) {
                            currentRoomType = rt;
                            break;
                        }
                    }
                }

                String typeName = currentRoomType != null ? currentRoomType.getTypeName() : "Standard";
                String price = currentRoomType != null ? String.format("%,.0f", currentRoomType.getPricePerNight()) : "1,500,000";
                int capacity = currentRoomType != null ? currentRoomType.getCapacity() : 2;
        %>
        <div class="room-card">
            <div class="room-image">
                <img src="image/<%= room.getRoomNumber() %>.jpg" 
                     alt="Phòng <%= room.getRoomNumber() %>"
                     onerror="this.src='image/default-room.jpg'">
                <span class="room-badge"><%= typeName %></span>
            </div>
            <div class="room-details">
                <h3>Phòng <%= room.getRoomNumber() %></h3>
                <p class="room-description">
                    <%= room.getDescription() != null ? room.getDescription() : "Phòng thoải mái với đầy đủ tiện nghi hiện đại, phù hợp cho kỳ nghỉ của bạn." %>
                </p>
                <div class="room-amenities">
                    <span><i class="fa-solid fa-user-group"></i> Tối đa <%= capacity %> người</span>
                    <span><i class="fa-solid fa-bed"></i> Giường <%= typeName %></span>
                    <span><i class="fa-solid fa-wifi"></i> WiFi miễn phí</span>
                    <span><i class="fa-solid fa-tv"></i> TV màn hình phẳng</span>
                    <%
                        if (currentRoomType != null && currentRoomType.getPricePerNight().doubleValue() > 2000000) {
                    %>
                    <span><i class="fa-solid fa-mug-saucer"></i> Bữa sáng</span>
                    <span><i class="fa-solid fa-car"></i> Đỗ xe miễn phí</span>
                    <%
                        }
                    %>
                </div>
                <div class="room-price"><%= price %> VNĐ <span>/đêm</span></div>
                
                <% if (!isStaff) { %>
                <form action="<%=IConstant.rentalServlet%>" method="post">
                    <input type="hidden" value="<%= room.getRoomId() %>" name="roomId">
                    <input type="hidden" value="<%= room.getRoomTypeId()%>" name="roomTypeId">
                    <input type="hidden" value="<%= checkIn %>" name="checkIn">
                    <input type="hidden" value="<%= checkOut %>" name="checkOut">
                    <input type="hidden" value="<%= guests %>" name="guests">
                    <input type="submit" class="btn btn-book" value="Đặt phòng ngay">
                </form>
                <% } else { %>
                <button class="btn btn-book" disabled style="background-color: #ccc; cursor: not-allowed;">
                    Nhân viên không thể đặt phòng
                </button>
                <% } %>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
        } else {
    %>
    <div class="no-results">
        <i class="fa-solid fa-bed-empty"></i>
        <h2>Không tìm thấy phòng trống</h2>
        <p>Rất tiếc, không có phòng nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
        <p>Vui lòng thử lại với ngày khác hoặc loại phòng khác.</p>
        <br>
        <a href="home" class="back-button" style="font-size: 1.1em; padding: 12px 30px;">
            <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
        </a>
    </div>
    <%
        }
    %>
</main>

<footer class="footer">
    <div class="container footer-grid">
        <div class="footer-col">
            <h3>Luxury Hotel</h3>
            <p>Chất lượng sang trọng hàng đầu với dịch vụ chất lượng cao và các tiện nghi tốt.</p>
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

</body>
</html>
