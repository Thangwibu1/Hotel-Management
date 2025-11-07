/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingActionRow;
import model.BookingService;
import model.Room;
import model.Service;
import model.ServiceDetail;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "ViewBookingController", urlPatterns = {"/receptionist/ViewBookingController"})
public class ViewBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private GuestDAO guestDAO;
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private BookingServiceDAO bookingServiceDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        guestDAO = new GuestDAO();
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        bookingServiceDAO = new BookingServiceDAO();
        serviceDAO = new ServiceDAO();
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String idStr = request.getParameter("bookingId");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendError(400, "Missing bookingId");
                return;
            }

            int bookingId = Integer.parseInt(idStr.trim());
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                System.err.println("Booking not found for ID: " + bookingId);
                response.sendError(404, "Booking not found");
                return;
            }
            System.out.println("[ViewBookingController] Booking ID = " + bookingId);
            Room room = roomDAO.getRoomById(booking.getRoomId());
            ArrayList<BookingActionRow> rows = bookingDAO.getInforBooking();
            BookingActionRow foundRow = null;
            for (BookingActionRow row : rows) {
                if (row.getBooking().getBookingId() == bookingId) {
                    foundRow = row;
                    break;
                }
            }
            if (foundRow == null) {
                System.err.println("No BookingActionRow found for ID: " + bookingId);
                response.sendError(404, "Booking info not found");
                return;
            }
            ArrayList<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
            ArrayList<Service> serviceList = new ArrayList<>();
            BigDecimal serviceTotal = BigDecimal.ZERO;

            for (BookingService bs : bookingServices) {
                Service s = serviceDAO.getServiceById(bs.getServiceId());
                if (s != null) {
                    BigDecimal total = s.getPrice().multiply(BigDecimal.valueOf(bs.getQuantity()));
                    s.setPrice(total);
                    serviceList.add(s);
                    serviceTotal = serviceTotal.add(total);
                } else {
                    System.err.println("Service not found or price null for ID: " + bs.getServiceId());
                }
            }

            BigDecimal roomPrice = foundRow.getRoomType().getPricePerNight();
            long nights = java.time.temporal.ChronoUnit.DAYS.between(
                    booking.getCheckInDate().toLocalDate(),
                    booking.getCheckOutDate().toLocalDate()
            );
            BigDecimal roomTotal = roomPrice.multiply(BigDecimal.valueOf(nights));
            BigDecimal grandTotal = roomTotal.add(serviceTotal);

            ArrayList<ServiceDetail> serviceDetails = bookingServiceDAO.getServiceDetailsByBookingId(bookingId);

            request.setAttribute("SERVICE_DETAILS", serviceDetails);
            request.setAttribute("DETAIL_ROW", foundRow);
            request.setAttribute("BOOKING", booking);
            request.setAttribute("SERVICES", serviceList);
            request.setAttribute("ROOM_TOTAL", roomTotal);
            request.setAttribute("SERVICE_TOTAL", serviceTotal);
            request.setAttribute("GRAND_TOTAL", grandTotal);
            request.setAttribute("nights", nights);
            request.setAttribute("room", room);

            request.setAttribute("CURRENT_TAB", "bookings");
            request.setAttribute("CURRENT_STEP", "detail");
            request.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(request, response);
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
