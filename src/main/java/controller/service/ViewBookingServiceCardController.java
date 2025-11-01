/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Booking;
import model.BookingService;
import model.Guest;
import model.Room;
import model.Service;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "ViewBookingServiceCardController", urlPatterns = {"/service-staff/viewBookingServiceCardController"})
public class ViewBookingServiceCardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            if(staff != null){
                String bookingServiceId = request.getParameter("bookingServiceId");
                String staffPress = request.getParameter("staffId");
                String status_Current = (String) request.getParameter("status_Current");
                if(bookingServiceId != null){
                    BookingServiceDAO d = new BookingServiceDAO();
                    BookingService resultBooking = d.getBookingServiceByBookingServiceId(Integer.parseInt(bookingServiceId));
                    BookingDAO bD = new BookingDAO();
                    Booking booking = bD.getBookingById(resultBooking.getBookingId());
                    RoomDAO rD = new RoomDAO();
                    Room room = rD.getRoomById(booking.getRoomId());
                    ServiceDAO sd = new ServiceDAO();
                    Service service = sd.getServiceById(resultBooking.getServiceId());
                    GuestDAO gD = new GuestDAO();
                    Guest guest = gD.getGuestById(booking.getGuestId());
                    if(booking == null || service == null || resultBooking == null || room == null){
                        System.out.println("Khong du du lieu , hay cai nano do b? null roi ViewBooking");
                    }
                    request.setAttribute("SERVICE_IMPLEMENT", service);
                    request.setAttribute("BOOKING_IMPLEMENT", booking);
                    request.setAttribute("STAFF_IMPLEMENT", staffPress);
                    request.setAttribute("STATUS_CURRENT", status_Current);
                    request.setAttribute("BOOKING_SERVICE_DETAIL", resultBooking);
                    request.setAttribute("ROOM_REGISTER", room);
                    request.setAttribute("GUEST_REGISTER", guest);
                    
                    request.getRequestDispatcher(IConstant.viewBookingServiceCardPage).forward(request, response);
                }else{
                    System.out.println("Ko du du lieu");
                }  
            }else{
                response.sendRedirect(IConstant.loginPage);
            }
        } catch (Exception e) {
            System.out.println("BUG IN ViewBookingCard");
            e.printStackTrace();
        } 
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
}