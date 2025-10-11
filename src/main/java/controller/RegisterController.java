package controller;


import dao.GuestDAO;
import model.Guest;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        guestDAO = new GuestDAO();
    }

    public boolean validate(String email, String idNumber) {
        return guestDAO.checkDuplicateEmail(email) || guestDAO.checkDuplicateIdNumber(idNumber);
    }

    public boolean addGuest(String fullName, String phone, String email, String password, String address, String idNumber, String dateOfBirth) {
        return guestDAO.addGuest(new Guest(fullName, phone, email, address, idNumber, dateOfBirth, password));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        fullName=abc&email=abc%40gmail.com&
//        password=abc123&confirmPassword=abc123&
//        phone=0909090909&
//        dateOfBirth=2005-02-08&
//        address=abc&
//        idNumber=0909090909
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String dateOfBirth = req.getParameter("dateOfBirth");
        String address = req.getParameter("address");
        String idNumber = req.getParameter("idNumber");
        System.out.println(dateOfBirth);
        try {
            if (!validate(email, idNumber)) {
                addGuest(fullName, phone, email, password, address, idNumber, dateOfBirth);
                req.setAttribute("fullName", fullName);
                req.setAttribute("email", email);
                req.setAttribute("phone", phone);
                req.setAttribute("dateOfBirth", dateOfBirth);
                req.setAttribute("address", address);
                req.setAttribute("idNumber", idNumber);
                req.getRequestDispatcher(IConstant.registerSuccess).forward(req, resp);
            } else {
                System.out.println("Toi day la dung ne");
                resp.sendRedirect(IConstant.registerPage + "?error=Email or ID number is already used");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }



    }
}
