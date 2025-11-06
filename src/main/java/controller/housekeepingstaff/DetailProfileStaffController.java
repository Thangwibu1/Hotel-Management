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
import javax.servlet.http.HttpSession;
import model.Staff;
import utils.IConstant;

/**
 *
 * @author TranHongGam
 */
@WebServlet(name="DetailProfileStaffController", urlPatterns={"/housekeepingstaff/detailProfileStaffController"})
public class DetailProfileStaffController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            
            if (staff == null) {
                response.sendRedirect(IConstant.loginPage);
                return;
            } else {
                
                System.out.println("hehehe");
                request.getRequestDispatcher(IConstant.detailProfileStaffPage).forward(request, response);
            }    
        } catch (Exception e) {
            System.out.println("Bi Loi o DETAIL PROFILE roi a nha");
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