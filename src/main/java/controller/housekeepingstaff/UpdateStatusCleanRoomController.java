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
        
        try {
            int roomID = Integer.parseInt(request.getParameter("room").trim());
            int roomTaskID = Integer.parseInt(request.getParameter("room_Task_ID").trim());
            String statusWantUpdate = request.getParameter("status_want_update");
            
            RoomTaskDAO d = new RoomTaskDAO();
            int rowAffected = d.updateStatusRoomTask(roomTaskID, statusWantUpdate);
            if(rowAffected > 0){
                request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
            }else{
                System.out.println("SAI R?I L�M L?I ?I");
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