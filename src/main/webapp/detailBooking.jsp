<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.*" %>
<%@ page import="utils.IConstant" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>

<%!
    // Helper function để tìm tên loại phòng từ ID
    public String getRoomTypeNameById(int roomTypeId, List<RoomType> allRoomTypes) {
        if (allRoomTypes == null) return "N/A";
        for (RoomType rt : allRoomTypes) {
            if (rt.getRoomTypeId() == roomTypeId) {
                return rt.getTypeName();
            }
        }
        return "Unknown";
    }
%>

<%
    // --- Lấy tất cả attributes từ controller với tên chính xác ---
    Booking booking = (Booking) request.getAttribute("booking");
    Guest guest = (Guest) request.getAttribute("guest");
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");

    // Dữ liệu cho phần dịch vụ của booking hiện tại
    List<BookingService> bookingServices = (List<BookingService>) request.getAttribute("bookingServices");
    List<Service> serviceDetails = (List<Service>) request.getAttribute("services"); // Đổi tên để tránh trùng lặp

    // Dữ liệu cho phần lịch sử các booking khác
    List<Booking> otherBookings = (List<Booking>) request.getAttribute("bookings");
    List<Room> otherRooms = (List<Room>) request.getAttribute("rooms");
    List<RoomType> allRoomTypes = (List<RoomType>) request.getAttribute("roomTypes");

    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Đặt Phòng - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        :root { --primary-color: #007bff; --secondary-color: #6c757d; --dark-text: #333; --light-gray: #f8f9fa; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: var(--light-gray); color: var(--dark-text); margin: 0; padding: 40px 20px; }
        .container { max-width: 900px; margin: auto; }
        a { text-decoration: none; color: inherit; }
        .btn { display: inline-block; padding: 8px 15px; border-radius: 5px; border: none; cursor: pointer; font-size: 0.9rem; text-align: center; color: white; }
        .btn-primary { background-color: var(--primary-color); }
        .btn-secondary { background-color: var(--secondary-color); }
        .card { background: #fff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 30px; }
        .card-header { background: var(--primary-color); color: white; padding: 25px; text-align: center; border-radius: 8px 8px 0 0; }
        .card-header h1 { margin: 0; }
        .card-body { padding: 30px; }
        .detail-section { margin-bottom: 30px; }
        .detail-section h2 { font-size: 1.3em; color: var(--primary-color); border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        .detail-item { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f0f0f0; }
        .detail-item strong { color: #555; }
        .services-table, .history-table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 0.95rem;}
        .services-table th, .services-table td, .history-table th, .history-table td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; vertical-align: middle; }
        .services-table th, .history-table th { background-color: var(--light-gray); font-weight: bold; }
        .text-right { text-align: right !important; }
        .status { padding: 5px 10px; border-radius: 15px; color: white; font-size: 0.8em; font-weight: bold; text-align: center; display: inline-block; min-width: 90px; }
        .status.reserved { background-color: #007bff; }
        .status.checked-in { background-color: #28a745; }
        .status.checked-out { background-color: #6c757d; }
        .status.canceled { background-color: #dc3545; }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <% if (booking != null) { %>
        <div class="card-header">
            <h1>Chi Tiết Đặt Phòng #<%= booking.getBookingId() %></h1>
        </div>
        <div class="card-body">
            <div class="detail-section">
                <h2><i class="fa-solid fa-user"></i> Thông tin khách hàng</h2>
                <div class="detail-item"><strong>Họ và tên:</strong> <span><%= guest.getFullName() %></span></div>
                <div class="detail-item"><strong>Email:</strong> <span><%= guest.getEmail() %></span></div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-suitcase-rolling"></i> Chi tiết lưu trú</h2>
                <div class="detail-item"><strong>Phòng:</strong> <span><%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</span></div>
                <div class="detail-item"><strong>Ngày nhận phòng:</strong> <span><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></span></div>
                <div class="detail-item"><strong>Ngày trả phòng:</strong> <span><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></span></div>
                <div class="detail-item"><strong>Ngày đặt:</strong> <span><%= IConstant.dateFormat.format(booking.getBookingDate()) %></span></div>
                <div class="detail-item"><strong>Trạng thái:</strong> <span class="status <%= booking.getStatus().toLowerCase().replace("-", "") %>"><%= booking.getStatus() %></span></div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-concierge-bell"></i> Dịch vụ đã sử dụng</h2>
                <% if (bookingServices != null && !bookingServices.isEmpty()) { %>
                <table class="services-table">
                    <thead><tr><th>Tên dịch vụ</th><th class="text-right">Số lượng</th><th>Ngày sử dụng</th><th class="text-right">Thành tiền</th></tr></thead>
                    <tbody>
                    <%-- Dùng vòng lặp có chỉ số để truy cập 2 list song song --%>
                    <% for (int i = 0; i < bookingServices.size(); i++) {
                        BookingService bs = bookingServices.get(i);
                        Service service = serviceDetails.get(i); // Lấy service tương ứng
                        BigDecimal subTotal = service.getPrice().multiply(new BigDecimal(bs.getQuantity()));
                    %>
                    <tr>
                        <td><%= service.getServiceName() %></td>
                        <td class="text-right"><%= bs.getQuantity() %></td>
                        <td><%= IConstant.dateFormat.format(bs.getServiceDate()) %></td>
                        <td class="text-right"><%= currencyFormatter.format(subTotal) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>Không có dịch vụ nào được sử dụng cho lần đặt phòng này.</p>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="card-header" style="background-color: #dc3545;"><h1>Không tìm thấy thông tin</h1></div>
        <div class="card-body"><p>Mã đặt phòng không hợp lệ hoặc đã có lỗi xảy ra.</p></div>
        <% } %>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="detail-section">
                <h2><i class="fa-solid fa-history"></i> Các Lần Đặt Phòng Khác</h2>
                <% if (otherBookings != null && otherBookings.size() > 1) { %>
                <table class="history-table">
                    <thead>
                    <tr><th>STT</th><th>Số Phòng</th><th>Loại Phòng</th><th>Ngày Nhận Phòng</th><th>Trạng Thái</th><th>Hành động</th></tr>
                    </thead>
                    <tbody>
                    <% int stt = 0;
                        for (int i = 0; i < otherBookings.size(); i++) {
                            Booking otherBooking = otherBookings.get(i);
                            // Bỏ qua booking hiện tại đang xem chi tiết
                            if (otherBooking.getBookingId() == booking.getBookingId()) {
                                continue;
                            }
                            stt++;
                            Room otherRoom = otherRooms.get(i);
                            String otherRoomTypeName = getRoomTypeNameById(otherRoom.getRoomTypeId(), allRoomTypes); // Dùng allRoomTypes để tra cứu
                    %>
                    <tr>
                        <td><%= stt %></td>
                        <td><%= otherRoom.getRoomNumber() %></td>
                        <td><%= otherRoomTypeName %></td>
                        <td><%= IConstant.localDateFormat.format(otherBooking.getCheckInDate()) %></td>
                        <td><span class="status <%= otherBooking.getStatus().toLowerCase().replace("-", "") %>"><%= otherBooking.getStatus() %></span></td>
                        <td>
                            <form action="detailBooking" method="post" style="display: inline;">
                                <input type="hidden" name="bookingId" value="<%= otherBooking.getBookingId() %>">
                                <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                                <button type="submit" class="btn btn-secondary">Xem</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>Không có lịch sử đặt phòng nào khác.</p>
                <% } %>
            </div>
            <div style="text-align: center; margin-top: 20px;">
                <a href=<%=IConstant.homeServlet%> class="btn btn-primary">Về trang chủ dùm tui cái</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>