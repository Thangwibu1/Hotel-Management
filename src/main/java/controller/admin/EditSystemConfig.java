package controller.admin;

import dao.SystemConfigDAO;
import model.SystemConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/edit-system-config")
public class EditSystemConfig extends HttpServlet {
    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        systemConfigDAO = new SystemConfigDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String configId = req.getParameter("configId");
        String configName = req.getParameter("configName");
        String configValue = req.getParameter("configValue");
        int id = Integer.parseInt(configId);
        
        // For config ID = 1, preserve the original config name from database
        if (id == 1) {
            SystemConfig existingConfig = systemConfigDAO.getSystemConfigById(id);
            if (existingConfig != null) {
                configName = existingConfig.getConfigName();
            }
        }
        
        boolean success = systemConfigDAO.updateVale(new SystemConfig(id, configName, Integer.parseInt(configValue)));
        if (success) {
            req.setAttribute("success", "System config updated successfully!");
        } else {
            req.setAttribute("error", "Failed to update system config. Please try again.");
        }
        req.getRequestDispatcher("./system").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
