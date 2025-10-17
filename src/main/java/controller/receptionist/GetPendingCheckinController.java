/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingActionRow;
import model.Guest;
import model.Room;
import utils.IConstant;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "GetPendingCheckinController", urlPatterns = {"/GetPendingCheckinController"})
public class GetPendingCheckinController extends HttpServlet {

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
            String subTab = request.getParameter("tab");
            if (subTab == null) {
                subTab = "in";
            }
            BookingDAO bookingDao = new BookingDAO();
            if ("in".equals(subTab)) {
                ArrayList<BookingActionRow> bookings = bookingDao.getBookingByStatus("Reserved", "checkin");
                request.setAttribute("PENDING_CHECKIN", bookings);
            } else {
                ArrayList<BookingActionRow> bookings = bookingDao.getBookingByStatus("Checked-in", "checkout");
                request.setAttribute("PENDING_CHECKOUT", bookings);
            }
            
            request.setAttribute("SUB_TAB", subTab);
            request.setAttribute("CURRENT_TAB", "checkin"); 
            request.getRequestDispatcher("/receptionist/checkPage.jsp").forward(request, response);
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
