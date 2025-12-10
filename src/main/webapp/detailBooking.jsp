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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { 
            --gold: #c9ab81;
            --gold-dark: #b8941f;
            --black: #000000;
            --white: #FFFFFF;
            --off-white: #FAFAFA;
            --gray-light: #F5F5F5;
            --gray: #666666;
            --border: #E0E0E0;
            
            --font-serif: 'Cormorant Garamond', serif;
            --font-sans: 'Montserrat', sans-serif;
        }
        
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body { 
            font-family: var(--font-sans);
            background: var(--white);
            color: var(--black);
            line-height: 1.6;
        }
        
        /* === HEADER === */
        .header { 
            background: var(--black);
            border-bottom: 2px solid var(--gold);
            padding: 1.5rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header .container { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .logo a { 
            font-family: var(--font-serif);
            font-size: 2rem;
            font-weight: 700;
            color: var(--white);
            letter-spacing: 2px;
            text-transform: uppercase;
        }
        
        .logo a span {
            color: var(--gold);
        }
        
        .main-nav { 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }
        
        .main-nav span { 
            color: var(--white); 
            font-size: 0.9rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        .container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; }
        a { text-decoration: none; color: inherit; }
        
        .btn { 
            display: inline-block;
            padding: 0.75rem 2rem;
            border: 2px solid;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-family: var(--font-sans);
            background: transparent;
        }
        
        .btn-info { 
            background: transparent;
            border-color: var(--gold);
            color: var(--gold);
        }
        
        .btn-info:hover { 
            background: var(--gold);
            color: var(--black);
        }
        
        .btn-primary { 
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
        }
        
        .btn-primary:hover { 
            background: transparent;
            color: var(--gold);
        }
        
        .btn-secondary { 
            background: var(--black);
            color: var(--white);
            border-color: var(--black);
        }
        
        .btn-secondary:hover { 
            background: transparent;
            color: var(--black);
        }
        
        .card { 
            background: var(--white);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 3rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .card-header { 
            background: var(--white);
            color: var(--black);
            padding: 3rem;
            text-align: center;
            border-bottom: 1px solid var(--border);
        }
        
        .card-header h1 { 
            font-family: var(--font-serif);
            margin: 0;
            font-size: 3rem;
            font-weight: 700;
        }
        
        .card-header h1 span {
            color: var(--gold);
        }
        
        .card-body { padding: 3rem; }
        
        .detail-section { 
            margin-bottom: 3rem;
            padding: 2rem;
            background: var(--gray-light);
            border: 1px solid var(--border);
            border-radius: 8px;
        }
        
        .detail-section h2 { 
            font-family: var(--font-serif);
            font-size: 1.8rem;
            color: var(--black);
            border-bottom: 1px solid var(--border);
            padding-bottom: 1rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        
        .detail-section h2 span { 
            color: var(--gold); 
        }
        
        .detail-item { 
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border);
        }
        
        .detail-item:last-child { border-bottom: none; }
        .detail-item strong { 
            color: var(--gray); 
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .detail-item span { 
            color: var(--black); 
            font-weight: 400;
        }
        
        .services-table, .history-table { 
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            font-size: 1rem;
            background: var(--white);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .services-table th, .services-table td, .history-table th, .history-table td { 
            text-align: left;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
        }
        
        .services-table th, .history-table th { 
            background: linear-gradient(135deg, var(--black) 0%, #2c2c2c 100%);
            color: var(--white);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            border-bottom: none;
        }
        
        .services-table tbody tr, .history-table tbody tr { 
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
        }
        
        .services-table tbody tr:hover, .history-table tbody tr:hover { 
            background: var(--off-white);
            transform: scale(1.002);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .text-right { text-align: right !important; }
        
        .status { 
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.8em;
            font-weight: 600;
            text-align: center;
            display: inline-block;
            min-width: 90px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 2px solid;
        }
        
        .status.reserved { 
            background: #e3f2fd;
            color: #1976d2;
            border-color: #1976d2;
        }
        .status.checkedin { 
            background: #e8f5e9;
            color: #2e7d32;
            border-color: #2e7d32;
        }
        .status.checkedout { 
            background: #f5f5f5;
            color: #616161;
            border-color: #9e9e9e;
        }
        .status.canceled { 
            background: #ffebee;
            color: #c62828;
            border-color: #c62828;
        }
        
        .service-status { 
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 0.8em;
            display: inline-block;
            font-weight: 600;
            border: 2px solid;
        }
        
        .status-0 { 
            background: #e3f2fd;
            color: #1976d2;
            border-color: #1976d2;
        }
        .status-1 { 
            background: #fff3e0;
            color: #e65100;
            border-color: #e65100;
        }
        .status-2 { 
            background: #e8f5e9;
            color: #2e7d32;
            border-color: #2e7d32;
        }
        .status--1 { 
            background: #f5f5f5;
            color: #616161;
            border-color: #9e9e9e;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="<%= IConstant.homeServlet %>">LUXURY <span>HOTEL</span></a>
        </div>
        <nav class="main-nav">
            <% if (guest != null) { %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= guest.getFullName() %>!</span>
            <form action="<%= IConstant.viewBookingServlet %>" method="post" style="display: inline;">
                <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                <button type="submit" class="btn btn-info">Phòng đã đặt</button>
            </form>
            <form action="logout" method="get" style="display: inline;">
                <button type="submit" class="btn btn-secondary">Đăng xuất</button>
            </form>
            <% } %>
        </nav>
    </div>
</header>

<div class="container" style="margin-top: 100px;">
    <div class="card">
        <% if (booking != null) { %>
        <div class="card-header">
            <h1>Chi Tiết Đặt Phòng <span>#<%= booking.getBookingId() %></span></h1>
        </div>
        <div class="card-body">
            <div class="detail-section">
                <h2>Thông Tin <span>Khách Hàng</span></h2>
                <div class="detail-item"><strong>Họ và tên:</strong> <span><%= guest.getFullName() %></span></div>
                <div class="detail-item"><strong>Email:</strong> <span><%= guest.getEmail() %></span></div>
            </div>

            <div class="detail-section">
                <h2>Chi Tiết <span>Lưu Trú</span></h2>
                <div class="detail-item"><strong>Phòng:</strong> <span><%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</span></div>
                <div class="detail-item"><strong>Ngày nhận phòng:</strong> <span><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></span></div>
                <div class="detail-item"><strong>Ngày trả phòng:</strong> <span><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></span></div>
                <div class="detail-item"><strong>Ngày đặt:</strong> <span><%= IConstant.dateFormat.format(booking.getBookingDate()) %></span></div>
                <div class="detail-item"><strong>Trạng thái:</strong> <span class="status <%= booking.getStatus().toLowerCase().replace("-", "") %>"><%= booking.getStatus() %></span></div>
            </div>

            <div class="detail-section">
                <h2>Dịch Vụ <span>Đã Sử Dụng</span></h2>
                <% if (bookingServices != null && !bookingServices.isEmpty()) { %>
                <table class="services-table">
                    <thead><tr><th>Tên dịch vụ</th><th class="text-right">Số lượng</th><th>Ngày sử dụng</th><th>Trạng thái</th><th class="text-right">Thành tiền</th></tr></thead>
                    <tbody>
                    <%-- Dùng vòng lặp có chỉ số để truy cập 2 list song song --%>
                    <% for (int i = 0; i < bookingServices.size(); i++) {
                        BookingService bs = bookingServices.get(i);
                        Service service = serviceDetails.get(i); // Lấy service tương ứng
                        BigDecimal subTotal = service.getPrice().multiply(new BigDecimal(bs.getQuantity()));
                        String statusText;
                        switch (bs.getStatus()) {
                            case 0: statusText = "Chưa làm"; break;
                            case 1: statusText = "Đang làm"; break;
                            case 2: statusText = "Đã làm"; break;
                            case -1: statusText = "Đã hủy"; break;
                            default: statusText = "Không xác định";
                        }
                    %>
                    <tr>
                        <td><%= service.getServiceName() %></td>
                        <td class="text-right"><%= bs.getQuantity() %></td>
                        <td><%= IConstant.dateFormat.format(bs.getServiceDate()) %></td>
                        <td><span class="service-status status-<%= bs.getStatus() %>"><%= statusText %></span></td>
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
                <h2>Các Lần Đặt Phòng <span>Khác</span></h2>
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