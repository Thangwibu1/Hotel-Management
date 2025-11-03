<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Guest" %>
<%@ page import="model.Staff" %>
<%@ page import="utils.IConstant" %>
<%@ page import="com.sun.org.apache.bcel.internal.generic.ICONST" %>

<%!
    // Helper function
    public String getRoomTypeNameById(int roomTypeId, List<RoomType> roomTypes) {
        if (roomTypes == null) return "N/A";
        for (RoomType rt : roomTypes) {
            if (rt.getRoomTypeId() == roomTypeId) return rt.getTypeName();
        }
        return "Unknown";
    }
%>

<%
    Boolean isLogin = (Boolean) session.getAttribute("isLogin");
    if (isLogin == null || !isLogin) {
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp?returnUrl=viewbooking");
        return;
    }
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
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
            gap: 2rem; 
        }
        
        .main-nav span { 
            color: var(--white); 
            font-size: 0.9rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
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
        }
        
        .btn-logout { 
            background: transparent;
            color: var(--gold);
            border-color: var(--gold);
        }
        
        .btn-logout:hover { 
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
        
        .btn-edit { 
            background: transparent;
            color: var(--black);
            border-color: var(--black);
        }
        
        .btn-edit:hover {
            background: var(--black);
            color: var(--white);
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
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            border-color: #6c757d;
        }
        
        .btn-secondary:hover {
            background: transparent;
            color: #6c757d;
        }
        
        /* === MAIN CONTENT === */
        .main-content { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 4rem 2rem 6rem;
            min-height: calc(100vh - 400px);
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 4rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--border);
        }
        
        .page-title { 
            font-family: var(--font-serif);
            font-size: 3.5rem;
            font-weight: 700;
            color: var(--black);
            margin-bottom: 1rem;
            letter-spacing: 1px;
        }
        
        .page-title span {
            color: var(--gold);
        }
        
        .page-subtitle {
            color: var(--gray);
            font-size: 1rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        /* === BOOKING CARDS === */
        .bookings-grid {
            display: grid;
            gap: 2rem;
        }
        
        .booking-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .booking-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--gold);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .booking-card:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }
        
        .booking-card:hover::before {
            transform: scaleY(1);
        }
        
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--gray-light);
        }
        
        .booking-number {
            font-family: var(--font-serif);
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--black);
        }
        
        .booking-number span {
            color: var(--gold);
            font-size: 2.2rem;
        }
        
        .status { 
            padding: 0.5rem 1.5rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: 2px solid;
            background: var(--white);
        }
        
        .status.reserved { 
            color: #1565C0;
            border-color: #1565C0;
        }
        
        .status.checkedin { 
            color: #2E7D32;
            border-color: #2E7D32;
        }
        
        .status.checkedout { 
            color: var(--gray);
            border-color: var(--gray);
        }
        
        .status.canceled { 
            color: #C62828;
            border-color: #C62828;
        }
        
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .detail-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--gray);
            font-weight: 600;
        }
        
        .detail-value {
            font-size: 1.1rem;
            color: var(--black);
            font-weight: 400;
        }
        
        .detail-value.highlight {
            font-family: var(--font-serif);
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--gold);
        }
        
        .booking-actions {
            display: flex;
            gap: 1rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--gray-light);
        }
        
        .booking-actions form {
            margin: 0;
        }
        
        .booking-card .btn {
            padding: 0.7rem 1.8rem;
            font-size: 0.8rem;
        }
        
        .booking-card .btn i {
            margin-right: 0.5rem;
        }
        
        /* === EMPTY STATE === */
        .no-booking { 
            text-align: center;
            padding: 6rem 2rem;
        }
        
        .no-booking-icon {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            border: 3px solid var(--gold);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .no-booking i { 
            font-size: 3.5rem;
            color: var(--gold);
        }
        
        .no-booking h3 {
            font-family: var(--font-serif);
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--black);
        }
        
        .no-booking p {
            font-size: 1rem;
            color: var(--gray);
            font-weight: 300;
        }
        
        /* === FOOTER === */
        .footer { 
            background: var(--black);
            color: var(--white);
            padding: 4rem 0 0;
            border-top: 2px solid var(--gold);
        }
        
        .footer .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        .footer-grid { 
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 3rem;
            padding-bottom: 3rem;
        }
        
        .footer-col h3 { 
            font-family: var(--font-serif);
            margin-bottom: 1.5rem;
            color: var(--gold);
            font-size: 1.5rem;
            font-weight: 600;
            letter-spacing: 1px;
        }
        
        .footer-col p { 
            margin-bottom: 1rem;
            color: #CCCCCC;
            font-weight: 300;
            line-height: 1.8;
        }
        
        .footer-col ul { 
            list-style: none; 
        }
        
        .footer-col li {
            margin-bottom: 0.8rem;
        }
        
        .footer-col a { 
            color: #CCCCCC;
            transition: all 0.3s ease;
            font-weight: 300;
        }
        
        .footer-col a:hover { 
            color: var(--gold);
            padding-left: 5px;
        }
        
        .footer-col i { 
            color: var(--gold); 
            margin-right: 0.8rem;
            width: 20px;
        }
        
        .footer-bottom { 
            text-align: center;
            padding: 2rem 0;
            border-top: 1px solid #333;
            font-size: 0.85rem;
            color: #999;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        /* === RESPONSIVE === */
        @media (max-width: 768px) {
            .header .container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .page-title {
                font-size: 2.5rem;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .booking-actions {
                flex-direction: column;
            }
            
            .booking-actions .btn {
                width: 100%;
            }
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

<main class="main-content">
    <div class="page-header">
        <h1 class="page-title">Lịch Sử <span>Đặt Phòng</span></h1>
        <p class="page-subtitle">Quản lý và theo dõi các đặt phòng của bạn</p>
    </div>
    
    <% if (bookings != null && !bookings.isEmpty()) { %>
    <div class="bookings-grid">
        <% for (int i = 0; i < bookings.size(); i++) {
            Booking booking = bookings.get(i);
            Room room = rooms.get(i);
            String roomTypeName = getRoomTypeNameById(room.getRoomTypeId(), roomTypes);
        %>
        <div class="booking-card">
            <div class="booking-header">
                <div class="booking-number">
                    <span>#<%= String.format("%03d", i + 1) %></span>
                </div>
                <span class="status <%= booking.getStatus().toLowerCase().replace("-", "") %>">
                    <%= booking.getStatus() %>
                </span>
            </div>
            
            <div class="booking-details">
                <div class="detail-item">
                    <span class="detail-label">Số Phòng</span>
                    <span class="detail-value highlight"><%= room.getRoomNumber() %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Loại Phòng</span>
                    <span class="detail-value"><%= roomTypeName %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Ngày Nhận Phòng</span>
                    <span class="detail-value"><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Ngày Trả Phòng</span>
                    <span class="detail-value"><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></span>
                </div>
            </div>
            
            <div class="booking-actions">
                <form action="./detailBooking" method="post">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                    <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-eye"></i> Chi tiết
                    </button>
                </form>

                <% if ("Reserved".equalsIgnoreCase(booking.getStatus())) { %>
                <form action="<%=IConstant.getBookingInfoServlet%>" method="post">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                    <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                    <button type="submit" class="btn btn-edit">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </button>
                </form>
                <% } %>
                
                <form action="./paymentRemain" method="post">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                    <button type="submit" class="btn btn-info">
                        <i class="fas fa-credit-card"></i> Thanh toán
                    </button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="no-booking">
        <div class="no-booking-icon">
            <i class="fas fa-calendar-times"></i>
        </div>
        <h3>Chưa có đặt phòng</h3>
        <p>Bạn chưa có lịch sử đặt phòng nào trong hệ thống</p>
    </div>
    <% } %>
</main>

<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <h3>Luxury Hotel</h3>
                <p>Nơi sang trọng và đẳng cấp, mang đến trải nghiệm nghỉ dưỡng hoàn hảo với dịch vụ chuyên nghiệp.</p>
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
    </div>
</footer>

</body>
</html>