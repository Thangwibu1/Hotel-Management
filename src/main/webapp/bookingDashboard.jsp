<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Import đầy đủ các lớp cần thiết --%>
<%@ page import="utils.IConstant" %>
<%@ page import="java.util.List" %>
<%@ page import="model.*" %>

<%
    // Lấy tất cả các attributes từ request và ép kiểu
    Booking booking = (Booking) request.getAttribute("booking");
    Guest guest = (Guest) request.getAttribute("guest");
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<ChoosenService> chosenServices = (List<ChoosenService>) request.getAttribute("chosenServices");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Nhận Đặt Phòng - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* (CSS giữ nguyên như phiên bản trước) */
        :root { --primary-color: #007bff; --success-color: #28a745; --dark-text: #333; --light-gray: #f8f9fa; }
        body { font-family: Arial, sans-serif; background-color: var(--light-gray); color: var(--dark-text); line-height: 1.6; margin: 0; padding: 40px 20px; }
        .container { max-width: 800px; margin: auto; }
        .booking-summary-card { background: #fff; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden; }
        .card-header { background: var(--success-color); color: white; padding: 25px; text-align: center; }
        .card-header .icon { font-size: 3em; margin-bottom: 10px; }
        .card-header h1 { margin: 0; font-size: 1.8em; }
        .card-body { padding: 30px; }
        .detail-section { margin-bottom: 30px; }
        .detail-section h2 { font-size: 1.3em; color: var(--primary-color); border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        .detail-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #f0f0f0; }
        .detail-item:last-child { border-bottom: none; }
        .detail-item strong { color: #555; }
        .services-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .services-table th, .services-table td { text-align: left; padding: 12px; border-bottom: 1px solid #ddd; }
        .services-table th { background-color: var(--light-gray); }
        .card-footer { background: var(--light-gray); padding: 20px; text-align: center; }
        .btn { display: inline-block; padding: 12px 25px; border-radius: 5px; border: none; cursor: pointer; font-size: 1rem; text-decoration: none; transition: background-color 0.3s; }
        .btn-primary { background-color: var(--primary-color); color: white; }
        .btn-primary:hover { background-color: #0056b3; }
    </style>
</head>
<body>

<div class="container">
    <div class="booking-summary-card">
        <div class="card-header">
            <div class="icon"><i class="fa-solid fa-check-circle"></i></div>
            <h1>Đặt Phòng Thành Công!</h1>
            <p>Cảm ơn bạn đã lựa chọn Luxury Hotel. Dưới đây là thông tin chi tiết về đặt phòng của bạn.</p>
        </div>

        <%-- Kiểm tra xem booking có tồn tại không --%>
        <% if (booking != null && guest != null && room != null && roomType != null) { %>
        <div class="card-body">
            <div class="detail-section">
                <h2><i class="fa-solid fa-user"></i> Thông tin khách hàng</h2>
                <div class="detail-item">
                    <strong>Họ và tên:</strong>
                    <span><%= guest.getFullName() %></span>
                </div>
                <div class="detail-item">
                    <strong>Email:</strong>
                    <span><%= guest.getEmail() %></span>
                </div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-suitcase-rolling"></i> Chi tiết đặt phòng</h2>
                <div class="detail-item">
                    <strong>Mã đặt phòng:</strong>
                    <span>#<%= booking.getBookingId() %></span>
                </div>
                <div class="detail-item">
                    <strong>Phòng:</strong>
                    <span><%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</span>
                </div>
                <div class="detail-item">
                    <strong>Ngày nhận phòng (Check-in):</strong>
                    <span>
                            <%= IConstant.localDateFormat.format(booking.getCheckInDate()) %>
                        </span>
                </div>
                <div class="detail-item">
                    <strong>Ngày trả phòng (Check-out):</strong>
                    <span>
                            <%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %>
                        </span>
                </div>
                <div class="detail-item">
                    <strong>Ngày đặt:</strong>
                    <span>
                            <%= IConstant.dateFormat.format(booking.getBookingDate()) %>
                        </span>
                </div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-concierge-bell"></i> Dịch vụ đã đặt</h2>
                <%-- Thay thế <c:choose> bằng if-else --%>
                <% if (chosenServices != null && !chosenServices.isEmpty()) { %>
                <table class="services-table">
                    <thead>
                    <tr>
                        <th>Tên dịch vụ</th>
                        <th>Số lượng</th>
                        <th>Ngày sử dụng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%-- Thay thế <c:forEach> bằng vòng lặp for của Java --%>
                    <% for (int i = 0; i < services.size(); i++) {
                        Service service = services.get(i);
                        ChoosenService chosenService = chosenServices.get(i);
                    %>
                    <tr>
                        <td><%= service.getServiceName() %></td>
                        <td><%= chosenService.getQuantity() %></td>
                        <td>
                            <%= IConstant.dateFormat.format(chosenService.getServiceDate()) %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>Không có dịch vụ nào được đặt.</p>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="card-body">
            <h2>Có lỗi xảy ra</h2>
            <p>Không thể hiển thị thông tin đặt phòng. Vui lòng thử lại.</p>
        </div>
        <% } %>

        <div class="card-footer">
            <a href="<%= IConstant.homeServlet %>" class="btn btn-primary">Quay về trang chủ</a>
        </div>
    </div>
</div>

</body>
</html>