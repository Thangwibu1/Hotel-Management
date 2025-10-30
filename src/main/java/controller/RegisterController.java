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
        
        try {
            // Validate password match
            if (!password.equals(confirmPassword)) {
                resp.sendRedirect(IConstant.registerPage + "?error=Mật khẩu xác nhận không khớp");
                return;
            }
            
            if (!validate(email, idNumber)) {
                boolean success = addGuest(fullName, phone, email, password, address, idNumber, dateOfBirth);
                if (success) {
                    req.setAttribute("fullName", fullName);
                    req.setAttribute("email", email);
                    req.setAttribute("phone", phone);
                    req.setAttribute("dateOfBirth", dateOfBirth);
                    req.setAttribute("address", address);
                    req.setAttribute("idNumber", idNumber);
                    req.getRequestDispatcher(IConstant.registerSuccess).forward(req, resp);
                } else {
                    resp.sendRedirect(IConstant.registerPage + "?error=Không thể tạo tài khoản. Vui lòng thử lại sau.");
                    return;
                }
            } else {
                System.out.println("Email hoặc CMND/CCCD đã được sử dụng");
                resp.sendRedirect(IConstant.registerPage + "?error=Email or ID number is already used");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(IConstant.registerPage + "?error=Đã có lỗi xảy ra. Vui lòng thử lại sau.");
        }



    }
}
