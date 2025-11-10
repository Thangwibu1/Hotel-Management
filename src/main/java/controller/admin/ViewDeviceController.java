package controller.admin;

import dao.DeviceDAO;
import model.Device;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/view-device")
public class ViewDeviceController extends HttpServlet {

    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Staff admin = (Staff) session.getAttribute("admin");
        
        // Get all devices
        ArrayList<Device> devices = deviceDAO.getAllDevices();
        
        req.setAttribute("admin", admin);
        req.setAttribute("devices", devices);
        req.getRequestDispatcher("/admin/viewDevice.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

