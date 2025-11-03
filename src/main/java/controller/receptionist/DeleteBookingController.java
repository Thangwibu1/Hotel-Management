/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingService;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "DeleteBookingController", urlPatterns = {"/receptionist/DeleteBookingController"})
public class DeleteBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private BookingServiceDAO bookingServiceDAO;

    @Override
    public void init() throws ServletException {
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
        String bookingIdStr = request.getParameter("bookingId");

        try {
            if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                int bookingId = Integer.parseInt(bookingIdStr);
                Booking booking = bookingDAO.getBookingById(bookingId);

                if (booking == null) {
                    response.sendError(404, "Booking not found");
                    return;
                }

                String currentStatus = booking.getStatus();

                if (currentStatus.equalsIgnoreCase("Checked-in")
                        || currentStatus.equalsIgnoreCase("Checked-out")
                        || currentStatus.equalsIgnoreCase("Canceled")) {

                    request.setAttribute("ERROR",
                            "Cannot cancel booking in status: " + currentStatus);
                    request.getRequestDispatcher("/receptionist/BookingsController").forward(request, response);
                    return;
                }
                ArrayList<BookingService> list = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
                for (BookingService bs : list) {
                    bookingServiceDAO.updateBookingServiceStatus(bs.getBookingServiceId(), -1);
                }

                boolean updated = bookingDAO.updateBookingStatus(bookingId, "Canceled");

                if (updated) {
                    request.setAttribute("MESSAGE", "Booking #" + bookingId + " has been canceled successfully.");
                } else {
                    request.setAttribute("MESSAGE", "Failed to cancel booking #" + bookingId);
                }

                request.setAttribute("CURRENT_TAB", "bookings");
                request.setAttribute("CURRENT_STEP", "manage");
                request.getRequestDispatcher("/receptionist/BookingsController").forward(request, response);
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
