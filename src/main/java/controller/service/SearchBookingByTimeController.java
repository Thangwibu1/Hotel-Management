/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import dao.ServiceDAO;
import java.io.IOException;
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
@WebServlet(name = "SearchBookingByTimeController", urlPatterns = {"/service-staff/searchBookingByTimeController"})
public class SearchBookingByTimeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            String report_type = (String) request.getParameter("report_type");
            String start_date_str = request.getParameter("startDate");
            String end_date_str = request.getParameter("endDate");
            if(staff != null){
                LocalDate startDateReport = null;
                LocalDate endDateReport = null;
                if (report_type == null || start_date_str == null || end_date_str == null) {
                    System.out.println("Chua co du du lieu");
                } else {
                    startDateReport = LocalDate.parse(start_date_str, DateTimeFormatter.ISO_LOCAL_DATE);
                    endDateReport = LocalDate.parse(end_date_str, DateTimeFormatter.ISO_LOCAL_DATE);
                    if(endDateReport.isBefore(startDateReport) || endDateReport.isAfter(LocalDate.now())){
                        System.out.println("ngay nhap vp sai r be oi");
                        request.setAttribute("ERROR_INPUT", "The end date must be greater than or equal to the start date and cannot exceed the current date.");
                        request.getRequestDispatcher(IConstant.employeePerformancePage).forward(request, response);
                        return;
                    }
                    ServiceDAO sd = new ServiceDAO();
                    ArrayList<Service> listService = sd.getAllService();
                    BookingServiceDAO d = new BookingServiceDAO();
                    ArrayList<BookingService> listTakeByTime = d.getAllBookingServiceBaseStartEndDate(startDateReport, endDateReport, staff.getStaffId(),1);
                    request.setAttribute("LIST_SEARCH_BOOKING_SERVICE", listTakeByTime);
                    request.setAttribute("report_type", "searchBookingByTime");
                    request.setAttribute("start_date", start_date_str); 
                    request.setAttribute("end_date", end_date_str);
                    request.setAttribute("CHECK", "true");
                    request.setAttribute("LIST_SERVICE", listService);
                    request.getRequestDispatcher(IConstant.employeePerformancePage).forward(request, response);
                }
            }else{
                request.getRequestDispatcher(IConstant.loginPage).forward(request, response);
            }


        } catch (Exception e) {
            System.out.println("Loi o trông SearchBookingByTimeController");
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