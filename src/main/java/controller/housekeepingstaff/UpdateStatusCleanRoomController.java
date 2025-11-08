/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.housekeepingstaff;

import dao.BookingServiceDAO;
import dao.RoomDAO;
import dao.RoomTaskDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

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
@WebServlet(name="UpdateStatusCleanRoomController", urlPatterns={"/housekeepingstaff/UpdateStatusCleanRoomController"})
public class UpdateStatusCleanRoomController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int roomTaskID = 0;
        String statusWantUpdate = "";
        RoomTaskDAO d = new RoomTaskDAO();
        int rowAffected  = 0;
        String[] damagedItemsArray = null;
        StringBuilder sb = new StringBuilder();
        if(request.getSession().getAttribute("userStaff") == null){
            response.sendRedirect(IConstant.loginPage);
            return;
        }
        HttpSession session = request.getSession();
        Staff staff = (Staff)session.getAttribute("userStaff");
        try {
            if (request.getAttribute("LIST_DEVICE_BROKEN") != null) {
                damagedItemsArray = (String[]) request.getAttribute("LIST_DEVICE_BROKEN");

                if (damagedItemsArray != null) {
                    for (String item : damagedItemsArray) {
                        sb.append(item);
                        sb.append(",");
                    }
                }
                String deviceBroken = sb.toString();
                System.out.println(deviceBroken != null ? deviceBroken : "roi chuoi rong luon ro / UpdateStatus" );
                Object roomTaskIDObj = request.getAttribute("room_Task_ID");
                String idString = roomTaskIDObj.toString();
                roomTaskID = Integer.parseInt(idString);

                statusWantUpdate = (String)request.getAttribute("status_want_update");
                System.out.println("DEBUG DAO Call:");
                System.out.println("ID: " + roomTaskID);
                System.out.println("Note: " + deviceBroken);
                System.out.println("Status: " + statusWantUpdate);
                int staffID = staff.getStaffId();

                rowAffected = d.updateStatusRoomTask(roomTaskID, statusWantUpdate);
            }else if(request.getParameter("DONE_TASK") != null){
                roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
                statusWantUpdate = request.getParameter("status_want_update");
                int staffID = staff.getStaffId();
                if (d.getRoomTaskById(roomTaskID).getStaffID() == staffID) {
                    rowAffected = d.updateStatusRoomTaskToCleand(staffID, statusWantUpdate, roomTaskID);
                    int bookingServiceId = d.getBookingServiceIdByRoomTaskId(roomTaskID);
                    if (bookingServiceId > 0) {
                        (new BookingServiceDAO()).updateBookingServiceStatus(bookingServiceId, 2, staffID);
                    }
                    request.setAttribute("THONGBAO", "Update Successfully!!");
                    request.getRequestDispatcher("./homeHouseKeeping.jsp").forward(request, response);
                } else {
                    request.setAttribute("THONGBAO", "Update Fail!!");
                    request.getRequestDispatcher("./homeHouseKeeping.jsp").forward(request, response);
                }
                
                System.out.println("DA XU LY" + rowAffected);
            }else if ((new RoomTaskDAO()).getRoomTaskById(Integer.parseInt(request.getParameter("room_Task_ID"))).getStatusClean().equalsIgnoreCase("Maintenance")) {
                roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
                statusWantUpdate = request.getParameter("status_want_update");
                int staffID = staff.getStaffId();
                if (d.getRoomTaskById(roomTaskID).getStaffID() == staffID) {
                    rowAffected = d.updateStatusRoomTaskToCleand(staffID, statusWantUpdate, roomTaskID);
                    (new RoomDAO()).updateRoomStatus(d.getRoomTaskById(roomTaskID).getRoomID(), "Waiting");
                    int bookingServiceId = d.getBookingServiceIdByRoomTaskId(roomTaskID);
                    if (bookingServiceId > 0) {
                        (new BookingServiceDAO()).updateBookingServiceStatus(bookingServiceId, 2, staffID);
                    }
                } else {
                    request.setAttribute("THONGBAO", "Update Fail!!");
                }
            }else{
                roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
                statusWantUpdate = request.getParameter("status_want_update");
                int staffID = staff.getStaffId();
                int bookingServiceId = d.getBookingServiceIdByRoomTaskId(roomTaskID);
                ArrayList<RoomTask> listTask = d.getAllRoomTaskBaseDate(LocalDateTime.now());
                boolean flag = false;
                for (RoomTask roomTask : listTask) {
                    if (roomTask.getStatusClean().equalsIgnoreCase("In Progress") && roomTask.getStaffID() == staffID) {
                        flag = true;
                        break;
                    }
                }
                if (flag) {
                    request.setAttribute("THONGBAO", "Update Fail!!");
                    request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
                } else {
                    rowAffected = d.updateStatusRoomTask(staff.getStaffId(), roomTaskID, statusWantUpdate);
                    if (bookingServiceId > 0) {
                        (new BookingServiceDAO()).updateBookingServiceStatus(bookingServiceId, 1, staffID);
                    }
                }
                
                // HashMap<Integer, Integer> roomIdAndGuestId = d.getRoomIdAndGuestIdByRoomTaskId(roomTaskID);
//                int roomId = roomIdAndGuestId.keySet().iterator().next();
//                int guestId = roomIdAndGuestId.values().iterator().next();
//                System.out.println(roomId + guestId + "DUng roi djt me may");
            }



            //qa chay xong update
            if(rowAffected > 0){
                request.setAttribute("THONGBAO", "Status updated successfully!");
                request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
            }else{
                System.out.println("SAI ROI NHA");
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