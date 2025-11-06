/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Room;
import model.RoomType;
import model.Service;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "AddServiceController", urlPatterns = {"/receptionist/AddServiceController"})
public class AddServiceController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        try {
           
            String guestId = req.getParameter("guestId");
            String roomIdStr = req.getParameter("selectedRoomId");
            String checkInStr = req.getParameter("checkInTime");   // yyyy-MM-dd
            String checkOutStr = req.getParameter("checkOutTime"); // yyyy-MM-dd
            String bookingDateStr = req.getParameter("bookingDate");

            if (guestId == null || roomIdStr == null || checkInStr == null
                    || checkOutStr == null || bookingDateStr == null) {
                req.setAttribute("ERROR", "Thi?u tham s? b?t bu?c.");
                req.setAttribute("CURRENT_TAB", "bookings");
                req.setAttribute("CURRENT_STEP", "addServices");
                req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
                return;
            }

            
            LocalDate checkIn = LocalDate.parse(checkInStr);
            LocalDate checkOut = LocalDate.parse(checkOutStr);
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            if (nights <= 0) {
                req.setAttribute("ERROR", "Kho?ng ngày không h?p l?.");
                req.setAttribute("CURRENT_TAB", "bookings");
                req.setAttribute("CURRENT_STEP", "addServices");
                req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            RoomDAO roomDao = new RoomDAO();
            Room room = roomDao.getRoomById(roomId);
            if (room == null) {
                req.setAttribute("ERROR", "Không tìm th?y phòng.");
                req.setAttribute("CURRENT_TAB", "bookings");
                req.setAttribute("CURRENT_STEP", "addServices");
                req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
                return;
            }

            RoomTypeDAO roomTypeDao = new RoomTypeDAO();
            RoomType roomType = roomTypeDao.getRoomTypeById(room.getRoomTypeId());
            if (roomType == null) {
                req.setAttribute("ERROR", "Không tìm th?y lo?i phòng.");
                req.setAttribute("CURRENT_TAB", "bookings");
                req.setAttribute("CURRENT_STEP", "addServices");
                req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
                return;
            }

            BigDecimal pricePerNight = roomType.getPricePerNight();
            BigDecimal priceOfRoom = pricePerNight.multiply(BigDecimal.valueOf(nights));

            ServiceDAO serviceDao = new ServiceDAO();
            ArrayList<Service> services = serviceDao.getAllService(); 
            req.setAttribute("guestId", guestId);
            req.setAttribute("roomId", String.valueOf(roomId));
            req.setAttribute("roomNumber", room.getRoomNumber());
            req.setAttribute("checkIn", checkInStr);
            req.setAttribute("checkOut", checkOutStr);
            req.setAttribute("bookingDate", bookingDateStr);
            req.setAttribute("nights", nights);
            req.setAttribute("roomTypeName", roomType.getTypeName());
            req.setAttribute("pricePerNight", pricePerNight);
            req.setAttribute("priceOfRoom", priceOfRoom);

            req.setAttribute("SERVICES", services);
            req.setAttribute("CURRENT_TAB", "bookings");
            req.setAttribute("CURRENT_STEP", "addServices");

            req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("ERROR", "Có l?i x?y ra khi chu?n b? trang ch?n d?ch v?.");
            req.setAttribute("CURRENT_TAB", "bookings");
            req.setAttribute("CURRENT_STEP", "addServices");
            req.getRequestDispatcher("/receptionist/bookingPage.jsp").forward(req, resp);
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
