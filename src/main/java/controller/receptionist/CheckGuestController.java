/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import dao.GuestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Guest;

/**
 *
 * @author trinhdtu
 */
@WebServlet(name = "CheckGuestController", urlPatterns = {"/receptionist/CheckGuestController"})
public class CheckGuestController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String guestId = request.getParameter("guestId");
            GuestDAO guestDao = new GuestDAO();
            boolean checkExist = guestDao.checkDuplicateIdNumber(guestId);
            HttpSession ss = request.getSession();
            // XÓA H?T flash data c? tr??c
            ss.removeAttribute("GUEST");
            ss.removeAttribute("FLASH_NEXT_WAY");
            ss.removeAttribute("FLASH_ID_NUM");

            // Set l?i data m?i
            ss.setAttribute("FLASH_NEXT_WAY", checkExist ? "booking" : "createAcc");
            ss.setAttribute("FLASH_ID_NUM", guestId);

            if (checkExist) {
                ss.setAttribute("GUEST", guestDao.getGuestByIdNumber(guestId));
            } else {
                ss.removeAttribute("GUEST");
            }
            ss.setAttribute("FLASH_ID_NUM", guestId);
            response.sendRedirect(request.getContextPath() + "/receptionist/receptionist?tab=bookings");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        HttpSession ss = request.getSession(false);
        
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
