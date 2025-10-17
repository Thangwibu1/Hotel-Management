package controller.admin;

import dao.StaffDAO;
import model.Staff;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/update-staff")
public class UpdateStaffController extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

    public boolean isUsernameExist(String username) {
        return staffDAO.isUsernameExist(username);
    }

    public boolean updateStaff(Staff staff) {
        return staffDAO.updateStaff(staff);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("staffId");
        String fullName = req.getParameter("fullName");
        String role = req.getParameter("role");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        Staff staff = new Staff(Integer.parseInt(id), fullName, role, username, password, phone, email);

        updateStaff(staff);
        req.getRequestDispatcher("admin").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    
}
