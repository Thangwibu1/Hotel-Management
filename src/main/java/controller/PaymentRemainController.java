package controller;

import java.io.IOException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.PaymentDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import dao.SystemConfigDAO;
import model.Booking;
import model.BookingService;
import model.Payment;
import model.Room;
import model.RoomType;
import model.Service;
import model.SystemConfig;

@WebServlet("/paymentRemain")
public class PaymentRemainController extends HttpServlet {

    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private BookingServiceDAO bookingServiceDAO;
    private ServiceDAO serviceDAO;
    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        bookingServiceDAO = new BookingServiceDAO();
        serviceDAO = new ServiceDAO();
        systemConfigDAO = new SystemConfigDAO();
    }


    protected double getTotalAmount(int bookingId) {
        try {
            // 1. Lấy thông tin booking
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                return 0;
            }
            
            // 2. Tính số ngày ở (số đêm)
            long numberOfNights = ChronoUnit.DAYS.between(
                booking.getCheckInDate().toLocalDate(), 
                booking.getCheckOutDate().toLocalDate()
            );
            
            // 3. Lấy thông tin phòng và loại phòng để tính tiền phòng
            Room room = roomDAO.getRoomById(booking.getRoomId());
            if (room == null) {
                return 0;
            }
            
            RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            if (roomType == null) {
                return 0;
            }
            
            // 4. Tính tổng tiền phòng = giá phòng/đêm * số đêm
            double pricePerNight = roomType.getPricePerNight().doubleValue();
            double roomTotal = pricePerNight * numberOfNights;
            
            // 5. Lấy danh sách dịch vụ đã sử dụng
            ArrayList<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
            
            // 6. Tính tổng tiền dịch vụ
            double servicesTotal = 0;
            for (BookingService bs : bookingServices) {
                Service service = serviceDAO.getServiceById(bs.getServiceId());
                if (service != null) {
                    // Tiền dịch vụ = giá dịch vụ * số lượng
                    double servicePrice = service.getPrice().doubleValue();
                    double serviceItemTotal = servicePrice * bs.getQuantity();
                    servicesTotal += serviceItemTotal;
                }
            }
            
            // 7. Lấy thuế suất từ system config
            double taxRate = 0;
            SystemConfig taxConfig = systemConfigDAO.getSystemConfigByName("TAX_RATE");
            if (taxConfig != null) {
                taxRate = taxConfig.getConfigValue() / 100.0; // Convert % to decimal
            }
            
            // 8. Tính tiền thuế
            double subtotal = roomTotal + servicesTotal;
            double taxAmount = subtotal * taxRate;
            
            // 9. Tổng tiền = tiền phòng + tiền dịch vụ + thuế
            double totalAmount = subtotal + taxAmount;
            
            return totalAmount;
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        processRequest(req, resp);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            // Kiểm tra thông báo từ processPayment
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if (success != null) {
                request.setAttribute("successMessage", "Thanh toán thành công!");
            }
            if (error != null) {
                request.setAttribute("errorMessage", "Thanh toán thất bại. Vui lòng thử lại!");
            }
            
            // Lấy thông tin booking
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            // Lấy thông tin phòng và loại phòng
            Room room = roomDAO.getRoomById(booking.getRoomId());
            RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            
            // count days
            long numberOfNights = ChronoUnit.DAYS.between(
                booking.getCheckInDate().toLocalDate(), 
                booking.getCheckOutDate().toLocalDate()
            );
            
            // Tính tiền phòng
            double pricePerNight = roomType.getPricePerNight().doubleValue(); //convert BigDecimal to double
            double roomTotal = pricePerNight * numberOfNights; //calculate room total
            
            // Lấy danh sách dịch vụ đã sử dụng
            ArrayList<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
            
            // Lấy chi tiết từng dịch vụ và tính tổng tiền dịch vụ
            ArrayList<Service> serviceDetails = new ArrayList<>();
            double servicesTotal = 0;
            for (BookingService bs : bookingServices) {
                Service service = serviceDAO.getServiceById(bs.getServiceId());
                if (service != null) {
                    serviceDetails.add(service);
                    double servicePrice = service.getPrice().doubleValue();
                    double serviceItemTotal = servicePrice * bs.getQuantity();
                    servicesTotal += serviceItemTotal;
                }
            }
            
            // Lấy thuế suất từ system config
            double taxRate = 0;
            SystemConfig taxConfig = systemConfigDAO.getSystemConfigByName("tax");
            if (taxConfig != null) {
                taxRate = taxConfig.getConfigValue() / 100.0; // Convert % to decimal
            }
            
            // Tính tiền thuế
            double subtotal = roomTotal + servicesTotal;
            double taxAmount = subtotal * taxRate;
            
            // Tổng tiền phải trả (bao gồm thuế)
            double totalAmount = subtotal + taxAmount;
            
            // Lấy tổng số tiền đã thanh toán
            ArrayList<Payment> payments = paymentDAO.getPaymentByBookingId(bookingId);
            double paidAmount = 0;
            for (Payment payment : payments) {
                paidAmount += payment.getAmount();
            }
            
            // Tính số tiền còn lại phải trả
            double remainingAmount = totalAmount - paidAmount;
            
            // Gửi thông tin về client
            request.setAttribute("booking", booking);
            request.setAttribute("room", room);
            request.setAttribute("roomType", roomType);
            request.setAttribute("numberOfNights", numberOfNights);
            request.setAttribute("roomTotal", roomTotal);
            request.setAttribute("bookingServices", bookingServices);
            request.setAttribute("serviceDetails", serviceDetails);
            request.setAttribute("servicesTotal", servicesTotal);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("taxRate", taxRate * 100); // Convert back to percentage for display
            request.setAttribute("taxAmount", taxAmount);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("paidAmount", paidAmount);
            request.setAttribute("remainingAmount", remainingAmount);
            request.setAttribute("payments", payments);
            
            request.getRequestDispatcher("./paymentRemainView.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
