package controller;

import dao.*;
import model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;
    private BookingServiceDAO bookingServiceDAO;
    private ServiceDAO serviceDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        guestDAO = new GuestDAO();
        bookingServiceDAO = new BookingServiceDAO();
        serviceDAO = new ServiceDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    /**
     * Hàm gửi email xác nhận booking cho khách hàng
     * 
     * @param recipientEmail Email người nhận
     * @param booking Thông tin booking
     * @param bookingServices Danh sách dịch vụ đã đặt
     * @return true nếu gửi thành công, false nếu thất bại
     */
    protected boolean sendBookingConfirmationEmail(String recipientEmail, Booking booking, List<BookingService> bookingServices) {
        // Cấu hình email server
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        
        // Thông tin tài khoản email gửi (cần thay đổi theo thông tin thực tế)
        final String username = "your-email@gmail.com"; // Thay bằng email của bạn
        final String password = "your-app-password";     // Thay bằng app password
        
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
        
        try {
            // Lấy thông tin chi tiết
            Guest guest = guestDAO.getGuestById(booking.getGuestId());
            Room room = roomDAO.getRoomById(booking.getRoomId());
            RoomType roomType = null;
            if (room != null) {
                roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            }
            
            // Tạo nội dung email
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Xác nhận đặt phòng - Booking #" + booking.getBookingId());
            
            // Format ngày tháng
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            
            // Xây dựng nội dung HTML
            StringBuilder emailContent = new StringBuilder();
            emailContent.append("<html><body style='font-family: Arial, sans-serif;'>");
            emailContent.append("<div style='max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd;'>");
            
            // Header
            emailContent.append("<h2 style='color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px;'>");
            emailContent.append("Xác Nhận Đặt Phòng");
            emailContent.append("</h2>");
            
            // Thông báo thành công
            emailContent.append("<p style='color: #27ae60; font-size: 16px;'>");
            emailContent.append("✓ Đặt phòng của bạn đã được xác nhận thành công!");
            emailContent.append("</p>");
            
            // Thông tin khách hàng
            emailContent.append("<h3 style='color: #34495e; margin-top: 20px;'>Thông Tin Khách Hàng</h3>");
            emailContent.append("<table style='width: 100%; border-collapse: collapse;'>");
            if (guest != null) {
                emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Họ tên:</strong></td>");
                emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(guest.getFullName()).append("</td></tr>");
                emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Email:</strong></td>");
                emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(guest.getEmail()).append("</td></tr>");
                emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Số điện thoại:</strong></td>");
                emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(guest.getPhone()).append("</td></tr>");
            }
            emailContent.append("</table>");
            
            // Thông tin booking
            emailContent.append("<h3 style='color: #34495e; margin-top: 20px;'>Thông Tin Đặt Phòng</h3>");
            emailContent.append("<table style='width: 100%; border-collapse: collapse;'>");
            emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Mã đặt phòng:</strong></td>");
            emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(booking.getBookingId()).append("</td></tr>");
            emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Ngày đặt:</strong></td>");
            emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(booking.getBookingDate().format(dateFormatter)).append("</td></tr>");
            emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Trạng thái:</strong></td>");
            emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'><span style='color: #3498db;'>").append(booking.getStatus()).append("</span></td></tr>");
            emailContent.append("</table>");
            
            // Thông tin phòng
            emailContent.append("<h3 style='color: #34495e; margin-top: 20px;'>Thông Tin Phòng</h3>");
            emailContent.append("<table style='width: 100%; border-collapse: collapse;'>");
            if (room != null) {
                emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Số phòng:</strong></td>");
                emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(room.getRoomNumber()).append("</td></tr>");
                if (roomType != null) {
                    emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Loại phòng:</strong></td>");
                    emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(roomType.getTypeName()).append("</td></tr>");
                }
                emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Mô tả:</strong></td>");
                emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(room.getDescription() != null ? room.getDescription() : "N/A").append("</td></tr>");
            }
            emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Check-in:</strong></td>");
            emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(booking.getCheckInDate().format(dateTimeFormatter)).append("</td></tr>");
            emailContent.append("<tr><td style='padding: 8px; border-bottom: 1px solid #eee;'><strong>Check-out:</strong></td>");
            emailContent.append("<td style='padding: 8px; border-bottom: 1px solid #eee;'>").append(booking.getCheckOutDate().format(dateTimeFormatter)).append("</td></tr>");
            emailContent.append("</table>");
            
            // Dịch vụ đã đặt
            if (bookingServices != null && !bookingServices.isEmpty()) {
                emailContent.append("<h3 style='color: #34495e; margin-top: 20px;'>Dịch Vụ Đã Đặt</h3>");
                emailContent.append("<table style='width: 100%; border-collapse: collapse; border: 1px solid #ddd;'>");
                emailContent.append("<thead><tr style='background-color: #3498db; color: white;'>");
                emailContent.append("<th style='padding: 10px; text-align: left;'>Tên dịch vụ</th>");
                emailContent.append("<th style='padding: 10px; text-align: center;'>Số lượng</th>");
                emailContent.append("<th style='padding: 10px; text-align: left;'>Ngày sử dụng</th>");
                emailContent.append("<th style='padding: 10px; text-align: right;'>Đơn giá</th>");
                emailContent.append("</tr></thead><tbody>");
                
                for (BookingService bs : bookingServices) {
                    Service service = serviceDAO.getServiceById(bs.getServiceId());
                    if (service != null) {
                        emailContent.append("<tr style='border-bottom: 1px solid #ddd;'>");
                        emailContent.append("<td style='padding: 8px;'>").append(service.getServiceName()).append("</td>");
                        emailContent.append("<td style='padding: 8px; text-align: center;'>").append(bs.getQuantity()).append("</td>");
                        emailContent.append("<td style='padding: 8px;'>").append(bs.getServiceDate().format(dateFormatter)).append("</td>");
                        emailContent.append("<td style='padding: 8px; text-align: right;'>").append(String.format("%,d VNĐ", service.getPrice().longValue())).append("</td>");
                        emailContent.append("</tr>");
                    }
                }
                emailContent.append("</tbody></table>");
            }
            
            // Lưu ý
            emailContent.append("<div style='margin-top: 30px; padding: 15px; background-color: #fff3cd; border-left: 4px solid #ffc107;'>");
            emailContent.append("<h4 style='margin-top: 0; color: #856404;'>Lưu ý:</h4>");
            emailContent.append("<ul style='margin: 0; padding-left: 20px; color: #856404;'>");
            emailContent.append("<li>Vui lòng mang theo CMND/CCCD khi check-in</li>");
            emailContent.append("<li>Check-in: sau 14:00 | Check-out: trước 12:00</li>");
            emailContent.append("<li>Liên hệ lễ tân nếu cần hỗ trợ</li>");
            emailContent.append("</ul>");
            emailContent.append("</div>");
            
            // Footer
            emailContent.append("<p style='margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #7f8c8d; font-size: 14px;'>");
            emailContent.append("Cảm ơn bạn đã tin tưởng và lựa chọn dịch vụ của chúng tôi!<br>");
            emailContent.append("Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.<br><br>");
            emailContent.append("<strong>Hotel Management System</strong><br>");
            emailContent.append("Email: support@hotel.com | Hotline: 1900-xxxx");
            emailContent.append("</p>");
            
            emailContent.append("</div></body></html>");
            
            // Set nội dung email
            message.setContent(emailContent.toString(), "text/html; charset=UTF-8");
            
            // Gửi email
            Transport.send(message);
            
            System.out.println("Email đã được gửi thành công đến: " + recipientEmail);
            return true;
            
        } catch (MessagingException e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Implementation của doPost
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
