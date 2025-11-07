/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.receptionist;

import controller.feature.EmailSender;
import dao.GuestDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
    private EmailSender emailSender;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
        emailSender = new EmailSender();
    }

    public boolean validate(String email, String idNumber) {
        return guestDAO.checkDuplicateEmail(email) || guestDAO.checkDuplicateIdNumber(idNumber);
    }

    public boolean addGuest(String fullName, String phone, String email, String password, String idNumber) {
        return guestDAO.addGuestForRecep(new Guest(fullName, phone, email, idNumber, password));
    }

    /**
     * Gửi email chào mừng đến guest mới
     * @param guest Thông tin guest
     * @return true nếu gửi thành công, false nếu thất bại
     */
    private boolean sendWelcomeEmail(Guest guest) {
        try {
            String subject = "Welcome to Our Hotel - Account Created Successfully";
            
            String htmlBody = "<!DOCTYPE html>"
                    + "<html>"
                    + "<head>"
                    + "<style>"
                    + "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }"
                    + ".container { max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; }"
                    + ".header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }"
                    + ".content { background-color: white; padding: 30px; border-radius: 0 0 5px 5px; }"
                    + ".info-box { background-color: #e8f5e9; padding: 15px; border-left: 4px solid #4CAF50; margin: 20px 0; }"
                    + ".footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }"
                    + "</style>"
                    + "</head>"
                    + "<body>"
                    + "<div class='container'>"
                    + "<div class='header'>"
                    + "<h1>Welcome to Our Hotel!</h1>"
                    + "</div>"
                    + "<div class='content'>"
                    + "<h2>Hello " + guest.getFullName() + ",</h2>"
                    + "<p>Your guest account has been successfully created by our receptionist.</p>"
                    + "<div class='info-box'>"
                    + "<h3>Your Account Information:</h3>"
                    + "<p><strong>Full Name:</strong> " + guest.getFullName() + "</p>"
                    + "<p><strong>Email:</strong> " + guest.getEmail() + "</p>"
                    + "<p><strong>Phone:</strong> " + guest.getPhone() + "</p>"
                    + "<p><strong>ID Number:</strong> " + guest.getIdNumber() + "</p>"
                    + "</div>"
                    + "<p>You can now use your email and password to log in to our system and manage your bookings.</p>"
                    + "<p>If you have any questions, please don't hesitate to contact our reception desk.</p>"
                    + "<p>Thank you for choosing our hotel!</p>"
                    + "</div>"
                    + "<div class='footer'>"
                    + "<p>This is an automated message. Please do not reply to this email.</p>"
                    + "</div>"
                    + "</div>"
                    + "</body>"
                    + "</html>";
            
            return emailSender.sendHtmlEmail(guest.getEmail(), subject, htmlBody);
            
        } catch (Exception e) {
            System.err.println("✗ Lỗi khi gửi email chào mừng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String idNumber = request.getParameter("idNumber");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            if (!validate(email, idNumber)) {
                addGuest(fullName, phone, email, password, idNumber);
                Guest newGuest = new GuestDAO().getGuestByIdNumber(idNumber);
                
                // Gửi email chào mừng đến guest
//                sendWelcomeEmail(newGuest);
                
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
