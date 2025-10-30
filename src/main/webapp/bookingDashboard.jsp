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
        /* === MODERN LUXURY DESIGN === */
        :root { 
            --primary-color: #2c3e50;
            --accent-color: #d4af37;
            --success-color: #27ae60;
            --dark-text: #2c3e50;
            --light-gray: #ecf0f1;
            --gradient-start: #667eea;
            --gradient-end: #764ba2;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
            color: var(--dark-text);
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
            background: #fff; 
            border-radius: 20px; 
            box-shadow: 0 15px 50px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .card-header { 
            background: linear-gradient(135deg, var(--success-color) 0%, #2ecc71 100%);
            color: white; 
            padding: 50px 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: pulse 3s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.5; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }
        
        .card-header .icon { 
            font-size: 4em; 
            margin-bottom: 15px;
            animation: bounce 1s ease-in-out;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-20px); }
            60% { transform: translateY(-10px); }
        }
        
        .card-header h1 { 
            margin: 0 0 10px 0;
            font-size: 2.2em;
            font-weight: bold;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
        
        .card-header p {
            font-size: 1.1em;
            opacity: 0.95;
        }
        
        .card-body { 
            padding: 40px;
            background: linear-gradient(to bottom, #fff 0%, #f8f9fa 100%);
        }
        
        .detail-section { 
            margin-bottom: 35px;
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .detail-section:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .detail-section h2 { 
            font-size: 1.5em;
            color: var(--primary-color);
            border-bottom: 3px solid var(--accent-color);
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .detail-section h2 i {
            color: var(--accent-color);
        }
        
        .detail-item { 
            display: flex; 
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
            transition: background 0.3s ease;
        }
        
        .detail-item:hover {
            background: linear-gradient(90deg, transparent 0%, rgba(212, 175, 55, 0.05) 50%, transparent 100%);
        }
        
        .detail-item:last-child { border-bottom: none; }
        
        .detail-item strong { 
            color: #555;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-item strong i {
            color: var(--accent-color);
            width: 20px;
        }
        
        .detail-item span {
            color: var(--primary-color);
            font-weight: 500;
        }
        
        .booking-id-badge {
            background: linear-gradient(135deg, var(--accent-color), #f4e4a6);
            color: var(--primary-color);
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(212, 175, 55, 0.3);
        }
        
        .services-table { 
            width: 100%; 
            border-collapse: collapse;
            margin-top: 20px;
            overflow: hidden;
            border-radius: 10px;
        }
        
        .services-table thead {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
        }
        
        .services-table th { 
            text-align: left; 
            padding: 15px;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }
        
        .services-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .services-table tbody tr {
            transition: all 0.3s ease;
        }
        
        .services-table tbody tr:hover { 
            background: linear-gradient(90deg, transparent 0%, rgba(212, 175, 55, 0.1) 50%, transparent 100%);
            transform: scale(1.01);
        }
        
        .no-services {
            text-align: center;
            padding: 30px;
            color: #777;
            font-style: italic;
        }
        
        .card-footer { 
            background: linear-gradient(135deg, var(--light-gray) 0%, #dfe6e9 100%);
            padding: 30px;
            text-align: center;
            border-top: 3px solid var(--accent-color);
        }
        
        .btn { 
            display: inline-block; 
            padding: 15px 35px;
            border-radius: 50px;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .btn-primary { 
            background: linear-gradient(135deg, var(--accent-color), #f4e4a6);
            color: var(--primary-color);
        }
        
        .btn-primary:hover { 
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(212, 175, 55, 0.4);
        }
        
        .error-message {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }
        
        .success-checkmark {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px auto;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.2);
            animation: scaleIn 0.5s ease-out;
        }
        
        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
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