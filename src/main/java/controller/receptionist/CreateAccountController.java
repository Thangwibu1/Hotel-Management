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
@WebServlet(name = "CreateAccountController", urlPatterns = {"/receptionist/CreateAccountController"})
public class CreateAccountController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
    }

    public boolean validate(String email, String idNumber) {
        return guestDAO.checkDuplicateEmail(email) || guestDAO.checkDuplicateIdNumber(idNumber);
    }

    public boolean addGuest(String fullName, String phone, String email, String password, String idNumber) {
        return guestDAO.addGuestForRecep(new Guest(fullName, phone, email, idNumber, password));
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession ss = request.getSession();

        try {
            String idNumber = request.getParameter("idNumber");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            if (!validate(email, idNumber)) {
                addGuest(fullName, phone, email, password, idNumber);
                Guest newGuest = new GuestDAO().getGuestByIdNumber(idNumber);
                request.setAttribute("FLASH_ID_NUM", idNumber);
                request.setAttribute("GUEST", newGuest);
                request.setAttribute("CURRENT_STEP", "checkGuest");
                request.setAttribute("CURRENT_TAB", "bookings");
                request.getRequestDispatcher("/receptionist/bookingPage.jsp?tab=bookings").forward(request, response);
            } else {
                request.setAttribute("STATUS", "true");
                request.setAttribute("CURRENT_TAB", "bookings");
                request.setAttribute("FLASH_ID_NUM", idNumber);
                request.getRequestDispatcher("/receptionist/bookingPage.jsp?tab=bookings").forward(request, response);
            }
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
