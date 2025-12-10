/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.housekeepingstaff;


import dao.RoomDAO;
import dao.RoomTaskDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;

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
@WebServlet(name="TakeRoomForCleanController", urlPatterns={"/housekeepingstaff/takeRoomForCleanController"})
public class TakeRoomForCleanController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            System.out.println("DAY LA TAKEROOMCLEAN");  
            RoomTaskDAO d = new RoomTaskDAO();
            ArrayList<RoomTask> listTask = d.getAllRoomTaskBaseDate(LocalDateTime.now(),1);

            ArrayList<RoomTask> listTask2 = d.getAllRoomTaskBaseDate(LocalDateTime.now(), 0);
            
            if (listTask == null || listTask.isEmpty()) {
                request.getRequestDispatcher(IConstant.makeNewRoomTaskController).forward(request, response);
            } else {

                if (listTask2 != null && !listTask2.isEmpty()) {
                    for (RoomTask roomTask : listTask2) {
                        if (roomTask.getIsSystemTask() == 0) {
                            listTask.add(roomTask);
                        }
                    }
                }   
                Comparator<RoomTask> statusComparator = new Comparator<RoomTask>() {
                    @Override
                    public int compare(RoomTask task1, RoomTask task2) {
                      
                        int priority1 = getStatusPriority(task1.getStatusClean());
                        int priority2 = getStatusPriority(task2.getStatusClean());
                        return Integer.compare(priority1, priority2);
                    }
                            
                    private int getStatusPriority(String status) {
                        if (status == null) return 5; 
                        String lowerStatus = status.toLowerCase();
                        if (lowerStatus.equals("pending")) return 1;
                        if (lowerStatus.equals("in progress")) return 2;
                        if (lowerStatus.equals("cleaned")) return 3;
                        if (lowerStatus.equals("maintenance")) return 4;
                        return 5;
                    }
                };
                listTask.sort(statusComparator);
                ArrayList<RoomTask> listPending = d.getRoomBaseStatus("Pending", LocalDateTime.now());
                ArrayList<RoomTask> listMaintenance = d.getRoomBaseStatus("Maintenance", LocalDateTime.now());
                ArrayList<RoomTask> listCleaned = d.getRoomBaseStatus("Cleaned", LocalDateTime.now());
                ArrayList<RoomTask> listInProgress = d.getRoomBaseStatus("In Progress", LocalDateTime.now());
               
                RoomDAO rd = new RoomDAO();
                ArrayList<Room> listR = rd.getAllRoom();

                String active = request.getParameter("active");
                request.setAttribute("LIST_ALL_TASKS_SUMMARY", listTask);
                request.setAttribute("LIST_DISPLAY_HOME", listTask);
                request.setAttribute("ROOM_CLEANED", listCleaned);
                request.setAttribute("ROOM_PENDING", listPending);
                request.setAttribute("ROOM_IN_PROGRESS", listInProgress);
                request.setAttribute("ROOM_MATAINTENANCE", listMaintenance);
                request.setAttribute("ROOM_LIST", listR);

                if (active == null ) {
                    request.getRequestDispatcher("homeHouseKeeping.jsp").forward(request, response);
                } else {

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

                    request.getRequestDispatcher("homeHouseKeeping.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } 

    } 
    
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