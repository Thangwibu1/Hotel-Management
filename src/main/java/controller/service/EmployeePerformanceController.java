/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import java.io.IOException;
import java.util.ArrayList;
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
@WebServlet(name = "EmployeePerformanceController", urlPatterns = {"/service-staff/employeePerformanceController"})
public class EmployeePerformanceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession ss = request.getSession();
            Staff staff = (Staff)ss.getAttribute("userStaff");
            String report_type =(String) request.getParameter("report_type");
            if(report_type.equals("employee_performance")){
                System.out.println("Vo Employee PerformanceController ne");
                BookingServiceDAO bookingServiceDAO = new BookingServiceDAO();
                ArrayList<BookingService> bookingServiceList = bookingServiceDAO.getAllBookingService(staff.getStaffId());
                request.setAttribute("LIST_PERFORMANCE_BOOKING_SERVICE", bookingServiceList);
                request.setAttribute("FLAG", "true");
                request.getRequestDispatcher(IConstant.employeePerformancePage).forward(request, response);
             }
        } catch (Exception e) {
            System.out.println("Loi o employeePerformancePage");
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