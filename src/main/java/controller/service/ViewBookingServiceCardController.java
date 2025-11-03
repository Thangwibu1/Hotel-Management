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
            
            
            if (bookingServiceId == null) {
                Object editStatusObj = request.getAttribute("EDITSTATUS");
                if (editStatusObj == null) {
                    editStatusObj = request.getAttribute("BD_ID");
                }
                if (editStatusObj != null) {
                    bookingServiceId = String.valueOf(editStatusObj);
                }
            }
            
            String THONGBAO = (String) session.getAttribute("SUCCESS_MESSAGE");
            String COLOR_TEXT = (String) session.getAttribute("COLOR_TEXT");
            
            if (THONGBAO != null) {
                System.out.println("Message: " + THONGBAO);
                request.setAttribute("THONGBAO", THONGBAO);
                session.removeAttribute("SUCCESS_MESSAGE"); 
            }
            
            if(COLOR_TEXT != null){
                System.out.println("Day la View" + COLOR_TEXT);
                request.setAttribute("COLOR_TEXT", COLOR_TEXT);
                session.removeAttribute("COLOR_TEXT");
            }
            
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
                    System.out.println("Khong du du lieu , hay cai nano do null roi ViewBooking");
                }
                
                request.setAttribute("SERVICE_IMPLEMENT", service);
                request.setAttribute("BOOKING_IMPLEMENT", booking);
                request.setAttribute("BOOKING_SERVICE_DETAIL", resultBooking);
                request.setAttribute("ROOM_REGISTER", room);
                request.setAttribute("GUEST_REGISTER", guest);
                
                request.getRequestDispatcher(IConstant.viewBookingServiceCardPage).forward(request, response);
            }else{
                System.out.println("Ko du du lieu Day la VIEW");
                response.sendRedirect(IConstant.updateStatusServiceController);
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