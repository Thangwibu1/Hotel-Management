<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // 1. KIỂM TRA ĐĂNG NHẬP
    // Lấy trạng thái đăng nhập từ session.
    Boolean isLoginSession = (Boolean) session.getAttribute("isLogin");

    // Nếu chưa đăng nhập (isLogin là null hoặc false), chuyển hướng đến trang đăng nhập
    if (isLoginSession == null || !isLoginSession) {
        // Lưu lại URL hiện tại để sau khi đăng nhập thành công có thể quay lại đúng trang này
        String returnUrl = "rentalRoom?roomId=" + request.getParameter("roomId") + "&roomTypeId=" + request.getParameter("roomTypeId");
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
        return; // Dừng việc xử lý trang JSP này lại
    }

    // Nếu đã đăng nhập, lấy thông tin phòng và người dùng
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    Guest guest = (Guest) session.getAttribute("userGuest"); // Thông tin guest được lưu trong session

    // Xử lý trường hợp không tìm thấy phòng
    if (room == null || roomType == null) {
        response.sendRedirect("home"); // Chuyển về trang chủ nếu không có dữ liệu phòng
        return;
    }

    // Định dạng số tiền tệ
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - <%= roomType.getTypeName() %> - Luxury Hotel</title>
    <%-- Đường dẫn tới CSS cần đi ra 1 cấp vì file này nằm trong thư mục /views/ --%>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* Thêm một chút CSS cho trang đặt phòng */
        .rental-page-container {
            display: flex;
            gap: 30px;
            margin-top: 40px;
            margin-bottom: 40px;
            flex-wrap: wrap; /* Cho phép xuống dòng trên màn hình nhỏ */
        }

        .room-info-details, .booking-form-section {
            flex: 1;
            min-width: 320px; /* Đảm bảo có chiều rộng tối thiểu */
        }

        .room-info-details img {
            width: 100%;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .booking-form-section {
            padding: 30px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .booking-form-section h2 {
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
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
    </style>
</head>
<body>

<%-- ================= HEADER SAO CHÉP TỪ HOME.JSP ================= --%>
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
                    username = loginGuest.getFullName();
                }
            }
        %>
        <nav class="main-nav">
            <% if (isLogin != null && isLogin == true) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>

            <% if (isStaff) { %>
            <%-- Kiểm tra xem staff có phải là admin không --%>
            <% if (isAdmin) { %>
            <%-- Nếu là admin, hiển thị nút Go to Admin Page --%>
            <form style="display: inline;">
                <button class="btn btn-danger"> <%-- Dùng màu khác để phân biệt --%>
                    <%-- Thay "adminPage.jsp" bằng URL trang admin của bạn --%>
                    <a href="adminPage.jsp" style="color: black; text-decoration: none;">Go to Admin Page</a>
                </button>
            </form>
            <% } else { %>
            <%-- Nếu là staff thường, hiển thị nút Go to staff page --%>
            <form style="display: inline;">
                <button class="btn btn-info">
                    <%-- Thay "staffPage.jsp" bằng URL trang staff của bạn --%>
                    <a href="staffPage.jsp" style="color: black; text-decoration: none;">Go to staff page</a>
                </button>
            </form>
            <% } %>
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
                    <a href="./registerPage.jsp" style="color: white; text-decoration: none;">Đăng ký</a>
                </button>
            </form>
            <% } %>
        </nav>
    </div>
</header>
<%-- ================= KẾT THÚC HEADER ================= --%>


<main class="main-content">
    <div class="container">
        <div class="rental-page-container">
            <%-- CỘT BÊN TRÁI: THÔNG TIN PHÒNG --%>
            <div class="room-info-details">
                <img src="../images/room-<%= room.getRoomId() %>.jpg" alt="Phòng <%= room.getRoomNumber() %>">
                <h2><%= roomType.getTypeName() %> - Phòng <%= room.getRoomNumber() %></h2>
                <p><%= room.getDescription() %></p>
                <div class="room-amenities" style="margin-top: 20px; font-size: 1.1em;">
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

            <%-- CỘT BÊN PHẢI: FORM ĐẶT PHÒNG --%>
            <div class="booking-form-section">
                <h2>Thông tin đặt phòng</h2>
                <form action="createBooking" method="post">
                    <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                    <input type="hidden" id="price-per-night" value="<%= roomType.getPricePerNight() %>">

                    <div class="form-group-rental">
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" value="<%= guest != null ? guest.getFullName() : "" %>" readonly>
                    </div>

                    <div class="form-group-rental">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" value="<%= guest != null ? guest.getEmail() : "" %>" readonly>
                    </div>

                    <div class="form-group-rental">
                        <label for="check-in">Ngày nhận phòng</label>
                        <input type="date" id="check-in" name="checkInDate" required>
                    </div>
                    <div class="form-group-rental">
                        <label for="check-out">Ngày trả phòng</label>
                        <input type="date" id="check-out" name="checkOutDate" required>
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


<%-- ================= FOOTER SAO CHÉP TỪ HOME.JSP ================= --%>
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
<%-- ================= KẾT THÚC FOOTER ================= --%>


<script>
    const checkInInput = document.getElementById('check-in');
    const checkOutInput = document.getElementById('check-out');
    const totalPriceElement = document.getElementById('total-price-value');
    const pricePerNight = parseFloat(document.getElementById('price-per-night').value);

    const today = new Date().toISOString().split('T')[0];
    checkInInput.setAttribute('min', today);

    function calculateTotal() {
        const checkInDate = new Date(checkInInput.value);
        const checkOutDate = new Date(checkOutInput.value);

        if (checkInInput.value && checkOutInput.value && checkOutDate > checkInDate) {
            const timeDiff = checkOutDate.getTime() - checkInDate.getTime();
            const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));

            if (nights > 0) {
                const total = nights * pricePerNight;
                totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(total);
            } else {
                totalPriceElement.textContent = '0 VNĐ';
            }
        } else {
            totalPriceElement.textContent = '0 VNĐ';
        }
    }

    checkInInput.addEventListener('change', () => {
        if (checkInInput.value) {
            let nextDay = new Date(checkInInput.value);
            nextDay.setDate(nextDay.getDate() + 1);
            const nextDayString = nextDay.toISOString().split('T')[0];
            checkOutInput.setAttribute('min', nextDayString);

            // Nếu ngày trả phòng cũ nhỏ hơn ngày nhận phòng mới, reset nó
            if(checkOutInput.value < checkInInput.value){
                checkOutInput.value = nextDayString;
            }
        }
        calculateTotal();
    });

    checkOutInput.addEventListener('change', calculateTotal);

</script>
</body>
</html>