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
    List<BookingService> bookingServices = (List<BookingService>) request.getAttribute("bookingServices");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Nhận Đặt Phòng - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
        /* === BASIC LUXURY WHITE THEME === */
        :root { 
            --gold: #d4af37;
            --black: #1a1a1a;
            --gray: #666;
            --light-gray: #f8f8f8;
            --border: #e0e0e0;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fafafa;
            color: var(--black);
            line-height: 1.6;
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .container { 
            max-width: 900px; 
            margin: auto;
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .booking-summary-card { 
            background: #ffffff;
            border-radius: 8px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid var(--border);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card-header { 
            background: var(--black);
            color: #ffffff;
            padding: 40px 30px;
            text-align: center;
            border-bottom: 3px solid var(--gold);
        }
        
        .card-header .icon { 
            font-size: 3.5em; 
            margin-bottom: 12px;
            color: var(--gold);
        }
        
        .card-header h1 { 
            margin: 0 0 10px 0;
            font-size: 2em;
            font-weight: 600;
        }
        
        .card-header p {
            font-size: 1em;
            opacity: 0.9;
        }
        
        .card-body { 
            padding: 35px;
            background: #ffffff;
        }
        
        .detail-section { 
            margin-bottom: 30px;
            background: var(--light-gray);
            padding: 25px;
            border-radius: 6px;
            border-left: 3px solid var(--gold);
        }
        
        .detail-section h2 { 
            font-size: 1.3em;
            color: var(--black);
            border-bottom: 2px solid var(--gold);
            padding-bottom: 12px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }
        
        .detail-section h2 i {
            color: var(--gold);
        }
        
        .detail-item { 
            display: flex; 
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
        }
        
        .detail-item:last-child { border-bottom: none; }
        
        .detail-item strong { 
            color: var(--gray);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-item strong i {
            color: var(--gold);
            width: 18px;
        }
        
        .detail-item span {
            color: var(--black);
            font-weight: 500;
        }
        
        .booking-id-badge {
            background: var(--gold);
            color: var(--black);
            padding: 6px 14px;
            border-radius: 4px;
            font-weight: 600;
        }
        
        .services-table { 
            width: 100%; 
            border-collapse: collapse;
            margin-top: 20px;
            overflow: hidden;
            border-radius: 10px;
        }
        
        .services-table thead {
            background: var(--light-gray);
            color: var(--black);
        }
        
        .services-table th { 
            text-align: left; 
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }
        
        .services-table td {
            padding: 12px;
            border-bottom: 1px solid var(--border);
        }
        
        .services-table tbody tr {
            transition: background 0.2s ease;
        }
        
        .services-table tbody tr:hover { 
            background: var(--light-gray);
        }
        
        .no-services {
            text-align: center;
            padding: 30px;
            color: var(--gray);
            font-style: italic;
        }
        
        .card-footer { 
            background: var(--light-gray);
            padding: 25px;
            text-align: center;
            border-top: 2px solid var(--border);
        }
        
        .btn { 
            display: inline-block; 
            padding: 12px 30px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.2s ease;
            font-weight: 500;
        }
        
        .btn-primary { 
            background: var(--gold);
            color: var(--black);
        }
        
        .btn-primary:hover { 
            opacity: 0.9;
        }
        
        .error-message {
            background: #f44336;
            color: white;
            padding: 30px;
            border-radius: 6px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="booking-summary-card">
        <div class="card-header">
            <div class="success-checkmark">
                <i class="fa-solid fa-check-circle icon"></i>
            </div>
            <h1>🎉 Đặt Phòng Thành Công!</h1>
            <p>Cảm ơn bạn đã lựa chọn Luxury Hotel. Chúng tôi đã gửi email xác nhận đến hộp thư của bạn.</p>
        </div>

        <%-- Kiểm tra xem booking có tồn tại không --%>
        <% if (booking != null && guest != null && room != null && roomType != null) { %>
        <div class="card-body">
            <div class="detail-section">
                <h2><i class="fa-solid fa-user-circle"></i> Thông tin khách hàng</h2>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-user"></i> Họ và tên:</strong>
                    <span><%= guest.getFullName() %></span>
                </div>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-envelope"></i> Email:</strong>
                    <span><%= guest.getEmail() %></span>
                </div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-calendar-check"></i> Chi tiết đặt phòng</h2>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-hashtag"></i> Mã đặt phòng:</strong>
                    <span class="booking-id-badge">#<%= booking.getBookingId() %></span>
                </div>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-door-open"></i> Phòng:</strong>
                    <span><%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</span>
                </div>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-sign-in-alt"></i> Ngày nhận phòng:</strong>
                    <span>
                            <%= IConstant.localDateFormat.format(booking.getCheckInDate()) %>
                        </span>
                </div>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-sign-out-alt"></i> Ngày trả phòng:</strong>
                    <span>
                            <%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %>
                        </span>
                </div>
                <div class="detail-item">
                    <strong><i class="fa-solid fa-calendar-plus"></i> Ngày đặt:</strong>
                    <span>
                            <%= IConstant.dateFormat.format(booking.getBookingDate()) %>
                        </span>
                </div>
            </div>

            <div class="detail-section">
                <h2><i class="fa-solid fa-concierge-bell"></i> Dịch vụ đã đặt</h2>
                <% if (bookingServices != null && !bookingServices.isEmpty()) { %>
                <table class="services-table">
                    <thead>
                    <tr>
                        <th>Tên dịch vụ</th>
                        <th>Số lượng</th>
                        <th>Ngày sử dụng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (BookingService bookingService : bookingServices) {
                        Service currentService = null;
                        for (Service service : services) {
                            if (service.getServiceId() == bookingService.getServiceId()) {
                                currentService = service;
                                break;
                            }
                        }
                        if (currentService != null) { %>
                    <tr>
                        <td><%= currentService.getServiceName() %></td>
                        <td><%= bookingService.getQuantity() %></td>
                        <td>
                            <%= IConstant.dateFormat.format(bookingService.getServiceDate()) %>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="no-services">
                    <i class="fa-solid fa-info-circle" style="font-size: 2em; color: #999; margin-bottom: 10px;"></i>
                    <p>Không có dịch vụ nào được đặt thêm.</p>
                </div>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="card-body">
            <div class="error-message">
                <i class="fa-solid fa-exclamation-triangle" style="font-size: 3em; margin-bottom: 15px;"></i>
                <h2>Có lỗi xảy ra</h2>
                <p>Không thể hiển thị thông tin đặt phòng. Vui lòng thử lại sau.</p>
            </div>
        </div>
        <% } %>

        <div class="card-footer">
            <a href="<%= IConstant.homeServlet %>" class="btn btn-primary">
                <i class="fa-solid fa-home"></i> Quay về trang chủ
            </a>
        </div>
    </div>
</div>

</body>
</html>