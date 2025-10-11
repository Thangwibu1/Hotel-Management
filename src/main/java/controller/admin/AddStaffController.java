package controller.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.StaffDAO;
import model.Staff;
import utils.IConstant;

@WebServlet("/admin/add-staff")
public class AddStaffController extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

    public boolean isUsernameExist(String username) {
        return staffDAO.isUsernameExist(username);
    }

    public boolean addStaff(Staff staff) {
        return staffDAO.addStaff(staff);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        String id = req.getParameter("staffId");
        String fullName = req.getParameter("fullName");
        String role = req.getParameter("role");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        Staff newStaff = new Staff(fullName, role, username, password, phone, email);

        if (!isUsernameExist(username)) {
            addStaff(newStaff);
            req.getRequestDispatcher("admin").forward(req, resp);
        } else {
            req.setAttribute("error", "Username already exists!");
            req.getRequestDispatcher("admin").forward(req, resp);
            
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    
}