/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.BookingServiceDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
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
@WebServlet(name = "UpdateStatusServiceController", urlPatterns = {"/service-staff/updateStatusServiceController"})
public class UpdateStatusServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            //lay du lieu de tai len trang tiep theo 
            BookingServiceDAO d = new BookingServiceDAO();
            ArrayList<BookingService> listTask = d.getAllBookingServiceFromToday(LocalDate.now());
            ServiceDAO sd = new ServiceDAO();
            ArrayList<Service> listService = sd.getAllService();
            if(listTask != null && !listTask.isEmpty()){
                listTask.sort(new Comparator<model.BookingService>() {
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
            
            
            request.setAttribute("LIST_SERVICE_TASK", listTask);
            request.setAttribute("LIST_SERVICE", listService);
            request.getRequestDispatcher(IConstant.updateStatusServicePage).forward(request, response);
        } catch (Exception e) {
            System.out.println("BUG IN UpdateStatusServiceController ");
            e.printStackTrace();
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