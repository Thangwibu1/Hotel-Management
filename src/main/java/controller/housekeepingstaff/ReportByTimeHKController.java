/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.housekeepingstaff;

import dao.RoomDAO;
import dao.RoomTaskDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.RoomTask;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "ReportByTimeHKController", urlPatterns = {"/housekeepingstaff/reportByTimeHKController"})
public class ReportByTimeHKController extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            if (staff != null) {
                String startTimeStr = (String) request.getParameter("start_date");
                String endTimeStr = (String) request.getParameter("end_date");
                LocalDate startDate = LocalDate.parse(startTimeStr);
                LocalDate endDate = LocalDate.parse(endTimeStr);
                
                request.setAttribute("START", startTimeStr);
                request.setAttribute("END", endTimeStr);
                if (startDate.isAfter(endDate) || endDate.isAfter(LocalDate.now())) {
                    request.setAttribute("FLAG", "Invalid report date. Please check again.");
                    request.getRequestDispatcher(IConstant.detailProfileStaffController).forward(request, response);
                }                
                RoomTaskDAO rd = new RoomTaskDAO();
                ArrayList<RoomTask> listPerformance = rd.getAllRoomTaskByDateRangeAndStatus(startDate, endDate, "Cleaned", staff.getStaffId());
                ArrayList<RoomTask> listMaintain = rd.getAllRoomTaskByDateRangeAndStatus(startDate, endDate, "Maintenance",staff.getStaffId());
                request.setAttribute("FLAG", "true");
                System.out.println("LISTMAINTAIN start");
                System.out.println("listMaintain is null? " + (listMaintain == null));
                if (listMaintain != null) {
                    System.out.println("listMaintain size: " + listMaintain.size());
                }

                if (listMaintain != null && !listMaintain.isEmpty()) {
                    System.out.println("LISTMAINTAIN - Adding " + listMaintain.size() + " tasks");
                    for (RoomTask roomTask : listMaintain) {
                        listPerformance.add(roomTask);
                    }
                }
    
                if (listPerformance != null && !listPerformance.isEmpty()) {
                    listPerformance.removeIf(task -> task == null || task.getStartTime() == null);
                    Collections.sort(listPerformance, new Comparator<RoomTask>() {
                        @Override
                        public int compare(RoomTask t1, RoomTask t2) {
                            return t2.getStartTime().compareTo(t1.getStartTime());
                        }
                    });
                    
                }
                
                if (listPerformance == null || listPerformance.isEmpty()) {
                    System.out.println("LISTNULL");
                }
                request.setAttribute("LIST_REPORT", listPerformance);
                request.getRequestDispatcher(IConstant.detailProfileStaffController).forward(request, response);
            } else {
                request.getRequestDispatcher(IConstant.loginPage).forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("LOI O REPORT BY TIME");
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
