package controller.admin;

import dao.StaffDAO;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/remove-staff")
public class RemoveStaffController extends HttpServlet {
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
        String id = req.getParameter("staffId");
        staffDAO.deleteStaff(Integer.parseInt(id));
        req.getRequestDispatcher("admin").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
