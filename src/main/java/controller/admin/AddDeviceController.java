package controller.admin;

import dao.DeviceDAO;
import model.Device;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/add-device")
public class AddDeviceController extends HttpServlet {

    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String deviceName = req.getParameter("deviceName");
        String description = req.getParameter("description");
        
        // Validate input
        if (deviceName == null || deviceName.trim().isEmpty()) {
            req.setAttribute("error", "Device name is required!");
            req.getRequestDispatcher("view-device").forward(req, resp);
            return;
        }
        
        Device newDevice = new Device(deviceName.trim(), description != null ? description.trim() : "");
        
        boolean success = deviceDAO.insertDevice(newDevice);
        
        if (success) {
            req.setAttribute("success", "Device added successfully!");
        } else {
            req.setAttribute("error", "Failed to add device. Please try again.");
        }
        
        req.getRequestDispatcher("view-device").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

