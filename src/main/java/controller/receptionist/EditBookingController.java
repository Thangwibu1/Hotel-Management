/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.BookingDAO;
import dao.BookingServiceDAO;
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
import model.Room;
import model.RoomInformation;
import utils.IConstant;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "EditBookingController", urlPatterns = {"/receptionist/EditBookingController"})
public class EditBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private ServiceDAO serviceDAO;
    private BookingServiceDAO bookingServiceDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        serviceDAO = new ServiceDAO();
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
            request.setAttribute("CURRENT_TAB", "bookings");
            request.setAttribute("CURRENT_STEP", "edit");
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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing booking id");
            return;
        }

        try {
            int bookingId = Integer.parseInt(idRaw);
            Booking bk = bookingDAO.getBookingById(bookingId);
            if (bk == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }

            ArrayList<RoomInformation> availableRooms = bookingDAO.getBookingByCheckInCheckOutDateV2(bk.getCheckInDate(), bk.getCheckOutDate());

            ArrayList<BookingService> lines = bookingServiceDAO.getBookingServiceByBookingId(bookingId);

            req.setAttribute("booking", bk);
            req.setAttribute("availableRooms", availableRooms);
            req.setAttribute("serviceLines", lines);
            req.getRequestDispatcher("/receptionist/editBooking.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking id");
        } catch (Exception e) {
            throw new ServletException(e);
        }
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

        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        int roomId = Integer.parseInt(req.getParameter("roomId"));
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        int numGuests = Integer.parseInt(req.getParameter("numGuests"));

        LocalDate ci = LocalDate.parse(req.getParameter("checkInDate"), IConstant.dateFormat);
        LocalDate co = LocalDate.parse(req.getParameter("checkOutDate"), IConstant.dateFormat);

//        BigDecimal deposit = BigDecimal.valueOf(req.getParameter("deposit"));
        String specialReq = req.getParameter("specialRequests");
        String internalNotes = req.getParameter("internalNotes");

        // Service lines (name/id tùy form c?a b?n). ? ?ây nh?n theo id có s?n:
        String[] bsIds = req.getParameterValues("bsId");       // id dòng (n?u update)
        String[] serviceId = req.getParameterValues("serviceId");  // ServiceID
        String[] qty = req.getParameterValues("quantity");
        String[] sDate = req.getParameterValues("serviceDate");
        String[] sStatus = req.getParameterValues("serviceStatus"); // 1:active, 0:canceled

        // ---- validate c? b?n
        ArrayList<String> errors = new ArrayList<>();
        if (bookingId <= 0) {
            errors.add("Invalid booking id.");
        }
        if (ci == null || co == null || !co.isAfter(ci)) {
            errors.add("Check-out must be after check-in.");
        }
        if (numGuests <= 0) {
            errors.add("Number of guests must be > 0.");
        }

        // L?y b?n ghi c? ?? so sánh
        Booking old = bookingDAO.getBookingById(bookingId);
        if (old == null) {
            errors.add("Booking not found.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            doGet(req, resp); // n?p l?i form
            return;
        }

        
            // Redirect v? trang chi ti?t ho?c danh sách
            resp.sendRedirect(req.getContextPath() + "/receptionist/BookingDetail?id=" + bookingId + "&updated=1");

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
