<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.*" %>
<%@ page import="utils.IConstant" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    Room room = (Room) request.getAttribute("room");
    RoomType roomType = (RoomType) request.getAttribute("roomType");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Double paidAmount = (Double) request.getAttribute("paidAmount");
    Double remainingAmount = (Double) request.getAttribute("remainingAmount");
    Long numberOfNights = (Long) request.getAttribute("numberOfNights");
    Double roomTotal = (Double) request.getAttribute("roomTotal");
    Double servicesTotal = (Double) request.getAttribute("servicesTotal");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double taxRate = (Double) request.getAttribute("taxRate");
    Double taxAmount = (Double) request.getAttribute("taxAmount");
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    
    // Kiểm tra trạng thái: đã checkout thành công hay chưa thanh toán đủ
    boolean isCheckoutSuccess = (successMessage != null);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isCheckoutSuccess ? "Check-out Thành Công" : "Thông Báo Thanh Toán" %> - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #1a1a1a;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        .card {
            background: #2a2a2a;
            border-radius: 8px;
            border: 1px solid #3a3a3a;
            overflow: hidden;
            margin-bottom: 20px;
        }

        .card-header {
            background: <%= isCheckoutSuccess ? "#2d3748" : "#3a2a2a" %>;
            color: white;
            padding: 30px;
            text-align: center;
            border-bottom: 1px solid #3a3a3a;
        }

        .card-header .icon {
            font-size: 60px;
            margin-bottom: 15px;
            color: <%= isCheckoutSuccess ? "#48bb78" : "#f56565" %>;
        }

        .card-header h1 {
            font-size: 28px;
            margin-bottom: 8px;
            color: #ffffff;
        }

        .card-header p {
            font-size: 14px;
            color: #a0aec0;
        }

        .card-body {
            padding: 30px;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 15px;
            border-left: 3px solid;
        }

        .alert-success {
            background: #1a3a2a;
            color: #48bb78;
            border-left-color: #48bb78;
        }

        .alert-error {
            background: #3a1a1a;
            color: #f56565;
            border-left-color: #f56565;
        }

        .alert i {
            font-size: 24px;
        }

        .detail-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #3a3a3a;
        }

        .detail-section:last-child {
            border-bottom: none;
        }

        .detail-section h2 {
            color: #e2e8f0;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #3a3a3a;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-item strong {
            color: #cbd5e0;
            font-weight: 500;
        }

        .detail-item span {
            color: #a0aec0;
            text-align: right;
        }

        .summary-box {
            background: #1a1a1a;
            padding: 20px;
            border-radius: 6px;
            margin-top: 15px;
            border: 1px solid #3a3a3a;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 15px;
            color: #cbd5e0;
        }

        .summary-item.total {
            border-top: 1px solid #3a3a3a;
            padding-top: 15px;
            margin-top: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #e2e8f0;
        }

        .invoice-box {
            background: #1a1a1a;
            border: 1px solid #3a3a3a;
            color: #e2e8f0;
            padding: 20px;
            border-radius: 6px;
            margin-top: 20px;
        }

        .invoice-box h3 {
            font-size: 20px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
        }

        .invoice-box .invoice-info {
            background: #2a2a2a;
            padding: 15px;
            border-radius: 6px;
        }

        .invoice-box .invoice-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            color: #cbd5e0;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            justify-content: center;
        }

        .btn {
            padding: 12px 30px;
            border: 1px solid #3a3a3a;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #2d3748;
            color: white;
            border-color: #4a5568;
        }

        .btn-primary:hover {
            background: #4a5568;
            border-color: #718096;
        }

        .btn-danger {
            background: #742a2a;
            color: white;
            border-color: #9b2c2c;
        }

        .btn-danger:hover {
            background: #9b2c2c;
            border-color: #c53030;
        }

        .btn-secondary {
            background: #3a3a3a;
            color: #cbd5e0;
            border-color: #4a4a4a;
        }

        .btn-secondary:hover {
            background: #4a4a4a;
            border-color: #5a5a5a;
        }

        .highlight {
            font-weight: bold;
            color: <%= isCheckoutSuccess ? "#48bb78" : "#f56565" %>;
            font-size: 18px;
        }

        @media (max-width: 768px) {
            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="card-header">
            <div class="icon">
                <% if (isCheckoutSuccess) { %>
                    <i class="fas fa-check-circle"></i>
                <% } else { %>
                    <i class="fas fa-exclamation-triangle"></i>
                <% } %>
            </div>
            <h1>
                <% if (isCheckoutSuccess) { %>
                    Check-out Thành Công!
                <% } else { %>
                    Cảnh Báo Thanh Toán
                <% } %>
            </h1>
            <p>Booking #<%= booking.getBookingId() %> - Phòng <%= room.getRoomNumber() %></p>
        </div>

        <div class="card-body">
            <!-- Thông báo -->
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= successMessage %></span>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span><%= errorMessage %></span>
                </div>
            <% } %>

            <!-- Thông tin booking -->
            <div class="detail-section">
                <h2><i class="fas fa-info-circle"></i> Thông Tin Booking</h2>
                <div class="detail-item">
                    <strong>Mã booking:</strong>
                    <span>#<%= booking.getBookingId() %></span>
                </div>
                <div class="detail-item">
                    <strong>Phòng:</strong>
                    <span><%= room.getRoomNumber() %> - <%= roomType.getTypeName() %></span>
                </div>
                <div class="detail-item">
                    <strong>Check-in:</strong>
                    <span><%= IConstant.localDateFormat.format(booking.getCheckInDate()) %></span>
                </div>
                <div class="detail-item">
                    <strong>Check-out:</strong>
                    <span><%= IConstant.localDateFormat.format(booking.getCheckOutDate()) %></span>
                </div>
                <% if (numberOfNights != null) { %>
                <div class="detail-item">
                    <strong>Số đêm:</strong>
                    <span><%= numberOfNights %> đêm</span>
                </div>
                <% } %>
            </div>

            <!-- Tổng kết thanh toán -->
            <div class="detail-section">
                <h2><i class="fas fa-calculator"></i> Tổng Kết Thanh Toán</h2>
                <div class="summary-box">
                    <% if (roomTotal != null) { %>
                    <div class="summary-item">
                        <span>Tiền phòng:</span>
                        <span><%= currencyFormatter.format(roomTotal) %></span>
                    </div>
                    <% } %>
                    
                    <% if (servicesTotal != null && servicesTotal > 0) { %>
                    <div class="summary-item">
                        <span>Tiền dịch vụ:</span>
                        <span><%= currencyFormatter.format(servicesTotal) %></span>
                    </div>
                    <% } %>
                    
                    <% if (subtotal != null) { %>
                    <div class="summary-item">
                        <span>Tổng phụ:</span>
                        <span><%= currencyFormatter.format(subtotal) %></span>
                    </div>
                    <% } %>
                    
                    <% if (taxAmount != null && taxAmount > 0) { %>
                    <div class="summary-item">
                        <span>Thuế (<%= String.format("%.0f", taxRate) %>%):</span>
                        <span><%= currencyFormatter.format(taxAmount) %></span>
                    </div>
                    <% } %>
                    
                    <div class="summary-item total">
                        <span>Tổng chi phí (Bao gồm thuế):</span>
                        <span><%= currencyFormatter.format(totalAmount) %></span>
                    </div>
                    
                    <div class="summary-item" style="color: #28a745;">
                        <span><i class="fas fa-check-circle"></i> Đã thanh toán:</span>
                        <span><%= currencyFormatter.format(paidAmount) %></span>
                    </div>
                    
                    <% if (remainingAmount != null && remainingAmount > 0) { %>
                    <div class="summary-item" style="color: #dc3545; font-weight: bold; background: #fff3cd; padding: 15px; border-radius: 8px; margin-top: 10px;">
                        <span><i class="fas fa-exclamation-circle"></i> Còn thiếu:</span>
                        <span class="highlight"><%= currencyFormatter.format(remainingAmount) %></span>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Invoice - chỉ hiển thị nếu checkout thành công -->
            <% if (invoice != null && isCheckoutSuccess) { %>
            <div class="invoice-box">
                <h3><i class="fas fa-file-invoice"></i> Hóa Đơn</h3>
                <div class="invoice-info">
                    <div class="invoice-item">
                        <span>Ngày xuất:</span>
                        <span><%= invoice.getIssueDate() %></span>
                    </div>
                    <div class="invoice-item">
                        <span>Tổng tiền:</span>
                        <span><%= currencyFormatter.format(invoice.getTotalAmount()) %></span>
                    </div>
                    <div class="invoice-item">
                        <span>Trạng thái:</span>
                        <span><%= invoice.getStatus() %></span>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Nút hành động -->
            <div class="button-group">
                <% if (!isCheckoutSuccess && remainingAmount > 0) { %>
                    <!-- Nếu chưa thanh toán đủ, chuyển đến trang thanh toán -->
                    <form action="../paymentRemain" method="post" style="display: inline;">
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-credit-card"></i>
                            Đi Thanh Toán Ngay
                        </button>
                    </form>
                <% } else { %>
                    <!-- Nếu đã checkout thành công -->
                    <button onclick="window.print()" class="btn btn-primary">
                        <i class="fas fa-print"></i>
                        In Hóa Đơn
                    </button>
                <% } %>
                
                <button onclick="history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Quay Lại
                </button>
            </div>
        </div>
    </div>
</div>

</body>
</html>

