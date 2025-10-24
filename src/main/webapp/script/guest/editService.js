// --- Lấy các phần tử DOM ---
const serviceSelect = document.getElementById('service-select');
const addServiceBtn = document.getElementById('add-service-btn');
const selectedServicesList = document.getElementById('selected-services-list');

// Lấy ngày check-in và check-out từ JSP để giới hạn date picker
//fix khuc nay sau

const checkInDate = "<%= booking.getCheckInDate().toLocalDate() %>";
const checkOutDate = "<%= booking.getCheckOutDate().toLocalDate() %>";

// --- HÀM XỬ LÝ ---
function addServiceItem() {
    const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
    if (!selectedOption.value) return; // Không làm gì nếu chọn option rỗng

    const serviceId = selectedOption.value;
    const serviceName = selectedOption.dataset.name;

    // Tạo một item dịch vụ mới
    const newItem = document.createElement('div');
    newItem.classList.add('selected-service-item');

    // Cấu trúc HTML cho một item dịch vụ
    newItem.innerHTML = `
            <span>${serviceName}</span>
            <input type="number" value="1" min="1" class="service-quantity" placeholder="Số lượng">
            <input type="date" class="service-date" required>
            <button type="button" class="remove-service-btn">&times;</button>
            <input type="hidden" name="newServiceId" value="${serviceId}">
            <input type="hidden" name="newServiceQuantity" class="hidden-quantity" value="1">
            <input type="hidden" name="newServiceDate" class="hidden-date" value="">
        `;

    selectedServicesList.appendChild(newItem);
    updateSingleServiceDatePicker(newItem.querySelector('.service-date'));
    attachEventsToServiceItem(newItem);
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