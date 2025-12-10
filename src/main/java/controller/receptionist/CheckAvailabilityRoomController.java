/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.GuestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Guest;
import model.RoomInformation;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "CheckAvailabilityRoomController", urlPatterns = {"/receptionist/CheckAvailabilityRoomController"})
public class CheckAvailabilityRoomController extends HttpServlet {

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
        ArrayList<RoomInformation> result = null;
        try {
            String checkinStr = request.getParameter("checkinDate");
            String checkoutStr = request.getParameter("checkoutDate");
            String guestId = request.getParameter("guestId");
            GuestDAO guestDao = new GuestDAO();
            Guest guest = guestDao.getGuestById(Integer.parseInt(guestId));
            if (checkinStr == null || checkoutStr == null) {
                request.setAttribute("ERROR", "Please select both dates.");
                request.getRequestDispatcher("/receptionist/bookingPage.jsp?tab=bookings").forward(request, response);
                return;
            }

            LocalDate ciDate = LocalDate.parse(checkinStr);
            LocalDate coDate = LocalDate.parse(checkoutStr);

            LocalDateTime checkInDateTime = ciDate.atTime(14, 0);  // 14:00 check-in
            LocalDateTime checkOutDateTime = coDate.atTime(12, 0);  // 12:00 check-out

            // Validate
            if (!checkOutDateTime.isAfter(checkInDateTime)) {
                request.setAttribute("ERROR", "Check-out must be after check-in.");
//                request.getRequestDispatcher("/receptionist/NewBookingController").forward(request, response);
                request.setAttribute("CURRENT_STEP", "checkGuest");
                request.setAttribute("CURRENT_TAB", "bookings");
                request.setAttribute("GUEST", guest);
                request.getRequestDispatcher("/receptionist/bookingPage.jsp?tab=bookings").forward(request, response);
                return;
            }

            BookingDAO bookingDao = new BookingDAO();
            result = bookingDao.getBookingByCheckInCheckOutDateV2(checkInDateTime, checkOutDateTime);
            long nights = ChronoUnit.DAYS.between(ciDate, coDate);
            request.setAttribute("NIGHT", nights);
            request.setAttribute("AVAIL_LIST", result);
            request.setAttribute("CHECKIN", ciDate);
            request.setAttribute("CHECKOUT", coDate);
            request.setAttribute("CURRENT_STEP", "selectRoom");
            request.setAttribute("CURRENT_TAB", "bookings");
            request.setAttribute("GUEST", guest);
            request.getRequestDispatcher("/receptionist/bookingPage.jsp?tab=bookings").forward(request, response);

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
