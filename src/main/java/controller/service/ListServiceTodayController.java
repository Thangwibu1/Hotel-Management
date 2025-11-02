/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.BookingService;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "ListServiceTodayController", urlPatterns = {"/service-staff/listServiceTodayController"})
public class ListServiceTodayController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String report_type =(String) request.getParameter("report_type");
            LocalDate today = LocalDate.now();
            if(report_type.equals("today_services")){
                BookingServiceDAO bookingDAO = new BookingServiceDAO();
                ArrayList<BookingService> listBookingToday = bookingDAO.getAllBookingService(today);
                if(listBookingToday != null && !listBookingToday.isEmpty()){
                    listBookingToday.sort(new Comparator<model.BookingService>() {
                        @Override
                        public int compare(model.BookingService b1, model.BookingService b2) {
                            int status1 = b1.getStatus();
                            int status2 = b2.getStatus();

                            if (status1 == status2) {
                                return 0;
                            }
                            if (status1 == 0) return -1;
                            if (status2 == 0) return 1;

                            if (status1 == 1) return -1;
                            if (status2 == 1) return 1;

                            if (status1 == 2) return -1;
                            if (status2 == 2) return 1;

                            return 0;
                        }
                    });
                }
                
                
                request.setAttribute("LIST_BOOKING_SERVICE", listBookingToday);
                request.getRequestDispatcher(IConstant.listServiceTodayPage).forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("Loi o ListServiceTodayController");
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