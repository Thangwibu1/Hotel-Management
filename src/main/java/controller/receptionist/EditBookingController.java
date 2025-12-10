/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingService;
import model.Guest;
import model.Room;
import model.RoomInformation;
import utils.IConstant;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "EditBookingController", urlPatterns = {"/receptionist/EditBookingController"})
public class EditBookingController extends HttpServlet {

    private GuestDAO guestDAO;
    private BookingDAO bookingDAO;
    private BookingServiceDAO bookingServiceDAO;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
        bookingDAO = new BookingDAO();
        bookingServiceDAO = new BookingServiceDAO();
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
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int guestId = Integer.parseInt(request.getParameter("guestId"));
            System.out.println("hehehe"  + guestId);
            // FIX: ??i t? selectedRoomId sang roomId
            String roomIdParam = request.getParameter("roomId");
            if (roomIdParam == null || roomIdParam.isEmpty()) {
                roomIdParam = request.getParameter("selectedRoomId");
            }
            int roomId = Integer.parseInt(roomIdParam);

            String checkinStr = request.getParameter("checkinDate");
            String checkoutStr = request.getParameter("checkoutDate");

            LocalDate checkin = (checkinStr != null && !checkinStr.isEmpty())
                    ? LocalDate.parse(checkinStr) : null;
            LocalDate checkout = (checkoutStr != null && !checkoutStr.isEmpty())
                    ? LocalDate.parse(checkoutStr) : null;

            String[] serviceIds = request.getParameterValues("serviceId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] serviceDates = request.getParameterValues("serviceDate[]");

            // L?y booking hi?n t?i
            Booking current = bookingDAO.getBookingById(bookingId);
            if (current == null) {
                response.sendError(404, "Booking not found");
                return;
            }

            String status = current.getStatus();
            boolean canEditAll = status.equalsIgnoreCase("Reserved") || status.equalsIgnoreCase("Draft");
            boolean canEditService = status.equalsIgnoreCase("Checked-in");
            boolean canEditNone = status.equalsIgnoreCase("Checked-out")
                    || status.equalsIgnoreCase("Canceled")
                    || status.equalsIgnoreCase("Completed");

            if (canEditNone) {
                response.sendError(403, "Booking cannot be modified because it's already " + status);
                return;
            }

            // Chu?n b? d? li?u booking update
            Booking updated = new Booking();
            updated.setBookingId(bookingId);
            updated.setGuestId(guestId);
            updated.setRoomId(roomId);
            if (checkin != null) {
                updated.setCheckInDate(checkin.atStartOfDay());
            }
            if (checkout != null) {
                updated.setCheckOutDate(checkout.atStartOfDay());
            }

            // UPDATE BOOKING VÀ SERVICES
            boolean updatedBooking = false;
            if (canEditAll) {
                updatedBooking = bookingDAO.updateBookingAndServices(updated, serviceIds, quantities, serviceDates);
            } else if (canEditService) {
                updatedBooking = bookingDAO.updateServicesOnly(updated, serviceIds, quantities, serviceDates);
            }

            if (!updatedBooking) {
                response.sendError(500, "Failed to update booking");
                return;
            }

            // UPDATE GUEST INFO (ch? khi có quy?n edit)
            if (canEditAll || canEditService) {
                String fullName = request.getParameter("guestName");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");

                // Ki?m tra guest có t?n t?i không
                Guest currentGuest = guestDAO.getGuestById(guestId);
                if (currentGuest == null) {
                    response.sendError(404, "Guest not found");
                    return;
                }

                // Ki?m tra duplicate email (n?u email thay ??i)
                if (email != null && !email.equals(currentGuest.getEmail())) {
                    if (guestDAO.checkDuplicateEmail(email)) {
                        response.sendError(400, "Email already exists");
                        return;
                    }
                }

                // T?o object Guest ?? update
                Guest updatedGuest = new Guest();
                updatedGuest.setGuestId(guestId);
                updatedGuest.setFullName(fullName);
                updatedGuest.setPhone(phone);
                updatedGuest.setEmail(email);
                updatedGuest.setAddress(currentGuest.getAddress()); // gi? nguyên
                updatedGuest.setIdNumber(currentGuest.getIdNumber()); // gi? nguyên
                updatedGuest.setDateOfBirth(currentGuest.getDateOfBirth()); // gi? nguyên

                boolean resultGuest = guestDAO.updateGuest(updatedGuest);

                if (!resultGuest) {
                    response.sendError(500, "Failed to update guest");
                    return;
                }
            }

            // Chuy?n h??ng l?i trang chi ti?t
            response.sendRedirect(request.getContextPath() + "/receptionist/ViewBookingController?bookingId=" + bookingId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Error updating booking: " + e.getMessage());
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processRequest(req, resp);

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        processRequest(req, resp);
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
