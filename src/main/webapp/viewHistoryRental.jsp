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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        /* === LUXURY ELEGANT THEME === */
        :root { 
            --font-heading: 'Playfair Display', serif;
            --font-body: 'Lato', sans-serif;
            --color-gold: #c9ab81;
            --color-charcoal: #1a1a1a;
            --color-offwhite: #f8f7f5;
            --color-grey: #666;
            --color-light: #999;
            --border-color: #e5e5e5;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: var(--font-body);
            line-height: 1.8;
            color: var(--color-charcoal);
            background: var(--color-offwhite);
            min-height: 100vh;
        }
        
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 0 20px; 
        }
        
        a { text-decoration: none; color: inherit; }
        
        /* === HEADER === */
        .header { 
            background: rgba(26, 26, 26, 0.95);
            backdrop-filter: blur(10px);
            color: #fff;
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header .container { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .logo a { 
            font-family: var(--font-heading);
            font-size: 1.5rem;
            font-weight: 700;
            color: #fff;
            letter-spacing: 1px;
        }
        
        .main-nav { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
        }
        
        .main-nav span { 
            color: #fff; 
            font-size: 0.95rem;
        }
        
        .main-nav form { margin: 0; }
        
        .btn { 
            display: inline-block;
            padding: 10px 24px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 0.9rem;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 700;
        }
        
        .btn:hover { opacity: 0.9; }
        
        .btn-secondary { 
            background: #6c757d;
            color: #fff;
            border-color: #6c757d;
        }
        
        .btn-primary { 
            background: var(--color-gold);
            color: #fff;
            border-color: var(--color-gold);
        }
        
        .btn-primary:hover { 
            background: transparent;
            color: var(--color-gold);
        }
        
        .btn-warning { 
            background: #ffa500;
            color: #fff;
            border-color: #ffa500;
        }
        
        .btn-warning:hover {
            background: transparent;
            color: #ffa500;
        }
        
        /* === FOOTER === */
        .footer { 
            background: var(--color-charcoal);
            color: #ccc;
            padding: 3rem 0 0;
            margin-top: 100px;
        }
        
        .footer-grid { 
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            padding-bottom: 2rem;
        }
        
        .footer-col h3 { 
            font-family: var(--font-heading);
            margin-bottom: 1.2rem;
            color: #fff;
            font-size: 1.3rem;
            font-weight: 600;
            letter-spacing: 1px;
        }
        
        .footer-col p, 
        .footer-col li { 
            margin-bottom: 0.7rem;
        }
        
        .footer-col ul { list-style: none; }
        .footer-col a { transition: all 0.3s ease; }
        .footer-col a:hover { 
            color: var(--color-gold);
            padding-left: 5px;
        }
        .footer-col i { color: var(--color-gold); margin-right: 10px; }
        
        .footer-bottom { 
            text-align: center;
            padding: 2rem 0;
            margin-top: 2rem;
            border-top: 1px solid #444;
            font-size: 0.9rem;
            color: var(--color-grey);
        }
        
        /* === MAIN CONTENT === */
        .main-content { 
            padding: 60px 0; 
            min-height: 70vh;
        }
        
        .page-header {
            margin-bottom: 40px;
            text-align: center;
        }
        
        .page-title { 
            font-family: var(--font-heading);
            font-size: 3em;
            color: var(--color-charcoal);
            margin-bottom: 15px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        
        .page-title i {
            color: var(--color-gold);
            font-size: 0.8em;
        }
        
        .page-subtitle {
            color: var(--color-grey);
            font-size: 1.2em;
            font-weight: 300;
        }
        
        .history-container { 
            background: #fff;
            padding: 0;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            border: 1px solid var(--border-color);
            overflow: hidden;
        }
        
        .history-table { 
            width: 100%;
            border-collapse: collapse;
            font-size: 1rem;
        }
        
        .history-table th, 
        .history-table td { 
            padding: 20px 24px;
            text-align: left;
            vertical-align: middle;
        }
        
        .history-table thead {
            background: linear-gradient(135deg, var(--color-charcoal) 0%, #2c2c2c 100%);
        }
        
        .history-table th { 
            color: #fff;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            border-bottom: none;
        }
        
        .history-table tbody tr { 
            border-bottom: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }
        
        .history-table tbody tr:last-child {
            border-bottom: none;
        }
        
        .history-table tbody tr:hover { 
            background: var(--color-offwhite);
            transform: scale(1.005);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .history-table tbody td {
            color: var(--color-charcoal);
            font-weight: 400;
        }
        
        .history-table tbody td:first-child {
            font-weight: 700;
            color: var(--color-gold);
        }
        
        /* === ACTION BUTTONS COLUMN === */
        .history-table tbody td:last-child {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .history-table tbody td:last-child form {
            margin: 0 !important;
        }
        
        .history-table .btn {
            padding: 10px 20px;
            font-size: 0.9rem;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .history-table .btn i {
            font-size: 0.9em;
        }
        
        .no-booking { 
            text-align: center;
            padding: 100px 40px;
            color: var(--color-grey);
        }
        
        .no-booking i { 
            font-size: 5rem;
            color: var(--color-gold);
            margin-bottom: 30px;
            display: block;
            opacity: 0.3;
        }
        
        .no-booking p {
            font-size: 1.3rem;
            font-weight: 300;
            margin-top: 15px;
        }
        
        .status { 
            padding: 8px 16px;
            border-radius: 5px;
            font-size: 0.8rem;
            font-weight: 600;
            text-align: center;
            display: inline-block;
            min-width: 110px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
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
        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-history"></i>
                Lịch Sử Đặt Phòng
            </h1>
            <p class="page-subtitle">Quản lý và xem chi tiết các lần đặt phòng của bạn</p>
        </div>
        
        <div class="history-container">
            <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="history-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Số Phòng</th>
                    <th>Loại Phòng</th>
                    <th>Ngày Nhận Phòng</th>
                    <th>Ngày Trả Phòng</th>
                    <th>Trạng Thái</th>
                    <th>Hành động</th>
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
                    <td>
                        <span class="status <%= booking.getStatus().toLowerCase().replace("-", "") %>">
                            <%= booking.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <form action="./detailBooking" method="post">
                            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                            <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-eye"></i> Chi tiết
                            </button>
                        </form>

                        <%-- NÚT CHỈNH SỬA DỊCH VỤ - CHỈ CHO PHÉP KHI TRẠNG THÁI LÀ "Reserved" --%>
                        <% if ("Reserved".equalsIgnoreCase(booking.getStatus())) { %>
                            <form action="<%=IConstant.getBookingInfoServlet%>" method="post">
                                <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Chỉnh sửa
                                </button>
                            </form>
                        <% } %>

                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="no-booking">
                <i class="fas fa-calendar-times"></i>
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