package controller;

import controller.feature.EmailSender;
import dao.*;
import model.*;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

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
     * Hàm gửi email xác nhận đặt phòng cho khách hàng
     * 
     * @param recipientEmail Email người nhận
     * @param bookingId ID của booking để lấy thông tin chi tiết
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
            if (guest == null) {
                System.err.println("Không tìm thấy guest với ID: " + booking.getGuestId());
                return false;
            }

            // Lấy thông tin room
            Room room = roomDAO.getRoomById(booking.getRoomId());
            if (room == null) {
                System.err.println("Không tìm thấy room với ID: " + booking.getRoomId());
                return false;
            }

            // Lấy thông tin room type
            RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            if (roomType == null) {
                System.err.println("Không tìm thấy room type với ID: " + room.getRoomTypeId());
                return false;
            }

            // Lấy danh sách booking services
            List<BookingService> bookingServices = bookingServiceDAO.getBookingServicesByBookingId(bookingId);
            
            // Tính toán số đêm lưu trú
            long numberOfNights = ChronoUnit.DAYS.between(
                booking.getCheckInDate().toLocalDate(), 
                booking.getCheckOutDate().toLocalDate()
            );

            // Tính tổng tiền phòng
            BigDecimal roomTotal = roomType.getPricePerNight().multiply(BigDecimal.valueOf(numberOfNights));

            // Tính tổng tiền dịch vụ
            BigDecimal serviceTotal = BigDecimal.ZERO;
            StringBuilder serviceDetails = new StringBuilder();
            
            if (bookingServices != null && !bookingServices.isEmpty()) {
                for (BookingService bs : bookingServices) {
                    Service service = serviceDAO.getServiceById(bs.getServiceId());
                    if (service != null) {
                        BigDecimal serviceAmount = service.getPrice().multiply(BigDecimal.valueOf(bs.getQuantity()));
                        serviceTotal = serviceTotal.add(serviceAmount);
                        
                        // Format chi tiết dịch vụ
                        serviceDetails.append(String.format(
                            "                    <tr>\n" +
                            "                        <td style='padding: 8px; border-bottom: 1px solid #e0e0e0;'>%s</td>\n" +
                            "                        <td style='padding: 8px; border-bottom: 1px solid #e0e0e0; text-align: center;'>%d</td>\n" +
                            "                        <td style='padding: 8px; border-bottom: 1px solid #e0e0e0; text-align: center;'>%s</td>\n" +
                            "                        <td style='padding: 8px; border-bottom: 1px solid #e0e0e0; text-align: right;'>%,.0f VNĐ</td>\n" +
                            "                        <td style='padding: 8px; border-bottom: 1px solid #e0e0e0; text-align: right;'>%,.0f VNĐ</td>\n" +
                            "                    </tr>\n",
                            service.getServiceName(),
                            bs.getQuantity(),
                            bs.getServiceDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
                            service.getPrice(),
                            serviceAmount
                        ));
                    }
                }
            }

            // Tính tổng tiền
            BigDecimal totalAmount = roomTotal.add(serviceTotal);

            // Format ngày tháng
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            // Tạo nội dung email HTML
            String emailContent = buildEmailContent(
                booking,
                guest,
                room,
                roomType,
                numberOfNights,
                roomTotal,
                serviceDetails.toString(),
                serviceTotal,
                totalAmount,
                dateFormatter,
                dateTimeFormatter
            );

            // Cấu hình email server
            Properties properties = new Properties();
            properties.put("mail.smtp.host", "smtp.gmail.com"); // Thay đổi theo mail server của bạn
            properties.put("mail.smtp.port", "587");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            // Thông tin đăng nhập email (nên lưu trong file cấu hình hoặc biến môi trường)
            final String username = "your-email@gmail.com"; // Thay đổi email của bạn
            final String password = "your-app-password"; // Thay đổi password của bạn

            // Tạo session
            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            // Tạo message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username, "Hotel Management System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Xác nhận đặt phòng #" + bookingId + " - Hotel Management");
            message.setContent(emailContent, "text/html; charset=UTF-8");

            // Gửi email
            Transport.send(message);
            
            System.out.println("Email đã được gửi thành công đến: " + recipientEmail);
            return true;

        } catch (Exception e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Hàm xây dựng nội dung email HTML
     */
    private String buildEmailContent(
            Booking booking,
            Guest guest,
            Room room,
            RoomType roomType,
            long numberOfNights,
            BigDecimal roomTotal,
            String serviceDetailsHtml,
            BigDecimal serviceTotal,
            BigDecimal totalAmount,
            DateTimeFormatter dateFormatter,
            DateTimeFormatter dateTimeFormatter) {

        return String.format(
            "<!DOCTYPE html>\n" +
            "<html>\n" +
            "<head>\n" +
            "    <meta charset='UTF-8'>\n" +
            "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n" +
            "</head>\n" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px;'>\n" +
            "    <div style='background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%); padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>\n" +
            "        <h1 style='color: white; margin: 0; font-size: 28px;'>Xác Nhận Đặt Phòng</h1>\n" +
            "        <p style='color: #f0f0f0; margin: 10px 0 0 0; font-size: 16px;'>Cảm ơn bạn đã tin tưởng dịch vụ của chúng tôi!</p>\n" +
            "    </div>\n" +
            "    \n" +
            "    <div style='background-color: #f9f9f9; padding: 30px; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 10px 10px;'>\n" +
            "        <div style='background-color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>\n" +
            "            <h2 style='color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; margin-top: 0;'>Thông Tin Khách Hàng</h2>\n" +
            "            <table style='width: 100%%; border-collapse: collapse;'>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold; width: 180px;'>Mã đặt phòng:</td>\n" +
            "                    <td style='padding: 10px 0; color: #667eea; font-weight: bold; font-size: 18px;'>#%d</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Họ và tên:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Email:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Số điện thoại:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Ngày đặt:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Trạng thái:</td>\n" +
            "                    <td style='padding: 10px 0;'><span style='background-color: #4CAF50; color: white; padding: 5px 15px; border-radius: 20px; font-size: 14px;'>%s</span></td>\n" +
            "                </tr>\n" +
            "            </table>\n" +
            "        </div>\n" +
            "        \n" +
            "        <div style='background-color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>\n" +
            "            <h2 style='color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; margin-top: 0;'>Thông Tin Phòng</h2>\n" +
            "            <table style='width: 100%%; border-collapse: collapse;'>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold; width: 180px;'>Số phòng:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Loại phòng:</td>\n" +
            "                    <td style='padding: 10px 0;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Sức chứa:</td>\n" +
            "                    <td style='padding: 10px 0;'>%d người</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Giá phòng/đêm:</td>\n" +
            "                    <td style='padding: 10px 0;'>%,.0f VNĐ</td>\n" +
            "                </tr>\n" +
            "                <tr style='background-color: #f5f5f5;'>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Check-in:</td>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold; color: #667eea;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr style='background-color: #f5f5f5;'>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Check-out:</td>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold; color: #667eea;'>%s</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Số đêm:</td>\n" +
            "                    <td style='padding: 10px 0;'>%d đêm</td>\n" +
            "                </tr>\n" +
            "            </table>\n" +
            "        </div>\n" +
            "        \n" +
            (serviceDetailsHtml != null && !serviceDetailsHtml.isEmpty() ? 
            "        <div style='background-color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>\n" +
            "            <h2 style='color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; margin-top: 0;'>Dịch Vụ Đã Đặt</h2>\n" +
            "            <table style='width: 100%%; border-collapse: collapse;'>\n" +
            "                <thead>\n" +
            "                    <tr style='background-color: #667eea; color: white;'>\n" +
            "                        <th style='padding: 12px; text-align: left;'>Dịch vụ</th>\n" +
            "                        <th style='padding: 12px; text-align: center;'>Số lượng</th>\n" +
            "                        <th style='padding: 12px; text-align: center;'>Ngày sử dụng</th>\n" +
            "                        <th style='padding: 12px; text-align: right;'>Đơn giá</th>\n" +
            "                        <th style='padding: 12px; text-align: right;'>Thành tiền</th>\n" +
            "                    </tr>\n" +
            "                </thead>\n" +
            "                <tbody>\n" +
            serviceDetailsHtml +
            "                </tbody>\n" +
            "            </table>\n" +
            "        </div>\n" : "") +
            "        \n" +
            "        <div style='background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);'>\n" +
            "            <h2 style='color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; margin-top: 0;'>Chi Tiết Thanh Toán</h2>\n" +
            "            <table style='width: 100%%; border-collapse: collapse;'>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Tiền phòng:</td>\n" +
            "                    <td style='padding: 10px 0; text-align: right;'>%,.0f VNĐ</td>\n" +
            "                </tr>\n" +
            "                <tr>\n" +
            "                    <td style='padding: 10px 0; font-weight: bold;'>Tiền dịch vụ:</td>\n" +
            "                    <td style='padding: 10px 0; text-align: right;'>%,.0f VNĐ</td>\n" +
            "                </tr>\n" +
            "                <tr style='border-top: 2px solid #667eea; background-color: #f0f0ff;'>\n" +
            "                    <td style='padding: 15px 0; font-weight: bold; font-size: 18px; color: #667eea;'>TỔNG CỘNG:</td>\n" +
            "                    <td style='padding: 15px 0; text-align: right; font-weight: bold; font-size: 20px; color: #667eea;'>%,.0f VNĐ</td>\n" +
            "                </tr>\n" +
            "            </table>\n" +
            "        </div>\n" +
            "        \n" +
            "        <div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 4px;'>\n" +
            "            <p style='margin: 0; color: #856404;'><strong>Lưu ý:</strong> Vui lòng mang theo giấy tờ tùy thân khi làm thủ tục check-in. Nếu có bất kỳ thay đổi nào, vui lòng liên hệ với chúng tôi ít nhất 24 giờ trước thời gian check-in.</p>\n" +
            "        </div>\n" +
            "        \n" +
            "        <div style='text-align: center; margin-top: 30px; padding-top: 20px; border-top: 2px solid #e0e0e0;'>\n" +
            "            <p style='color: #666; margin: 5px 0;'>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ:</p>\n" +
            "            <p style='color: #667eea; font-weight: bold; margin: 5px 0;'>Email: support@hotel.com | Hotline: 1900-xxxx</p>\n" +
            "            <p style='color: #999; font-size: 12px; margin-top: 20px;'>Email này được gửi tự động, vui lòng không trả lời email này.</p>\n" +
            "        </div>\n" +
            "    </div>\n" +
            "</body>\n" +
            "</html>",
            booking.getBookingId(),
            guest.getFullName(),
            guest.getEmail(),
            guest.getPhone() != null ? guest.getPhone() : "N/A",
            booking.getBookingDate().format(dateFormatter),
            booking.getStatus(),
            room.getRoomNumber(),
            roomType.getTypeName(),
            roomType.getCapacity(),
            roomType.getPricePerNight(),
            booking.getCheckInDate().format(dateTimeFormatter),
            booking.getCheckOutDate().format(dateTimeFormatter),
            numberOfNights,
            roomTotal,
            serviceTotal,
            totalAmount
        );
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /*
         * http://localhost:8080/PRJ_Assignment/booking?roomId=1&bookingDate=2025-09-28&guestId=1&fullName=Nguy%3Fn+Van+An&email=nguyenvanan%40email.com&checkInDate=2025-09-27&checkOutDate=2025-09-30&
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
        int newBookingId = 0;
        // add new booking
        try {
            newBookingId = bookingHandle(Integer.parseInt(roomId), Integer.parseInt(guestId), inDateTime, outDateTime, bookDate);
            if (newBookingId > 0) {
                roomDAO.updateRoomStatus(Integer.parseInt(roomId), "Available");
                boolean bookingServiceResult = bookingServiceHandle(services, newBookingId);
                // make new payment
                Payment newPayment = new Payment(newBookingId, bookDate, (double) (Integer.parseInt(totalAmount)) / 2.0, "cash", "Pending");
                PaymentDAO paymentDAO = new PaymentDAO();
                boolean newPaymentId = paymentDAO.addPayment(newPayment);
                System.out.println("New payment id: " + newPaymentId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Room viewRoom = roomDAO.getRoomById(Integer.parseInt(roomId));
        ArrayList<Service> servicesList = new ArrayList<>();
        for (ChoosenService service : services) {
            servicesList.add(serviceDAO.getServiceById(service.getServiceId()));
        }
        Guest viewGuest = guestDAO.getGuestById(Integer.parseInt(guestId));

//        req.setAttribute("booking", bookingDAO.getBookingById(newBookingId));
//
//        req.setAttribute("chosenServices", services);
//        req.setAttribute("roomType", roomTypeDAO.getRoomTypeById(viewRoom.getRoomTypeId()));
//        req.setAttribute("room", viewRoom);
//        req.setAttribute("guest", viewGuest);
//        req.setAttribute("services", servicesList);
        String mailTo = "";
        if (newBookingId > 0) {
            mailTo = viewGuest.getEmail();
            // Gửi email xác nhận đặt phòng
            sendBookingConfirmationEmail(mailTo, newBookingId);
        }
        

        resp.sendRedirect("./viewBookingAfter?" + "bookingId=" + newBookingId);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

// Class hỗ trợ cho ChoosenService (nếu chưa có)
class ChoosenService {
    private int serviceId;
    private int quantity;
    private LocalDate serviceDate;

    public ChoosenService(int serviceId, int quantity, LocalDate serviceDate) {
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.serviceDate = serviceDate;
    }

    public int getServiceId() {
        return serviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public LocalDate getServiceDate() {
        return serviceDate;
    }
}
