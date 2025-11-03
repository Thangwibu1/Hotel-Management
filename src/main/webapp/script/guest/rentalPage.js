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

checkInInput.setAttribute('min', today);

// --- CÁC HÀM XỬ LÝ ---
function addServiceItem() {
    const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
    if (!selectedOption.value) return;

    const serviceId = selectedOption.value;
    const serviceName = selectedOption.dataset.name;
    const servicePrice = selectedOption.dataset.price;

    const newItem = document.createElement('div');
    newItem.classList.add('selected-service-item');
    newItem.dataset.price = servicePrice;

    newItem.innerHTML = `
            <span>${serviceName}</span>
            <input type="number" value="1" min="1" class="service-quantity">
            <input type="date" class="service-date" required>
            <button type="button" class="remove-service-btn">&times;</button>
            <input type="hidden" name="serviceId" value="${serviceId}">
            <input type="hidden" name="serviceQuantity" class="hidden-quantity" value="1">
            <input type="hidden" name="serviceDate" class="hidden-date" value="">
        `;
    selectedServicesList.appendChild(newItem);
    updateSingleServiceDatePicker(newItem.querySelector('.service-date'));
    attachEventsToServiceItem(newItem);
    calculateTotal();
}

function attachEventsToServiceItem(item) {
    const quantityInput = item.querySelector('.service-quantity');
    const dateInput = item.querySelector('.service-date');
    const removeBtn = item.querySelector('.remove-service-btn');
    const hiddenQuantity = item.querySelector('.hidden-quantity');
    const hiddenDate = item.querySelector('.hidden-date');

    quantityInput.addEventListener('input', () => {
        hiddenQuantity.value = quantityInput.value;
        calculateTotal();
    });
    dateInput.addEventListener('change', () => {
        hiddenDate.value = dateInput.value;
    });
    removeBtn.addEventListener('click', () => {
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
    totalPriceElement.textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(finalTotal);

    // Cập nhật giá trị totalAmount vào trường hidden
    document.getElementById('totalAmount').value = finalTotal;
}

// --- GẮN CÁC SỰ KIỆN BAN ĐẦU ---
checkInInput.addEventListener('change', () => {
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
    updateAllServiceDatePickers();
    calculateTotal();
});

addServiceBtn.addEventListener('click', addServiceItem);

bookingForm.addEventListener('submit', function(event) {
    const todaySubmit = new Date();
    const year = todaySubmit.getFullYear();
    const month = String(todaySubmit.getMonth() + 1).padStart(2, '0');
    const day = String(todaySubmit.getDate()).padStart(2, '0');
    bookingDateInput.value = `${year}-${month}-${day}`;
});

// Tự động kích hoạt các hàm cần thiết khi tải trang
if (checkInInput.value) {
    checkInInput.dispatchEvent(new Event('change'));
}
updateAllServiceDatePickers();
calculateTotal();

// === XỬ LÝ CREDIT CARD ANIMATION ===
const cardHolderInput = document.getElementById('card-holder');
const cardNumberInput = document.getElementById('card-number');
const cardMonthInput = document.getElementById('card-month');
const cardYearInput = document.getElementById('card-year');
const cardCvvInput = document.getElementById('card-cvv');

const cardHolderDisplay = document.getElementById('card-holder-display');
const cardNumberDisplay = document.getElementById('card-number-display');
const cardExpiryDisplay = document.getElementById('card-expiry-display');

// Format và hiển thị tên chủ thẻ
if (cardHolderInput) {
    cardHolderInput.addEventListener('input', function(e) {
        let value = e.target.value.toUpperCase();
        cardHolderDisplay.textContent = value || 'YOUR NAME';
    });
}

// Format và hiển thị số thẻ (thêm khoảng trắng sau mỗi 4 số)
if (cardNumberInput) {
    cardNumberInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\s/g, '').replace(/\D/g, '');
        let formattedValue = value.match(/.{1,4}/g)?.join(' ') || '';
        e.target.value = formattedValue;
        
        // Hiển thị với bullet points
        if (value.length > 0) {
            let displayValue = value.split('').map((digit, index) => {
                if (index < value.length - 4) {
                    return '•';
                }
                return digit;
            }).join('');
            cardNumberDisplay.textContent = displayValue.match(/.{1,4}/g)?.join(' ') || '•••• •••• •••• ••••';
        } else {
            cardNumberDisplay.textContent = '•••• •••• •••• ••••';
        }
    });
}

// Chỉ cho phép nhập số cho tháng
if (cardMonthInput) {
    cardMonthInput.addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0, 2);
        updateExpiryDisplay();
    });
}

// Chỉ cho phép nhập số cho năm
if (cardYearInput) {
    cardYearInput.addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0, 2);
        updateExpiryDisplay();
    });
}

// Chỉ cho phép nhập số cho CVV
if (cardCvvInput) {
    cardCvvInput.addEventListener('input', function(e) {
        e.target.value = e.target.value.replace(/\D/g, '');
    });
}

function updateExpiryDisplay() {
    const month = cardMonthInput.value || 'MM';
    const year = cardYearInput.value || 'YY';
    cardExpiryDisplay.textContent = `${month}/${year}`;
}