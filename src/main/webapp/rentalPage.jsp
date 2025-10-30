<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Room" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.Staff" %>
<%@ page import="model.Guest" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="utils.IConstant" %>

<%
    // 1. KIỂM TRA ĐĂNG NHẬP
    Boolean isLoginSession = (Boolean) session.getAttribute("isLogin");
    if (isLoginSession == null || !isLoginSession) {
        String returnUrl = "rentalRoom?roomId=" + request.getParameter("roomId") + "&roomTypeId=" + request.getParameter("roomTypeId");
        response.sendRedirect(request.getContextPath() + "/loginPage.jsp?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
        return;
    }

    // 2. KIỂM TRA VAI TRÒ: NẾU LÀ STAFF THÌ VỀ TRANG CHỦ
    if (session.getAttribute("userStaff") != null) {
        response.sendRedirect("home");
        return;
    }

    // Nếu đã đăng nhập và không phải staff, thì chắc chắn là Guest
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    Guest guest = (Guest) session.getAttribute("userGuest");
    List<Service> services = (List<Service>) request.getAttribute("services");

    // Lấy giá trị ngày tháng được truyền từ controller
    String checkInValue = (String) request.getAttribute("checkInValue");
    String checkOutValue = (String) request.getAttribute("checkOutValue");

    if (room == null || roomType == null || guest == null) {
        response.sendRedirect("home");
        return;
    }
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - <%= roomType.getTypeName() %> - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { 
            --gold: #D4AF37;
            --gold-dark: #B8941F;
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
        
        .container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; }
        a { text-decoration: none; color: inherit; }
        
        /* === HEADER === */
        .header { 
            background: var(--black);
            border-bottom: 2px solid var(--gold);
            padding: 1.5rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        
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
        
        .btn-logout { 
            color: var(--gold);
            border-color: var(--gold);
        }
        
        .btn-logout:hover { 
            background: var(--gold);
            color: var(--black);
        }
        
        .btn-book { 
            background: var(--gold);
            color: var(--black);
            border-color: var(--gold);
        }
        
        .btn-book:hover { 
            background: transparent;
            color: var(--gold);
        }
        
        /* === FOOTER === */
        .footer { 
            background: var(--black);
            color: var(--white);
            padding: 4rem 0 0;
            border-top: 2px solid var(--gold);
            margin-top: 80px;
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
        
        .footer-bottom { 
            text-align: center;
            padding: 2rem 0;
            border-top: 1px solid #333;
            font-size: 0.85rem;
            color: #999;
            font-weight: 300;
            letter-spacing: 0.5px;
        }
        
        /* === MAIN CONTENT === */
        .main-content { 
            max-width: 1200px;
            margin: 0 auto;
            padding: 4rem 2rem 6rem;
        }
        
        .booking-form-section { 
            background: var(--white);
            padding: 3rem; 
            border: 1px solid var(--border);
        }
        
        .booking-form-section h2 { 
            font-family: var(--font-serif);
            font-size: 3rem;
            font-weight: 700;
            color: var(--black);
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border);
            text-align: center;
        }
        
        .booking-form-section h2 span {
            color: var(--gold);
        }
        
        .section-header {
            margin: 3rem 0 2rem 0;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }
        
        .section-header h3 {
            font-family: var(--font-serif);
            color: var(--black);
            font-size: 1.8rem;
            margin: 0;
            font-weight: 600;
        }
        
        .section-header h3 span {
            color: var(--gold);
        }
        
        .form-group-rental { margin-bottom: 25px; }
        
        .form-group-rental label { 
            display: block; 
            margin-bottom: 0.5rem; 
            font-weight: 600; 
            color: var(--gray);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .form-group-rental input, .form-group-rental select { 
            width: 100%; 
            padding: 0.75rem 1rem; 
            border: 1px solid var(--border);
            box-sizing: border-box; 
            font-size: 1rem;
            background: var(--white);
            color: var(--black);
            transition: all 0.3s ease;
            font-family: var(--font-sans);
        }
        
        .form-group-rental input:focus, .form-group-rental select:focus {
            border-color: var(--gold);
            outline: none;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .form-group-rental input:read-only { 
            background-color: var(--gray-light);
            cursor: not-allowed;
            color: var(--gray);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .total-price { 
            margin-top: 2rem; 
            padding: 2rem;
            background: var(--gray-light);
            border: 1px solid var(--border);
            font-family: var(--font-serif);
            font-size: 2rem; 
            font-weight: 700; 
            text-align: right;
            color: var(--black);
        }
        
        .total-price span {
            color: var(--gold);
        }

        /* === CSS CHO CREDIT CARD === */
        .credit-card-section {
            background: var(--gray-light);
            padding: 2rem;
            margin: 2rem 0;
            border: 1px solid var(--border);
        }
        
        .credit-card-section h3 {
            font-family: var(--font-serif);
            color: var(--black);
            margin: 0 0 1.5rem 0;
            font-weight: 600;
            font-size: 1.5rem;
        }
        
        .credit-card-section h3 span {
            color: var(--gold);
        }
        
        .card-visual {
            background: linear-gradient(135deg, var(--black) 0%, #2c2c2c 100%);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            position: relative;
            min-height: 200px;
            border: 2px solid var(--gold);
        }
        
        .card-chip {
            width: 50px;
            height: 40px;
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            border-radius: 8px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        
        .card-chip::before {
            content: '';
            position: absolute;
            top: 5px;
            left: 5px;
            right: 5px;
            bottom: 5px;
            background: linear-gradient(45deg, #d4af37, #f4e4a6);
            border-radius: 4px;
        }
        
        .card-number-display {
            font-size: 1.5em;
            letter-spacing: 3px;
            color: var(--white);
            font-weight: 600;
            margin: 20px 0;
            font-family: 'Courier New', monospace;
        }
        
        .card-details-display {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .card-holder-display, .card-expiry-display {
            color: var(--white);
        }
        
        .card-holder-display label, .card-expiry-display label {
            font-size: 0.7em;
            text-transform: uppercase;
            display: block;
            margin-bottom: 5px;
            color: var(--gold);
            font-weight: 600;
            letter-spacing: 1px;
        }
        
        .card-holder-display span, .card-expiry-display span {
            font-size: 1.1em;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .card-form-group {
            margin-bottom: 20px;
        }
        
        .card-form-group label {
            display: block;
            color: var(--black);
            margin-bottom: 6px;
            font-weight: 500;
        }
        
        .card-form-group input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            background: var(--white);
            color: var(--black);
            font-size: 0.95rem;
            transition: all 0.3s ease;
            font-family: var(--font-sans);
        }
        
        .card-form-group input::placeholder {
            color: var(--gray);
        }
        
        .card-form-group input:focus {
            border-color: var(--gold);
            outline: none;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .card-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 15px;
        }

        /* === CSS CHO TÍNH NĂNG THÊM DỊCH VỤ ĐỘNG === */
        .service-adder { display: flex; gap: 10px; align-items: flex-end; }
        .service-adder .form-group-rental { flex-grow: 1; margin-bottom: 0; }
        
        #add-service-btn { 
            padding: 12px 20px; 
            background: #4CAF50;
            color: white; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 1.1rem; 
            line-height: 1;
            transition: all 0.2s ease;
        }
        
        #add-service-btn:hover { 
            opacity: 0.9;
        }
        
        #selected-services-list { margin-top: 18px; }
        
        .selected-service-item { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
            background: var(--white);
            padding: 1rem; 
            border: 1px solid var(--border);
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .selected-service-item:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .selected-service-item span { 
            flex-grow: 1; 
            font-weight: 500; 
            color: var(--black); 
        }
        
        .service-quantity, .service-date { 
            padding: 8px; 
            border: 1px solid var(--border);
            border-radius: 4px; 
            width: 80px; 
            font-size: 0.95rem;
            transition: border-color 0.2s ease;
        }
        
        .service-quantity:focus, .service-date:focus {
            border-color: var(--gold);
            outline: none;
        }
        
        .service-date { width: 155px; }
        
        .remove-service-btn { 
            background: #f44336;
            color: white; 
            border: none; 
            border-radius: 50%; 
            width: 32px; 
            height: 32px; 
            cursor: pointer; 
            flex-shrink: 0; 
            font-weight: bold;
            font-size: 1.1rem;
            transition: all 0.2s ease;
        }
        
        .remove-service-btn:hover { 
            opacity: 0.9;
        }
        
        .info-box {
            background: var(--gray-light);
            border: 1px solid var(--border);
            padding: 1.5rem;
            margin: 1.5rem 0;
        }
        
        .info-box i {
            color: var(--gold);
            margin-right: 0.5rem;
        }
        
        .info-box p {
            margin: 0;
            color: var(--gray);
            line-height: 1.6;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="<%= IConstant.homeServlet %>">LUXURY <span>HOTEL</span></a>
        </div>
        <%
            String username = "";
            if (session.getAttribute("userStaff") != null) {
                username = ((Staff) session.getAttribute("userStaff")).getFullName();
            } else if (session.getAttribute("userGuest") != null) {
                username = ((Guest) session.getAttribute("userGuest")).getFullName();
            }
        %>
        <nav class="main-nav">
            <span>Xin chào, <%= username %></span>
            <form style="display: inline;">
                <button class="btn btn-logout">
                    <a href="logout" style="text-decoration: none; color: inherit;">Đăng xuất</a>
                </button>
            </form>
        </nav>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="booking-form-section">
            <h2>Đặt Phòng <span>#<%= room.getRoomNumber() %></span></h2>
            <p style="text-align: center; color: var(--gray); margin-bottom: 2rem; font-size: 1.1rem;"><%= roomType.getTypeName() %></p>
            
            <form id="bookingForm" action="<%= IConstant.bookingServlet %>" method="get">
                <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                <input type="hidden" id="price-per-night" value="<%= roomType.getPricePerNight() %>">
                <input type="hidden" id="bookingDate" name="bookingDate" value= "">
                <input type="hidden" id="guestId" name="guestId" value="<%= guest.getGuestId() %>">

                <!-- Thông tin khách hàng -->
                <div class="section-header">
                    <h3>Thông Tin <span>Khách Hàng</span></h3>
                </div>
                
                <div class="form-row">
                    <div class="form-group-rental">
                        <label for="fullName"><i class="fas fa-user"></i> Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" value="<%= guest.getFullName() %>" readonly>
                    </div>
                    <div class="form-group-rental">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" value="<%= guest.getEmail() %>" readonly>
                    </div>
                </div>

                <!-- Thời gian lưu trú -->
                <div class="section-header">
                    <h3>Thời Gian <span>Lưu Trú</span></h3>
                </div>
                
                <div class="form-row">
                    <div class="form-group-rental">
                        <label for="check-in"><i class="fas fa-sign-in-alt"></i> Ngày nhận phòng</label>
                        <input type="date" id="check-in" name="checkInDate" value="<%= (checkInValue != null) ? checkInValue : "" %>" required>
                    </div>
                    <div class="form-group-rental">
                        <label for="check-out"><i class="fas fa-sign-out-alt"></i> Ngày trả phòng</label>
                        <input type="date" id="check-out" name="checkOutDate" value="<%= (checkOutValue != null) ? checkOutValue : "" %>" required>
                    </div>
                </div>

                <!-- Dịch vụ đi kèm -->
                <div class="section-header">
                    <h3>Dịch Vụ <span>Đi Kèm</span></h3>
                </div>
                
                <div class="form-group-rental">
                    <div class="service-adder">
                        <div class="form-group-rental">
                            <label for="service-select"><i class="fas fa-list"></i> Chọn dịch vụ</label>
                            <select id="service-select">
                                <option value="">-- Chọn dịch vụ --</option>
                                <% if (services != null && !services.isEmpty()) {
                                    for (Service service : services) {
                                %>
                                <option value="<%= service.getServiceId() %>" data-price="<%= service.getPrice() %>" data-name="<%= service.getServiceName() %>">
                                    <%= service.getServiceName() %> (+<%= currencyFormatter.format(service.getPrice()) %>)
                                </option>
                                <%
                                        }
                                    } %>
                            </select>
                        </div>
                        <button type="button" id="add-service-btn" title="Thêm dịch vụ đã chọn vào danh sách bên dưới">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                </div>

                <div id="selected-services-list"></div>

                <!-- Thông tin thanh toán -->
                <div class="section-header">
                    <h3>Thông Tin <span>Thanh Toán</span></h3>
                </div>
                
                <div class="info-box">
                    <p><i class="fas fa-info-circle"></i> Bạn sẽ thanh toán 50% giá trị đặt phòng làm tiền cọc. Số tiền còn lại sẽ được thanh toán khi trả phòng.</p>
                </div>
                
                <div class="credit-card-section">
                    <h3>Thông Tin <span>Thẻ Thanh Toán</span></h3>
                    
                    <!-- Card Visual Display -->
                    <div class="card-visual">
                        <div class="card-chip"></div>
                        <div class="card-number-display" id="card-number-display">
                            •••• •••• •••• ••••
                        </div>
                        <div class="card-details-display">
                            <div class="card-holder-display">
                                <label>Chủ thẻ</label>
                                <span id="card-holder-display">YOUR NAME</span>
                            </div>
                            <div class="card-expiry-display">
                                <label>Ngày hết hạn</label>
                                <span id="card-expiry-display">MM/YY</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Card Input Form -->
                    <div class="card-form-group">
                        <label for="card-holder"><i class="fas fa-user"></i> Tên chủ thẻ</label>
                        <input type="text" id="card-holder" placeholder="NGUYEN VAN A" maxlength="50">
                    </div>
                    
                    <div class="card-form-group">
                        <label for="card-number"><i class="fas fa-credit-card"></i> Số thẻ</label>
                        <input type="text" id="card-number" placeholder="1234 5678 9012 3456" maxlength="19">
                    </div>
                    
                    <div class="card-row">
                        <div class="card-form-group">
                            <label for="card-month"><i class="fas fa-calendar"></i> Tháng</label>
                            <input type="text" id="card-month" placeholder="MM" maxlength="2">
                        </div>
                        <div class="card-form-group">
                            <label for="card-year"><i class="fas fa-calendar"></i> Năm</label>
                            <input type="text" id="card-year" placeholder="YY" maxlength="2">
                        </div>
                        <div class="card-form-group">
                            <label for="card-cvv"><i class="fas fa-lock"></i> CVV</label>
                            <input type="text" id="card-cvv" placeholder="123" maxlength="4">
                        </div>
                    </div>
                </div>

                <!-- Tổng tiền -->
                <div class="total-price">
                    Tổng cộng: <span id="total-price-value">0 VNĐ</span>
                </div>
                
                <button type="submit" class="btn btn-book" style="width: 100%; margin-top: 2rem; font-size: 1rem; padding: 1rem;">
                    Xác nhận đặt phòng
                </button>
                <input type="hidden" id="totalAmount" name="totalAmount" value="">
            </form>
        </div>
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
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 Luxury Hotel. Bảo lưu mọi quyền.</p>
        </div>
    </div>
</footer>
<script src="script/guest/rentalPage.js"></script>
</body>
</html>