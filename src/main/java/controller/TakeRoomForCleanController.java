/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import dao.RoomTaskDAO;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
            ArrayList<RoomTask> list = d.getAllRoom();
            if(list != null){
                request.setAttribute("ROOM_CLEAN", list);
                request.getRequestDispatcher(IConstant.housekeeping).forward(request, response);
            }else{
                //list null thì làm gì 
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