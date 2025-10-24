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
        :root { --primary-color: #007bff; --secondary-color: #6c757d; --dark-bg: #222; --light-text: #fff; --dark-text: #333; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; line-height: 1.6; color: var(--dark-text); background-color: #f4f4f4; }
        .container { max-width: 900px; margin: auto; padding: 0 20px; }
        a { text-decoration: none; color: inherit; }
        .header { background-color: var(--dark-bg); color: var(--light-text); padding: 1rem 0; }
        .header .container { display: flex; justify-content: space-between; align-items: center; }
        .logo a { font-size: 1.5em; font-weight: bold; }
        .main-nav { display: flex; align-items: center; }
        .main-nav form { margin-left: 10px; }
        .btn { display: inline-block; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-size: 1rem; text-align: center; }
        .btn-secondary { background-color: var(--secondary-color); color: white; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-info { background-color: #17a2b8; color: black; }
        .btn-book { background-color: var(--primary-color); color: var(--light-text); }
        .footer { background: #333; color: #fff; padding: 2rem 0; margin-top: 40px; text-align: center;}

        /* --- CSS CHO TRANG ĐẶT PHÒNG --- */
        .main-content { padding: 40px 0; }
        .booking-form-section { background: #fff; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .booking-form-section h2 { margin-top: 0; margin-bottom: 25px; border-bottom: 2px solid #eee; padding-bottom: 15px; font-size: 1.8em; }
        .form-group-rental { margin-bottom: 20px; }
        .form-group-rental label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        .form-group-rental input, .form-group-rental select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 1rem; }
        .form-group-rental input:read-only { background-color: #e9ecef; cursor: not-allowed; }
        .total-price { margin-top: 25px; padding-top: 20px; border-top: 2px solid #eee; font-size: 1.5em; font-weight: bold; text-align: right; }

        /* === CSS CHO TÍNH NĂNG THÊM DỊCH VỤ ĐỘNG === */
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
            <h2>Thông tin đặt phòng cho phòng <%= room.getRoomNumber() %> (<%= roomType.getTypeName() %>)</h2>
            <form id="bookingForm" action="<%= IConstant.bookingServlet %>" method="get">
                <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                <input type="hidden" id="price-per-night" value="<%= roomType.getPricePerNight() %>">
                <input type="hidden" id="bookingDate" name="bookingDate" value= "">
                <input type="hidden" id="guestId" name="guestId" value="<%= guest.getGuestId() %>">

                <div class="form-group-rental">
                    <label for="fullName">Họ và tên</label>
                    <input type="text" id="fullName" name="fullName" value="<%= guest.getFullName() %>" readonly>
                </div>
                <div class="form-group-rental">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= guest.getEmail() %>" readonly>
                </div>
                <div class="form-group-rental">
                    <label for="check-in">Ngày nhận phòng</label>
                    <input type="date" id="check-in" name="checkInDate" value="<%= (checkInValue != null) ? checkInValue : "" %>" required>
                </div>
                <div class="form-group-rental">
                    <label for="check-out">Ngày trả phòng</label>
                    <input type="date" id="check-out" name="checkOutDate" value="<%= (checkOutValue != null) ? checkOutValue : "" %>" required>
                </div>

                <hr style="margin: 30px 0;">

                <div class="form-group-rental">
                    <label>Thêm dịch vụ đi kèm</label>
                    <div class="service-adder">
                        <div class="form-group-rental">
                            <label for="service-select">Chọn dịch vụ</label>
                            <select id="service-select">
                                <option value="">-- Chọn --</option>
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
                        <button type="button" id="add-service-btn" title="Thêm dịch vụ đã chọn vào danh sách bên dưới">+</button>
                    </div>
                </div>

                <div id="selected-services-list"></div>

                <div class="total-price">
                    Tổng cộng: <span id="total-price-value">0 VNĐ</span>
                </div>
                <button type="submit" class="btn btn-book" style="width: 100%; margin-top: 20px;">Xác nhận đặt phòng</button>
                <input type="hidden" id="totalAmount" name="totalAmount" value="">
            </form>
        </div>
    </div>
</main>

<footer class="footer">
    <p>&copy; 2025 Luxury Hotel. Bảo lưu mọi quyền.</p>
</footer>

<script>
    // --- Lấy các phần tử DOM chính ---
    // --- Lấy các phần tử DOM chính ---
    // --- Lấy các phần tử DOM chính ---
    document.addEventListener('DOMContentLoaded', function () {
        console.log('✅ DOM loaded successfully');

        const checkInInput = document.getElementById('check-in');
        const checkOutInput = document.getElementById('check-out');
        const totalPriceElement = document.getElementById('total-price-value');
        const pricePerNight = parseFloat(document.getElementById('price-per-night').value);
        const today = new Date().toISOString().split('T')[0];
        const bookingForm = document.getElementById('bookingForm');
        const bookingDateInput = document.getElementById('bookingDate');



        const serviceSelect = document.getElementById('service-select');
        const addServiceBtn = document.getElementById('add-service-btn');
        const selectedServicesList = document.getElementById('selected-services-list');

        console.log('🔍 Checking elements:', {
            checkInInput,
            checkOutInput,
            serviceSelect,
            addServiceBtn,
            selectedServicesList
        });

        checkInInput.setAttribute('min', today);

        // --- CÁC HÀM XỬ LÝ ---

        function addServiceItem() {
            console.log('🔵 addServiceItem được gọi');



            const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
            console.log('Selected option:', selectedOption, 'Value:', selectedOption.value);

            if (!selectedOption.value || selectedOption.value === '') {
                console.log('⚠️ Không có dịch vụ nào được chọn');
                alert('Vui lòng chọn một dịch vụ!');
                return;
            }

            const serviceId = selectedOption.value;
            const serviceName = selectedOption.getAttribute('data-name');
            const servicePrice = selectedOption.getAttribute('data-price');

            console.log('✅ Service Info:', {
                serviceId: serviceId,
                serviceName: serviceName,
                servicePrice: servicePrice
            });

            if (!serviceId || !serviceName || !servicePrice) {
                console.error('❌ Thiếu thông tin dịch vụ!', {serviceId, serviceName, servicePrice});
                alert('Dữ liệu dịch vụ không hợp lệ!');
                return;
            }

            const newItem = document.createElement('div');
            newItem.classList.add('selected-service-item');
            newItem.dataset.price = servicePrice;
            newItem.dataset.serviceId = serviceId;

            // Tạo từng element riêng biệt thay vì innerHTML
            const span = document.createElement('span');
            span.textContent = serviceName;

            const quantityInput = document.createElement('input');
            quantityInput.type = 'number';
            quantityInput.value = '1';
            quantityInput.min = '1';
            quantityInput.className = 'service-quantity';

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
            hiddenServiceId.name = 'serviceId';
            hiddenServiceId.value = serviceId;
            hiddenServiceId.className = 'hidden-service-id';

            const hiddenQuantity = document.createElement('input');
            hiddenQuantity.type = 'hidden';
            hiddenQuantity.name = 'serviceQuantity';
            hiddenQuantity.value = '1';
            hiddenQuantity.className = 'hidden-quantity';

            const hiddenDate = document.createElement('input');
            hiddenDate.type = 'hidden';
            hiddenDate.name = 'serviceDate';
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

            selectedServicesList.appendChild(newItem);

            // Verify sau khi append
            const addedServiceId = newItem.querySelector('.hidden-service-id').value;
            console.log('✅ Service item đã được thêm. ServiceId in DOM:', addedServiceId);

            if (!addedServiceId || addedServiceId === '') {
                console.error('❌ LỖI: ServiceId không được gán vào hidden input!');
                alert('Lỗi kỹ thuật: Không thể thêm dịch vụ!');
                newItem.remove();
                return;
            }

            updateSingleServiceDatePicker(newItem.querySelector('.service-date'));
            attachEventsToServiceItem(newItem);

            calculateTotal();

            // Reset select về trạng thái ban đầu
            serviceSelect.selectedIndex = 0;
        }

        function attachEventsToServiceItem(item) {
            console.log('🔗 Gắn events cho service item');

            const quantityInput = item.querySelector('.service-quantity');
            const dateInput = item.querySelector('.service-date');
            const removeBtn = item.querySelector('.remove-service-btn');
            const hiddenQuantity = item.querySelector('.hidden-quantity');
            const hiddenDate = item.querySelector('.hidden-date');

            quantityInput.addEventListener('input', () => {
                console.log('Quantity changed:', quantityInput.value);
                hiddenQuantity.value = quantityInput.value;
                calculateTotal();
            });

            dateInput.addEventListener('change', () => {
                console.log('Service date changed:', dateInput.value);
                hiddenDate.value = dateInput.value;
            });

            removeBtn.addEventListener('click', () => {
                console.log('🗑️ Removing service item');
                item.remove();
                calculateTotal();
            });
        }

        function updateSingleServiceDatePicker(dateInput) {
            if (checkInInput.value) {
                dateInput.min = checkInInput.value;
                if(!dateInput.value || dateInput.value < checkInInput.value){
                    dateInput.value = checkInInput.value;
                    dateInput.closest('.selected-service-item').querySelector('.hidden-date').value = dateInput.value;
                }
            }
            if (checkOutInput.value) {
                let maxDate = new Date(checkOutInput.value);
                dateInput.max = maxDate.toISOString().split('T')[0];
                if(dateInput.value > dateInput.max){
                    dateInput.value = dateInput.max;
                    dateInput.closest('.selected-service-item').querySelector('.hidden-date').value = dateInput.value;
                }
            }
        }

        function updateAllServiceDatePickers() {
            document.querySelectorAll('.service-date').forEach(updateSingleServiceDatePicker);
        }

        function calculateTotal() {
            console.log('💰 Calculating total...');

            let roomTotal = 0;
            if (checkInInput.value && checkOutInput.value && new Date(checkOutInput.value) > new Date(checkInInput.value)) {
                const timeDiff = new Date(checkOutInput.value).getTime() - new Date(checkInInput.value).getTime();
                const nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
                roomTotal = nights > 0 ? nights * pricePerNight : 0;
            }

            let servicesTotal = 0;
            document.querySelectorAll('.selected-service-item').forEach(item => {
                const price = parseFloat(item.dataset.price);
                const quantity = parseInt(item.querySelector('.service-quantity').value, 10) || 1;
                servicesTotal += price * quantity;
            });

            const finalTotal = roomTotal + servicesTotal;
            console.log('Room total:', roomTotal, 'Services total:', servicesTotal, 'Final total:', finalTotal);

            totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(finalTotal);

            // Cập nhật giá trị totalAmount vào trường hidden
            document.getElementById('totalAmount').value = finalTotal;
        }

        // --- GẮN CÁC SỰ KIỆN BAN ĐẦU ---
        checkInInput.addEventListener('change', () => {
            console.log('📅 Check-in changed:', checkInInput.value);
            if (checkInInput.value) {
                let nextDay = new Date(checkInInput.value);
                nextDay.setDate(nextDay.getDate() + 1);
                const nextDayString = nextDay.toISOString().split('T')[0];
                checkOutInput.setAttribute('min', nextDayString);
                if (checkOutInput.value && checkOutInput.value < nextDayString) {
                    checkOutInput.value = nextDayString;
                }
            }
            updateAllServiceDatePickers();
            calculateTotal();
        });

        checkOutInput.addEventListener('change', () => {
            console.log('📅 Check-out changed:', checkOutInput.value);
            updateAllServiceDatePickers();
            calculateTotal();
        });

        // QUAN TRỌNG: Sửa phần này - thêm preventDefault
        addServiceBtn.addEventListener('click', function(e) {
            console.log('🟢 ADD SERVICE BUTTON CLICKED!');
            e.preventDefault(); // Ngăn form submit hoặc hành động mặc định
            e.stopPropagation(); // Ngăn event bubble lên

            addServiceItem();
        });

        bookingForm.addEventListener('submit', function(event) {
            console.log('📝 Form submitting...');

            // Set booking date

            const todaySubmit = new Date();
            const year = todaySubmit.getFullYear();
            const month = String(todaySubmit.getMonth() + 1).padStart(2, '0');
            const day = String(todaySubmit.getDate()).padStart(2, '0');
            const bookDate = year;
            console.log('Booking date:', bookDate);
            bookingDateInput.value = bookDate + '-' + month + '-' + day;
            console.log('Booking date set to:', bookingDateInput.value);

            // XÓA TẤT CẢ các input service rỗng khỏi form trước khi submit
            const emptyServiceInputs = bookingForm.querySelectorAll('input[name="serviceId"]');
            emptyServiceInputs.forEach(input => {
                if (!input.value || input.value.trim() === '') {
                    // Tìm parent service item và xóa hết
                    const serviceItem = input.closest('.selected-service-item');
                    if (serviceItem) {
                        console.log('🗑️ Xóa service item rỗng trước khi submit');
                        serviceItem.remove();
                    } else {
                        // Nếu không có parent, xóa chính input đó và các input liên quan
                        input.remove();
                        const relatedQuantity = bookingForm.querySelector('input[name="serviceQuantity"]');
                        const relatedDate = bookingForm.querySelector('input[name="serviceDate"]');
                        if (relatedQuantity && !relatedQuantity.closest('.selected-service-item')) {
                            relatedQuantity.remove();
                        }
                        if (relatedDate && !relatedDate.closest('.selected-service-item')) {
                            relatedDate.remove();
                        }
                    }
                }
            });

            console.log('Total services being submitted:', document.querySelectorAll('.selected-service-item').length);

            // Log tất cả data sẽ được submit
            const formData = new FormData(bookingForm);
            console.log('📤 Form data:');
            for (let [key, value] of formData.entries()) {
                console.log(`  ${key}: ${value}`);
            }
        });

        // Tự động kích hoạt các hàm cần thiết khi tải trang
        if (checkInInput.value) {
            checkInInput.dispatchEvent(new Event('change'));
        }
        updateAllServiceDatePickers();
        calculateTotal();

        console.log('✅ All event listeners attached');
    });
</script>
</body>
</html>