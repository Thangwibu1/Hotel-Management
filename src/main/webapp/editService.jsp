<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList, model.*, utils.IConstant, java.time.format.DateTimeFormatter" %>

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

    // Định dạng ngày để hiển thị
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String checkInStr = booking.getCheckInDate().format(dtf);
    String checkOutStr = booking.getCheckOutDate().format(dtf);
%>

<html>
<head>
    <title>Chỉnh sửa Dịch vụ - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <style>
        :root {
            --color-gold: #c9ab81;
            --color-charcoal: #1a1a1a;
            --color-offwhite: #f8f7f5;
            --color-grey: #666;
        }

        body {
            font-family: "Lato", sans-serif;
            background-color: var(--color-offwhite);
            color: var(--color-charcoal);
            line-height: 1.6;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 900px;
            margin: 20px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
        }

        h1,
        h2,
        h3 {
            font-family: "Playfair Display", serif;
        }

        h1 {
            text-align: center;
            color: var(--color-charcoal);
            margin-bottom: 10px;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: var(--color-gold);
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .booking-info {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 5px solid var(--color-gold);
        }

        .booking-info p {
            margin: 0 0 10px;
        }

        .booking-info strong {
            min-width: 120px;
            display: inline-block;
        }

        .section-title {
            border-bottom: 2px solid var(--color-gold);
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        th,
        td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .service-status {
            padding: 3px 8px;
            border-radius: 12px;
            color: #fff;
            font-size: 0.8em;
        }

        .status-0 {
            background-color: #007bff;
        }

        /* Chưa làm */
        .status-1 {
            background-color: #ffc107;
            color: #212529;
        }

        /* Đang làm */
        .status-2 {
            background-color: #28a745;
        }

        /* Đã làm */
        .status--1 {
            background-color: #6c757d;
        }

        /* Đã hủy */
        .btn {
            display: inline-block;
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 0.9rem;
            text-align: center;
            font-weight: 700;
            transition: all 0.3s ease;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-primary {
            background-color: var(--color-gold);
            color: #fff;
            border-color: var(--color-gold);
        }

        .btn-primary:hover {
            background-color: transparent;
            color: var(--color-gold);
        }

        .service-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .service-item:nth-child(odd) {
            background-color: #fdfdfd;
        }

        .service-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .service-controls input[type="number"] {
            width: 60px;
            padding: 5px;
            border-radius: 3px;
            border: 1px solid #ccc;
        }

        .service-controls input[type="date"] {
            padding: 4px;
            border-radius: 3px;
            border: 1px solid #ccc;
        }

        .no-services {
            text-align: center;
            color: var(--color-grey);
            padding: 20px;
            background: #fafafa;
            border-radius: 5px;
        }

        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="javascript:history.back()" class="back-link"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    <h1>Chỉnh sửa Dịch vụ</h1>

    <div class="booking-info">
        <h3>Thông tin Đặt phòng</h3>
        <p>
            <strong>Mã đặt phòng:</strong> #<%= booking.getBookingId() %>
        </p>
        <p>
            <strong>Phòng:</strong> <%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)
        </p>
        <p><strong>Nhận phòng:</strong> <%= checkInStr %></p>
        <p><strong>Trả phòng:</strong> <%= checkOutStr %></p>
    </div>

    <form action="" method="post">
        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />

        <h2 class="section-title">Các dịch vụ đã chọn</h2>
        <% if (chosenServices != null && !chosenServices.isEmpty()) { %>
        <table>
            <thead>
            <tr>
                <th>Tên dịch vụ</th>
                <th>Số lượng</th>
                <th>Ngày sử dụng</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <% for (BookingService bs : chosenServices) {
                Service service = allServices.stream().filter(s -> s.getServiceId() == bs.getServiceId()).findFirst().orElse(null);
                if (service == null) continue;
                String statusText = "Không xác định";
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
                }
            %>
            <tr>
                <td><%= service.getServiceName() %></td>
                <td><%= bs.getQuantity() %></td>
                <td><%= bs.getServiceDate().format(dtf) %></td>
                <td>
                    <span class="service-status status-<%= bs.getStatus() %>"><%= statusText %></span>
                </td>
                <td>
                    <%-- Chỉ cho phép hủy dịch vụ có status = 0 (Chưa làm) --%>
                    <% if (bs.getStatus() == 0) { %>
                    <input type="checkbox" name="cancelService" value="<%= bs.getBookingServiceId() %>" title="Chọn để hủy dịch vụ này" /> Hủy
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

        <h2 class="section-title">Thêm dịch vụ mới</h2>
        <div id="service-list">
            <% if (allServices != null) {
                for (Service service : allServices) { %>
            <div class="service-item">
                <div class="service-info">
                    <input type="checkbox" name="serviceId" value="<%= service.getServiceId() %>" id="service-<%= service.getServiceId() %>" onchange="toggleService(this)" />
                    <label for="service-<%= service.getServiceId() %>">
                        <strong><%= service.getServiceName() %></strong> - <%= String.format("%,.0f", service.getPrice()) %> VNĐ
                    </label>
                </div>
                <div class="service-controls" id="controls-<%= service.getServiceId() %>" style="display: none">
                    <label>Số lượng:</label>
                    <input type="number" name="quantity_<%= service.getServiceId() %>" value="1" min="1" />
                    <label>Ngày:</label>
                    <input type="date" name="serviceDate_<%= service.getServiceId() %>" min="<%= booking.getCheckInDate().toLocalDate() %>" max="<%= booking.getCheckOutDate().toLocalDate() %>" value="<%= booking.getCheckInDate().toLocalDate() %>" />
                </div>
            </div>
            <% } 
            } %>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-floppy-disk"></i> Cập nhật Dịch vụ
            </button>
        </div>
    </form>
</div>

<script>
    function toggleService(checkbox) {
        const serviceId = checkbox.value;
        const controls = document.getElementById("controls-" + serviceId);
        if (checkbox.checked) {
            controls.style.display = "flex";
        } else {
            controls.style.display = "none";
        }
    }

    // Đảm bảo ngày tối thiểu và tối đa cho các input date
    document.addEventListener("DOMContentLoaded", function () {
        const dateInputs = document.querySelectorAll('input[type="date"]');
        const checkInDate = "<%= booking.getCheckInDate().toLocalDate() %>";
        // Dịch vụ có thể dùng đến ngày cuối cùng trước khi trả phòng
        const checkOutDate = "<%= booking.getCheckOutDate().toLocalDate() %>";

        dateInputs.forEach((input) => {
            input.min = checkInDate;
            input.max = checkOutDate;
            // Đặt giá trị mặc định là ngày nhận phòng
            if (!input.value) {
                input.value = checkInDate;
            }
        });
    });
</script>
</body>
</html>