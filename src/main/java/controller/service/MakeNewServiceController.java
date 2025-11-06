/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import controller.feature.EmailSender;
import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTaskDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingService;
import model.Guest;
import model.Room;
import model.RoomTask;
import model.Service;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "MakeNewServiceController", urlPatterns = {"/service-staff/makeNewServiceController"})
public class MakeNewServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            String roomNumber = request.getParameter("room_number");
            String registerDate = request.getParameter("register_Date");
            String startTimeStr = request.getParameter("start_Time");
            int serviceId = Integer.parseInt(request.getParameter("service_Id"));
            String quantityStr = request.getParameter("quantity");
            int quantity = Integer.parseInt(quantityStr);
            String note = request.getParameter("note");
            
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalDate registerLocal = LocalDate.parse(registerDate);
            if(registerLocal.isBefore(LocalDate.now())){
                request.setAttribute("MSG", "The date must not be in the past.");
                request.setAttribute("color", "red");
                request.getRequestDispatcher(IConstant.registerServiceController).forward(request, response);
            }
            //process
            
            
            //Lay roomId 
            RoomDAO roomD = new RoomDAO();
            Room roomID = roomD.getRoomByRoomNumber(roomNumber);
            BookingDAO bookingD = new BookingDAO();
            //truyen vao 1 roomnumber && ng�y hi?n t?i nhan lai 1 booking ?� checkin != null th� m?i l�m ti?p 
            //check ph�ng ?� c� ?ang ?c book ko 
            Booking booking = bookingD.getBookingByRoomID(roomID.getRoomId(), LocalDate.now());
            if(booking != null){
                LocalDateTime checkoutDate = booking.getCheckOutDate();
                LocalDate checkoutLocalDate = checkoutDate.toLocalDate();
                LocalDate registerLocalDate = LocalDate.parse(registerDate);
                
                if(!registerLocalDate.isAfter(checkoutLocalDate)){
                    // startTime > now && < 24h hom nay
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime startDateTime = registerLocalDate.atTime(startTime);
                    if (startDateTime.isBefore(now) || startDateTime.isEqual(now)) {
                        request.setAttribute("MSG", "The service start time must be after the current time.");
                        request.setAttribute("color", "red");
                        request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                        return; 
                    }else{
                        BookingServiceDAO bSD = new BookingServiceDAO();
                        
                        note = "Start at: " + startTimeStr + "." + note;
                        System.out.println(note);
                        BookingService bookingService = new BookingService(booking.getBookingId(), serviceId, quantity, registerLocalDate, 0, note);
                        if(bSD.addBookingService(bookingService)){
                            
                            // Nếu serviceId = 3 (Housekeeping), tự động tạo room task
                            if (serviceId == 3) {
                                try {
                                    RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                                    LocalDateTime taskStartTime = registerLocalDate.atTime(startTime);
                                    
                                    // Tạo room task với status "Pending"
                                    RoomTask roomTask = new RoomTask(
                                        roomID.getRoomId(),     // roomID
                                        null,                   // staffID (null - chưa assign)
                                        taskStartTime,          // startTime
                                        null,                   // endTime (null - chưa hoàn thành)
                                        "Pending",              // statusClean
                                        "Service request from guest - Booking #" + booking.getBookingId(), // notes
                                        0                       // isSystemTask (1 = được tạo tự động từ service)
                                    );
                                    
                                    boolean roomTaskCreated = roomTaskDAO.insertRoomTaskForService(roomTask);
                                    
                                    if (roomTaskCreated) {
                                        System.out.println("✓ Room task đã được tạo tự động cho phòng " + roomNumber);
                                    } else {
                                        System.err.println("✗ Không thể tạo room task cho phòng " + roomNumber);
                                    }
                                } catch (Exception roomTaskException) {
                                    System.err.println("✗ Lỗi khi tạo room task: " + roomTaskException.getMessage());
                                    roomTaskException.printStackTrace();
                                    // Không throw exception để không ảnh hưởng đến việc đăng ký dịch vụ
                                }
                            }
                            
                            // Gửi email xác nhận đăng ký dịch vụ
                            try {
                                // Lấy thông tin guest từ booking
                                GuestDAO guestDAO = new GuestDAO();
                                Guest guest = guestDAO.getGuestById(booking.getGuestId());
                                
                                // Lấy thông tin service
                                ServiceDAO serviceDAO = new ServiceDAO();
                                Service service = serviceDAO.getServiceById(serviceId);
                                
                                if (guest != null && guest.getEmail() != null && !guest.getEmail().isEmpty()) {
                                    // Tạo nội dung email HTML
                                    String emailSubject = "Service Registration Confirmation - " + service.getServiceName();
                                    String emailBody = createServiceConfirmationEmail(
                                        guest.getFullName(), 
                                        roomNumber, 
                                        service.getServiceName(), 
                                        quantity, 
                                        registerLocalDate, 
                                        startTime,
                                        service.getPrice(),
                                        booking.getBookingId()
                                    );
                                    
                                    // Gửi email
                                    EmailSender emailSender = new EmailSender();
                                    boolean emailSent = emailSender.sendHtmlEmail(guest.getEmail(), emailSubject, emailBody);
                                    
                                    if (emailSent) {
                                        System.out.println("✓ Email xác nhận dịch vụ đã được gửi đến: " + guest.getEmail());
                                    } else {
                                        System.err.println("✗ Không thể gửi email xác nhận dịch vụ đến: " + guest.getEmail());
                                    }
                                } else {
                                    System.err.println("✗ Không tìm thấy email của khách hàng");
                                }
                            } catch (Exception emailException) {
                                System.err.println("✗ Lỗi khi gửi email xác nhận dịch vụ: " + emailException.getMessage());
                                emailException.printStackTrace();
                                // Không throw exception để không ảnh hưởng đến việc đăng ký dịch vụ
                            }
                            
                            request.setAttribute("MSG", "Booking Service Succesfullly");
                            request.setAttribute("color", "green");
                            request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                             return; 
                        }else{
                            request.setAttribute("MSG", "Can not make booking service.Booking again.!!");
                            request.setAttribute("color", "red");
                            request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                        }
                    }
                }else{
                    request.setAttribute("MSG", "The service date does not fall within the guest's stay .");
                    request.setAttribute("color", "red");
                    request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                }
            }else{
                request.setAttribute("MSG", "This room does not currently have a valid checked-in guest to register services!!");
                request.setAttribute("color", "red");
                request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
            }
            System.out.println("Room Number: " + roomNumber);
            System.out.println("Service Type: " + serviceId);
            System.out.println("Quantity: " + quantity);
            System.out.println("Notes: " + note);
            
        } catch (Exception e) {
            System.out.println("Loi o MakeNewSerrviceController");
            e.printStackTrace();
        } 
    }
    
    /**
     * Tạo nội dung email HTML xác nhận đăng ký dịch vụ
     */
    private String createServiceConfirmationEmail(String guestName, String roomNumber, 
            String serviceName, int quantity, LocalDate serviceDate, LocalTime startTime,
            java.math.BigDecimal servicePrice, int bookingId) {
        
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        
        String formattedDate = serviceDate.format(dateFormatter);
        String formattedTime = startTime.format(timeFormatter);
        
        // Tính tổng tiền
        java.math.BigDecimal totalPrice = servicePrice.multiply(java.math.BigDecimal.valueOf(quantity));
        
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("<!DOCTYPE html>");
        emailBody.append("<html>");
        emailBody.append("<head>");
        emailBody.append("<meta charset='UTF-8'>");
        emailBody.append("<style>");
        emailBody.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }");
        emailBody.append(".container { max-width: 600px; margin: 0 auto; padding: 20px; }");
        emailBody.append(".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }");
        emailBody.append(".header h1 { margin: 0; font-size: 28px; }");
        emailBody.append(".content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }");
        emailBody.append(".info-box { background: white; padding: 20px; margin: 20px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
        emailBody.append(".info-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; }");
        emailBody.append(".info-row:last-child { border-bottom: none; }");
        emailBody.append(".info-label { font-weight: bold; color: #667eea; }");
        emailBody.append(".info-value { color: #555; }");
        emailBody.append(".total { background: #667eea; color: white; padding: 15px; text-align: center; border-radius: 8px; margin-top: 20px; font-size: 18px; font-weight: bold; }");
        emailBody.append(".footer { text-align: center; margin-top: 30px; padding: 20px; color: #777; font-size: 14px; }");
        emailBody.append(".success-icon { font-size: 48px; text-align: center; margin: 20px 0; }");
        emailBody.append("</style>");
        emailBody.append("</head>");
        emailBody.append("<body>");
        emailBody.append("<div class='container'>");
        
        // Header
        emailBody.append("<div class='header'>");
        emailBody.append("<h1>✓ Service Registration Confirmed</h1>");
        emailBody.append("<p style='margin: 10px 0 0 0; font-size: 16px;'>Thank you for your registration!</p>");
        emailBody.append("</div>");
        
        // Content
        emailBody.append("<div class='content'>");
        emailBody.append("<div class='success-icon'>🎉</div>");
        emailBody.append("<p style='text-align: center; font-size: 18px; color: #667eea; margin-bottom: 30px;'>");
        emailBody.append("Dear <strong>").append(guestName).append("</strong>,<br>");
        emailBody.append("Your service has been successfully registered!");
        emailBody.append("</p>");
        
        // Service Information
        emailBody.append("<div class='info-box'>");
        emailBody.append("<h3 style='margin-top: 0; color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px;'>📋 Service Details</h3>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Booking ID:</span>");
        emailBody.append("<span class='info-value'>#").append(bookingId).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Room Number:</span>");
        emailBody.append("<span class='info-value'>").append(roomNumber).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Service Name:</span>");
        emailBody.append("<span class='info-value'>").append(serviceName).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Quantity:</span>");
        emailBody.append("<span class='info-value'>").append(quantity).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Service Date:</span>");
        emailBody.append("<span class='info-value'>").append(formattedDate).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Start Time:</span>");
        emailBody.append("<span class='info-value'>").append(formattedTime).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='info-row'>");
        emailBody.append("<span class='info-label'>Price per unit:</span>");
        emailBody.append("<span class='info-value'>$").append(servicePrice).append("</span>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        
        // Total
        emailBody.append("<div class='total'>");
        emailBody.append("Total Amount: $").append(totalPrice);
        emailBody.append("</div>");
        
        // Note
        emailBody.append("<p style='margin-top: 30px; padding: 15px; background: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px;'>");
        emailBody.append("<strong>📌 Note:</strong> Our staff will arrive at your room at the scheduled time. ");
        emailBody.append("If you need to make any changes, please contact the reception desk.");
        emailBody.append("</p>");
        
        emailBody.append("</div>");
        
        // Footer
        emailBody.append("<div class='footer'>");
        emailBody.append("<p>Thank you for choosing our hotel services!</p>");
        emailBody.append("<p style='margin: 5px 0;'>For any questions, please contact our reception desk.</p>");
        emailBody.append("<p style='margin: 5px 0; color: #999;'>This is an automated email. Please do not reply.</p>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        emailBody.append("</body>");
        emailBody.append("</html>");
        
        return emailBody.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
}