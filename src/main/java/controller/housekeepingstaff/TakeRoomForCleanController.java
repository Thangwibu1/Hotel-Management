/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.housekeepingstaff;


import dao.RoomDAO;
import dao.RoomTaskDAO;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Room;
import model.RoomTask;
import utils.IConstant;


/**
 *
 * @author TranHongGam
 */
@WebServlet(name="TakeRoomForCleanController", urlPatterns={"/takeRoomForCleanController"})
public class TakeRoomForCleanController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            RoomTaskDAO d = new RoomTaskDAO();
            ArrayList<RoomTask> listTask = d.getAllRoom();
            ArrayList<RoomTask> listPending = d.getRoomBaseStatus("Pending");
            ArrayList<RoomTask> listMaintenance = d.getRoomBaseStatus("Maintenance");
            ArrayList<RoomTask> listCleaned = d.getRoomBaseStatus("Cleaned");
            ArrayList<RoomTask> listInProgress = d.getRoomBaseStatus("In Progress");
            
            RoomDAO rd = new RoomDAO();
            ArrayList<Room> listR = rd.getAllRoom();
            
            String active = request.getParameter("active");
            request.setAttribute("ROOM_TASK", listTask);
            request.setAttribute("ROOM_CLEANED", listCleaned);
            request.setAttribute("ROOM_PENDING", listPending);
            request.setAttribute("ROOM_IN_PROGRESS", listInProgress);
            request.setAttribute("ROOM_MATAINTENANCE", listMaintenance);
            request.setAttribute("ROOM_LIST", listR);


            if(active == null){
                request.setAttribute("LIST_DISPLAY_HOME", listTask);
                request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
            } else {
                if (listTask != null) {
                    request.setAttribute("ACTIVE", active);

                    if (active.equalsIgnoreCase("pending")) {
                        request.setAttribute("LIST_DISPLAY_HOME", listPending);
                    } else if (active.equalsIgnoreCase("cleaned")) {
                        request.setAttribute("LIST_DISPLAY_HOME", listCleaned);
                    } else if (active.equalsIgnoreCase("in_progress")) {
                        request.setAttribute("LIST_DISPLAY_HOME", listInProgress);
                    } else if (active.equalsIgnoreCase("maintenance")) {
                        request.setAttribute("LIST_DISPLAY_HOME", listMaintenance);
                    } else if (active.equalsIgnoreCase("all")) {
                        request.setAttribute("LIST_DISPLAY_HOME", listTask);
                    }

                    request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
                } else {
                    //list null th� l�m g� 
                    request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
                }
            }

        } catch (Exception e) {
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