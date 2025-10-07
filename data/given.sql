-- Xóa Database cũ nếu tồn tại để tạo lại từ đầu
IF DB_ID('HotelManagement') IS NOT NULL
BEGIN
    ALTER DATABASE HotelManagement SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HotelManagement;
END
GO

-- Tạo Database
CREATE DATABASE HotelManagement;
GO

USE HotelManagement;
GO

-- ===================================================================
-- PHẦN 1: TẠO CẤU TRÚC CÁC BẢNG
-- ===================================================================

-- 1. Bảng Khách hàng (GUEST)
CREATE TABLE GUEST (
                       GuestID INT IDENTITY(1,1) PRIMARY KEY,
                       FullName NVARCHAR(100) NOT NULL,
                       Phone NVARCHAR(20) UNIQUE,
                       Email NVARCHAR(100) UNIQUE,
                       PasswordHash NVARCHAR(255) NOT NULL,
                       Address NVARCHAR(200),
                       IDNumber NVARCHAR(50),
                       DateOfBirth DATE
);
GO

-- 2. Bảng Loại phòng (ROOM_TYPE)
CREATE TABLE ROOM_TYPE (
                           RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
                           TypeName NVARCHAR(50) NOT NULL,
                           Capacity INT NOT NULL CHECK (Capacity > 0),
                           PricePerNight DECIMAL(10,2) NOT NULL CHECK (PricePerNight >= 0)
);
GO

-- 3. Bảng Phòng (ROOM) - ĐÃ CẬP NHẬT
CREATE TABLE ROOM (
                      RoomID INT IDENTITY(1,1) PRIMARY KEY,
                      RoomNumber NVARCHAR(10) UNIQUE NOT NULL,
                      RoomTypeID INT NOT NULL,
                      Description NVARCHAR(500) NULL, -- Thêm cột mô tả
                      Status NVARCHAR(20) CHECK (Status IN ('Available', 'Occupied', 'Dirty', 'Maintenance')),
                      FOREIGN KEY (RoomTypeID) REFERENCES ROOM_TYPE(RoomTypeID)
);
GO

-- 4. Bảng Đặt phòng (BOOKING)
CREATE TABLE BOOKING (
                         BookingID INT IDENTITY(1,1) PRIMARY KEY,
                         GuestID INT NOT NULL,
                         RoomID INT NOT NULL,
                         CheckInDate DATETIME NOT NULL,
                         CheckOutDate DATETIME NOT NULL,
                         BookingDate DATE DEFAULT GETDATE(),
                         Status NVARCHAR(20) CHECK (Status IN ('Reserved', 'Checked-in', 'Checked-out', 'Canceled')),
                         FOREIGN KEY (GuestID) REFERENCES GUEST(GuestID),
                         FOREIGN KEY (RoomID) REFERENCES ROOM(RoomID),
                         CHECK (CheckOutDate > CheckInDate)
);
GO

-- 5. Bảng Dịch vụ (SERVICE)
CREATE TABLE SERVICE (
                         ServiceID INT IDENTITY(1,1) PRIMARY KEY,
                         ServiceName NVARCHAR(100) NOT NULL,
                         ServiceType NVARCHAR(50),
                         Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);
GO

-- 6. Bảng Chi tiết Dịch vụ của Đặt phòng (BOOKING_SERVICE)
CREATE TABLE BOOKING_SERVICE (
                                 Booking_Service_ID INT IDENTITY(1,1) PRIMARY KEY,
                                 BookingID INT NOT NULL,
                                 ServiceID INT NOT NULL,
                                 Quantity INT DEFAULT 1 CHECK (Quantity > 0),
                                 ServiceDate DATE DEFAULT GETDATE(),
                                 Status INT DEFAULT 0, -- 1: Active, 0: Canceled
                                 FOREIGN KEY (BookingID) REFERENCES BOOKING(BookingID),
                                 FOREIGN KEY (ServiceID) REFERENCES SERVICE(ServiceID)
);
GO

-- 7. Bảng Hóa đơn (INVOICE)
CREATE TABLE INVOICE (
                         InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
                         BookingID INT NOT NULL UNIQUE,
                         IssueDate DATE DEFAULT GETDATE(),
                         TotalAmount DECIMAL(12,2) NOT NULL CHECK (TotalAmount >= 0),
                         Status NVARCHAR(20) CHECK (Status IN ('Unpaid', 'Paid', 'Canceled')),
                         FOREIGN KEY (BookingID) REFERENCES BOOKING(BookingID)
);
GO

-- 8. Bảng Thanh toán (PAYMENT)
CREATE TABLE PAYMENT (
                         PaymentID INT IDENTITY(1,1) PRIMARY KEY,
                         BookingID INT NOT NULL,
                         PaymentDate DATE DEFAULT GETDATE(),
                         Amount DECIMAL(12,2) NOT NULL CHECK (Amount >= 0),
                         PaymentMethod NVARCHAR(50) CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Debit Card', 'Online')),
                         Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Failed')),
                         FOREIGN KEY (BookingID) REFERENCES BOOKING(BookingID)
);
GO

-- 9. Bảng Nhân viên (STAFF)
CREATE TABLE STAFF (
                       StaffID INT IDENTITY(1,1) PRIMARY KEY,
                       FullName NVARCHAR(100) NOT NULL,
                       Role NVARCHAR(50) CHECK (Role IN ('Receptionist', 'Manager', 'Housekeeping', 'ServiceStaff', 'Admin')),
                       Username NVARCHAR(50) UNIQUE NOT NULL,
                       PasswordHash NVARCHAR(255) NOT NULL,
                       Phone NVARCHAR(20),
                       Email NVARCHAR(100)
);
GO

-- ===================================================================
-- PHẦN 2: CHÈN DỮ LIỆU MẪU
-- ===================================================================

-- 1. Dữ liệu bảng GUEST
INSERT INTO GUEST (FullName, Phone, Email, PasswordHash, Address, IDNumber, DateOfBirth) VALUES
('Nguyễn Văn An', '0901234567', 'nguyenvanan@email.com', 'hashed_password_1', '123 Lê Lợi, Q1, TPHCM', '012345678', '1990-05-15'),
('Trần Thị Bình', '0912345678', 'tranthibinh@email.com', 'hashed_password_2', '456 Hai Bà Trưng, Đà Nẵng', '087654321', '1988-11-22'),
('Lê Hoàng Cường', '0987654321', 'lehoangcuong@email.com', 'hashed_password_3', '789 Trần Hưng Đạo, Hà Nội', '055544433', '1995-02-10'),
('Phạm Thị Dung', '0911122333', 'phamthidung@email.com', 'hashed_password_4', '101 Nguyễn Trãi, Cần Thơ', '098712345', '2000-07-20'),
('Võ Minh Hải', '0933445566', 'vominhhai@email.com', 'hashed_password_5', '212 Lý Thường Kiệt, Huế', '045678912', '1985-01-30'),
('Đỗ Gia Hân', '0977889900', 'dogiahan@email.com', 'hashed_password_6', '333 Hùng Vương, Nha Trang', '078945612', '1992-09-05'),
('Hoàng Văn Kiên', '0905678123', 'hoangvankien@email.com', 'hashed_password_7', '555 Phan Châu Trinh, Đà Nẵng', '011223344', '1998-03-12'),
('Lý Thu Thảo', '0988776655', 'lythuthao@email.com', 'hashed_password_8', '444 Bạch Đằng, Hà Nội', '022334455', '1993-12-25');
GO

-- 2. Dữ liệu bảng ROOM_TYPE
INSERT INTO ROOM_TYPE (TypeName, Capacity, PricePerNight) VALUES
('Standard Single', 1, 50.00),
('Standard Double', 2, 80.00),
('Deluxe Double', 2, 120.00),
('Family Suite', 4, 180.00),
('Presidential Suite', 4, 350.00);
GO

-- 3. Dữ liệu bảng ROOM - ĐÃ CẬP NHẬT
INSERT INTO ROOM (RoomNumber, RoomTypeID, Description, Status) VALUES
-- Tầng 1 (Standard)
('101', 1, N'Phòng đơn tiêu chuẩn, hướng vườn.', 'Available'),
('102', 2, N'Phòng đôi tiêu chuẩn, gần sảnh chính.', 'Dirty'),
('103', 2, N'Phòng đôi tiêu chuẩn, yên tĩnh.', 'Available'),
-- Tầng 2 (Standard & Deluxe)
('201', 2, N'Phòng đôi tiêu chuẩn, tầng 2.', 'Available'),
('202', 3, N'Phòng Deluxe đôi, có ban công hướng thành phố.', 'Occupied'),
('203', 3, N'Phòng Deluxe đôi, gần cầu thang máy.', 'Maintenance'),
-- Tầng 3 (Deluxe)
('301', 3, N'Phòng Deluxe đôi, tầng cao yên tĩnh.', 'Available'),
('302', 3, N'Phòng Deluxe đôi, có tầm nhìn đẹp.', 'Available'),
('303', 3, N'Phòng Deluxe đôi, cuối hành lang.', 'Dirty'),
-- Tầng 4 (Family Suite)
('401', 4, N'Suite gia đình, 2 phòng ngủ, có bếp nhỏ.', 'Occupied'),
('402', 4, N'Suite gia đình, hướng hồ bơi.', 'Available'),
-- Tầng 5 (Presidential)
('501', 5, N'Suite Tổng thống, cao cấp nhất, có phòng khách riêng.', 'Available');
GO

-- 4. Dữ liệu bảng SERVICE
INSERT INTO SERVICE (ServiceName, ServiceType, Price) VALUES
('Breakfast Buffet', 'Food', 15.00),
('Set Menu Lunch', 'Food', 25.00),
('Laundry Service (per kg)', 'Laundry', 5.00),
('Spa Massage (60 mins)', 'Spa', 40.00)
GO

-- 5. Dữ liệu bảng STAFF
INSERT INTO STAFF (FullName, Role, Username, PasswordHash, Phone, Email) VALUES
('Phạm Minh Quân', 'Manager', 'manager01', 'hash_placeholder_staff_1', '0331112222', 'quan.pm@hotel.com'),
('Hoàng Thị Lan', 'Receptionist', 'receptionist01', 'hash_placeholder_staff_2', '0333334444', 'lan.ht@hotel.com'),
('Trần Văn Bình', 'Receptionist', 'receptionist02', 'hash_placeholder_staff_3', '0333334445', 'binh.tv@hotel.com');
GO

select [TypeName], [Capacity], [PricePerNight] from ROOM_TYPE;
