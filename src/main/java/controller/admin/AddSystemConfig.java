package controller.admin;

import dao.SystemConfigDAO;
import model.SystemConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/add-system-config")
public class AddSystemConfig extends HttpServlet {

    private SystemConfigDAO systemConfigDAO;

    @Override
    public void init() throws ServletException {
        systemConfigDAO = new SystemConfigDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String configName = req.getParameter("configName");
        String configValue = req.getParameter("configValue");
        systemConfigDAO.addSystemConfig(new SystemConfig(configName, Integer.parseInt(configValue)));
        req.getRequestDispatcher("./system").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
