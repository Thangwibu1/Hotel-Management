# 🚀 Quick Start - Cấu Hình Email SMTP

## ⚠️ Lỗi SSL/TLS - Giải Pháp Nhanh

Bạn đang gặp lỗi:

```
Could not convert socket to TLS
SSLHandshakeException: Remote host terminated the handshake
```

### ✅ Giải pháp 3 bước:

## Bước 1: Tạo App Password (BẮT BUỘC)

Google đã tắt "Less secure app", bạn PHẢI dùng App Password:

1. 🔗 Truy cập: https://myaccount.google.com/security
2. 🔐 Bật **2-Step Verification** (nếu chưa có)
3. 🔑 Tạo **App Password**:
   - Vào: `Security` → `2-Step Verification` → cuộn xuống → `App passwords`
   - Chọn app: `Mail`
   - Chọn device: `Other` → nhập `Hotel Management`
   - Click `Generate`
   - ⚠️ **QUAN TRỌNG**: Copy 16 ký tự ngay lập tức!

## Bước 2: Tạo File `.env`

### Vị trí file:

```
Hotel-Management/
├── src/
│   └── main/
│       └── resources/
│           └── .env    ← Tạo file ở đây!
```

### Nội dung file `.env`:

**OPTION 1: Port 587 (STARTTLS) - Thử đầu tiên**

```env
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=abcdefghijklmnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
```

**OPTION 2: Port 465 (SSL) - Nếu Option 1 không work**

```env
EMAIL_FROM=your-email@gmail.com
EMAIL_PASSWORD=abcdefghijklmnop
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
```

### 📝 Lưu ý:

- ✅ `EMAIL_FROM`: Email Gmail của bạn
- ✅ `EMAIL_PASSWORD`: App Password 16 ký tự (KHÔNG phải mật khẩu Gmail)
- ✅ `SMTP_PORT`: Thử 587 trước, nếu không được thì 465

## Bước 3: Rebuild & Test

### 3.1. Clean và Rebuild project:

**Maven:**

```bash
mvn clean install
```

**NetBeans:**

- Right-click project → `Clean and Build`

### 3.2. Restart server

### 3.3. Test gửi email

Khi tạo booking mới, email sẽ tự động gửi!

---

## 🔍 Troubleshooting

### ❌ Vẫn lỗi "Could not convert socket to TLS"?

**Checklist:**

```
□ Đã bật 2-Step Verification?
□ Đã tạo App Password (16 ký tự)?
□ File .env nằm trong src/main/resources/?
□ EMAIL_PASSWORD là App Password (không phải password thường)?
□ Đã rebuild project sau khi tạo .env?
□ Đã restart server?
```

### 🔄 Thử đổi port:

Nếu dùng port 587 bị lỗi, đổi sang 465:

```env
SMTP_PORT=465
```

### 🐛 Enable Debug:

Trong `EmailSender.java`, uncomment dòng:

```java
props.put("mail.debug", "true");
```

---

## 📦 Cấu Trúc Thư Mục

```
Hotel-Management/
├── src/
│   └── main/
│       ├── java/
│       │   └── controller/
│       │       ├── BookingController.java      ← Có hàm gửi email
│       │       └── feature/
│       │           ├── EmailSender.java        ← Class gửi email
│       │           └── EnvConfig.java          ← Đọc .env
│       └── resources/
│           └── .env                            ← TẠO FILE NÀY!
├── GMAIL_SMTP_SETUP.md                         ← Hướng dẫn chi tiết
└── BOOKING_EMAIL_GUIDE.md                      ← Hướng dẫn sử dụng hàm
```

---

## ✨ Sau khi cấu hình xong

Email xác nhận sẽ tự động gửi khi:

- ✅ Khách hàng đặt phòng thành công
- ✅ Email HTML đẹp mắt với đầy đủ thông tin
- ✅ Không làm chậm response (gửi async)

---

## 📞 Support

Nếu vẫn gặp vấn đề:

1. Check logs console
2. Verify file .env có trong `src/main/resources/`
3. Test App Password với Gmail web hoặc Thunderbird
4. Đọc file `GMAIL_SMTP_SETUP.md` để biết chi tiết

---

**💡 Tips:**

- App Password khác với mật khẩu Gmail thường
- Không cần khoảng trắng trong App Password cũng được
- File .env không nên commit lên Git (đã có trong .gitignore)
