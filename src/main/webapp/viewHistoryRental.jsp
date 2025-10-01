<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Import đầy đủ các lớp cần thiết --%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Guest" %>
<%@ page import="model.Staff" %>
<%@ page import="utils.IConstant" %>

<%-- ================== THÊM MỚI: KIỂM TRA ĐĂNG NHẬP ================== --%>
<%
    Boolean isLogin = (Boolean) session.getAttribute("isLogin");
    // Nếu chưa đăng nhập (isLogin là null hoặc false)
    if (isLogin == null || !isLogin) {
        // Chuyển hướng về trang đăng nhập.
        // Thêm returnUrl để sau khi đăng nhập thành công có thể quay lại trang này.
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp?returnUrl=viewbooking");
        return; // Rất quan trọng: Dừng việc render phần còn lại của trang.
    }
%>
<%-- ==================================================================== --%>


<%!
    // Helper function: Tạo một hàm nhỏ để tìm tên loại phòng từ ID.
    public String getRoomTypeNameById(int roomTypeId, List<RoomType> roomTypes) {
        if (roomTypes == null) {
            return "N/A";
        }
        for (RoomType rt : roomTypes) {
            if (rt.getRoomTypeId() == roomTypeId) {
                return rt.getTypeName();
            }
        }
        return "Unknown";
    }
%>

<%
    // Lấy tất cả các attributes từ request và ép kiểu
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
    Guest guest = (Guest) session.getAttribute("userGuest");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đặt Phòng - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* (CSS giữ nguyên như phiên bản trước) */
        :root { --primary-color: #007bff; --secondary-color: #6c757d; --dark-bg: #222; --light-text: #fff; --dark-text: #333; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; line-height: 1.6; color: var(--dark-text); background-color: #f4f4f4; }
        .container { max-width: 1200px; margin: auto; padding: 0 20px; }
        a { text-decoration: none; color: inherit; }
        .header { background-color: var(--dark-bg); color: var(--light-text); padding: 1rem 0; }
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo a { font-size: 1.5em; font-weight: bold; }
        .main-nav { display: flex; align-items: center; }
        .main-nav form { margin-left: 10px; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-size: 1rem; text-align: center; }
        .btn-secondary { background-color: var(--secondary-color); color: white; }
        .footer { background: #333; color: #fff; padding: 2rem 0 0; }
        .footer-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; padding-bottom: 2rem; }
        .footer-col h3 { margin-bottom: 1rem; }
        .footer-col p, .footer-col li { margin-bottom: 0.5rem; color: #ccc; }
        .footer-col ul { list-style-type: none; }
        .footer-col a:hover { color: var(--primary-color); }
        .footer-bottom { text-align: center; padding: 1rem 0; border-top: 1px solid #444; }
        .main-content { padding: 2rem 0; }
        .history-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
        .page-title { font-size: 2.5rem; color: var(--dark-text); margin-bottom: 1rem; border-bottom: 2px solid var(--primary-color); padding-bottom: 0.5rem; display: inline-block; }
        .history-table { width: 100%; border-collapse: collapse; margin-top: 2rem; font-size: 0.95rem; }
        .history-table th, .history-table td { padding: 12px 10px; border: 1px solid #ddd; text-align: left; vertical-align: middle; }
        .history-table th { background-color: #f2f2f2; font-weight: bold; }
        .history-table tr:nth-child(even) { background-color: #f9f9f9; }
        .history-table tr:hover { background-color: #f1f1f1; }
        .no-booking { text-align: center; padding: 40px; font-size: 1.2em; color: #777; }
        .status { padding: 5px 10px; border-radius: 15px; color: white; font-size: 0.8em; font-weight: bold; text-align: center; display: inline-block; min-width: 90px; }
        .status.reserved { background-color: #007bff; }
        .status.checked-in { background-color: #28a745; }
        .status.checked-out { background-color: #6c757d; }
        .status.canceled { background-color: #dc3545; }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="<%= IConstant.homeServlet %>">Luxury Hotel</a>
        </div>
        <nav class="main-nav">
            <% if (guest != null) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= guest.getFullName() %>!</span>
            <% } %>
            <form style="display: inline;"><button class="btn btn-secondary"><a href="logout">Đăng xuất</a></button></form>
        </nav>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="history-container">
            <h1 class="page-title">Lịch Sử Đặt Phòng Của Bạn</h1>

            <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="history-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Số Phòng</th>
                    <th>Loại Phòng</th>
                    <th>Ngày Nhận Phòng</th>
                    <th>Ngày Trả Phòng</th>
                    <th>Ngày Đặt</th>
                    <th>Trạng Thái</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < bookings.size(); i++) {
                    Booking booking = bookings.get(i);
                    Room room = rooms.get(i);
                    String roomTypeName = getRoomTypeNameById(room.getRoomTypeId(), roomTypes);
                %>
                <tr>
                    <td><%= i + 1 %></td>
                    <td><%= room.getRoomNumber() %></td>
                    <td><%= roomTypeName %></td>
                    <td><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></td>
                    <td><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></td>
                    <td><%= IConstant.dateFormat.format(booking.getBookingDate()) %></td>
                    <td>
                        <span class="status <%= booking.getStatus().toLowerCase().replace("-", "") %>">
                            <%= booking.getStatus() %>
                        </span>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="no-booking">
                <p>Bạn chưa có lịch sử đặt phòng nào.</p>
            </div>
            <% } %>
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

</body>
</html>