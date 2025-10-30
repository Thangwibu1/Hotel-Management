/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BookingService;
import model.Service;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "TakeIncomeByTimeController", urlPatterns = {"/service-staff/takeIncomeByTimeController"})
public class TakeIncomeByTimeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            if(staff != null){
                String report_type = (String) request.getParameter("report_type");
                String start_date_str = request.getParameter("start_date");
                String end_date_str = request.getParameter("end_date");
                
                LocalDate startDateReport = null;
                LocalDate endDateReport = null;
                BigDecimal total = BigDecimal.ZERO;
                if(report_type == null || start_date_str == null || end_date_str == null){
                    System.out.println("Chua co du du lieu");
                }else{
                    startDateReport = LocalDate.parse(start_date_str, DateTimeFormatter.ISO_LOCAL_DATE);
                    endDateReport = LocalDate.parse(end_date_str, DateTimeFormatter.ISO_LOCAL_DATE);

                    BookingServiceDAO d = new BookingServiceDAO();
                    ServiceDAO sd = new ServiceDAO();
                    ArrayList<Service> listService = sd.getAllService();
                    ArrayList<BookingService> listTakeByTime = d.getAllBookingServiceBaseStartEndDate(startDateReport, endDateReport, staff.getStaffId());

                    
                    if(listTakeByTime != null){
                        for (BookingService bookingService : listTakeByTime) {
                            for (Service service : listService) {
                                BigDecimal quantity = BigDecimal.valueOf(bookingService.getQuantity());
                                if(bookingService.getServiceId() == service.getServiceId()){
                                    BigDecimal itemTotal = service.getPrice().multiply(quantity);
                                    total = total.add(itemTotal);
                                    break;
                                }
                            }
                        }
                        
                    }
                    request.setAttribute("report_type", "service_revenue");
                    request.setAttribute("start_date", start_date_str); 
                    request.setAttribute("end_date", end_date_str);
                    request.setAttribute("FLAG", "true");
                    request.setAttribute("TOTAL_REVENUE", total);
                    request.setAttribute("LIST_PERFORMANCE_BOOKING_SERVICE", listTakeByTime);
                    
                    if(listTakeByTime != null){
                        System.out.println("in list");
                        for (BookingService bookingService : listTakeByTime) {
                            System.out.println(bookingService.getStatus());;
                        }
                    }else{
                        System.out.println("NULL R?I");
                    }
                    System.out.println("DEBUG TAKEINCOME");
                    System.out.println(total.toString());
                    System.out.println(start_date_str);
                    System.out.println(endDateReport);
                    
                    request.getRequestDispatcher(IConstant.serviceRevenuePage).forward(request, response);
                }
            } else {
                request.getRequestDispatcher(IConstant.loginPage).forward(request, response);
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