<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.*, utils.IConstant, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>

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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    <style>
        :root {
            --color-gold: #c9ab81;
            --color-charcoal: #1a1a1a;
            --color-offwhite: #f8f7f5;
            --color-grey: #666;
            --primary-color: #007bff;
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

        h1, h2, h3 {
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

        .booking-info p { margin: 0 0 10px; }
        .booking-info strong { min-width: 120px; display: inline-block; }

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

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th { background-color: #f2f2f2; }

        .service-status { padding: 3px 8px; border-radius: 12px; color: #fff; font-size: 0.8em; }
        .status-0 { background-color: #007bff; } /* Chưa làm */
        .status-1 { background-color: #ffc107; color: #212529; } /* Đang làm */
        .status-2 { background-color: #28a745; } /* Đã làm */
        .status--1 { background-color: #6c757d; } /* Đã hủy */

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 1rem;
            text-align: center;
            font-weight: 700;
            transition: all 0.3s ease;
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

        .no-services {
            text-align: center;
            color: var(--color-grey);
            padding: 20px;
            background: #fafafa;
            border-radius: 5px;
        }

        .form-actions {
            text-align: right;
            margin-top: 30px;
        }

        /* --- CSS CHO TÍNH NĂNG THÊM DỊCH VỤ ĐỘNG (TỪ rentalPage.jsp) --- */
        .form-group-rental { margin-bottom: 20px; }
        .form-group-rental label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        .form-group-rental select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 1rem; }

        .service-adder { display: flex; gap: 10px; align-items: flex-end; }
        .service-adder .form-group-rental { flex-grow: 1; margin-bottom: 0; }
        #add-service-btn { padding: 12px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 1.2rem; line-height: 1; }
        #add-service-btn:hover { background-color: #218838; }

        #selected-services-list { margin-top: 20px; }
        .selected-service-item { display: flex; align-items: center; gap: 10px; background-color: #f9f9f9; padding: 10px; border: 1px solid #eee; border-radius: 4px; margin-bottom: 10px; }
        .selected-service-item span { flex-grow: 1; }
        .service-quantity, .service-date { padding: 8px; border: 1px solid #ddd; border-radius: 4px; width: 80px; font-size: 1rem; }
        .service-date { width: 155px; }
        .remove-service-btn { background: #dc3545; color: white; border: none; border-radius: 50%; width: 30px; height: 30px; cursor: pointer; flex-shrink: 0; font-weight: bold; }
        .remove-service-btn:hover { background: #c82333; }
    </style>
</head>
<body>
<div class="container">
    <a href="<%= request.getContextPath() %>/viewbooking" class="back-link"><i class="fa-solid fa-arrow-left"></i> Quay lại danh sách</a>
    <h1>Chỉnh sửa Dịch vụ</h1>

    <div class="booking-info">
        <h3>Thông tin Đặt phòng</h3>
        <p><strong>Mã đặt phòng:</strong> #<%= booking.getBookingId() %></p>
        <p><strong>Phòng:</strong> <%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</p>
        <p><strong>Nhận phòng:</strong> <%= checkInStr %></p>
        <p><strong>Trả phòng:</strong> <%= checkOutStr %></p>
    </div>

    <form action="<%=IConstant.bookingChangeServlet%>" method="post">
        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>" />
        <input type="hidden" name="action" value="updateServices" />

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
                    case 0: statusText = "Chưa làm"; break;
                    case 1: statusText = "Đang làm"; break;
                    case 2: statusText = "Đã làm"; break;
                    case -1: statusText = "Đã hủy"; break;
                    default: statusText = "Không xác định";
                }
            %>
            <tr>
                <td><%= service.getServiceName() %></td>
                <td><%= bs.getQuantity() %></td>
                <td><%= bs.getServiceDate().format(dtf) %></td>
                <td><span class="service-status status-<%= bs.getStatus() %>"><%= statusText %></span></td>
                <td>
                    <% if (bs.getStatus() == 0) { %>
                    <input type="checkbox" name="cancelService" value="<%= bs.getBookingServiceId() %>" title="Chọn để hủy dịch vụ này" />
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
                        <option value="<%= service.getServiceId() %>" data-price="<%= service.getPrice() %>" data-name="<%= service.getServiceName() %>">
                            <%= service.getServiceName() %> (+<%= currencyFormatter.format(service.getPrice()) %>)
                        </option>
                        <%
                                }
                            } %>
                    </select>
                </div>
                <button type="button" id="add-service-btn" title="Thêm dịch vụ đã chọn vào danh sách bên dưới">+</button>
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

<script>
    // --- Lấy các phần tử DOM ---
    const serviceSelect = document.getElementById('service-select');
    const addServiceBtn = document.getElementById('add-service-btn');
    const selectedServicesList = document.getElementById('selected-services-list');

    // Lấy ngày check-in và check-out từ JSP để giới hạn date picker
    const checkInDate = "<%= booking.getCheckInDate().toLocalDate() %>";
    const checkOutDate = "<%= booking.getCheckOutDate().toLocalDate() %>";

    // --- HÀM XỬ LÝ ---
    function addServiceItem() {
        const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
        if (!selectedOption.value) {
            alert('Vui lòng chọn một dịch vụ!');
            return;
        }

        const serviceId = selectedOption.value;
        const serviceName = selectedOption.dataset.name;
        const servicePrice = selectedOption.dataset.price;

        if (!serviceId || !serviceName || !servicePrice) {
            alert('Dữ liệu dịch vụ không hợp lệ!');
            return;
        }

        // Tạo container cho service item
        const newItem = document.createElement('div');
        newItem.classList.add('selected-service-item');
        newItem.dataset.price = servicePrice;
        newItem.dataset.serviceId = serviceId;

        // Tạo từng element riêng biệt
        const span = document.createElement('span');
        span.textContent = serviceName;

        const quantityInput = document.createElement('input');
        quantityInput.type = 'number';
        quantityInput.value = '1';
        quantityInput.min = '1';
        quantityInput.className = 'service-quantity';
        quantityInput.placeholder = 'Số lượng';

        const dateInput = document.createElement('input');
        dateInput.type = 'date';
        dateInput.className = 'service-date';
        dateInput.required = true;

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'remove-service-btn';
        removeBtn.innerHTML = '&times;';

        const hiddenServiceId = document.createElement('input');
        hiddenServiceId.type = 'hidden';
        hiddenServiceId.name = 'newServiceId';
        hiddenServiceId.value = serviceId;

        const hiddenQuantity = document.createElement('input');
        hiddenQuantity.type = 'hidden';
        hiddenQuantity.name = 'newServiceQuantity';
        hiddenQuantity.value = '1';
        hiddenQuantity.className = 'hidden-quantity';

        const hiddenDate = document.createElement('input');
        hiddenDate.type = 'hidden';
        hiddenDate.name = 'newServiceDate';
        hiddenDate.value = '';
        hiddenDate.className = 'hidden-date';

        // Append tất cả vào newItem
        newItem.appendChild(span);
        newItem.appendChild(quantityInput);
        newItem.appendChild(dateInput);
        newItem.appendChild(removeBtn);
        newItem.appendChild(hiddenServiceId);
        newItem.appendChild(hiddenQuantity);
        newItem.appendChild(hiddenDate);

        // Thêm vào danh sách
        selectedServicesList.appendChild(newItem);

        // Cập nhật và gắn events
        updateSingleServiceDatePicker(newItem.querySelector('.service-date'));
        attachEventsToServiceItem(newItem);

        // Reset select về ban đầu
        serviceSelect.selectedIndex = 0;
    }

    function attachEventsToServiceItem(item) {
        const quantityInput = item.querySelector('.service-quantity');
        const dateInput = item.querySelector('.service-date');
        const removeBtn = item.querySelector('.remove-service-btn');
        const hiddenQuantity = item.querySelector('.hidden-quantity');
        const hiddenDate = item.querySelector('.hidden-date');

        quantityInput.addEventListener('input', () => {
            hiddenQuantity.value = quantityInput.value;
        });
        dateInput.addEventListener('change', () => {
            hiddenDate.value = dateInput.value;
        });
        removeBtn.addEventListener('click', () => {
            item.remove();
        });
    }

    function updateSingleServiceDatePicker(dateInput) {
        // Giới hạn ngày chọn dịch vụ trong khoảng check-in và check-out
        dateInput.min = checkInDate;
        dateInput.max = checkOutDate;

        // Nếu chưa có giá trị hoặc giá trị nằm ngoài khoảng, đặt mặc định là ngày check-in
        if (!dateInput.value || dateInput.value < checkInDate) {
            dateInput.value = checkInDate;
        }
        // Cập nhật giá trị cho hidden input tương ứng
        dateInput.closest('.selected-service-item').querySelector('.hidden-date').value = dateInput.value;
    }

    // --- GẮN SỰ KIỆN ---
    addServiceBtn.addEventListener('click', addServiceItem);

    // Khởi tạo giá trị cho các hidden date input khi trang được tải
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.selected-service-item').forEach(item => {
            const dateInput = item.querySelector('.service-date');
            const hiddenDate = item.querySelector('.hidden-date');
            if(dateInput.value) {
                hiddenDate.value = dateInput.value;
            }
        });
    });
</script>
</body>
</html>