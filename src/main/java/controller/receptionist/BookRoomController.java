/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.PaymentDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.Payment;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "BookRoomController", urlPatterns = {"/receptionist/BookRoomController"})
public class BookRoomController extends HttpServlet {

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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String roomId = request.getParameter("selectedRoomId");
            System.out.println(roomId + "roomid ne");
            String guestId = request.getParameter("guestId");
            String checkInTime = request.getParameter("checkInTime");
            String checkOutTime = request.getParameter("checkOutTime");
            String bookingDate = request.getParameter("bookingDate");

            LocalDate inDate = LocalDate.parse(checkInTime);
            LocalDate outDate = LocalDate.parse(checkOutTime);
            LocalDate bookDate = LocalDate.parse(bookingDate);

            LocalDateTime checkInDateTime = inDate.atTime(14, 0);  // 14:00 check-in
            LocalDateTime checkOutDateTime = outDate.atTime(12, 0);  // 12:00 check-out
            int newBookingId = 0;
            // add new booking
            try {
                newBookingId = bookingHandle(Integer.parseInt(roomId), Integer.parseInt(guestId), checkInDateTime, checkOutDateTime, bookDate);
                if (newBookingId > 0) {
//                boolean bookingServiceResult = bookingServiceHandle(services, newBookingId);
                    // make new payment
//                Payment newPayment = new Payment(newBookingId, bookDate, (double) (Integer.parseInt(totalAmount)) / 2.0, "cash", "Pending");
//                PaymentDAO paymentDAO = new PaymentDAO();
//                boolean newPaymentId = paymentDAO.addPayment(newPayment);
                    System.out.println("Bookeddd: " + newBookingId);
                    request.setAttribute("CURRENT_TAB", "bookings"); 
            request.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(request, response);
                }
                
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
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
