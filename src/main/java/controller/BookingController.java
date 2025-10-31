package controller;

import controller.feature.EmailSender;
import dao.*;
import model.*;
import utils.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

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

    protected int bookingHandle(int roomId, int guessId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate) {
        int returnValue = 0;

        Booking newBooking = new Booking(guessId, roomId, checkInDate, checkOutDate, bookingDate, "Reserved");
        try {
            returnValue = bookingDAO.addBookingV2(newBooking);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(returnValue);
        return returnValue;
    }

    protected boolean bookingServiceHandle(List<ChoosenService> services, int bookingId) {
        boolean resutlt = false;

        for (ChoosenService service : services) {
            try {
                BookingService newBookingService = new BookingService(bookingId, service.getServiceId(), service.getQuantity(), service.getServiceDate(), 0);
                resutlt = bookingServiceDAO.addBookingService(newBookingService);
                resutlt = true;
            } catch (Exception e) {
                e.printStackTrace();
                resutlt = false;
                break;
            }

        }

        return resutlt;
    }

    /**
     * Hàm gửi email xác nhận booking cho khách hàng
     * 
     * @param recipientEmail Email người nhận
     * @param bookingId ID của booking vừa tạo
     * @return true nếu gửi thành công, false nếu thất bại
     */
    protected boolean sendBookingConfirmationEmail(String recipientEmail, int bookingId) {
        try {
            // Lấy thông tin booking
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                System.err.println("Không tìm thấy booking với ID: " + bookingId);
                return false;
            }

            // Lấy thông tin guest
            Guest guest = guestDAO.getGuestById(booking.getGuestId());
            
            // Lấy thông tin room
            Room room = roomDAO.getRoomById(booking.getRoomId());
            
            // Lấy thông tin room type
            RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            
            // Lấy danh sách services của booking này
            List<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
            
            // Tính tổng số đêm
            long numberOfNights = ChronoUnit.DAYS.between(
                booking.getCheckInDate().toLocalDate(), 
                booking.getCheckOutDate().toLocalDate()
            );
            
            // Tính tổng tiền phòng
            BigDecimal roomTotal = roomType.getPricePerNight().multiply(BigDecimal.valueOf(numberOfNights));
            
            // Tính tổng tiền services và tạo bảng services
            BigDecimal servicesTotal = BigDecimal.ZERO;
            StringBuilder servicesHtml = new StringBuilder();
            
            if (bookingServices != null && !bookingServices.isEmpty()) {
                for (BookingService bs : bookingServices) {
                    Service service = serviceDAO.getServiceById(bs.getServiceId());
                    BigDecimal serviceItemTotal = service.getPrice().multiply(BigDecimal.valueOf(bs.getQuantity()));
                    servicesTotal = servicesTotal.add(serviceItemTotal);
                    
                    servicesHtml.append(String.format(
                        "<tr>" +
                        "<td style='padding: 12px; border-bottom: 1px solid #eee;'>%s</td>" +
                        "<td style='padding: 12px; border-bottom: 1px solid #eee; text-align: center;'>%d</td>" +
                        "<td style='padding: 12px; border-bottom: 1px solid #eee; text-align: center;'>%s</td>" +
                        "<td style='padding: 12px; border-bottom: 1px solid #eee; text-align: right;'>%,d VNĐ</td>" +
                        "<td style='padding: 12px; border-bottom: 1px solid #eee; text-align: right;'>%,d VNĐ</td>" +
                        "</tr>",
                        service.getServiceName(),
                        bs.getQuantity(),
                        bs.getServiceDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                        service.getPrice().intValue(),
                        serviceItemTotal.intValue()
                    ));
                }
            }
            
            // Tính tổng tiền
            BigDecimal grandTotal = roomTotal.add(servicesTotal);
            
            // Format ngày tháng
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            
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
                "<h1 style='color: #ffffff; margin: 0; font-size: 28px;'>✓ Xác Nhận Đặt Phòng</h1>" +
                "<p style='color: #ffffff; margin: 10px 0 0 0; opacity: 0.9;'>Mã đặt phòng: #%d</p>" +
                "</div>" +
                
                // Content
                "<div style='padding: 30px;'>" +
                
                // Greeting
                "<p style='color: #333; font-size: 16px; line-height: 1.6;'>Xin chào <strong>%s</strong>,</p>" +
                "<p style='color: #666; font-size: 14px; line-height: 1.6;'>Cảm ơn bạn đã đặt phòng tại khách sạn của chúng tôi. Dưới đây là thông tin chi tiết về đặt phòng của bạn:</p>" +
                
                // Booking Information
                "<div style='background-color: #f8f9fa; border-left: 4px solid #667eea; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>📋 Thông Tin Đặt Phòng</h2>" +
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; color: #666; width: 40%%;'>Mã đặt phòng:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>#%d</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Ngày đặt:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Trạng thái:</td><td style='padding: 8px 0;'><span style='background-color: #28a745; color: white; padding: 4px 12px; border-radius: 12px; font-size: 12px;'>%s</span></td></tr>" +
                "</table>" +
                "</div>" +
                
                // Room Information
                "<div style='background-color: #f8f9fa; border-left: 4px solid #764ba2; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>🏨 Thông Tin Phòng</h2>" +
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; color: #666; width: 40%%;'>Số phòng:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Loại phòng:</td><td style='padding: 8px 0; color: #333;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Sức chứa:</td><td style='padding: 8px 0; color: #333;'>%d người</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Giá phòng/đêm:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>%,d VNĐ</td></tr>" +
                "</table>" +
                "</div>" +
                
                // Check-in/out Information
                "<div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>📅 Thời Gian Lưu Trú</h2>" +
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; color: #666; width: 40%%;'>Nhận phòng:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Trả phòng:</td><td style='padding: 8px 0; color: #333; font-weight: bold;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Số đêm:</td><td style='padding: 8px 0; color: #333;'>%d đêm</td></tr>" +
                "</table>" +
                "</div>" +
                
                // Services (if any)
                "%s" +
                
                // Total Amount
                "<div style='background-color: #d1ecf1; border-left: 4px solid #17a2b8; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>💰 Chi Tiết Thanh Toán</h2>" +
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Tiền phòng (%d đêm):</td><td style='padding: 8px 0; color: #333; text-align: right;'>%,d VNĐ</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Tiền dịch vụ:</td><td style='padding: 8px 0; color: #333; text-align: right;'>%,d VNĐ</td></tr>" +
                "<tr style='border-top: 2px solid #17a2b8;'><td style='padding: 12px 0; color: #333; font-size: 18px; font-weight: bold;'>Tổng cộng:</td><td style='padding: 12px 0; color: #17a2b8; font-size: 20px; font-weight: bold; text-align: right;'>%,d VNĐ</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Đã thanh toán - Cọc 50%%:</td><td style='padding: 8px 0; color: #28a745; font-weight: bold; text-align: right;'>%,d VNĐ</td></tr>" +
                "<tr><td style='padding: 8px 0; color: #666;'>Còn lại:</td><td style='padding: 8px 0; color: #dc3545; font-weight: bold; text-align: right;'>%,d VNĐ</td></tr>" +
                "</table>" +
                "</div>" +
                
                // Note
                "<div style='background-color: #f8f9fa; padding: 15px; margin: 20px 0; border-radius: 4px;'>" +
                "<p style='color: #666; font-size: 13px; margin: 0; line-height: 1.6;'>" +
                "<strong>Lưu ý:</strong><br>" +
                "• Vui lòng mang theo giấy tờ tùy thân khi nhận phòng<br>" +
                "• Giờ nhận phòng: 14:00 | Giờ trả phòng: 12:00<br>" +
                "• Số tiền còn lại sẽ được thanh toán khi trả phòng<br>" +
                "• Nếu cần hỗ trợ, vui lòng liên hệ: support@hotel.com hoặc gọi: 1900-xxxx" +
                "</p>" +
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
                bookingId,
                guest.getFullName(),
                bookingId,
                booking.getBookingDate().format(dateFormatter),
                booking.getStatus(),
                room.getRoomNumber(),
                roomType.getTypeName(),
                roomType.getCapacity(),
                roomType.getPricePerNight().intValue(),
                booking.getCheckInDate().format(dateTimeFormatter),
                booking.getCheckOutDate().format(dateTimeFormatter),
                numberOfNights,
                
                // Services section (conditional)
                bookingServices != null && !bookingServices.isEmpty() ? 
                    String.format(
                        "<div style='background-color: #f8f9fa; border-left: 4px solid #28a745; padding: 20px; margin: 20px 0; border-radius: 4px;'>" +
                        "<h2 style='color: #333; margin: 0 0 15px 0; font-size: 18px;'>🛎️ Dịch Vụ Đã Đặt</h2>" +
                        "<table style='width: 100%%; border-collapse: collapse;'>" +
                        "<thead>" +
                        "<tr style='background-color: #e9ecef;'>" +
                        "<th style='padding: 12px; text-align: left; color: #495057;'>Dịch vụ</th>" +
                        "<th style='padding: 12px; text-align: center; color: #495057;'>SL</th>" +
                        "<th style='padding: 12px; text-align: center; color: #495057;'>Ngày sử dụng</th>" +
                        "<th style='padding: 12px; text-align: right; color: #495057;'>Đơn giá</th>" +
                        "<th style='padding: 12px; text-align: right; color: #495057;'>Thành tiền</th>" +
                        "</tr>" +
                        "</thead>" +
                        "<tbody>" +
                        "%s" +
                        "</tbody>" +
                        "</table>" +
                        "</div>",
                        servicesHtml.toString()
                    ) : "",
                
                numberOfNights,
                roomTotal.intValue(),
                servicesTotal.intValue(),
                grandTotal.intValue(),
                grandTotal.divide(BigDecimal.valueOf(2)).intValue(),
                grandTotal.divide(BigDecimal.valueOf(2)).intValue()
            );
            
            // Gửi email
            EmailSender emailSender = new EmailSender();
            boolean result = emailSender.sendHtmlEmail(
                recipientEmail, 
                "Xác nhận đặt phòng #" + bookingId + " - Hotel Management System",
                htmlContent
            );
            
            if (result) {
                System.out.println("✓ Đã gửi email xác nhận booking #" + bookingId + " đến: " + recipientEmail);
            }
            
            return result;
            
        } catch (Exception e) {
            System.err.println("✗ Lỗi khi gửi email xác nhận booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /*
         * http://localhost:8080/PRJ_Assignment/booking?
         * roomId=1&bookingDate=2025-09-28&guestId=1&fullName=Nguy%3Fn+Van+An&email=nguyenvanan%40email.com&checkInDate=2025-09-27&checkOutDate=2025-09-30&
         * serviceId=1&serviceQuantity=1&serviceDate=2025-09-27&
         * serviceId=1&serviceQuantity=1&serviceDate=2025-09-28&
         * serviceId=3&serviceQuantity=1&serviceDate=2025-09-27
         *
         * */
        String roomId = req.getParameter("roomId");
        String guestId = req.getParameter("guestId");

        String checkInDate = req.getParameter("checkInDate");
        String checkOutDate = req.getParameter("checkOutDate");
        String bookingDate = req.getParameter("bookingDate");
        //Convert to LocalDateTime
        LocalDate inDate = LocalDate.parse(checkInDate);
        LocalDate outDate = LocalDate.parse(checkOutDate);
        LocalDate bookDate = LocalDate.parse(bookingDate);
        //Change to 00:00:00 and 23:59:59
        LocalDateTime inDateTime = inDate.atStartOfDay();
        LocalDateTime outDateTime = outDate.atTime(23, 59, 59);

        ArrayList<ChoosenService> services = new ArrayList<>();
        String[] serviceId = (String[]) req.getParameterValues("serviceId");
        String[] serviceQuantity = (String[]) req.getParameterValues("serviceQuantity");
        String[] serviceDate = (String[]) req.getParameterValues("serviceDate");
        String totalAmount = req.getParameter("totalAmount");
        System.out.println("Total amount: " + totalAmount);
        if (serviceId != null && serviceQuantity != null && serviceDate != null) {
            for (int i = 0; i < serviceId.length; i++) {
                ChoosenService tmpService = new ChoosenService(Integer.parseInt(serviceId[i]), Integer.parseInt(serviceQuantity[i]), LocalDate.parse(serviceDate[i]));
                services.add(tmpService);
            }
        }
        // Transaction start
        int newBookingId = 0;
        Connection conn = null;
        
        try {
            
            // Bước 1: Lấy connection và tắt auto-commit
            //Tắt auto-commit: để tránh trường hợp nó sẽ tự commit khi mà những cái ở dưới có lỗi
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            System.out.println("=== BẮT ĐẦU TRANSACTION ===");
            
            // Bước 2: Tạo booking
            Booking newBooking = new Booking(Integer.parseInt(guestId), Integer.parseInt(roomId), inDateTime, outDateTime, bookDate, "Reserved");
            newBookingId = bookingDAO.addBookingWithTransaction(newBooking, conn);
            
            if (newBookingId <= 0) {
                throw new SQLException("Không thể tạo booking");
            }
            System.out.println("✓ Đã tạo booking ID: " + newBookingId);
            
            // Bước 3: Thêm các dịch vụ
            if (!services.isEmpty()) {
                for (ChoosenService service : services) {
                    BookingService newBookingService = new BookingService(
                        newBookingId, 
                        service.getServiceId(), 
                        service.getQuantity(), 
                        service.getServiceDate(), 
                        0
                    );
                    boolean serviceAdded = bookingServiceDAO.addBookingServiceWithTransaction(newBookingService, conn);
                    if (!serviceAdded) {
                        throw new SQLException("Không thể thêm dịch vụ ID: " + service.getServiceId());
                    }

                    if (service.getServiceId() == 3) {
                        RoomTask roomTask = new RoomTask(newBookingId, null, newBookingService.getServiceDate().atStartOfDay(), newBookingService.getServiceDate().atTime(23, 59, 59), "Pending", null, 0);
                        RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                        boolean roomTaskAdded = roomTaskDAO.insertRoomTaskForServiceForTransaction(roomTask, conn);
                        if (!roomTaskAdded) {
                            throw new SQLException("Không thể thêm task phòng");
                        }
                    }
                }
                System.out.println("✓ Đã thêm " + services.size() + " dịch vụ");
            }
            
            // Bước 4: Tạo payment (cọc 50%)
            Payment newPayment = new Payment(
                newBookingId, 
                bookDate, 
                (double) (Integer.parseInt(totalAmount)) / 2.0, 
                "Credit Card",
                "Pending"
            );
            PaymentDAO paymentDAO = new PaymentDAO();
            boolean paymentAdded = paymentDAO.addPaymentWithTransaction(newPayment, conn);
            
            if (!paymentAdded) {
                throw new SQLException("Không thể tạo payment");
            }
            System.out.println("✓ Đã tạo payment với số tiền: " + newPayment.getAmount() + " VNĐ");
            
            // Bước 5: COMMIT - Tất cả thành công
            conn.commit();
            System.out.println("✓✓✓ COMMIT THÀNH CÔNG - Booking ID: " + newBookingId + " ✓✓✓");
            
        } catch (Exception e) {
            // Bước 6: ROLLBACK nếu có lỗi
            System.err.println("✗✗✗ LỖI XẢY RA - BẮT ĐẦU ROLLBACK ✗✗✗");
            e.printStackTrace();
            
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("✗ ROLLBACK HOÀN TẤT - Tất cả thay đổi đã được hoàn tác");
                } catch (SQLException rollbackEx) {
                    System.err.println("✗✗ LỖI KHI ROLLBACK");
                    rollbackEx.printStackTrace();
                }
            }
            newBookingId = 0; // Reset về 0 để báo lỗi
        } finally {
            // Bước 7: Đóng connection và restore auto-commit
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
        // Transaction end

        // Kiểm tra kết quả và redirect
        if (newBookingId > 0) {
            // ✓ THÀNH CÔNG: Gửi email và chuyển đến trang xác nhận
            Guest viewGuest = guestDAO.getGuestById(Integer.parseInt(guestId));
            String recipientEmail = viewGuest.getEmail();
            
            if (recipientEmail != null && !recipientEmail.trim().isEmpty()) {
                // Gửi email trong thread riêng để không block response
                final int finalBookingId = newBookingId;
                final String finalEmail = recipientEmail;
                new Thread(() -> {
                    sendBookingConfirmationEmail(finalEmail, finalBookingId);
                }).start();
            }
            
            // Redirect đến trang xác nhận booking
            resp.sendRedirect("./viewBookingAfter?bookingId=" + newBookingId);
            
        } else {
            // ✗ THẤT BẠI: Redirect về trang chủ với thông báo lỗi
            System.err.println("✗ Booking thất bại, redirect về trang chủ với thông báo lỗi");
            resp.sendRedirect("./home?error=booking_failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
