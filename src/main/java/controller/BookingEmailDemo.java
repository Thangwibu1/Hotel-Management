package controller;

import dao.*;
import model.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Class demo minh họa cách sử dụng hàm sendBookingConfirmationEmail
 * 
 * CÁCH SỬ DỤNG:
 * 1. Đảm bảo đã có booking trong database
 * 2. Uncomment phần code trong main method
 * 3. Thay thế bookingId và email thực tế
 * 4. Run class này để test gửi email
 */
public class BookingEmailDemo {
    
    /**
     * Ví dụ 1: Gửi email cho một booking đã tồn tại
     */
    public static void sendEmailForExistingBooking() {
        BookingController controller = new BookingController();
        try {
            controller.init();
            
            // Thay thế bằng booking ID và email thực tế của bạn
            int bookingId = 1; // ID của booking đã tồn tại trong DB
            String customerEmail = "customer@example.com"; // Email khách hàng
            
            boolean result = controller.sendBookingConfirmationEmail(customerEmail, bookingId);
            
            if (result) {
                System.out.println("✓ Email đã được gửi thành công!");
            } else {
                System.out.println("✗ Có lỗi khi gửi email!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Ví dụ 2: Tạo booking mới và gửi email tự động
     */
    public static void createBookingAndSendEmail() {
        try {
            // Khởi tạo DAOs
            BookingDAO bookingDAO = new BookingDAO();
            GuestDAO guestDAO = new GuestDAO();
            
            // Tạo booking mới
            int guestId = 1; // ID khách hàng có sẵn
            int roomId = 101; // ID phòng có sẵn
            LocalDateTime checkIn = LocalDateTime.now().plusDays(7);
            LocalDateTime checkOut = LocalDateTime.now().plusDays(10);
            LocalDate bookingDate = LocalDate.now();
            
            Booking newBooking = new Booking(
                guestId, 
                roomId, 
                checkIn, 
                checkOut, 
                bookingDate, 
                "Reserved"
            );
            
            int newBookingId = bookingDAO.addBookingV2(newBooking);
            
            if (newBookingId > 0) {
                System.out.println("✓ Booking đã được tạo với ID: " + newBookingId);
                
                // Lấy email khách hàng
                Guest guest = guestDAO.getGuestById(guestId);
                String email = guest.getEmail();
                
                // Gửi email xác nhận
                BookingController controller = new BookingController();
                controller.init();
                
                boolean emailSent = controller.sendBookingConfirmationEmail(email, newBookingId);
                
                if (emailSent) {
                    System.out.println("✓ Email xác nhận đã được gửi đến: " + email);
                } else {
                    System.out.println("✗ Không thể gửi email xác nhận!");
                }
            } else {
                System.out.println("✗ Không thể tạo booking!");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Ví dụ 3: Gửi email async (không block thread chính)
     */
    public static void sendEmailAsync(int bookingId, String email) {
        BookingController controller = new BookingController();
        try {
            controller.init();
            
            System.out.println("Bắt đầu gửi email trong background...");
            
            // Gửi email trong thread riêng
            final int finalBookingId = bookingId;
            final String finalEmail = email;
            
            Thread emailThread = new Thread(() -> {
                System.out.println("→ Thread email đã start...");
                boolean result = controller.sendBookingConfirmationEmail(finalEmail, finalBookingId);
                if (result) {
                    System.out.println("✓ Email đã được gửi trong background!");
                } else {
                    System.out.println("✗ Lỗi khi gửi email trong background!");
                }
            });
            
            emailThread.start();
            
            System.out.println("Main thread tiếp tục chạy không bị block...");
            System.out.println("Có thể thực hiện các tác vụ khác trong khi email đang được gửi!");
            
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Ví dụ 4: Gửi email cho nhiều bookings
     */
    public static void sendBulkEmails() {
        BookingController controller = new BookingController();
        BookingDAO bookingDAO = new BookingDAO();
        GuestDAO guestDAO = new GuestDAO();
        
        try {
            controller.init();
            
            // Danh sách booking IDs cần gửi email
            int[] bookingIds = {1, 2, 3, 4, 5};
            
            int successCount = 0;
            int failCount = 0;
            
            for (int bookingId : bookingIds) {
                try {
                    // Lấy thông tin booking
                    Booking booking = bookingDAO.getBookingById(bookingId);
                    if (booking == null) {
                        System.out.println("⚠ Booking #" + bookingId + " không tồn tại, bỏ qua...");
                        failCount++;
                        continue;
                    }
                    
                    // Lấy email khách hàng
                    Guest guest = guestDAO.getGuestById(booking.getGuestId());
                    String email = guest.getEmail();
                    
                    if (email == null || email.trim().isEmpty()) {
                        System.out.println("⚠ Booking #" + bookingId + " không có email, bỏ qua...");
                        failCount++;
                        continue;
                    }
                    
                    // Gửi email
                    boolean result = controller.sendBookingConfirmationEmail(email, bookingId);
                    
                    if (result) {
                        System.out.println("✓ Booking #" + bookingId + " → Email sent to " + email);
                        successCount++;
                    } else {
                        System.out.println("✗ Booking #" + bookingId + " → Failed");
                        failCount++;
                    }
                    
                    // Delay 1 giây giữa các email để tránh spam
                    Thread.sleep(1000);
                    
                } catch (Exception e) {
                    System.err.println("✗ Lỗi khi xử lý booking #" + bookingId + ": " + e.getMessage());
                    failCount++;
                }
            }
            
            System.out.println("\n=== KẾT QUẢ ===");
            System.out.println("Tổng số: " + bookingIds.length);
            System.out.println("Thành công: " + successCount);
            System.out.println("Thất bại: " + failCount);
            
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Ví dụ 5: Kiểm tra và validate trước khi gửi
     */
    public static void sendEmailWithValidation(int bookingId, String email) {
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            System.err.println("✗ Email không hợp lệ!");
            return;
        }
        
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            System.err.println("✗ Format email không đúng!");
            return;
        }
        
        if (bookingId <= 0) {
            System.err.println("✗ Booking ID không hợp lệ!");
            return;
        }
        
        // Kiểm tra booking tồn tại
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        
        if (booking == null) {
            System.err.println("✗ Booking #" + bookingId + " không tồn tại trong database!");
            return;
        }
        
        // Tất cả validation passed, gửi email
        BookingController controller = new BookingController();
        try {
            controller.init();
            boolean result = controller.sendBookingConfirmationEmail(email, bookingId);
            
            if (result) {
                System.out.println("✓ Email validation passed và đã gửi thành công!");
            } else {
                System.out.println("✗ Email validation passed nhưng gửi thất bại!");
            }
        } catch (Exception e) {
            System.err.println("✗ Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Main method để test
     * Uncomment phần code bạn muốn test
     */
    public static void main(String[] args) {
        System.out.println("=== DEMO BOOKING EMAIL SENDER ===\n");
        
        // Uncomment để test các ví dụ
        
        // Ví dụ 1: Gửi email cho booking có sẵn
        // sendEmailForExistingBooking();
        
        // Ví dụ 2: Tạo booking mới và gửi email
        // createBookingAndSendEmail();
        
        // Ví dụ 3: Gửi email async
        // sendEmailAsync(1, "test@example.com");
        
        // Ví dụ 4: Gửi hàng loạt
        // sendBulkEmails();
        
        // Ví dụ 5: Gửi với validation
        // sendEmailWithValidation(1, "customer@example.com");
        
        System.out.println("\n=== DEMO COMPLETED ===");
    }
}

