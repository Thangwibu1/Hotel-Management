<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="utils.IConstant" %>

<%
    // (Phần logic Java của bạn ở đây được giữ nguyên)
    Boolean isLoginSession = (Boolean) session.getAttribute("isLogin");
    if (isLoginSession == null || !isLoginSession) {
        String returnUrl = "rentalRoom?roomId=" + request.getParameter("roomId") + "&roomTypeId=" + request.getParameter("roomTypeId");
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
        return;
    }
    if (session.getAttribute("userStaff") != null) {
        response.sendRedirect("home");
        return;
    }
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    Guest guest = (Guest) session.getAttribute("userGuest");
    List<Service> services = (List<Service>) request.getAttribute("services");
    if (room == null || roomType == null || guest == null) {
        response.sendRedirect("home");
        return;
    }
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - <%= roomType.getTypeName() %> - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <%-- ================= TOÀN BỘ CSS ĐƯỢC ĐẶT TẠI ĐÂY ================= --%>
    <style>
        /* --- 1. General Styles (Dựa trên home.jsp) --- */
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --dark-bg: #222;
            --light-text: #fff;
            --dark-text: #333;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: var(--dark-text);
            background-color: #f4f4f4;
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

        /* --- 2. Header (Dựa trên home.jsp) --- */
        .header {
            background-color: var(--dark-bg);
            color: var(--light-text);
            padding: 1rem 0;
        }

        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo a {
            font-size: 1.5em;
            font-weight: bold;
        }

        .main-nav {
            display: flex;
            align-items: center;
        }

        .main-nav form {
            margin-left: 10px;
        }

        /* --- 3. Buttons (Dựa trên home.jsp) --- */
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            text-align: center;
        }
        .btn-secondary { background-color: var(--secondary-color); color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-info { background-color: #17a2b8; color: black; }
        .btn-book {
            background-color: var(--primary-color);
            color: var(--light-text);
        }

        /* --- 4. Main Content for Rental Page --- */
        .main-content {
            padding: 2rem 0;
        }

        .rental-page-container {
            display: flex;
            gap: 30px;
            margin-top: 40px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }

        .room-info-details, .booking-form-section {
            flex: 1;
            min-width: 320px;
            background: #fff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .room-info-details img {
            width: 100%;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .booking-form-section {
            padding: 30px;
            background-color: #f9f9f9;
        }

        .booking-form-section h2 {
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
        }

        .room-amenities {
            border-bottom: 1px solid #eee;
            padding-bottom: 1rem;
            margin-bottom: 1rem;
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .room-amenities span {
            display: flex;
            align-items: center;
        }
        .room-amenities .fa-solid {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }

        .form-group-rental {
            margin-bottom: 20px;
        }

        .form-group-rental label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-group-rental input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .form-group-rental input:read-only {
            background-color: #e9ecef;
            cursor: not-allowed;
        }

        .total-price {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #eee;
            font-size: 1.5em;
            font-weight: bold;
            text-align: right;
        }

        .service-options {
            margin-top: 15px;
            padding: 15px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .service-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .service-item label {
            margin-left: 10px;
            font-weight: normal;
            color: #333;
        }

        .service-item input[type="checkbox"] {
            width: auto;
        }

        /* --- 5. Footer (Dựa trên home.jsp) --- */
        .footer {
            background: #333;
            color: #fff;
            padding: 2rem 0 0;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            padding-bottom: 2rem;
        }

        .footer-col h3 {
            margin-bottom: 1rem;
        }

        .footer-col p, .footer-col li {
            margin-bottom: 0.5rem;
            color: #ccc;
        }

        .footer-col ul {
            list-style-type: none;
        }

        .footer-col a:hover {
            color: var(--primary-color);
        }

        .footer-bottom {
            text-align: center;
            padding: 1rem 0;
            border-top: 1px solid #444;
        }
    </style>
</head>
<body>

<%-- Phần thân trang JSP giữ nguyên, không thay đổi --%>
<header class="header">
    <div class="container">
        <div class="logo">
            <a href=<%= IConstant.homeServlet %>>Luxury Hotel</a>
        </div>
        <%
            String username = "";
            boolean isStaff = false;
            boolean isAdmin = false;

            if (session.getAttribute("userStaff") != null) {
                Staff loginStaff = (Staff) session.getAttribute("userStaff");
                username = loginStaff.getFullName();
                isStaff = true;
                if ("admin".equalsIgnoreCase(loginStaff.getRole())) {
                    isAdmin = true;
                }
            } else if (session.getAttribute("userGuest") != null) {
                Guest loginGuest = (Guest) session.getAttribute("userGuest");
                username = loginGuest.getFullName();
            }
        %>
        <nav class="main-nav">
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>

            <% if (isStaff) { %>
            <% if (isAdmin) { %>
            <form style="display: inline;"><button class="btn btn-danger"><a href="adminPage.jsp">Go to Admin Page</a></button></form>
            <% } else { %>
            <form style="display: inline;"><button class="btn btn-info"><a href="staffPage.jsp">Go to staff page</a></button></form>
            <% } %>
            <% } %>
            <form style="display: inline;"><button class="btn btn-secondary"><a href="logout">Đăng xuất</a></button></form>
        </nav>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="rental-page-container">
            <div class="room-info-details">
                <img src="${pageContext.request.contextPath}/images/room-<%= room.getRoomId() %>.jpg" alt="Phòng <%= room.getRoomNumber() %>">
                <h2><%= roomType.getTypeName() %> - Phòng <%= room.getRoomNumber() %></h2>
                <p><%= room.getDescription() %></p>
                <div class="room-amenities">
                    <span><i class="fa-solid fa-user-group"></i> Tối đa <%= roomType.getCapacity() %> người</span>
                    <span><i class="fa-solid fa-bed"></i> Giường <%= roomType.getTypeName() %></span>
                    <% if (roomType.getPricePerNight().doubleValue() > 2000000) { %>
                    <span><i class="fa-solid fa-mug-saucer"></i> Breakfast</span>
                    <span><i class="fa-solid fa-car"></i> Parking</span>
                    <% } %>
                </div>
                <div class="room-price" style="margin-top: 20px; font-size: 1.8em;">
                    <%= currencyFormatter.format(roomType.getPricePerNight()) %> <span>/đêm</span>
                </div>
            </div>

            <div class="booking-form-section">
                <h2>Thông tin đặt phòng</h2>
                <form action="createBooking" method="post">
                    <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                    <input type="hidden" id="price-per-night" value="<%= roomType.getPricePerNight() %>">
                    <div class="form-group-rental">
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" value="<%= guest.getFullName() %>" readonly>
                    </div>
                    <div class="form-group-rental">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<%= guest.getEmail() %>" readonly>
                    </div>
                    <div class="form-group-rental">
                        <label for="check-in">Ngày nhận phòng</label>
                        <input type="date" id="check-in" name="checkInDate" required>
                    </div>
                    <div class="form-group-rental">
                        <label for="check-out">Ngày trả phòng</label>
                        <input type="date" id="check-out" name="checkOutDate" required>
                    </div>
                    <div class="form-group-rental">
                        <label>Dịch vụ đi kèm (tùy chọn)</label>
                        <div class="service-options">
                            <% if (services != null && !services.isEmpty()) {
                                for (Service service : services) {
                            %>
                            <div class="service-item">
                                <input type="checkbox"
                                       name="selectedServices"
                                       id="service-<%= service.getServiceId() %>"
                                       value="<%= service.getServiceId() %>"
                                       data-price="<%= service.getPrice() %>">
                                <label for="service-<%= service.getServiceId() %>">
                                    <%= service.getServiceName() %> (+<%= currencyFormatter.format(service.getPrice()) %>)
                                </label>
                            </div>
                            <%
                                }
                            } else { %>
                            <p>Không có dịch vụ nào để hiển thị.</p>
                            <% } %>
                        </div>
                    </div>
                    <div class="total-price">
                        Tổng cộng: <span id="total-price-value">0 VNĐ</span>
                    </div>
                    <button type="submit" class="btn btn-book" style="width: 100%; margin-top: 20px;">Xác nhận đặt phòng</button>
                </form>
            </div>
        </div>
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
    // (Phần Javascript giữ nguyên, không thay đổi)
    const checkInInput = document.getElementById('check-in');
    const checkOutInput = document.getElementById('check-out');
    const totalPriceElement = document.getElementById('total-price-value');
    const pricePerNight = parseFloat(document.getElementById('price-per-night').value);
    const today = new Date().toISOString().split('T')[0];
    const serviceCheckboxes = document.querySelectorAll('input[name="selectedServices"]');
    checkInInput.setAttribute('min', today);
    function calculateTotal() {
        let roomTotal = 0;
        const checkInDate = new Date(checkInInput.value);
        const checkOutDate = new Date(checkOutInput.value);
        if (checkInInput.value && checkOutInput.value && checkOutDate > checkInDate) {
            const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
            const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
            if (nights > 0) {
                roomTotal = nights * pricePerNight;
            }
        }
        let servicesTotal = 0;
        serviceCheckboxes.forEach(checkbox => {
            if (checkbox.checked) {
                servicesTotal += parseFloat(checkbox.dataset.price);
            }
        });
        const finalTotal = roomTotal + servicesTotal;
        totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(finalTotal);
    }
    checkInInput.addEventListener('change', () => {
        if (checkInInput.value) {
            let nextDay = new Date(checkInInput.value);
            nextDay.setDate(nextDay.getDate() + 1);
            const nextDayString = nextDay.toISOString().split('T')[0];
            checkOutInput.setAttribute('min', nextDayString);
            if (checkOutInput.value < checkInInput.value) {
                checkOutInput.value = nextDayString;
            }
        }
        calculateTotal();
    });
    checkOutInput.addEventListener('change', calculateTotal);
    serviceCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', calculateTotal);
    });
    calculateTotal();
</script>
</body>
</html>