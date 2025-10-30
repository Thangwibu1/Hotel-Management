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
        /* --- General, Header, Footer Styles --- */
        :root { 
            --primary-color: #2c3e50;
            --accent-color: #d4af37;
            --secondary-color: #34495e;
            --light-bg: #ecf0f1;
            --dark-bg: #1a252f;
            --light-text: #fff;
            --dark-text: #2c3e50;
            --border-color: #bdc3c7;
            --success-color: #27ae60;
            --danger-color: #e74c3c;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            line-height: 1.6; 
            color: var(--dark-text); 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container { max-width: 1000px; margin: auto; padding: 0 20px; }
        a { text-decoration: none; color: inherit; }
        
        .header { 
            background: linear-gradient(135deg, #1a252f 0%, #2c3e50 100%);
            color: var(--light-text); 
            padding: 1.2rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        
        .logo a { 
            font-size: 1.8em; 
            font-weight: bold; 
            background: linear-gradient(135deg, #d4af37, #f4e4a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .main-nav { display: flex; align-items: center; gap: 15px; }
        .main-nav span { color: var(--accent-color); font-weight: 500; }
        
        .btn { 
            display: inline-block; 
            padding: 10px 25px; 
            border-radius: 8px; 
            border: none; 
            cursor: pointer; 
            font-size: 1rem; 
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.2); }
        .btn-secondary { background-color: var(--secondary-color); color: white; }
        .btn-book { 
            background: linear-gradient(135deg, var(--accent-color), #f4e4a6);
            color: var(--dark-bg);
            font-weight: bold;
        }
        
        .footer { 
            background: linear-gradient(135deg, #1a252f 0%, #2c3e50 100%);
            color: #fff; 
            padding: 2rem 0; 
            margin-top: 40px; 
            text-align: center;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.3);
        }

        /* --- CSS CHO TRANG ĐẶT PHÒNG --- */
        .main-content { padding: 40px 0; }
        
        .booking-form-section { 
            background: #fff; 
            padding: 50px; 
            border-radius: 20px; 
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .booking-form-section h2 { 
            margin-top: 0; 
            margin-bottom: 30px; 
            border-bottom: 3px solid var(--accent-color);
            padding-bottom: 20px; 
            font-size: 2em;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 35px 0 25px 0;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--light-bg);
        }
        
        .section-header i {
            font-size: 1.5em;
            color: var(--accent-color);
        }
        
        .section-header h3 {
            color: var(--primary-color);
            font-size: 1.5em;
            margin: 0;
        }
        
        .form-group-rental { margin-bottom: 25px; }
        
        .form-group-rental label { 
            display: block; 
            margin-bottom: 10px; 
            font-weight: 600; 
            color: var(--primary-color);
            font-size: 0.95rem;
        }
        
        .form-group-rental input, .form-group-rental select { 
            width: 100%; 
            padding: 14px; 
            border: 2px solid var(--border-color);
            border-radius: 10px; 
            box-sizing: border-box; 
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-group-rental input:focus, .form-group-rental select:focus {
            border-color: var(--accent-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .form-group-rental input:read-only { 
            background-color: var(--light-bg);
            cursor: not-allowed;
            border-color: #ddd;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .total-price { 
            margin-top: 35px; 
            padding: 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            font-size: 1.8em; 
            font-weight: bold; 
            text-align: right;
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        /* === CSS CHO CREDIT CARD === */
        .credit-card-section {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .credit-card-section h3 {
            color: white;
            margin: 0 0 20px 0;
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
            color: white;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .card-form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 8px;
            background: rgba(255,255,255,0.1);
            color: white;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .card-form-group input::placeholder {
            color: rgba(255,255,255,0.5);
        }
        
        .card-form-group input:focus {
            border-color: var(--accent-color);
            background: rgba(255,255,255,0.15);
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
            padding: 14px 25px; 
            background: linear-gradient(135deg, var(--success-color), #2ecc71);
            color: white; 
            border: none; 
            border-radius: 10px; 
            cursor: pointer; 
            font-size: 1.3rem; 
            line-height: 1;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
        }
        
        #add-service-btn:hover { 
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
        }
        
        #selected-services-list { margin-top: 20px; }
        
        .selected-service-item { 
            display: flex; 
            align-items: center; 
            gap: 15px; 
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 15px; 
            border: 2px solid var(--border-color);
            border-radius: 12px; 
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        
        .selected-service-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        
        .selected-service-item span { flex-grow: 1; font-weight: 500; color: var(--primary-color); }
        
        .service-quantity, .service-date { 
            padding: 10px; 
            border: 2px solid var(--border-color);
            border-radius: 8px; 
            width: 80px; 
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .service-quantity:focus, .service-date:focus {
            border-color: var(--accent-color);
            outline: none;
        }
        
        .service-date { width: 155px; }
        
        .remove-service-btn { 
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: white; 
            border: none; 
            border-radius: 50%; 
            width: 35px; 
            height: 35px; 
            cursor: pointer; 
            flex-shrink: 0; 
            font-weight: bold;
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }
        
        .remove-service-btn:hover { 
            transform: rotate(90deg);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.4);
        }
        
        .info-box {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            border-left: 5px solid var(--success-color);
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
        }
        
        .info-box i {
            color: var(--success-color);
            margin-right: 10px;
        }
        
        .info-box p {
            margin: 0;
            color: var(--primary-color);
            line-height: 1.8;
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