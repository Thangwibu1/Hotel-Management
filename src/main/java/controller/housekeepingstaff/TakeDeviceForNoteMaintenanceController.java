/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.housekeepingstaff;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.RoomDAO;
import dao.RoomDeviceDAO;
import model.RoomDevice;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name="TakeDeviceForNoteMaintenanceController", urlPatterns={"/housekeepingstaff/takeDeviceForNoteMaintenanceController"})
public class TakeDeviceForNoteMaintenanceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        RoomDeviceDAO roomDeviceDAO = new RoomDeviceDAO();
        try {
            //lay data ra tu form
            String room = (String) request.getParameter("room");
            int roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID"));
            String status_want_update = (String) request.getParameter("status_want_update");
            status_want_update = "Maintenance";
            Staff staff = (Staff) request.getAttribute("userStaff");
            
            //bo data vao request de lam tiep theo
            request.setAttribute("room", room);
            request.setAttribute("room_Task_ID", roomTaskID);
            request.setAttribute("status_want_update", status_want_update);
            String[] damagedItemsArray = request.getParameterValues("roomDeviceIds");
            

            if (damagedItemsArray != null) {

                
                System.out.println("Show list device : ");
                for (String itemValue : damagedItemsArray) {
                    System.out.println(itemValue.toUpperCase());
                    RoomDevice roomDevice = roomDeviceDAO.getRoomDeviceById(Integer.parseInt(itemValue));
                    int roomDeviceId = roomDevice.getRoomDeviceId();
                    (new RoomDAO()).updateRoomStatus(roomDevice.getRoomId(), "Maintenance");
                    roomDevice.setStatus(0);
                    roomDeviceDAO.updateRoomDeviceById(roomDevice);
                }
                request.setAttribute("LIST_DEVICE_BROKEN", damagedItemsArray);
                request.getRequestDispatcher(IConstant.updateStatusCleanRoomController).forward(request, response);
                
            } else {
              
                request.setAttribute("THONGBAO_VI_BO_TRONG", "Please select at least one damaged item to proceed with the report.");
                request.getRequestDispatcher(IConstant.completeMaintain).forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("BUG IN TakeDeviceForNote");
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