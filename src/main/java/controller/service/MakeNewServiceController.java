/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.RoomDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Booking;
import model.BookingService;
import model.Room;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "MakeNewServiceController", urlPatterns = {"/service-staff/makeNewServiceController"})
public class MakeNewServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            String roomNumber = request.getParameter("room_number");
            String registerDate = request.getParameter("register_Date");
            String startTimeStr = request.getParameter("start_Time");
            int serviceId = Integer.parseInt(request.getParameter("service_Id"));
            String quantityStr = request.getParameter("quantity");
            int quantity = Integer.parseInt(quantityStr);
            String note = request.getParameter("note");
            
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalDate registerLocal = LocalDate.parse(registerDate);
            if(registerLocal.isBefore(LocalDate.now())){
                request.setAttribute("MSG", "The date must not be in the past.");
                request.setAttribute("color", "red");
                request.getRequestDispatcher(IConstant.registerServiceController).forward(request, response);
            }
            //process
            
            
            //Lay roomId d?a vào s? phòng
            RoomDAO roomD = new RoomDAO();
            Room roomID = roomD.getRoomByRoomNumber(roomNumber);
            BookingDAO bookingD = new BookingDAO();
            //truyen vao 1 roomnumber && ngày hi?n t?i nhan lai 1 booking ?ã checkin != null thì m?i làm ti?p 
            //check phòng ?ó có ?ang ?c book ko 
            Booking booking = bookingD.getBookingByRoomID(roomID.getRoomId(), LocalDate.now());
            if(booking != null){
                //check registerDate < checkoutDate
                LocalDateTime checkoutDate = booking.getCheckOutDate();
                //doi sang LocalDate de check cho de
                LocalDate checkoutLocalDate = checkoutDate.toLocalDate();
                LocalDate registerLocalDate = LocalDate.parse(registerDate);
                
                if(!registerLocalDate.isAfter(checkoutLocalDate)){
                    // startTime > now && < 24h hom nay
                    LocalDateTime now = LocalDateTime.now();
                    LocalDateTime startDateTime = registerLocalDate.atTime(startTime);
                    if (startDateTime.isBefore(now) || startDateTime.isEqual(now)) {
                        request.setAttribute("MSG", "The service start time must be after the current time.");
                        request.setAttribute("color", "red");
                        request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                        return; 
                    }else{
                        BookingServiceDAO bSD = new BookingServiceDAO();
                        BookingService bookingService = new BookingService(booking.getBookingId(), serviceId, quantity, registerLocalDate, 0, note);
                        if(bSD.addBookingService(bookingService)){
                            request.setAttribute("MSG", "Booking Service Succesfullly");
                            request.setAttribute("color", "green");
                            request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                             return; 
                        }else{
                            request.setAttribute("MSG", "Can not make booking service.Booking again.!!");
                            request.setAttribute("color", "red");
                            request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                        }
                    }
                }else{
                    request.setAttribute("MSG", "The service date does not fall within the guest's stay .");
                    request.setAttribute("color", "red");
                    request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
                }
            }else{
                request.setAttribute("MSG", "This room does not currently have a valid checked-in guest to register services!!");
                request.setAttribute("color", "red");
                request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
            }
            System.out.println("Room Number: " + roomNumber);
            System.out.println("Service Type: " + serviceId);
            System.out.println("Quantity: " + quantity);
            System.out.println("Notes: " + note);
            
        } catch (Exception e) {
            System.out.println("L?i ? MakeNewSerrviceController");
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