<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page
        import="java.util.List, model.*, utils.IConstant, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>

<%
    // Lấy dữ liệu đã được gửi từ GetBookingInfoController
    Booking booking = (Booking) request.getAttribute("booking");
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    List<BookingService> chosenServices = (List<BookingService>) request.getAttribute("chosenServices");
    List<Service> allServices = (List<Service>) request.getAttribute("allServices");

    // Kiểm tra nếu không có booking thì không hiển thị gì
    if (booking == null) {
        response.sendRedirect(request.getContextPath() + "/viewbooking");
        return;
    }

    // Định dạng ngày và tiền tệ
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String checkInStr = booking.getCheckInDate().format(dtf);
    String checkOutStr = booking.getCheckOutDate().format(dtf);
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<html>
<head>
    <title>Chỉnh sửa Dịch vụ - Luxury Hotel</title>
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
            --secondary-color: #6c757d;
            
            --font-serif: 'Cormorant Garamond', serif;
            --font-sans: 'Montserrat', sans-serif;
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
        
        .header-container { 
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
            gap: 10px; 
        }
        
        .main-nav span { 
            color: var(--white); 
            font-size: 0.9rem;
            font-weight: 300;
            letter-spacing: 0.5px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: var(--white);
            padding: 3rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        h1 {
            font-family: var(--font-serif);
            text-align: center;
            color: var(--black);
            margin-bottom: 2rem;
            font-size: 3rem;
            font-weight: 700;
        }
        
        h1 span {
            color: var(--gold);
        }

        .back-link {
            display: inline-block;
            margin-bottom: 2rem;
            color: var(--gold);
            font-weight: 500;
            padding: 0.75rem 2rem;
            border: 2px solid var(--gold);
            border-radius: 6px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.85rem;
        }

        .back-link:hover {
            background: var(--gold);
            color: var(--black);
        }

        .booking-info {
            background: var(--gray-light);
            padding: 2rem;
            margin-bottom: 3rem;
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .booking-info h3 {
            font-family: var(--font-serif);
            color: var(--black);
            margin-bottom: 1.5rem;
            font-weight: 600;
            font-size: 1.8rem;
        }
        
        .booking-info h3 span {
            color: var(--gold);
        }

        .booking-info p {
            margin: 0 0 12px;
        }

        .booking-info strong {
            min-width: 180px;
            display: inline-block;
            color: var(--gray);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .section-title {
            font-family: var(--font-serif);
            border-bottom: 1px solid var(--border);
            padding-bottom: 1rem;
            margin-bottom: 2rem;
            color: var(--black);
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        .section-title span {
            color: var(--gold);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
            background: var(--white);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        th {
            background: linear-gradient(135deg, var(--black) 0%, #2c2c2c 100%);
            color: var(--white);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
            border-bottom: none;
        }

        tbody tr {
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: var(--off-white);
            transform: scale(1.002);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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

        .btn {
            display: inline-block;
            padding: 0.75rem 2rem;
            border: 2px solid;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            text-align: center;
            font-weight: 500;
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
        
        .btn-secondary {
            background: var(--secondary-color);
            color: white;
            border-color: var(--secondary-color);
        }
        
        .btn-secondary:hover {
            background: transparent;
            color: var(--secondary-color);
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

        .no-services {
            text-align: center;
            color: var(--gray);
            padding: 3rem;
            background: var(--gray-light);
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .form-actions {
            text-align: right;
            margin-top: 3rem;
        }

        /* --- CSS CHO TÍNH NĂNG THÊM DỊCH VỤ ĐỘNG --- */
        .form-group-rental {
            margin-bottom: 25px;
        }

        .form-group-rental label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--black);
        }

        .form-group-rental select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            background: var(--white);
            color: var(--black);
            transition: all 0.3s ease;
            font-family: var(--font-sans);
        }

        .form-group-rental select:focus {
            border-color: var(--gold);
            outline: none;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }

        .service-adder {
            display: flex;
            gap: 10px;
            align-items: flex-end;
        }

        .service-adder .form-group-rental {
            flex-grow: 1;
            margin-bottom: 0;
        }

        #add-service-btn {
            padding: 12px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1.1rem;
            line-height: 1;
            transition: all 0.2s ease;
        }

        #add-service-btn:hover {
            opacity: 0.9;
        }

        #selected-services-list {
            margin-top: 20px;
        }

        .selected-service-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            background: var(--white);
            padding: 1rem;
            border: 1px solid var(--border);
            border-radius: 6px;
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
            padding: 0.5rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            width: 80px;
            font-size: 0.95rem;
            background: var(--white);
            color: var(--black);
            transition: all 0.3s ease;
            font-family: var(--font-sans);
        }

        .service-quantity:focus, .service-date:focus {
            border-color: var(--gold);
            outline: none;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }

        .service-date {
            width: 155px;
        }

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
    </style>
</head>
<body>

<header class="header">
    <div class="header-container">
        <div class="logo">
            <a href="<%= IConstant.homeServlet %>">LUXURY <span>HOTEL</span></a>
        </div>
        <nav class="main-nav">
            <% 
                Guest currentGuest = (Guest) session.getAttribute("userGuest");
                if (currentGuest != null) { 
            %>
            <span style="color: white; margin-right: 15px;">Xin chào, <%= currentGuest.getFullName() %>!</span>
            <form action="<%= IConstant.viewBookingServlet %>" method="post" style="display: inline;">
                <input type="hidden" name="guestId" value="<%= currentGuest.getGuestId() %>">
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
    <span>
        <i class="fa-solid fa-arrow-left back-link" style="display: inline"></i>
        <form style="display: inline" action="<%=request.getContextPath()%>/viewBooking" method="post">
            <input type="hidden" name="guestId" value="${sessionScope.userGuest.getGuestId()}">
            <input type="submit" value="Quay lai danh sach" class="back-link" style="border: none; background: none">
        </form>
    </span>
    <h1>Chỉnh Sửa <span>Dịch Vụ</span></h1>

    <div class="booking-info">
        <h3>Thông Tin <span>Đặt Phòng</span></h3>
        <p><strong>Mã đặt phòng:</strong> #<%= booking.getBookingId() %>
        </p>
        <p><strong>Phòng:</strong> <%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</p>
        <p id="checkin-date"><strong>Nhận phòng:</strong> <%= checkInStr %>
        </p>
        <p id="checkout-date"><strong>Trả phòng:</strong> <%= checkOutStr %>
        </p>
    </div>

    <form action="<%=IConstant.bookingChangeServlet%>" method="post">
        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>"/>
        <input type="hidden" name="action" value="updateServices"/>

        <h2 class="section-title">Các Dịch Vụ <span>Đã Chọn</span></h2>
        <% if (chosenServices != null && !chosenServices.isEmpty()) { %>
        <table>
            <thead>
            <tr>
                <th>Tên dịch vụ</th>
                <th>Số lượng</th>
                <th>Ngày sử dụng</th>
                <th>Trạng thái</th>
                <th>Hủy</th>
            </tr>
            </thead>
            <tbody>
            <% for (BookingService bs : chosenServices) {
                Service service = allServices.stream().filter(s -> s.getServiceId() == bs.getServiceId()).findFirst().orElse(null);
                if (service == null) continue;
                String statusText;
                switch (bs.getStatus()) {
                    case 0:
                        statusText = "Chưa làm";
                        break;
                    case 1:
                        statusText = "Đang làm";
                        break;
                    case 2:
                        statusText = "Đã làm";
                        break;
                    case -1:
                        statusText = "Đã hủy";
                        break;
                    default:
                        statusText = "Không xác định";
                }
            %>
            <tr>
                <td><%= service.getServiceName() %>
                </td>
                <td><%= bs.getQuantity() %>
                </td>
                <td><%= bs.getServiceDate().format(dtf) %>
                </td>
                <td><span class="service-status status-<%= bs.getStatus() %>"><%= statusText %></span></td>
                <td>
                    <% if (bs.getStatus() == 0) { %>
                    <input type="checkbox" name="cancelService" value="<%= bs.getBookingServiceId() %>"
                           title="Chọn để hủy dịch vụ này"/>
                    <% } else { %>
                    <span style="color: var(--color-grey)">Đã xử lý</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p class="no-services">Chưa có dịch vụ nào được chọn cho lần đặt phòng này.</p>
        <% } %>

        <hr style="margin: 30px 0;">

        <h2 class="section-title">Thêm <span>Dịch Vụ Mới</span></h2>
        <div class="form-group-rental">
            <div class="service-adder">
                <div class="form-group-rental">
                    <label for="service-select">Chọn dịch vụ</label>
                    <select id="service-select">
                        <option value="">-- Chọn --</option>
                        <% if (allServices != null && !allServices.isEmpty()) {
                            for (Service service : allServices) {
                        %>
                        <option value="<%= service.getServiceId() %>" data-price="<%= service.getPrice() %>"
                                data-name="<%= service.getServiceName() %>">
                            <%= service.getServiceName() %> (+<%= currencyFormatter.format(service.getPrice()) %>)
                        </option>
                        <%
                                }
                            } %>
                    </select>
                </div>
                <button type="button" id="add-service-btn" title="Thêm dịch vụ đã chọn vào danh sách bên dưới">+
                </button>
            </div>
        </div>

        <div id="selected-services-list">
            <!-- Dịch vụ mới thêm sẽ xuất hiện ở đây -->
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-floppy-disk"></i> Cập nhật Dịch vụ
            </button>
        </div>
    </form>
</div>

<script src="./script/guest/editService.js">

</script>
</body>
</html>