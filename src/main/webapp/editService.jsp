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
    <style>
        /* === BASIC LUXURY WHITE THEME === */
        :root {
            --gold: #d4af37;
            --black: #1a1a1a;
            --gray: #666;
            --light-gray: #f8f8f8;
            --border: #e0e0e0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fafafa;
            color: var(--black);
            line-height: 1.6;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 1000px;
            margin: 20px auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid var(--border);
        }

        h1, h2, h3 {
            font-family: 'Segoe UI', sans-serif;
        }

        h1 {
            text-align: center;
            color: var(--black);
            margin-bottom: 25px;
            font-size: 2rem;
            font-weight: 600;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: var(--gold);
            font-weight: 500;
            padding: 8px 15px;
            border: 1px solid var(--gold);
            border-radius: 4px;
            transition: all 0.2s ease;
        }

        .back-link:hover {
            background: var(--gold);
            color: var(--black);
        }

        .booking-info {
            background: var(--light-gray);
            padding: 25px;
            border-radius: 6px;
            margin-bottom: 30px;
            border-left: 3px solid var(--gold);
        }

        .booking-info h3 {
            color: var(--black);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .booking-info p {
            margin: 0 0 12px;
        }

        .booking-info strong {
            min-width: 150px;
            display: inline-block;
            color: var(--gray);
        }

        .section-title {
            border-bottom: 2px solid var(--gold);
            padding-bottom: 12px;
            margin-bottom: 20px;
            color: var(--black);
            font-size: 1.5em;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
            background: #ffffff;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        th {
            background: var(--light-gray);
            color: var(--black);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }

        tbody tr {
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: var(--light-gray);
        }

        .service-status {
            padding: 5px 10px;
            border-radius: 4px;
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
            padding: 10px 24px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            text-align: center;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn:hover { opacity: 0.9; }

        .btn-primary {
            background: var(--gold);
            color: var(--black);
        }

        .no-services {
            text-align: center;
            color: var(--gray);
            padding: 35px;
            background: var(--light-gray);
            border-radius: 6px;
        }

        .form-actions {
            text-align: right;
            margin-top: 35px;
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
            padding: 12px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 0.95rem;
            background: #ffffff;
            color: var(--black);
            transition: all 0.2s ease;
        }

        .form-group-rental select:focus {
            border-color: var(--gold);
            outline: none;
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
            border-radius: 4px;
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
            gap: 12px;
            background: var(--light-gray);
            padding: 14px;
            border: 1px solid var(--border);
            border-left: 3px solid var(--gold);
            border-radius: 6px;
            margin-bottom: 12px;
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
            background: #ffffff;
            color: var(--black);
            transition: border-color 0.2s ease;
        }

        .service-quantity:focus, .service-date:focus {
            border-color: var(--gold);
            outline: none;
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
<div class="container">
    <span>
        <i class="fa-solid fa-arrow-left back-link" style="display: inline"></i>
        <form style="display: inline" action="<%=request.getContextPath()%>/viewBooking" method="post">
            <input type="hidden" name="guestId" value="${sessionScope.userGuest.getGuestId()}">
            <input type="submit" value="Quay lai danh sach" class="back-link" style="border: none; background: none">
        </form>
    </span>
    <h1>Chỉnh sửa Dịch vụ</h1>

    <div class="booking-info">
        <h3>Thông tin Đặt phòng</h3>
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

        <h2 class="section-title">Các dịch vụ đã chọn</h2>
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

        <h2 class="section-title">Thêm dịch vụ mới</h2>
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