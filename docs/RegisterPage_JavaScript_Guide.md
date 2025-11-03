# 📘 Guideline: JavaScript Code - Register Page

## 📋 Mục Lục
1. [Tổng Quan](#tổng-quan)
2. [Error Popup System](#error-popup-system)
3. [Form Validation System](#form-validation-system)
4. [Flow Chart & Sơ Đồ](#flow-chart--sơ-đồ)
5. [Chi Tiết Từng Function](#chi-tiết-từng-function)

---

## 🎯 Tổng Quan

### Cấu Trúc JavaScript
File `registerPage.jsp` chứa JavaScript với **2 hệ thống chính**:

```
┌─────────────────────────────────────┐
│   JavaScript Architecture           │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────────────────────┐   │
│  │  1. Error Popup System       │   │
│  │     - Hiển thị lỗi server    │   │
│  │     - Quản lý URL params     │   │
│  │     - Event handlers         │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐   │
│  │  2. Form Validation System   │   │
│  │     - Real-time validation   │   │
│  │     - Field-level checks     │   │
│  │     - Submit validation      │   │
│  └──────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 🚨 Error Popup System

### 📌 Mục Đích
Hiển thị popup lỗi đẹp mắt khi đăng ký thất bại (thay vì alert đơn giản).

### 🔄 Flow Hoạt Động

```
┌─────────────────────────────────────────────────────────┐
│              ERROR POPUP FLOW                           │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Trang load (Page Load)        │
        └────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Kiểm tra URL có param 'error' │
        │  ?error=xxxxx                  │
        └────────────────────────────────┘
                         │
                ┌────────┴────────┐
                │                 │
               Có               Không
                │                 │
                ▼                 ▼
    ┌──────────────────┐    ┌──────────┐
    │ Lấy error param  │    │  Không   │
    │ Decode message   │    │  làm gì  │
    └──────────────────┘    └──────────┘
                │
                ▼
    ┌──────────────────────┐
    │ Tùy chỉnh message    │
    │ dựa trên error type  │
    └──────────────────────┘
                │
                ▼
    ┌──────────────────────┐
    │ Hiển thị popup       │
    │ (add class 'show')   │
    └──────────────────────┘
                │
                ▼
    ┌──────────────────────────────────┐
    │  User có thể đóng popup bằng:    │
    │  1. Click button "Đã hiểu"       │
    │  2. Click bên ngoài popup        │
    │  3. Nhấn phím ESC                │
    └──────────────────────────────────┘
                │
                ▼
    ┌──────────────────────┐
    │ Xóa param 'error'    │
    │ khỏi URL             │
    └──────────────────────┘
```

### 💻 Code Chi Tiết

#### 1️⃣ Function `closeErrorPopup()`

```javascript
function closeErrorPopup() {
    // Lấy element overlay
    const overlay = document.getElementById('errorPopupOverlay');
    
    // Ẩn popup bằng cách remove class 'show'
    overlay.classList.remove('show');
    
    // Tạo URL object từ current URL
    const url = new URL(window.location);
    
    // Xóa parameter 'error' khỏi URL
    url.searchParams.delete('error');
    
    // Cập nhật URL mà không reload trang
    window.history.replaceState({}, '', url);
}
```

**Giải thích:**
- **Mục đích**: Đóng popup và làm sạch URL
- **`classList.remove('show')`**: CSS sẽ ẩn overlay khi không có class 'show'
- **`URLSearchParams.delete()`**: Xóa param error khỏi URL
- **`history.replaceState()`**: Thay đổi URL mà không reload trang

**Ví dụ:**
```
Trước: http://localhost/register?error=Email%20exists
Sau:  http://localhost/register
```

---

#### 2️⃣ Kiểm Tra URL Parameters (Khi Trang Load)

```javascript
// Lấy tất cả URL parameters
const urlParams = new URLSearchParams(window.location.search);

// Lấy giá trị của param 'error'
const errorParam = urlParams.get('error');

if (errorParam) {
    // Có lỗi - hiển thị popup
    const overlay = document.getElementById('errorPopupOverlay');
    const errorMessage = document.getElementById('errorMessage');
    
    // Tùy chỉnh message dựa trên loại lỗi
    if (errorParam.includes('Email') || errorParam.includes('ID number')) {
        // Lỗi trùng email/CMND
        errorMessage.innerHTML = '...custom message...';
    } else {
        // Lỗi khác - hiển thị message gốc
        errorMessage.textContent = decodeURIComponent(errorParam);
    }
    
    // Hiển thị popup
    overlay.classList.add('show');
}
```

**Giải thích:**
- **`URLSearchParams`**: API để xử lý query string
- **`includes()`**: Kiểm tra xem error message có chứa từ khóa cụ thể
- **`decodeURIComponent()`**: Decode URL-encoded string
- **`innerHTML` vs `textContent`**: 
  - `innerHTML`: Cho phép HTML tags (icon, <br>)
  - `textContent`: Chỉ text thuần

**Ví dụ Flow:**
```
URL: ?error=Email%20already%20exists

↓ URLSearchParams.get('error')

errorParam = "Email already exists"

↓ Check includes('Email')

✓ Match → Custom message with icon

↓ overlay.classList.add('show')

Popup hiển thị!
```

---

#### 3️⃣ Event Listeners

##### a) Đóng popup khi click bên ngoài

```javascript
document.getElementById('errorPopupOverlay').addEventListener('click', function(e) {
    // Kiểm tra xem có click vào chính overlay (không phải popup bên trong)
    if (e.target === this) {
        closeErrorPopup();
    }
});
```

**Giải thích:**
- **`e.target`**: Element được click
- **`this`**: Chính overlay element
- Chỉ đóng khi click vào overlay (background đen mờ), không phải popup trắng

**Minh họa:**
```
┌──────────────────────────────────────────┐
│  Overlay (e.target === this) ← ĐÓNG     │
│                                          │
│     ┌────────────────────────┐          │
│     │  Popup Content         │          │
│     │  (e.target !== this)   │          │
│     │  ← KHÔNG ĐÓNG          │          │
│     └────────────────────────┘          │
│                                          │
└──────────────────────────────────────────┘
```

##### b) Đóng popup khi nhấn ESC

```javascript
document.addEventListener('keydown', function(e) {
    // Kiểm tra phím ESC
    if (e.key === 'Escape') {
        const overlay = document.getElementById('errorPopupOverlay');
        
        // Chỉ đóng nếu popup đang hiển thị
        if (overlay.classList.contains('show')) {
            closeErrorPopup();
        }
    }
});
```

**Giải thích:**
- **`keydown` event**: Bắt sự kiện nhấn phím
- **`e.key`**: Tên phím được nhấn
- **`classList.contains()`**: Kiểm tra xem popup có đang hiển thị không

---

## ✅ Form Validation System

### 📌 Mục Đích
- Validate input **real-time** (ngay khi user nhập)
- Hiển thị lỗi rõ ràng cho từng field
- Ngăn submit form nếu có lỗi

### 🔄 Flow Hoạt Động Tổng Quan

```
┌────────────────────────────────────────────────────────┐
│          FORM VALIDATION FLOW                          │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
        ┌───────────────────────────────┐
        │  DOMContentLoaded Event       │
        │  (Trang load xong)            │
        └───────────────────────────────┘
                        │
                        ▼
        ┌───────────────────────────────┐
        │  Setup date constraints       │
        │  (min/max cho ngày sinh)      │
        └───────────────────────────────┘
                        │
                        ▼
        ┌───────────────────────────────┐
        │  Attach event listeners       │
        │  - blur: validate on focus out│
        │  - input: re-validate if err  │
        │  - submit: validate all       │
        └───────────────────────────────┘
                        │
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
┌──────────────┐              ┌──────────────┐
│ User Input   │              │ User Submit  │
│ & Blur       │              │ Form         │
└──────────────┘              └──────────────┘
        │                               │
        ▼                               ▼
┌──────────────┐              ┌──────────────┐
│ validateField│              │ Validate All │
│ (single)     │              │ Fields       │
└──────────────┘              └──────────────┘
        │                               │
        ▼                               ▼
┌──────────────┐              ┌──────────────┐
│ Update UI    │              │  All Valid?  │
│ (CSS class)  │              └──────────────┘
└──────────────┘                      │
                              ┌───────┴───────┐
                              │               │
                             YES             NO
                              │               │
                              ▼               ▼
                        ┌──────────┐   ┌──────────┐
                        │  Submit  │   │ Prevent  │
                        │  Form    │   │ & Focus  │
                        └──────────┘   │ 1st Err  │
                                       └──────────┘
```

### 💻 Code Chi Tiết

#### 1️⃣ Setup Khi Trang Load

```javascript
document.addEventListener('DOMContentLoaded', function() {
    // Lấy form element
    const form = document.getElementById('registerForm');
    
    // Lấy tất cả inputs có attribute 'required'
    const inputs = form.querySelectorAll('input[required]');
    
    // ... tiếp tục setup
});
```

**Giải thích:**
- **`DOMContentLoaded`**: Event kích hoạt khi HTML đã load xong
- **`querySelectorAll('input[required]')`**: Lấy tất cả input bắt buộc
- Chỉ validate các field required (không validate các field optional)

---

#### 2️⃣ Setup Date Constraints (Ngày Sinh)

```javascript
const dateOfBirthInput = document.getElementById('dateOfBirth');

if (dateOfBirthInput) {
    // Lấy ngày hiện tại
    const today = new Date();
    
    // Tính ngày max (phải đủ 18 tuổi)
    const maxDate = new Date(
        today.getFullYear() - 18,  // 18 năm trước
        today.getMonth(),           // Tháng hiện tại
        today.getDate()             // Ngày hiện tại
    );
    
    // Tính ngày min (không quá 120 tuổi)
    const minDate = new Date(
        today.getFullYear() - 120,
        today.getMonth(),
        today.getDate()
    );
    
    // Set attribute max và min cho input
    dateOfBirthInput.max = maxDate.toISOString().split('T')[0];
    dateOfBirthInput.min = minDate.toISOString().split('T')[0];
}
```

**Giải thích:**
- **Mục đích**: Giới hạn ngày có thể chọn trong date picker
- **maxDate**: Người dùng phải đủ 18 tuổi
- **minDate**: Giới hạn tối đa 120 tuổi (ngăn bug)
- **`toISOString().split('T')[0]`**: Convert Date → "YYYY-MM-DD"

**Ví dụ:**
```
Hôm nay: 2025-10-30

maxDate: 2007-10-30 (18 năm trước)
minDate: 1905-10-30 (120 năm trước)

→ Date picker chỉ cho chọn từ 1905-10-30 đến 2007-10-30
```

---

#### 3️⃣ Function `validateField()` - CORE LOGIC

Đây là function quan trọng nhất, validate từng field riêng lẻ.

##### 📋 Cấu Trúc Function

```javascript
function validateField(input) {
    // 1. Lấy error element tương ứng
    const errorElement = document.getElementById(input.id + '-error');
    let isValid = true;
    
    // 2. Kiểm tra các điều kiện validation
    // ... nhiều if-else ...
    
    // 3. Cập nhật UI dựa trên kết quả
    if (isValid) {
        // Thêm class 'valid', xóa 'invalid', ẩn error text
    } else {
        // Thêm class 'invalid', xóa 'valid', hiện error text
    }
    
    // 4. Return kết quả
    return isValid;
}
```

##### 🔍 Chi Tiết Từng Validation Rule

###### a) Kiểm Tra Field Rỗng

```javascript
if (input.hasAttribute('required') && !input.value.trim()) {
    isValid = false;
    if (errorElement) {
        errorElement.textContent = 'Vui lòng nhập ' + (input.placeholder || 'trường này');
    }
}
```

**Logic:**
- **Điều kiện**: Field có `required` attribute VÀ giá trị rỗng (sau khi trim)
- **`trim()`**: Xóa khoảng trắng đầu/cuối → ngăn user nhập toàn spaces
- **Error message**: Dynamic dựa trên placeholder

**Ví dụ:**
```
Input: "   " (3 spaces)
→ value.trim() = ""
→ isValid = false
→ Message: "Vui lòng nhập Nguyễn Văn A" (từ placeholder)
```

---

###### b) Validate Email Format

```javascript
else if (input.type === 'email' && input.value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(input.value)) {
        isValid = false;
        if (errorElement) {
            errorElement.textContent = 'Email không hợp lệ';
        }
    }
}
```

**Regex Breakdown:**
```
/^[^\s@]+@[^\s@]+\.[^\s@]+$/

^           : Bắt đầu string
[^\s@]+     : 1+ ký tự KHÔNG phải space hoặc @
@           : Ký tự @ (bắt buộc)
[^\s@]+     : 1+ ký tự KHÔNG phải space hoặc @
\.          : Dấu chấm (escaped)
[^\s@]+     : 1+ ký tự KHÔNG phải space hoặc @
$           : Kết thúc string
```

**Ví dụ:**
```
✓ Valid:
  - user@example.com
  - john.doe@company.co.uk
  - test123@gmail.com

✗ Invalid:
  - user@                (thiếu domain)
  - @example.com         (thiếu local part)
  - user @example.com    (có space)
  - user@example         (thiếu TLD)
```

---

###### c) Validate Password Length

```javascript
else if (input.id === 'password' && input.value) {
    if (input.value.length < 6) {
        isValid = false;
        if (errorElement) {
            errorElement.textContent = 'Mật khẩu tối thiểu 6 ký tự';
        }
    }
}
```

**Logic:**
- Chỉ check nếu `id === 'password'`
- Yêu cầu tối thiểu 6 ký tự
- Không check độ phức tạp (uppercase, special chars, etc.)

---

###### d) Validate Password Confirmation

```javascript
else if (input.id === 'confirmPassword' && input.value) {
    const password = document.getElementById('password').value;
    if (input.value !== password) {
        isValid = false;
        if (errorElement) {
            errorElement.textContent = 'Mật khẩu không khớp';
        }
    }
}
```

**Logic:**
- So sánh strict (`!==`) giá trị 2 password
- Phân biệt hoa/thường (case-sensitive)

**Ví dụ:**
```
Password:        "MyPass123"
Confirm:         "mypass123"
→ isValid = false (khác case)

Password:        "MyPass123"
Confirm:         "MyPass123"
→ isValid = true
```

---

###### e) Validate Phone Number

```javascript
else if (input.id === 'phone' && input.value) {
    const phoneRegex = /^[0-9]{10,11}$/;
    if (!phoneRegex.test(input.value)) {
        isValid = false;
        if (errorElement) {
            errorElement.textContent = 'Số điện thoại không hợp lệ (10-11 số)';
        }
    }
}
```

**Regex Breakdown:**
```
/^[0-9]{10,11}$/

^           : Bắt đầu
[0-9]       : Chỉ chữ số 0-9
{10,11}     : Từ 10 đến 11 ký tự
$           : Kết thúc
```

**Ví dụ:**
```
✓ Valid:
  - 0901234567 (10 số)
  - 09012345678 (11 số)

✗ Invalid:
  - 090123456 (9 số - quá ngắn)
  - 090123456789 (12 số - quá dài)
  - 090-123-4567 (có dấu -)
  - 090 123 4567 (có space)
```

---

###### f) Validate Date of Birth (Phức Tạp Nhất!)

```javascript
else if (input.id === 'dateOfBirth' && input.value) {
    // Parse ngày được chọn
    const selectedDate = new Date(input.value);
    const today = new Date();
    
    // Tính tuổi
    const age = today.getFullYear() - selectedDate.getFullYear();
    const monthDiff = today.getMonth() - selectedDate.getMonth();
    const dayDiff = today.getDate() - selectedDate.getDate();
    
    // CHECK 1: Ngày trong tương lai?
    if (selectedDate > today) {
        isValid = false;
        errorElement.textContent = 'Ngày sinh không thể là ngày tương lai';
    }
    // CHECK 2: Chưa đủ 18 tuổi?
    else if (age < 18 || (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))) {
        isValid = false;
        errorElement.textContent = 'Bạn phải đủ 18 tuổi để đăng ký';
    }
    // CHECK 3: Quá 120 tuổi?
    else if (age > 120) {
        isValid = false;
        errorElement.textContent = 'Ngày sinh không hợp lệ';
    }
}
```

**Chi Tiết Logic Kiểm Tra 18 Tuổi:**

```javascript
age < 18  ||  (age === 18 && (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)))
```

**Giải thích:**

1. **`age < 18`**: Chưa đủ 18 năm → Invalid

2. **`age === 18`**: Đúng 18 năm, cần check thêm tháng/ngày
   - **`monthDiff < 0`**: Chưa đến tháng sinh → Invalid
   - **`monthDiff === 0 && dayDiff < 0`**: Đúng tháng sinh nhưng chưa đến ngày → Invalid

**Ví dụ Chi Tiết:**

```
Hôm nay: 2025-10-30

Case 1: Sinh ngày 2008-10-30
  age = 2025 - 2008 = 17
  → age < 18 → INVALID ❌

Case 2: Sinh ngày 2007-10-30
  age = 2025 - 2007 = 18
  monthDiff = 10 - 10 = 0
  dayDiff = 30 - 30 = 0
  → Đủ 18 tuổi đúng hôm nay → VALID ✓

Case 3: Sinh ngày 2007-11-15
  age = 2025 - 2007 = 18
  monthDiff = 10 - 11 = -1 (chưa đến tháng sinh)
  → age === 18 && monthDiff < 0 → INVALID ❌

Case 4: Sinh ngày 2007-10-31
  age = 18
  monthDiff = 0
  dayDiff = 30 - 31 = -1 (chưa đến ngày sinh)
  → age === 18 && monthDiff === 0 && dayDiff < 0 → INVALID ❌

Case 5: Sinh ngày 2007-09-15
  age = 18
  monthDiff = 10 - 9 = 1 (đã qua tháng sinh)
  → age === 18 nhưng monthDiff > 0 → VALID ✓
```

---

##### 🎨 Cập Nhật UI Sau Validation

```javascript
// Update UI
if (isValid) {
    input.classList.remove('invalid');
    input.classList.add('valid');
    if (errorElement) {
        errorElement.classList.remove('show');
    }
} else {
    input.classList.remove('valid');
    input.classList.add('invalid');
    if (errorElement) {
        errorElement.classList.add('show');
    }
}

return isValid;
```

**CSS Classes Effect:**

```css
/* Valid state */
.form-group input.valid {
    border-color: #28a745;        /* Viền xanh lá */
    background-color: #f5fff5;    /* Nền xanh nhạt */
}

/* Invalid state */
.form-group input.invalid {
    border-color: #dc3545;        /* Viền đỏ */
    background-color: #fff5f5;    /* Nền đỏ nhạt */
}

/* Error text */
.error-text.show {
    display: block;               /* Hiện text lỗi */
}
```

**Visual Effect:**
```
┌─────────────────────────────────────┐
│ Email                               │
│ ┌─────────────────────────────────┐ │
│ │ invalid@                        │ │ ← Input có class 'invalid'
│ └─────────────────────────────────┘ │   (viền đỏ, nền đỏ nhạt)
│ ⚠ Email không hợp lệ                │ ← Error text có class 'show'
└─────────────────────────────────────┘
```

---

#### 4️⃣ Event Listeners Cho Inputs

##### a) Blur Event (Khi Rời Khỏi Field)

```javascript
inputs.forEach(input => {
    input.addEventListener('blur', function() {
        validateField(this);
    });
});
```

**Giải thích:**
- **`blur` event**: Kích hoạt khi input mất focus
- **`this`**: Tham chiếu đến input element
- Validate ngay khi user rời khỏi field

**User Experience Flow:**
```
User click vào Email field
  → Nhập "test@"
  → Click ra ngoài (blur)
  → validateField() chạy
  → Hiển thị lỗi "Email không hợp lệ"
```

---

##### b) Input Event (Khi Đang Nhập)

```javascript
input.addEventListener('input', function() {
    // CHỈ re-validate nếu field đang bị lỗi
    if (this.classList.contains('invalid')) {
        validateField(this);
    }
});
```

**Giải thích:**
- **`input` event**: Kích hoạt mỗi khi giá trị thay đổi
- **Optimization**: Chỉ validate nếu đang có lỗi (tránh validate liên tục)
- **UX**: Giúp lỗi biến mất ngay khi user sửa

**Flow:**
```
Email field có lỗi (invalid class)
  → User gõ thêm ".com"
  → Input event trigger
  → validateField() chạy
  → Email hợp lệ → remove 'invalid', add 'valid'
  → Lỗi biến mất ngay lập tức ✓
```

---

##### c) Special: Password Match Sync

```javascript
document.getElementById('password').addEventListener('input', function() {
    const confirmPassword = document.getElementById('confirmPassword');
    // Nếu user đã nhập confirmPassword, validate lại nó
    if (confirmPassword.value) {
        validateField(confirmPassword);
    }
});
```

**Giải thích:**
- Khi user thay đổi password gốc
- Tự động re-validate confirmPassword (nếu đã nhập)
- Đảm bảo 2 field luôn sync

**Scenario:**
```
1. User nhập:
   Password: "abc123"
   Confirm:  "abc123"  → Valid ✓

2. User sửa password:
   Password: "newpass"  (đang gõ)
   Confirm:  "abc123"   → Auto re-validate → Invalid ✗

3. User sửa confirm:
   Password: "newpass"
   Confirm:  "newpass"  → Valid ✓
```

---

#### 5️⃣ Form Submit Validation

```javascript
form.addEventListener('submit', function(e) {
    let isFormValid = true;
    
    // Validate tất cả required fields
    inputs.forEach(input => {
        if (!validateField(input)) {
            isFormValid = false;
        }
    });
    
    // Ngăn submit nếu form invalid
    if (!isFormValid) {
        e.preventDefault();  // STOP submission!
        
        // Scroll đến field lỗi đầu tiên
        const firstInvalid = form.querySelector('.invalid');
        if (firstInvalid) {
            firstInvalid.focus();
            firstInvalid.scrollIntoView({ 
                behavior: 'smooth', 
                block: 'center' 
            });
        }
    }
});
```

**Flow Chi Tiết:**

```
User click "Đăng Ký Ngay"
        │
        ▼
Submit event trigger
        │
        ▼
┌───────────────────────┐
│ Loop qua ALL inputs   │
│ Validate từng field   │
└───────────────────────┘
        │
        ▼
┌───────────────────────┐
│ Có field nào lỗi?     │
└───────────────────────┘
        │
   ┌────┴────┐
   │         │
  YES       NO
   │         │
   ▼         ▼
┌─────┐  ┌─────┐
│ e.  │  │ Form│
│ pre │  │ đươc│
│ vent│  │ sub │
│ Defa│  │ mit │
│ ult │  │ lên │
│ ()  │  │ serv│
└─────┘  └─────┘
   │
   ▼
┌─────────────────┐
│ Focus field lỗi │
│ đầu tiên        │
└─────────────────┘
   │
   ▼
┌─────────────────┐
│ Scroll smooth   │
│ đến field đó    │
└─────────────────┘
```

**`scrollIntoView()` Options:**
```javascript
{
    behavior: 'smooth',  // Cuộn mượt mà (không giật)
    block: 'center'      // Đặt element ở giữa viewport
}
```

**Visual:**
```
Before scroll:
┌────────────────────────┐
│ [Viewport]             │
│                        │
│ ✓ Email: valid         │
└────────────────────────┘
  ...
  ...
  ✗ Phone: invalid (out of view)

After scrollIntoView():
┌────────────────────────┐
│ ✓ Email: valid         │
│                        │
│ ✗ Phone: invalid       │ ← Centered in viewport
│                        │
│ ⬜ Address              │
└────────────────────────┘
```

---

## 📊 Flow Chart Tổng Hợp

### Complete User Interaction Flow

```
                    ┌──────────────┐
                    │ User mở trang│
                    └──────────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ▼                       ▼
        ┌──────────────┐        ┌──────────────┐
        │ URL có error?│        │ Không error  │
        └──────────────┘        │ → Form trống │
                │               └──────────────┘
                ▼
        ┌──────────────┐
        │ Show popup   │
        │ lỗi từ server│
        └──────────────┘
                │
                ▼
        ┌──────────────┐
        │ User đóng    │
        │ popup        │
        └──────────────┘
                │
                └───────────┐
                            ▼
                    ┌──────────────┐
                    │ User nhập    │
                    │ thông tin    │
                    └──────────────┘
                            │
                    ┌───────┴───────┐
                    │               │
                    ▼               ▼
            ┌──────────┐    ┌──────────┐
            │ Blur     │    │ Input    │
            │ (rời     │    │ (đang    │
            │ field)   │    │ gõ)      │
            └──────────┘    └──────────┘
                    │               │
                    │       ┌───────┘
                    │       │ (nếu đang có lỗi)
                    ▼       ▼
            ┌──────────────────┐
            │ validateField()  │
            └──────────────────┘
                    │
            ┌───────┴───────┐
            │               │
           Valid         Invalid
            │               │
            ▼               ▼
    ┌──────────┐    ┌──────────┐
    │ Xanh lá  │    │ Đỏ +     │
    │ ✓        │    │ Message  │
    └──────────┘    └──────────┘
            │               │
            └───────┬───────┘
                    │
                    ▼
            ┌──────────────┐
            │ User click   │
            │ "Đăng Ký"    │
            └──────────────┘
                    │
                    ▼
            ┌──────────────────┐
            │ Validate ALL     │
            │ fields           │
            └──────────────────┘
                    │
            ┌───────┴───────┐
            │               │
        All Valid      Có Invalid
            │               │
            ▼               ▼
    ┌──────────┐    ┌──────────────┐
    │ Submit   │    │ preventDefault│
    │ to       │    │ Focus & Scroll│
    │ Servlet  │    │ to error      │
    └──────────┘    └──────────────┘
```

---

## 🎯 Key Takeaways

### 1. **Separation of Concerns**
```
┌─────────────────────────────────────┐
│ Error Popup  →  Server-side errors  │
│ Validation   →  Client-side checks  │
└─────────────────────────────────────┘
```

### 2. **Progressive Enhancement**
```
1. HTML5 validation (type="email", required, etc.)
   ↓
2. JavaScript validation (regex, custom rules)
   ↓
3. Server validation (final check)
```

### 3. **Event Strategy**
```
blur:   Validate khi rời field (first check)
input:  Re-validate nếu đang lỗi (instant feedback)
submit: Validate tất cả (final gate)
```

### 4. **Performance Optimization**
- ✓ Chỉ validate khi cần (blur, không phải mọi keystroke)
- ✓ Re-validate chỉ khi đang có lỗi
- ✓ Cache elements (errorElement)

### 5. **User Experience**
- ✓ Error messages rõ ràng, cụ thể
- ✓ Visual feedback (màu sắc, icon)
- ✓ Scroll to error
- ✓ Popup đẹp thay vì alert()
- ✓ Smooth animations

---

## 🔧 Testing Checklist

### Error Popup
- [ ] Popup hiện khi có `?error=xxx` trong URL
- [ ] Đóng được bằng button
- [ ] Đóng được bằng click ngoài
- [ ] Đóng được bằng ESC
- [ ] URL được clean sau khi đóng

### Validation Rules
- [ ] Email: reject `@`, `test@`, `test @gmail.com`
- [ ] Password: reject < 6 chars
- [ ] Confirm: reject khi không khớp
- [ ] Phone: reject 9 số, 12 số, chữ
- [ ] Date: reject future, <18 tuổi, >120 tuổi

### UI/UX
- [ ] Border đổi màu (xanh/đỏ)
- [ ] Error text hiện/ẩn đúng lúc
- [ ] Scroll to first error
- [ ] Validation ngay khi blur
- [ ] Re-validation khi sửa lỗi

---

## 📝 Potential Improvements

### 1. Debouncing cho input event
```javascript
let timeout;
input.addEventListener('input', function() {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
        if (this.classList.contains('invalid')) {
            validateField(this);
        }
    }, 300);  // Chờ 300ms sau khi user ngừng gõ
});
```

### 2. Stronger Password Rules
```javascript
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
// Yêu cầu: 1 chữ thường, 1 chữ hoa, 1 số, min 8 chars
```

### 3. Phone Number Normalization
```javascript
const phone = input.value.replace(/[\s\-\(\)]/g, '');
// Cho phép "090-123-4567" → "0901234567"
```

### 4. Show password toggle
```javascript
const toggleBtn = document.createElement('button');
toggleBtn.onclick = () => {
    input.type = input.type === 'password' ? 'text' : 'password';
};
```

---

## 🎓 Conclusion

Code JavaScript trong `registerPage.jsp` được thiết kế với:

✅ **Modularity**: Tách biệt error popup và validation  
✅ **Robustness**: Validate đầy đủ, nhiều rules  
✅ **UX-focused**: Feedback ngay lập tức, smooth animations  
✅ **Performance**: Chỉ validate khi cần  
✅ **Maintainability**: Code rõ ràng, dễ extend  

Đây là một **production-ready form validation system** phù hợp cho website khách sạn cao cấp! 🏨✨

---

**📅 Last Updated:** October 30, 2025  
**👨‍💻 Author:** Auto-generated Guide  
**📚 Version:** 1.0

