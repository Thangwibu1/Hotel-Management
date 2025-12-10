package controller.admin;

import dao.SystemConfigDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/remove-system-config")
public class RemoveSystemConfig extends HttpServlet {

    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        systemConfigDAO = new SystemConfigDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String configId = req.getParameter("configId");
        int id = Integer.parseInt(configId);
        
        // Prevent deleting config ID = 1 (protected system config)
        if (id == 1) {
            req.setAttribute("error", "Cannot delete system config ID 1. This is a protected configuration.");
            req.getRequestDispatcher("./system").forward(req, resp);
            return;
        }
        
        boolean success = systemConfigDAO.deleteSystemConfig(id);
        if (success) {
            req.setAttribute("success", "System config deleted successfully!");
        } else {
            req.setAttribute("error", "Failed to delete system config. Please try again.");
        }
        req.getRequestDispatcher("./system").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

}
