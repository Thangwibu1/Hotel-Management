/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.housekeepingstaff;

import dao.RoomTaskDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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

                rowAffected = d.updateStatusRoomTask(roomTaskID, "Cleaned");
            }else if(request.getParameter("DONE_TASK") != null){
                roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
                statusWantUpdate = request.getParameter("status_want_update");
                int staffID = staff.getStaffId();
                if (d.getRoomTaskById(roomTaskID).getStaffID() == staffID) {
                    rowAffected = d.updateStatusRoomTaskToCleand(staffID, statusWantUpdate, roomTaskID);
                } else {
                    request.setAttribute("THONGBAO", "Update Fail!!");
                    request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
                }
                System.out.println("DA XU LY" + rowAffected);
            }else{
                roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
                statusWantUpdate = request.getParameter("status_want_update");
                rowAffected = d.updateStatusRoomTask(staff.getStaffId(), roomTaskID, statusWantUpdate);
            }



            //?a chay xong update
            if(rowAffected > 0){
                request.setAttribute("THONGBAO", "Update successfully!!");
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