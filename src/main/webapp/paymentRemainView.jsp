
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.*" %>
<%@ page import="utils.IConstant" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // Lấy tất cả attributes từ controller
    Booking booking = (Booking) request.getAttribute("booking");
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    Long numberOfNights = (Long) request.getAttribute("numberOfNights");
    Double roomTotal = (Double) request.getAttribute("roomTotal");
    
    List<BookingService> bookingServices = (List<BookingService>) request.getAttribute("bookingServices");
    List<Service> serviceDetails = (List<Service>) request.getAttribute("serviceDetails");
    Double servicesTotal = (Double) request.getAttribute("servicesTotal");
    
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Double paidAmount = (Double) request.getAttribute("paidAmount");
    Double remainingAmount = (Double) request.getAttribute("remainingAmount");
    
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    Guest guest = (Guest) session.getAttribute("userGuest");
    
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Còn Lại - Luxury Hotel</title>
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
            text-decoration: none;
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
            text-decoration: none;
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
            background: #6c757d;
            color: white;
            border-color: #6c757d;
        }
        
        .btn-secondary:hover {
            background: transparent;
            color: #6c757d;
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
        
        /* === MAIN CONTENT === */
        .main-content { 
            max-width: 1200px;
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
        
        /* === ALERTS === */
        .alert {
            padding: 1.2rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid;
            font-size: 0.95rem;
        }

        .alert i {
            font-size: 1.2rem;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left-color: #28a745;
        }
        
        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border-left-color: #ffc107;
        }
        
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left-color: #17a2b8;
        }
        
        /* === PAYMENT CARD === */
        .payment-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .payment-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--gold);
        }
        
        .section-title {
            font-family: var(--font-serif);
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--black);
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gray-light);
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }
        
        .section-title i {
            color: var(--gold);
            font-size: 1.5rem;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
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
        
        .booking-id-badge {
            background: var(--gold);
            color: var(--black);
            padding: 0.5rem 1.5rem;
            border-radius: 20px;
            font-weight: 700;
            font-size: 1.2rem;
            display: inline-block;
            font-family: var(--font-serif);
        }
        
        /* === SERVICES TABLE === */
        .services-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }
        
        .services-table thead {
            background: var(--gray-light);
        }
        
        .services-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--black);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--gold);
        }
        
        .services-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        .services-table tbody tr:hover {
            background: var(--off-white);
        }
        
        .text-right {
            text-align: right !important;
        }
        
        /* === PAYMENT SUMMARY === */
        .payment-summary {
            background: var(--gray-light);
            padding: 2rem;
            border-radius: 8px;
            margin-top: 2rem;
            border: 2px solid var(--border);
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            font-size: 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .summary-item.total {
            border-top: 3px solid var(--gold);
            padding-top: 1.5rem;
            margin-top: 1rem;
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--gold);
            font-family: var(--font-serif);
        }
        
        .summary-item.remaining {
            background: #fff3cd;
            padding: 1.2rem;
            border-radius: 8px;
            margin-top: 1rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #c62828;
            border: 2px solid #ffc107;
            font-family: var(--font-serif);
        }
        
        .summary-item.paid {
            color: #2E7D32;
            font-weight: 600;
        }
        
        /* === PAYMENT HISTORY === */
        .payment-history {
            margin-top: 1.5rem;
        }
        
        .payment-history table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .payment-history thead {
            background: var(--gray-light);
        }
        
        .payment-history th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--black);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--gold);
        }
        
        .payment-history td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        .payment-history tbody tr:hover {
            background: var(--off-white);
        }
        
        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
            border: 1px solid #28a745;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffc107;
        }
        
        /* === PAYMENT METHOD === */
        .payment-method-container {
            background: var(--gray-light);
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 1.5rem;
            border: 1px solid var(--border);
        }
        
        .payment-method-label {
            display: block;
            margin-bottom: 1rem;
            font-weight: 600;
            color: var(--black);
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .payment-method-label i {
            color: var(--gold);
            margin-right: 0.5rem;
        }
        
        .payment-method-select {
            width: 100%;
            padding: 1rem 1.5rem;
            font-size: 1rem;
            border: 2px solid var(--border);
            border-radius: 6px;
            background: var(--white);
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: var(--font-sans);
            color: var(--black);
        }
        
        .payment-method-select:hover {
            border-color: var(--gold);
        }
        
        .payment-method-select:focus {
            outline: none;
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201, 171, 129, 0.1);
        }
        
        /* === BUTTON GROUP === */
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            justify-content: center;
        }
        
        .button-group form {
            margin: 0;
        }
        
        .button-group .btn {
            padding: 1rem 2.5rem;
            font-size: 0.9rem;
        }
        
        .button-group .btn i {
            margin-right: 0.5rem;
        }
        
        /* === FOOTER === */
        .footer { 
            background: var(--black);
            color: var(--white);
            padding: 4rem 0 0;
            border-top: 2px solid var(--gold);
            margin-top: 4rem;
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
            text-decoration: none;
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
            
            .detail-grid {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .button-group .btn {
                width: 100%;
            }
            
            .services-table,
            .payment-history table {
                font-size: 0.85rem;
            }
            
            .services-table th,
            .services-table td,
            .payment-history th,
            .payment-history td {
                padding: 0.7rem 0.5rem;
            }
            
            .payment-card {
                padding: 1.5rem;
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
            <span>Xin chào, <%= guest.getFullName() %>!</span>
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
        <h1 class="page-title">Thanh Toán <span>Còn Lại</span></h1>
        <p class="page-subtitle">Thông tin chi tiết thanh toán cho booking #<%= booking.getBookingId() %></p>
    </div>
    
    <!-- Thông báo thành công/lỗi -->
    <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span><strong><%= successMessage %></strong></span>
        </div>
    <% } %>
    
    <% if (errorMessage != null) { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <span><strong><%= errorMessage %></strong></span>
        </div>
    <% } %>
    
    <% if (remainingAmount != null && remainingAmount > 0) { %>
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Bạn còn <strong><%= currencyFormatter.format(remainingAmount) %></strong> chưa thanh toán.</span>
        </div>
    <% } else if (remainingAmount != null && remainingAmount == 0) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span>Bạn đã thanh toán đầy đủ cho booking này.</span>
        </div>
    <% } %>

    <!-- Thông tin booking -->
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-info-circle"></i>
            Thông Tin Booking
        </h2>
        <div class="detail-grid">
            <div class="detail-item">
                <span class="detail-label">Mã Booking</span>
                <span class="booking-id-badge">#<%= booking.getBookingId() %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Số Phòng</span>
                <span class="detail-value highlight"><%= room.getRoomNumber() %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Loại Phòng</span>
                <span class="detail-value"><%= roomType.getTypeName() %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Ngày Nhận Phòng</span>
                <span class="detail-value"><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Ngày Trả Phòng</span>
                <span class="detail-value"><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Số Đêm</span>
                <span class="detail-value highlight"><%= numberOfNights %> đêm</span>
            </div>
        </div>
    </div>

    <!-- Chi tiết tiền phòng -->
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-bed"></i>
            Chi Phí Phòng
        </h2>
        <div class="detail-grid">
            <div class="detail-item">
                <span class="detail-label">Giá Phòng/Đêm</span>
                <span class="detail-value"><%= currencyFormatter.format(roomType.getPricePerNight()) %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Số Đêm</span>
                <span class="detail-value"><%= numberOfNights %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Tổng Tiền Phòng</span>
                <span class="detail-value highlight"><%= currencyFormatter.format(roomTotal) %></span>
            </div>
        </div>
    </div>

    <!-- Dịch vụ đã sử dụng -->
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-concierge-bell"></i>
            Dịch Vụ Đã Sử Dụng
        </h2>
        <% if (bookingServices != null && !bookingServices.isEmpty()) { %>
            <table class="services-table">
                <thead>
                    <tr>
                        <th>Tên Dịch Vụ</th>
                        <th class="text-right">Giá</th>
                        <th class="text-right">Số Lượng</th>
                        <th class="text-right">Thành Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (int i = 0; i < bookingServices.size(); i++) {
                        BookingService bs = bookingServices.get(i);
                        Service service = serviceDetails.get(i);
                        double servicePrice = service.getPrice().doubleValue();
                        double subTotal = servicePrice * bs.getQuantity();
                    %>
                    <tr>
                        <td><%= service.getServiceName() %></td>
                        <td class="text-right"><%= currencyFormatter.format(servicePrice) %></td>
                        <td class="text-right"><%= bs.getQuantity() %></td>
                        <td class="text-right"><strong><%= currencyFormatter.format(subTotal) %></strong></td>
                    </tr>
                    <% } %>
                    <tr style="background: var(--gray-light); font-weight: 600;">
                        <td colspan="3" class="text-right">Tổng Tiền Dịch Vụ:</td>
                        <td class="text-right"><span style="color: var(--gold); font-size: 1.1rem;"><%= currencyFormatter.format(servicesTotal) %></span></td>
                    </tr>
                </tbody>
            </table>
        <% } else { %>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                <span>Không có dịch vụ nào được sử dụng.</span>
            </div>
        <% } %>
    </div>

    <!-- Lịch sử thanh toán -->
    <% if (payments != null && !payments.isEmpty()) { %>
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-history"></i>
            Lịch Sử Thanh Toán
        </h2>
        <div class="payment-history">
            <table>
                <thead>
                    <tr>
                        <th>Ngày Thanh Toán</th>
                        <th>Phương Thức</th>
                        <th class="text-right">Số Tiền</th>
                        <th>Trạng Thái</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (Payment payment : payments) { 
                        String methodIcon = "";
                        String method = payment.getPaymentMethod();
                        if ("Cash".equals(method)) {
                            methodIcon = "💵";
                        } else if ("Credit Card".equals(method)) {
                            methodIcon = "💳";
                        } else if ("Debit Card".equals(method)) {
                            methodIcon = "💳";
                        } else if ("Online".equals(method)) {
                            methodIcon = "🌐";
                        } else {
                            methodIcon = "💰";
                        }
                    %>
                    <tr>
                        <td><%= IConstant.dateFormat.format(payment.getPaymentDate()) %></td>
                        <td><%= methodIcon %> <%= payment.getPaymentMethod() %></td>
                        <td class="text-right"><strong><%= currencyFormatter.format(payment.getAmount()) %></strong></td>
                        <td><span class="status-badge status-<%= payment.getStatus().toLowerCase() %>"><%= payment.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <!-- Tổng kết thanh toán -->
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-calculator"></i>
            Tổng Kết Thanh Toán
        </h2>
        <div class="payment-summary">
            <div class="summary-item">
                <span>Tổng Chi Phí:</span>
                <span><strong><%= currencyFormatter.format(totalAmount) %></strong></span>
            </div>
            <div class="summary-item paid">
                <span><i class="fas fa-check-circle"></i> Đã Thanh Toán:</span>
                <span><strong><%= currencyFormatter.format(paidAmount) %></strong></span>
            </div>
            <div class="summary-item remaining">
                <span><i class="fas fa-exclamation-circle"></i> Còn Phải Trả:</span>
                <span><strong><%= currencyFormatter.format(remainingAmount) %></strong></span>
            </div>
        </div>
    </div>

    <!-- Phương thức thanh toán -->
    <% if (remainingAmount != null && remainingAmount > 0) { %>
    <div class="payment-card">
        <h2 class="section-title">
            <i class="fas fa-credit-card"></i>
            Phương Thức Thanh Toán
        </h2>
        <form id="paymentForm" action="processPayment" method="post">
            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
            <input type="hidden" name="amount" value="<%= remainingAmount %>">
            
            <div class="payment-method-container">
                <label for="paymentMethod" class="payment-method-label">
                    <i class="fas fa-wallet"></i> Chọn Phương Thức Thanh Toán
                </label>
                <select name="paymentMethod" id="paymentMethod" class="payment-method-select" required>
                    <option value="Cash" selected>💵 Tiền mặt (Cash)</option>
                    <option value="Credit Card">💳 Thẻ tín dụng (Credit Card)</option>
                    <option value="Debit Card">💳 Thẻ ghi nợ (Debit Card)</option>
                    <option value="Online">🌐 Thanh toán trực tuyến (Online)</option>
                </select>
            </div>
        </form>
    </div>
    <% } %>

    <!-- Nút hành động -->
    <div class="button-group">
        <% if (remainingAmount != null && remainingAmount > 0) { %>
            <button type="submit" form="paymentForm" class="btn btn-primary">
                <i class="fas fa-credit-card"></i>
                Thanh Toán Ngay
            </button>
        <% } %>
        
        <form action="./viewBooking" method="post" style="display: inline;">
            <input type="hidden" name="guestId" value="<%= booking.getGuestId() %>">
            <button type="submit" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Quay Lại
            </button>
        </form>
    </div>
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
            <p>&copy; 2024 Luxury Hotel. Bảo lưu mọi
