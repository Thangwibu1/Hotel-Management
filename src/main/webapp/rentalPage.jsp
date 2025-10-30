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
    <style>
        /* --- BASIC LUXURY WHITE THEME --- */
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
            line-height: 1.6; 
            color: var(--black);
            background: #fafafa;
            min-height: 100vh;
        }
        
        .container { max-width: 1000px; margin: auto; padding: 0 20px; }
        a { text-decoration: none; color: inherit; }
        
        .header { 
            background: var(--black);
            color: #ffffff;
            padding: 1.5rem 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        
        .logo a { 
            font-size: 1.8em; 
            font-weight: 600; 
            color: var(--gold);
            letter-spacing: 1px;
        }
        
        .main-nav { display: flex; align-items: center; gap: 15px; }
        .main-nav span { color: #ffffff; font-weight: 400; }
        
        .btn { 
            display: inline-block; 
            padding: 10px 24px; 
            border-radius: 4px; 
            border: none; 
            cursor: pointer; 
            font-size: 0.95rem; 
            text-align: center;
            transition: all 0.2s ease;
            font-weight: 500;
        }
        
        .btn:hover { opacity: 0.9; }
        .btn-secondary { background-color: var(--black); color: white; }
        .btn-book { 
            background: var(--gold);
            color: var(--black);
            font-weight: 600;
        }
        
        .footer { 
            background: var(--black);
            color: #999;
            padding: 2rem 0; 
            margin-top: 60px; 
            text-align: center;
            border-top: 3px solid var(--gold);
        }

        /* --- CSS CHO TRANG ĐẶT PHÒNG --- */
        .main-content { padding: 40px 0; }
        
        .booking-form-section { 
            background: #ffffff;
            padding: 45px; 
            border-radius: 8px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid var(--border);
        }
        
        .booking-form-section h2 { 
            margin-top: 0; 
            margin-bottom: 25px; 
            border-bottom: 2px solid var(--gold);
            padding-bottom: 15px; 
            font-size: 1.8em;
            color: var(--black);
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 30px 0 20px 0;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }
        
        .section-header i {
            font-size: 1.3em;
            color: var(--gold);
        }
        
        .section-header h3 {
            color: var(--black);
            font-size: 1.3em;
            margin: 0;
            font-weight: 600;
        }
        
        .form-group-rental { margin-bottom: 25px; }
        
        .form-group-rental label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 500; 
            color: var(--black);
            font-size: 0.95rem;
        }
        
        .form-group-rental input, .form-group-rental select { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid var(--border);
            border-radius: 4px; 
            box-sizing: border-box; 
            font-size: 0.95rem;
            background: #ffffff;
            color: var(--black);
            transition: all 0.2s ease;
        }
        
        .form-group-rental input:focus, .form-group-rental select:focus {
            border-color: var(--gold);
            outline: none;
        }
        
        .form-group-rental input:read-only { 
            background-color: var(--light-gray);
            cursor: not-allowed;
            color: var(--gray);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .total-price { 
            margin-top: 30px; 
            padding: 20px;
            background: var(--light-gray);
            border-radius: 6px;
            border-left: 3px solid var(--gold);
            font-size: 1.5em; 
            font-weight: 600; 
            text-align: right;
            color: var(--black);
        }

        /* === CSS CHO CREDIT CARD === */
        .credit-card-section {
            background: var(--light-gray);
            padding: 25px;
            border-radius: 6px;
            margin: 25px 0;
            border-left: 3px solid var(--gold);
        }
        
        .credit-card-section h3 {
            color: var(--black);
            margin: 0 0 18px 0;
            font-weight: 600;
        }
        
        .card-visual {
            background: linear-gradient(135deg, #d4af37 0%, #f4e4a6 100%);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            position: relative;
            min-height: 200px;
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
            color: var(--dark-bg);
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
            color: var(--dark-bg);
        }
        
        .card-holder-display label, .card-expiry-display label {
            font-size: 0.7em;
            text-transform: uppercase;
            display: block;
            margin-bottom: 5px;
            opacity: 0.7;
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
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 4px;
            background: #ffffff;
            color: var(--black);
            font-size: 0.95rem;
            transition: all 0.2s ease;
        }
        
        .card-form-group input::placeholder {
            color: var(--gray);
        }
        
        .card-form-group input:focus {
            border-color: var(--gold);
            outline: none;
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
            gap: 12px; 
            background: var(--light-gray);
            padding: 14px; 
            border: 1px solid var(--border);
            border-left: 3px solid var(--gold);
            border-radius: 6px; 
            margin-bottom: 12px;
        }
        
        .selected-service-item span { flex-grow: 1; font-weight: 500; color: var(--black); }
        
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
            background: #e8f5e9;
            border-left: 3px solid #4CAF50;
            padding: 18px;
            border-radius: 6px;
            margin: 20px 0;
        }
        
        .info-box i {
            color: #4CAF50;
            margin-right: 8px;
        }
        
        .info-box p {
            margin: 0;
            color: var(--black);
            line-height: 1.6;
        }
    </style>
</head>
<body>

<header class="header">
    <div class="container">
        <div class="logo">
            <a href="<%= IConstant.homeServlet %>">Luxury Hotel</a>
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
            <span style="color: white; margin-right: 15px;">Xin chào, <%= username %>!</span>
            <form style="display: inline;"><button class="btn btn-secondary"><a href="logout">Đăng xuất</a></button></form>
        </nav>
    </div>
</header>

<main class="main-content">
    <div class="container">
        <div class="booking-form-section">
            <h2><i class="fas fa-hotel"></i> Thông tin đặt phòng cho phòng <%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</h2>
            
            <form id="bookingForm" action="<%= IConstant.bookingServlet %>" method="get">
                <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                <input type="hidden" id="price-per-night" value="<%= roomType.getPricePerNight() %>">
                <input type="hidden" id="bookingDate" name="bookingDate" value= "">
                <input type="hidden" id="guestId" name="guestId" value="<%= guest.getGuestId() %>">

                <!-- Thông tin khách hàng -->
                <div class="section-header">
                    <i class="fas fa-user-circle"></i>
                    <h3>Thông tin khách hàng</h3>
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
                    <i class="fas fa-calendar-alt"></i>
                    <h3>Thời gian lưu trú</h3>
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
                    <i class="fas fa-concierge-bell"></i>
                    <h3>Dịch vụ đi kèm</h3>
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
                    <i class="fas fa-credit-card"></i>
                    <h3>Thông tin thanh toán</h3>
                </div>
                
                <div class="info-box">
                    <p><i class="fas fa-info-circle"></i> Bạn sẽ thanh toán 50% giá trị đặt phòng làm tiền cọc. Số tiền còn lại sẽ được thanh toán khi trả phòng.</p>
                </div>
                
                <div class="credit-card-section">
                    <h3><i class="fas fa-credit-card"></i> Thông tin thẻ thanh toán</h3>
                    
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
                    <i class="fas fa-money-bill-wave"></i> Tổng cộng: <span id="total-price-value">0 VNĐ</span>
                </div>
                
                <button type="submit" class="btn btn-book" style="width: 100%; margin-top: 20px; font-size: 1.2rem; padding: 15px;">
                    <i class="fas fa-check-circle"></i> Xác nhận đặt phòng
                </button>
                <input type="hidden" id="totalAmount" name="totalAmount" value="">
            </form>
        </div>
    </div>
</main>

<footer class="footer">
    <p>&copy; 2025 Luxury Hotel. Bảo lưu mọi quyền.</p>
</footer>
<script src="script/guest/rentalPage.js"></script>
</body>
</html>