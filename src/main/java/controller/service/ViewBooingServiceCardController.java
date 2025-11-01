/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BookingService;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "ViewBooingServiceCardController", urlPatterns = {"/service-staff/viewBooingServiceCardController"})
public class ViewBooingServiceCardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            if(staff != null){
                String bookingServiceId = request.getParameter("bookingServiceId");
                if(bookingServiceId != null){
                    String staffPress = request.getParameter("staffId");
                    BookingServiceDAO d = new BookingServiceDAO();
                    BookingService resultBooking = d.getBookingServiceByBookingServiceId(Integer.parseInt(bookingServiceId));
//                    request.getRequestDispatcher()
                }
                
                
            }else{
                response.sendRedirect(IConstant.loginPage);
            }
        } catch (Exception e) {

        } finally {

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