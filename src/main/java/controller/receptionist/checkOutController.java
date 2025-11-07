package controller.receptionist;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.InvoiceDAO;
import dao.PaymentDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import dao.SystemConfigDAO;
import model.Booking;
import model.BookingService;
import model.Invoice;
import model.Payment;
import model.Room;
import model.RoomType;
import model.Service;
import model.SystemConfig;

import java.io.IOException;
import java.sql.Date;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

@WebServlet(name = "checkOutController", urlPatterns = {"/receptionist/checkOutController"})
public class checkOutController extends HttpServlet {

    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private ServiceDAO serviceDAO;
    private BookingServiceDAO bookingServiceDAO;
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private InvoiceDAO invoiceDAO;
    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        paymentDAO = new PaymentDAO();
        serviceDAO = new ServiceDAO();
        bookingServiceDAO = new BookingServiceDAO();
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        invoiceDAO = new InvoiceDAO();
        systemConfigDAO = new SystemConfigDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            // Lấy thông tin booking
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                request.setAttribute("errorMessage", "Không tìm thấy booking!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Lấy thông tin phòng và loại phòng
            Room room = roomDAO.getRoomById(booking.getRoomId());
            RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
            
            // Tính số đêm, count night/ days
            long numberOfNights = ChronoUnit.DAYS.between(
                booking.getCheckInDate().toLocalDate(), 
                booking.getCheckOutDate().toLocalDate()
            );
            
            // Tính tiền phòng
            double pricePerNight = roomType.getPricePerNight().doubleValue(); //convert BigDecimal to double
            double roomTotal = pricePerNight * numberOfNights; //calculate room total
            
            // Lấy danh sách dịch vụ đã sử dụng
            ArrayList<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
            
            // Tính tổng tiền dịch vụ
            double servicesTotal = 0;
            for (BookingService bs : bookingServices) {
                Service service = serviceDAO.getServiceById(bs.getServiceId());
                if (service != null) {
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
            
            // Kiểm tra xem đã thanh toán đủ chưa
            if (remainingAmount > 0) {
                // Chưa thanh toán đủ - hiển thị thông báo lỗi
                request.setAttribute("booking", booking);
                request.setAttribute("room", room);
                request.setAttribute("roomType", roomType);
                request.setAttribute("totalAmount", totalAmount);
                request.setAttribute("paidAmount", paidAmount);
                request.setAttribute("remainingAmount", remainingAmount);
                request.setAttribute("errorMessage", "Khách hàng chưa thanh toán đủ tiền! Còn thiếu: " + String.format("%,.0f VNĐ", remainingAmount));
                request.getRequestDispatcher("/receptionist/checkOutView.jsp").forward(request, response);
                return;
            }
            
            // Đã thanh toán đủ - tiến hành checkout
            // 1. Cập nhật trạng thái booking thành "Checked-out"
            boolean updateSuccess = bookingDAO.updateBookingStatus(bookingId, "Checked-out");
            
            if (!updateSuccess) {
                request.setAttribute("errorMessage", "Không thể cập nhật trạng thái booking!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // 2. Tạo invoice
            Invoice invoice = new Invoice();
            invoice.setBookingId(bookingId);
            invoice.setIssueDate(new Date(System.currentTimeMillis()));
            invoice.setPrice(subtotal);
            invoice.setDiscount(0); // Không có giảm giá
            invoice.setTax(taxAmount); // Thuế
            invoice.setTotalAmount(totalAmount);
            invoice.setStatus("Paid");
            
            boolean invoiceSuccess = invoiceDAO.addInvoice(invoice);
            
            if (!invoiceSuccess) {
                request.setAttribute("errorMessage", "Không thể tạo invoice!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // 3. Hiển thị trang thành công
            request.setAttribute("booking", booking);
            request.setAttribute("room", room);
            request.setAttribute("roomType", roomType);
            request.setAttribute("numberOfNights", numberOfNights);
            request.setAttribute("roomTotal", roomTotal);
            request.setAttribute("servicesTotal", servicesTotal);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("taxRate", taxRate * 100); // Convert back to percentage for display
            request.setAttribute("taxAmount", taxAmount);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("paidAmount", paidAmount);
            request.setAttribute("invoice", invoice);
            request.setAttribute("successMessage", "Check-out thành công!");
            request.getRequestDispatcher("/receptionist/checkOutView.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        processRequest(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        processRequest(req, resp);
    }
}
