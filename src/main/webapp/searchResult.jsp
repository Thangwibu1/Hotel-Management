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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lato:wght@300;400;700&display=swap"
          rel="stylesheet">
    <style>
        /* (Toàn bộ CSS được giữ nguyên như bạn đã cung cấp) */
        :root {
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Lato', sans-serif;
            --color-gold: #c9ab81;
            --color-charcoal: #1a1a1a;
            --color-offwhite: #f8f7f5;
            --color-grey: #666;
            --primary-color: #007bff;
            --secondary-color: #6c757d;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-body);
            line-height: 1.8;
            color: var(--color-charcoal);
            background-color: var(--color-offwhite);
        }

        .container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: var(--color-gold);
            color: #fff;
            border-color: var(--color-gold);
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

        .btn-info {
            background-color: transparent;
            border-color: var(--color-gold);
            color: var(--color-gold);
        }

        .btn-info:hover {
            background-color: var(--color-gold);
            color: #fff;
        }

        .header {
            background-color: var(--color-charcoal);
            color: #fff;
            padding: 1rem 0;
        }

        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo a {
            font-family: var(--font-heading);
            font-size: 1.5em;
            letter-spacing: 1px;
        }

        .main-nav {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-criteria {
            background-color: #fff;
            padding: 30px 0;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }

        .search-criteria h1 {
            font-family: var(--font-heading);
            font-size: 2.5em;
            margin: 0 0 25px 0;
        }

        .search-info {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }

        .search-info-item {
            font-size: 1.1em;
            color: var(--color-grey);
        }

        .search-info-item i {
            margin-right: 8px;
            color: var(--color-gold);
        }

        .results-container {
            padding: 60px 20px;
        }

        .filter-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .results-count {
            font-size: 1.2em;
            font-weight: 700;
        }

        .back-button {
            background-color: var(--color-charcoal);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 40px;
        }

        .room-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.4s ease;
            border: 1px solid #e0e0e0;
        }

        .room-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
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
            transform: scale(1.1);
        }

        .room-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: var(--color-charcoal);
            color: white;
            padding: 8px 18px;
            border-radius: 25px;
            font-size: 0.85em;
            font-weight: 700;
        }

        .room-details {
            padding: 30px;
        }

        .room-details h3 {
            font-family: var(--font-heading);
            font-size: 1.8em;
            margin-bottom: 15px;
        }

        .room-description {
            color: var(--color-grey);
            margin-bottom: 25px;
            line-height: 1.8;
        }

        .room-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 1px solid #f0f0f0;
        }

        .room-amenities span {
            color: #555;
            font-size: 0.9em;
        }

        .room-amenities i {
            color: var(--color-gold);
            margin-right: 6px;
        }

        .room-price {
            font-family: var(--font-heading);
            font-size: 2em;
            color: var(--color-charcoal);
            margin-bottom: 25px;
        }

        .room-price span {
            font-size: 0.5em;
            color: #999;
            font-weight: 400;
            margin-left: 8px;
        }

        .btn-book {
            width: 100%;
            background: var(--color-charcoal);
            color: white;
            padding: 15px;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 700;
        }

        .btn-book:hover {
            background-color: var(--color-gold);
            border-color: var(--color-gold);
        }

        .no-results {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border-radius: 10px;
            margin: 40px 0;
        }

        .no-results i {
            font-size: 5em;
            color: #e0e0e0;
            margin-bottom: 30px;
        }

        .no-results h2 {
            font-family: var(--font-heading);
            font-size: 2.5em;
            color: #555;
            margin-bottom: 15px;
        }

        .no-results p {
            color: var(--color-grey);
            font-size: 1.1em;
        }
    </style>
</head>
<body>

<%
    Guest loginGuest = (Guest) session.getAttribute("userGuest");
    Staff loginStaff = (Staff) session.getAttribute("userStaff");
    boolean isLogin = (session.getAttribute("isLogin") != null && (boolean) session.getAttribute("isLogin"));
    String username = "";
    int guestId = 0;
    boolean isStaff = false;
    if (isLogin) {
        if (loginGuest != null) {
            username = loginGuest.getFullName();
            guestId = loginGuest.getGuestId();
        } else if (loginStaff != null) {
            username = loginStaff.getFullName();
            isStaff = true;
        }
    }

    List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");
    Object guestsObj = request.getAttribute("guests");
    String guestsStr = (guestsObj != null) ? String.valueOf(guestsObj) : "0";
    String roomTypeIdStr = (String) request.getAttribute("roomTypeId");
    String selectedRoomTypeName = "Tất cả";
    if (roomTypeIdStr != null && !roomTypeIdStr.isEmpty() && !roomTypeIdStr.equals("null") && roomTypes != null) {
        for (RoomType rt : roomTypes) {
            if (String.valueOf(rt.getRoomTypeId()).equals(roomTypeIdStr)) {
                selectedRoomTypeName = rt.getTypeName();
                break;
            }
        }
    }
%>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="home">LUXURY HOTEL</a>
        </div>
        <nav class="main-nav">
            <% if (isLogin) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>
            <% if (!isStaff) { %>
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
        </nav>
    </div>
</header>

<section class="search-criteria">
    <div class="container">
        <h1>Kết Quả Tìm Kiếm</h1>
        <div class="search-info">
            <span class="search-info-item"><i class="fa-solid fa-calendar-check"></i> <strong>Từ:</strong> <%= checkIn %></span>
            <span class="search-info-item"><i class="fa-solid fa-calendar-xmark"></i> <strong>Đến:</strong> <%= checkOut %></span>
            <span class="search-info-item"><i class="fa-solid fa-user-group"></i> <strong>Số người:</strong> <%= guestsStr %></span>
            <span class="search-info-item"><i class="fa-solid fa-bed"></i> <strong>Loại phòng:</strong> <%= selectedRoomTypeName %></span>
        </div>
    </div>
</section>

<div class="container results-container">
    <div class="filter-bar">
        <%-- (Filter bar giữ nguyên) --%>
    </div>

    <% if (availableRooms != null && !availableRooms.isEmpty()) { %>
    <div class="room-grid">
        <%
            for (Room room : availableRooms) {
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
                String price = currentRoomType != null ? String.format("%,.0f", currentRoomType.getPricePerNight()) : "N/A";
                int capacity = currentRoomType != null ? currentRoomType.getCapacity() : 2;
        %>
        <div class="room-card">
            <div class="room-image">
                <img src="image/<%= room.getRoomNumber() %>.jpg" alt="Phòng <%= room.getRoomNumber() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1590490359854-dfba59392828?w=800'">
                <div class="room-badge"><%= typeName %>
                </div>
            </div>
            <div class="room-details">
                <h3>Phòng <%= room.getRoomNumber() %>
                </h3>
                <p class="room-description"><%= room.getDescription() %>
                </p>
                <div class="room-amenities">
                    <span><i class="fa-solid fa-user-group"></i> Tối đa <%= capacity %> người</span>
                    <span><i class="fa-solid fa-bed"></i> Giường <%= typeName %></span>
                </div>
                <div class="room-price"><%= price %> VNĐ <span>/ đêm</span></div>

                <% if (isLogin && !isStaff) { %>

                <%-- ================== THAY ĐỔI LOGIC TẠI ĐÂY ================== --%>
                <form action="<%=IConstant.rentalServlet%>" method="post">
                    <input type="hidden" value="<%= room.getRoomId() %>" name="roomId">
                    <input type="hidden" value="<%= room.getRoomTypeId()%>" name="roomTypeId">

                    <%-- Thêm 2 input ẩn để gửi kèm ngày đã tìm kiếm --%>
                    <input type="hidden" value="<%= checkIn %>" name="checkInDate">
                    <input type="hidden" value="<%= checkOut %>" name="checkOutDate">

                    <button type="submit" class="btn-book">Chọn phòng</button>
                </form>
                <%-- ========================================================== --%>

                <% } else if (!isLogin) { %>
                <a href="loginPage.jsp" class="btn-book" style="text-align: center; display: block;">Đăng nhập để đặt
                    phòng</a>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="no-results">
        <i class="fa-solid fa-magnifying-glass"></i>
        <h2>Không tìm thấy phòng trống</h2>
        <p>Rất tiếc, không có phòng nào phù hợp với lựa chọn của bạn. Vui lòng thử lại.</p>
    </div>
    <% } %>
</div>

<%-- (Footer giữ nguyên) --%>

</body>
</html>