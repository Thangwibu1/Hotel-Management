package controller;


import controller.feature.EmailSender;
import dao.GuestDAO;
import model.Guest;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
    }

    public boolean validate(String email, String idNumber) {
        return guestDAO.checkDuplicateEmail(email) || guestDAO.checkDuplicateIdNumber(idNumber);
    }

    public boolean addGuest(String fullName, String phone, String email, String password, String address, String idNumber, String dateOfBirth) {
        return guestDAO.addGuest(new Guest(fullName, phone, email, address, idNumber, dateOfBirth, password));
    }

    /**
     * Hàm gửi email chào mừng người dùng mới đăng ký
     * 
     * @param recipientEmail Email người nhận
     * @param guest Thông tin Guest vừa đăng ký
     * @return true nếu gửi thành công, false nếu thất bại
     */
    protected boolean sendWelcomeEmail(String recipientEmail, Guest guest) {
        try {
            if (guest == null) {
                System.err.println("Không tìm thấy thông tin khách hàng");
                return false;
            }

            // Format ngày tháng
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            String registrationDate = LocalDate.now().format(dateFormatter);
            
            // Format ngày sinh nếu có
            String formattedDOB = "";
            if (guest.getDateOfBirth() != null && !guest.getDateOfBirth().isEmpty()) {
                try {
                    LocalDate dob = LocalDate.parse(guest.getDateOfBirth());
                    formattedDOB = dob.format(dateFormatter);
                } catch (Exception e) {
                    formattedDOB = guest.getDateOfBirth();
                }
            }
            
            // Tạo nội dung email HTML
            String htmlContent = String.format(
                "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
                "<div style='max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
                
                // Header
                "<div style='background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); padding: 30px; text-align: center;'>" +
                "<h1 style='color: #ffffff; margin: 0; font-size: 28px;'>🎉 Chào Mừng Đến Với Hotel Management</h1>" +
                "<p style='color: #ffffff; margin: 10px 0 0 0; opacity: 0.9;'>Đăng ký tài khoản thành công!</p>" +
                "</div>" +
                
                // Content
                "<div style='padding: 30px;'>" +
                
                // Greeting
                "<p style='color: #333; font-size: 16px; line-height: 1.6;'>Xin chào <strong>%s</strong>,</p>" +
                "<p style='color: #666; font-size: 14px; line-height: 1.6;'>Cảm ơn bạn đã đăng ký tài khoản tại hệ thống quản lý khách sạn của chúng tôi. Tài khoản của bạn đã được tạo thành công và bạn có thể bắt đầu trải nghiệm các dịch vụ của chúng tôi.</p>" +
                
                // Account Information
                "<div style='background-color: #f8f9fa; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>👤 Thông Tin Tài Khoản</h2>" +
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; color: #666; width: 40%%;'>Họ và tên:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Email:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Số điện thoại:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>CMND/CCCD:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "%s" + // Date of birth (optional)
                "%s" + // Address (optional)
                "<tr><td style='padding: 8px 0; color: #666;'>Ngày đăng ký:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "</table>" +
                "</div>" +
                
                // Benefits
                "<div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>✨ Quyền Lợi Của Thành Viên</h2>" +
                "<ul style='color: #666; font-size: 14px; line-height: 1.8; margin: 0; padding-left: 20px;'>" +
                "<li>Đặt phòng trực tuyến nhanh chóng và tiện lợi</li>" +
                "<li>Theo dõi lịch sử đặt phòng của bạn</li>" +
                "<li>Nhận thông tin ưu đãi và khuyến mãi đặc biệt</li>" +
                "<li>Quản lý thông tin cá nhân dễ dàng</li>" +
                "<li>Đặt các dịch vụ bổ sung cho kỳ nghỉ của bạn</li>" +
                "</ul>" +
                "</div>" +
                
                // Next Steps
                "<div style='background-color: #d1ecf1; border-left: 4px solid #17a2b8; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>🚀 Bước Tiếp Theo</h2>" +
                "<p style='color: #666; font-size: 14px; line-height: 1.6; margin: 0 0 10px 0;'>Bây giờ bạn có thể:</p>" +
                "<ul style='color: #666; font-size: 14px; line-height: 1.8; margin: 0; padding-left: 20px;'>" +
                "<li>Đăng nhập vào tài khoản của bạn</li>" +
                "<li>Khám phá các loại phòng của chúng tôi</li>" +
                "<li>Đặt phòng cho kỳ nghỉ sắp tới</li>" +
                "<li>Cập nhật thông tin cá nhân nếu cần</li>" +
                "</ul>" +
                "</div>" +
                
                // Support Information
                "<div style='background-color: #f8f9fa; padding: 15px; margin: 20px 0; border-radius: 4px;'>" +
                "<p style='color: #666; font-size: 13px; margin: 0; line-height: 1.6;'>" +
                "<strong>💡 Cần hỗ trợ?</strong><br>" +
                "Nếu bạn có bất kỳ câu hỏi nào hoặc cần hỗ trợ, đừng ngần ngại liên hệ với chúng tôi:<br>" +
                "📧 Email: support@hotel.com<br>" +
                "📞 Hotline: 1900-xxxx<br>" +
                "🕐 Thời gian làm việc: 24/7" +
                "</p>" +
                "</div>" +
                
                // Call to Action
                "<div style='text-align: center; margin: 30px 0;'>" +
                "<a href='http://localhost:8080/Hotel-Management/loginPage.jsp' style='display: inline-block; background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); color: #ffffff; text-decoration: none; padding: 12px 30px; border-radius: 25px; font-size: 16px; font-weight: bold;'>Đăng Nhập Ngay</a>" +
                "</div>" +
                
                "</div>" +
                
                // Footer
                "<div style='background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #dee2e6;'>" +
                "<p style='color: #666; font-size: 14px; margin: 0;'>Cảm ơn bạn đã tin tưởng và lựa chọn dịch vụ của chúng tôi!</p>" +
                "<p style='color: #999; font-size: 12px; margin: 10px 0 0 0;'>© 2025 Hotel Management System. All rights reserved.</p>" +
                "</div>" +
                
                "</div>" +
                "</body>" +
                "</html>",
                
                // Parameters
                guest.getFullName(),                                          // Greeting name
                guest.getFullName(),                                          // Full name in table
                guest.getEmail(),                                             // Email
                guest.getPhone() != null ? guest.getPhone() : "Chưa cập nhật", // Phone
                guest.getIdNumber() != null ? guest.getIdNumber() : "Chưa cập nhật", // ID Number
                
                // Date of birth (conditional)
                !formattedDOB.isEmpty() ? 
                    String.format("<tr><td style='padding: 8px 0; color: #666;'>Ngày sinh:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>", formattedDOB) 
                    : "",
                
                // Address (conditional)
                guest.getAddress() != null && !guest.getAddress().isEmpty() ? 
                    String.format("<tr><td style='padding: 8px 0; color: #666;'>Địa chỉ:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>", guest.getAddress()) 
                    : "",
                
                registrationDate                                              // Registration date
            );
            
            // Gửi email
            EmailSender emailSender = new EmailSender();
            boolean result = emailSender.sendHtmlEmail(
                recipientEmail, 
                "Chào mừng bạn đến với Hotel Management System! 🎉",
                htmlContent
            );
            
            if (result) {
                System.out.println("✓ Đã gửi email chào mừng đến: " + recipientEmail);
            } else {
                System.err.println("✗ Không thể gửi email chào mừng đến: " + recipientEmail);
            }
            
            return result;
            
        } catch (Exception e) {
            System.err.println("✗ Lỗi khi gửi email chào mừng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        fullName=abc&email=abc%40gmail.com&
//        password=abc123&confirmPassword=abc123&
//        phone=0909090909&
//        dateOfBirth=2005-02-08&
//        address=abc&
//        idNumber=0909090909
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String dateOfBirth = req.getParameter("dateOfBirth");
        String address = req.getParameter("address");
        String idNumber = req.getParameter("idNumber");
        
        try {
            // Validate password match
            if (!password.equals(confirmPassword)) {
                resp.sendRedirect(IConstant.registerPage + "?error=Mật khẩu xác nhận không khớp");
                return;
            }
            
            if (!validate(email, idNumber)) {
                boolean success = addGuest(fullName, phone, email, password, address, idNumber, dateOfBirth);
                if (success) {
                    // Lấy thông tin guest vừa tạo để gửi email
                    Guest newGuest = guestDAO.getGuestByEmail(email);
                    
                    if (newGuest != null && email != null && !email.trim().isEmpty()) {
                        // Gửi email trong thread riêng để không block response
                        final Guest finalGuest = newGuest;
                        final String finalEmail = email;
                        new Thread(() -> {
                            sendWelcomeEmail(finalEmail, finalGuest);
                        }).start();
                    }
                    
                    req.setAttribute("fullName", fullName);
                    req.setAttribute("email", email);
                    req.setAttribute("phone", phone);
                    req.setAttribute("dateOfBirth", dateOfBirth);
                    req.setAttribute("address", address);
                    req.setAttribute("idNumber", idNumber);
                    req.getRequestDispatcher(IConstant.registerSuccess).forward(req, resp);
                } else {
                    resp.sendRedirect(IConstant.registerPage + "?error=Không thể tạo tài khoản. Vui lòng thử lại sau.");
                    return;
                }
            } else {
                System.out.println("Email hoặc CMND/CCCD đã được sử dụng");
                resp.sendRedirect(IConstant.registerPage + "?error=Email or ID number is already used");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(IConstant.registerPage + "?error=Đã có lỗi xảy ra. Vui lòng thử lại sau.");
        }



    }
}
