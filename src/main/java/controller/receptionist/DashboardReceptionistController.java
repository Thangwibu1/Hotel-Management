package controller.receptionist;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dao.BookingDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.Room;
import model.RoomType;
import utils.IConstant;

/**
 *
 * @author trinhdtu
 */
@WebServlet(urlPatterns = {"/receptionist/Dashboard"})
public class DashboardReceptionistController extends HttpServlet {

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
            
            BookingDAO d = new BookingDAO();
            RoomDAO roomDao = new RoomDAO();
            RoomTypeDAO roomTypeDao = new RoomTypeDAO();

            int checkedIn = d.countCurrCheckedInRooms("Reserved");
            int checkedOut = d.countCurrCheckedInRooms("Checked-out");
            int availableRoom = roomDao.countAvailableRoom("Available");
            int countOccupied = roomDao.countAvailableRoom("Occupied");
            int countMaintaince = roomDao.countAvailableRoom("Maintenance");

            int countRoom = roomDao.countRoom();
            int occupancyRate = ((countRoom - countMaintaince) > 0)
                    ? (int) Math.round((countOccupied * 100.0) / (countRoom - countMaintaince)) // 0 ch? s?
                    : 0;

            ArrayList<Room> roomList = roomDao.getAllRoom();
            ArrayList<RoomType> roomTypes = roomTypeDao.getAllRoomType();

            request.setAttribute("TYPES_LIST", roomTypes);
            request.setAttribute("COUNTIN", checkedIn);
            request.setAttribute("COUNTOUT", checkedOut);
            request.setAttribute("COUNTAVLB", availableRoom);
            request.setAttribute("COUNTOCC", countOccupied);
            request.setAttribute("COUNTROOM", countRoom - countMaintaince);
            request.setAttribute("RATE", occupancyRate);
            request.setAttribute("COUNTMAINTAIN", countMaintaince);

            request.setAttribute("ROOM_LIST", roomList);

            request.getRequestDispatcher("./receptionistPage.jsp").forward(request, response);
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
