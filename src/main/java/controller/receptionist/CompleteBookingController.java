/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import controller.feature.EmailSender;
import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingService;
import model.ChoosenService;
import model.Guest;
import model.Room;
import model.RoomType;
import model.Service;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "CompleteBookingController", urlPatterns = {"/receptionist/CompleteBookingController"})
public class CompleteBookingController extends HttpServlet {

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
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected int bookingHandle(int roomId, int guessId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate) {
        int returnValue = 0;
        BookingDAO bookingDAO = new BookingDAO();
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String roomId = request.getParameter("selectedRoomId");
            String guestId = request.getParameter("guestId");
            String checkInTime = request.getParameter("checkInTime");
            String checkOutTime = request.getParameter("checkOutTime");
            String bookingDate = request.getParameter("bookingDate");

            LocalDate inDate = LocalDate.parse(checkInTime);
            LocalDate outDate = LocalDate.parse(checkOutTime);
            LocalDate bookDate = LocalDate.parse(bookingDate);

            LocalDateTime checkInDateTime = inDate.atTime(14, 0);  // 14:00 check-in
            LocalDateTime checkOutDateTime = outDate.atTime(12, 0);  // 12:00 check-out

            ArrayList<ChoosenService> services = new ArrayList<>();
            String[] serviceId = request.getParameterValues("serviceId[]");
            String[] serviceQuantity = request.getParameterValues("qty[]");
            String[] serviceDate = request.getParameterValues("date[]");
            if (serviceId != null && serviceQuantity != null && serviceDate != null) {
                for (int i = 0; i < serviceId.length; i++) {
                    ChoosenService tmpService = new ChoosenService(Integer.parseInt(serviceId[i]), Integer.parseInt(serviceQuantity[i]), LocalDate.parse(serviceDate[i]));
                    services.add(tmpService);
                }
            }
            int newBookingId = 0;
            // add new booking
            try {
                newBookingId = bookingHandle(Integer.parseInt(roomId), Integer.parseInt(guestId), checkInDateTime, checkOutDateTime, bookDate);
                if (newBookingId > 0) {
                boolean bookingServiceResult = bookingServiceHandle(services, newBookingId);
                    
                    // Gửi email xác nhận booking
                    try {
                        // Lấy thông tin guest
                        Guest guest = guestDAO.getGuestById(Integer.parseInt(guestId));
                        
                        // Lấy thông tin room
                        Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
                        
                        // Lấy thông tin room type
                        RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
                        
                        if (guest != null && guest.getEmail() != null && !guest.getEmail().isEmpty()) {
                            // Tạo nội dung email HTML
                            String emailSubject = "Booking Confirmation - Reservation #" + newBookingId;
                            String emailBody = createBookingConfirmationEmail(
                                guest.getFullName(),
                                newBookingId,
                                room.getRoomNumber(),
                                roomType.getTypeName(),
                                checkInDateTime,
                                checkOutDateTime,
                                bookDate,
                                roomType.getPricePerNight(),
                                services
                            );
                            
                            // Gửi email
                            EmailSender emailSender = new EmailSender();
                            boolean emailSent = emailSender.sendHtmlEmail(guest.getEmail(), emailSubject, emailBody);
                            
                            if (emailSent) {
                                System.out.println("✓ Email xác nhận booking đã được gửi đến: " + guest.getEmail());
                            } else {
                                System.err.println("✗ Không thể gửi email xác nhận booking đến: " + guest.getEmail());
                            }
                        } else {
                            System.err.println("✗ Không tìm thấy email của khách hàng");
                        }
                    } catch (Exception emailException) {
                        System.err.println("✗ Lỗi khi gửi email xác nhận booking: " + emailException.getMessage());
                        emailException.printStackTrace();
                        // Không throw exception để không ảnh hưởng đến việc tạo booking
                    }
                    
                    // make new payment
//                Payment newPayment = new Payment(newBookingId, bookDate, (double) (Integer.parseInt(totalAmount)) / 2.0, "cash", "Pending");
//                PaymentDAO paymentDAO = new PaymentDAO();
//                boolean newPaymentId = paymentDAO.addPayment(newPayment);
                    request.getRequestDispatcher("/receptionist/BookingsController").forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Tạo nội dung email HTML xác nhận booking
     */
    private String createBookingConfirmationEmail(String guestName, int bookingId, 
            String roomNumber, String roomType, LocalDateTime checkInDate, 
            LocalDateTime checkOutDate, LocalDate bookingDate, BigDecimal pricePerNight,
            List<ChoosenService> services) {
        
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        
        String formattedCheckIn = checkInDate.format(dateTimeFormatter);
        String formattedCheckOut = checkOutDate.format(dateTimeFormatter);
        String formattedBookingDate = bookingDate.format(dateFormatter);
        
        // Tính số đêm
        long numberOfNights = ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());
        
        // Tính tổng tiền phòng
        BigDecimal roomTotal = pricePerNight.multiply(BigDecimal.valueOf(numberOfNights));
        
        // Tính tổng tiền dịch vụ
        BigDecimal servicesTotal = BigDecimal.ZERO;
        if (services != null && !services.isEmpty()) {
            for (ChoosenService service : services) {
                Service serviceInfo = serviceDAO.getServiceById(service.getServiceId());
                if (serviceInfo != null) {
                    BigDecimal serviceAmount = serviceInfo.getPrice().multiply(BigDecimal.valueOf(service.getQuantity()));
                    servicesTotal = servicesTotal.add(serviceAmount);
                }
            }
        }
        
        BigDecimal totalAmount = roomTotal.add(servicesTotal);
        
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("<!DOCTYPE html>");
        emailBody.append("<html>");
        emailBody.append("<head>");
        emailBody.append("<meta charset='UTF-8'>");
        emailBody.append("<style>");
        emailBody.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; background: #f4f4f4; margin: 0; padding: 0; }");
        emailBody.append(".container { max-width: 650px; margin: 20px auto; background: white; }");
        emailBody.append(".header { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); color: white; padding: 40px 30px; text-align: center; }");
        emailBody.append(".header h1 { margin: 0; font-size: 32px; font-weight: bold; }");
        emailBody.append(".header p { margin: 10px 0 0 0; font-size: 16px; opacity: 0.9; }");
        emailBody.append(".content { padding: 30px; }");
        emailBody.append(".success-badge { background: #28a745; color: white; display: inline-block; padding: 8px 20px; border-radius: 20px; font-size: 14px; margin: 0 0 20px 0; font-weight: bold; }");
        emailBody.append(".greeting { font-size: 18px; color: #333; margin-bottom: 20px; }");
        emailBody.append(".info-section { background: #f8f9fa; padding: 20px; margin: 20px 0; border-radius: 8px; border-left: 4px solid #1e3c72; }");
        emailBody.append(".info-section h3 { margin: 0 0 15px 0; color: #1e3c72; font-size: 18px; border-bottom: 2px solid #1e3c72; padding-bottom: 10px; }");
        emailBody.append(".info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #dee2e6; }");
        emailBody.append(".info-row:last-child { border-bottom: none; }");
        emailBody.append(".info-label { font-weight: 600; color: #555; }");
        emailBody.append(".info-value { color: #333; text-align: right; }");
        emailBody.append(".highlight { background: #fff3cd; padding: 3px 8px; border-radius: 4px; font-weight: bold; }");
        emailBody.append(".services-table { width: 100%; border-collapse: collapse; margin-top: 10px; }");
        emailBody.append(".services-table th { background: #1e3c72; color: white; padding: 10px; text-align: left; }");
        emailBody.append(".services-table td { padding: 10px; border-bottom: 1px solid #dee2e6; }");
        emailBody.append(".total-section { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); color: white; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0; }");
        emailBody.append(".total-section .label { font-size: 16px; opacity: 0.9; }");
        emailBody.append(".total-section .amount { font-size: 32px; font-weight: bold; margin-top: 5px; }");
        emailBody.append(".note-box { background: #d1ecf1; border: 1px solid #bee5eb; border-left: 4px solid #17a2b8; padding: 15px; border-radius: 4px; margin: 20px 0; }");
        emailBody.append(".note-box strong { color: #0c5460; }");
        emailBody.append(".footer { background: #2c3e50; color: white; padding: 30px; text-align: center; }");
        emailBody.append(".footer p { margin: 8px 0; font-size: 14px; }");
        emailBody.append(".footer .contact { opacity: 0.8; }");
        emailBody.append("</style>");
        emailBody.append("</head>");
        emailBody.append("<body>");
        emailBody.append("<div class='container'>");
        
        // Header
        emailBody.append("<div class='header'>");
        emailBody.append("<h1>🏨 Booking Confirmation</h1>");
        emailBody.append("<p>Your reservation has been successfully confirmed</p>");
        emailBody.append("</div>");
        
        // Content
        emailBody.append("<div class='content'>");
        
        // Success badge
        emailBody.append("<div style='text-align: center;'>");
        emailBody.append("<span class='success-badge'>✓ CONFIRMED</span>");
        emailBody.append("</div>");
        
        // Greeting
        emailBody.append("<p class='greeting'>Dear <strong>").append(guestName).append("</strong>,</p>");
        emailBody.append("<p style='margin-bottom: 30px;'>Thank you for choosing our hotel! We are delighted to confirm your reservation. Below are the details of your booking:</p>");
        
        // Booking Information
        emailBody.append("<div class='info-section'>");
        emailBody.append("<h3>📋 Booking Information</h3>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Booking ID:</span>");
        emailBody.append("<span class='info-value'><span class='highlight'>#").append(bookingId).append("</span></span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Booking Date:</span>");
        emailBody.append("<span class='info-value'>").append(formattedBookingDate).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Status:</span>");
        emailBody.append("<span class='info-value' style='color: #28a745; font-weight: bold;'>Reserved</span>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        
        // Room Information
        emailBody.append("<div class='info-section'>");
        emailBody.append("<h3>🛏️ Room Information</h3>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Room Number:</span>");
        emailBody.append("<span class='info-value'><strong>").append(roomNumber).append("</strong></span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Room Type:</span>");
        emailBody.append("<span class='info-value'>").append(roomType).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Check-in:</span>");
        emailBody.append("<span class='info-value'><strong>").append(formattedCheckIn).append("</strong></span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Check-out:</span>");
        emailBody.append("<span class='info-value'><strong>").append(formattedCheckOut).append("</strong></span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Number of Nights:</span>");
        emailBody.append("<span class='info-value'>").append(numberOfNights).append(" night(s)</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Price per Night:</span>");
        emailBody.append("<span class='info-value'>$").append(pricePerNight).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Room Total:</span>");
        emailBody.append("<span class='info-value' style='font-weight: bold; color: #1e3c72;'>$").append(roomTotal).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        
        // Services Information (if any)
        if (services != null && !services.isEmpty() && servicesTotal.compareTo(BigDecimal.ZERO) > 0) {
            emailBody.append("<div class='info-section'>");
            emailBody.append("<h3>🎁 Additional Services</h3>");
            emailBody.append("<table class='services-table'>");
            emailBody.append("<thead><tr>");
            emailBody.append("<th>Service</th>");
            emailBody.append("<th>Date</th>");
            emailBody.append("<th>Qty</th>");
            emailBody.append("<th>Price</th>");
            emailBody.append("<th>Total</th>");
            emailBody.append("</tr></thead>");
            emailBody.append("<tbody>");
            
            for (ChoosenService service : services) {
                Service serviceInfo = serviceDAO.getServiceById(service.getServiceId());
                if (serviceInfo != null) {
                    BigDecimal serviceTotal = serviceInfo.getPrice().multiply(BigDecimal.valueOf(service.getQuantity()));
                    emailBody.append("<tr>");
                    emailBody.append("<td>").append(serviceInfo.getServiceName()).append("</td>");
                    emailBody.append("<td>").append(service.getServiceDate().format(dateFormatter)).append("</td>");
                    emailBody.append("<td>").append(service.getQuantity()).append("</td>");
                    emailBody.append("<td>$").append(serviceInfo.getPrice()).append("</td>");
                    emailBody.append("<td><strong>$").append(serviceTotal).append("</strong></td>");
                    emailBody.append("</tr>");
                }
            }
            
            emailBody.append("</tbody>");
            emailBody.append("</table>");
            emailBody.append("<div class='info-row' style='margin-top: 15px; font-size: 16px;'>");
            emailBody.append("<span class='info-label'>Services Total:</span>");
            emailBody.append("<span class='info-value' style='font-weight: bold; color: #1e3c72;'>$").append(servicesTotal).append("</span>");
            emailBody.append("</div>");
            emailBody.append("</div>");
        }
        
        // Total Amount
        emailBody.append("<div class='total-section'>");
        emailBody.append("<div class='label'>Total Amount</div>");
        emailBody.append("<div class='amount'>$").append(totalAmount).append("</div>");
        emailBody.append("</div>");
        
        // Important Notes
        emailBody.append("<div class='note-box'>");
        emailBody.append("<strong>📌 Important Information:</strong>");
        emailBody.append("<ul style='margin: 10px 0 0 0; padding-left: 20px;'>");
        emailBody.append("<li>Check-in time: 14:00 | Check-out time: 12:00</li>");
        emailBody.append("<li>Please bring a valid ID and this confirmation email</li>");
        emailBody.append("<li>Early check-in or late check-out may be available upon request</li>");
        emailBody.append("<li>Cancellation policy: Please contact us at least 24 hours in advance</li>");
        emailBody.append("</ul>");
        emailBody.append("</div>");
        
        emailBody.append("<p style='text-align: center; margin-top: 30px; font-size: 16px;'>");
        emailBody.append("We look forward to welcoming you! 🌟");
        emailBody.append("</p>");
        
        emailBody.append("</div>");
        
        // Footer
        emailBody.append("<div class='footer'>");
        emailBody.append("<p style='font-size: 18px; font-weight: bold; margin-bottom: 15px;'>Thank you for choosing our hotel!</p>");
        emailBody.append("<p class='contact'>For any questions or special requests, please contact us:</p>");
        emailBody.append("<p class='contact'>📞 Phone: +1 (555) 123-4567 | 📧 Email: info@hotel.com</p>");
        emailBody.append("<p style='margin-top: 20px; opacity: 0.7; font-size: 12px;'>This is an automated email. Please do not reply directly to this message.</p>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        emailBody.append("</body>");
        emailBody.append("</html>");
        
        return emailBody.toString();
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
