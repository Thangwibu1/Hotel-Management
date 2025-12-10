/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.service;

import dao.RoomDAO;
import dao.ServiceDAO;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Room;
import model.Service;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name = "RegisterServiceController", urlPatterns = {"/service-staff/registerServiceController"})
public class RegisterServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            
            // Lấy danh sách tất cả các phòng từ database
            RoomDAO roomDAO = new RoomDAO();
            ArrayList<Room> rooms = roomDAO.getAllRoom();
            request.setAttribute("rooms", rooms);
            
            // Lấy danh sách tất cả các dịch vụ từ database
            ServiceDAO serviceDAO = new ServiceDAO();
            ArrayList<Service> services = serviceDAO.getAllService();
            request.setAttribute("services", services);
            
            System.out.println("✓ Loaded " + rooms.size() + " rooms and " + services.size() + " services");
            
            request.getRequestDispatcher(IConstant.registerServicePage).forward(request, response);
            
        } catch (Exception e) {
            System.err.println("✗ Error in RegisterServiceController: " + e.getMessage());
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