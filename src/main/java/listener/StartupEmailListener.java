package listener;

import controller.feature.EmailSender;
import dao.GuestDAO;
import model.Guest;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.ArrayList;
import java.util.List;

@WebListener
public class StartupEmailListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // try {
            
        //     System.out.println("INFO: Server is starting, attempting to send startup email to all guests.");

        //     // Lấy danh sách tất cả guest từ database
        //     GuestDAO guestDAO = new GuestDAO();
        //     ArrayList<Guest> allGuests = guestDAO.getAllGuest();

        //     if (allGuests == null || allGuests.isEmpty()) {
        //         System.out.println("INFO: No guests found in database. Skipping startup email.");
        //         return;
        //     }

        //     // Lọc các guest có email hợp lệ
        //     List<String> guestEmails = new ArrayList<>();
        //     for (Guest guest : allGuests) {
        //         String email = guest.getEmail();
        //         if (email != null && !email.trim().isEmpty() && email.contains("@")) {
        //             guestEmails.add(email);
        //         }
        //     }

        //     if (guestEmails.isEmpty()) {
        //         System.out.println("INFO: No valid guest emails found. Skipping startup email.");
        //         return;
        //     }

        //     System.out.println("INFO: Found " + guestEmails.size() + " valid guest emails.");

        //     // Khởi tạo EmailSender
        //     EmailSender emailSender = new EmailSender();

        //     String subject = "Thông báo: Hệ thống khách sạn đã khởi động";
        //     String body = "Kính chào Quý khách,\n\n"
        //             + "Hệ thống quản lý khách sạn của chúng tôi đã được khởi động thành công.\n"
        //             + "Quý khách có thể tiếp tục sử dụng các dịch vụ đặt phòng và quản lý.\n\n"
        //             + "Trân trọng,\n"
        //             + "Hotel Management System";

        //     // Gửi email cho tất cả guest
        //     int successCount = 0;
        //     int failCount = 0;

        //     for (String email : guestEmails) {
        //         try {
        //             boolean success = emailSender.sendTextEmail(email, subject, body);
        //             if (success) {
        //                 successCount++;
        //             } else {
        //                 failCount++;
        //             }
        //             // Thêm delay nhỏ giữa các email để tránh spam
        //             Thread.sleep(100);
        //         } catch (Exception e) {
        //             System.err.println("ERROR: Failed to send email to: " + email);
        //             failCount++;
        //         }
        //     }

        //     System.out.println("INFO: Startup email summary - Success: " + successCount + ", Failed: " + failCount);

        // } catch (Exception e) {
        //     System.err.println("ERROR: An unexpected error occurred in StartupEmailListener during startup.");
        //     e.printStackTrace();
        // }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // try {
        //     System.out.println("INFO: Server is shutting down, attempting to send shutdown email to all guests.");

        //     // Lấy danh sách tất cả guest từ database
        //     GuestDAO guestDAO = new GuestDAO();
        //     ArrayList<Guest> allGuests = guestDAO.getAllGuest();

        //     if (allGuests == null || allGuests.isEmpty()) {
        //         System.out.println("INFO: No guests found in database. Skipping shutdown email.");
        //         return;
        //     }

        //     // Lọc các guest có email hợp lệ
        //     List<String> guestEmails = new ArrayList<>();
        //     for (Guest guest : allGuests) {
        //         String email = guest.getEmail();
        //         if (email != null && !email.trim().isEmpty() && email.contains("@")) {
        //             guestEmails.add(email);
        //         }
        //     }

        //     if (guestEmails.isEmpty()) {
        //         System.out.println("INFO: No valid guest emails found. Skipping shutdown email.");
        //         return;
        //     }

        //     System.out.println("INFO: Found " + guestEmails.size() + " valid guest emails.");

        //     // Khởi tạo EmailSender
        //     EmailSender emailSender = new EmailSender();

        //     String subject = "Thông báo: Hệ thống khách sạn đang bảo trì";
        //     String body = "Kính chào Quý khách,\n\n"
        //             + "Hệ thống quản lý khách sạn của chúng tôi đang tạm dừng để bảo trì.\n"
        //             + "Chúng tôi sẽ quay lại phục vụ Quý khách trong thời gian sớm nhất.\n\n"
        //             + "Xin cảm ơn sự thông cảm của Quý khách.\n\n"
        //             + "Trân trọng,\n"
        //             + "Hotel Management System";

        //     // Gửi email cho tất cả guest
        //     int successCount = 0;
        //     int failCount = 0;

        //     for (String email : guestEmails) {
        //         try {
        //             boolean success = emailSender.sendTextEmail(email, subject, body);
        //             if (success) {
        //                 successCount++;
        //             } else {
        //                 failCount++;
        //             }
        //             // Thêm delay nhỏ giữa các email để tránh spam
        //             Thread.sleep(100);
        //         } catch (Exception e) {
        //             System.err.println("ERROR: Failed to send shutdown email to: " + email);
        //             failCount++;
        //         }
        //     }

        //     System.out.println("INFO: Shutdown email summary - Success: " + successCount + ", Failed: " + failCount);

        // } catch (Exception e) {
        //     System.err.println("ERROR: An unexpected error occurred during server shutdown email notification.");
        //     e.printStackTrace();
        // }
    }
}