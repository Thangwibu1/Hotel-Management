package controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.SystemConfigDAO;
import model.Staff;
import model.SystemConfig;
import utils.IConstant;

@WebServlet("/admin/system")
public class SystemController extends HttpServlet {
    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        systemConfigDAO = new SystemConfigDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Staff admin = null;
        if (session != null) {
            admin = (Staff) session.getAttribute("userStaff");
        }

        // Redirect to login if not logged in or not an admin
        if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("./" + IConstant.loginPage);
            return;
        }

        req.setAttribute("admin", admin);

        ArrayList<SystemConfig> systemConfigs = systemConfigDAO.getAllSystemConfig();
        req.setAttribute("systemConfigs", systemConfigs);

        req.getRequestDispatcher(IConstant.systemConfigPage).forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
