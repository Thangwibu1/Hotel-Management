package controller.admin;

import dao.RoomDeviceDAO;
import model.RoomDevice;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/add-room-device")
public class AddRoomDeviceController extends HttpServlet {

    private RoomDeviceDAO roomDeviceDAO;

    @Override
    public void init() throws ServletException {
        roomDeviceDAO = new RoomDeviceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roomIdStr = req.getParameter("roomId");
        String deviceIdStr = req.getParameter("deviceId");
        String quantityStr = req.getParameter("quantity");
        String statusStr = req.getParameter("status");
        String roomNumber = req.getParameter("roomNumber");
        
        // Validate input
        if (roomIdStr == null || roomIdStr.trim().isEmpty() ||
            deviceIdStr == null || deviceIdStr.trim().isEmpty() ||
            quantityStr == null || quantityStr.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required!");
            req.getRequestDispatcher("view-room-device?roomNumber=" + roomNumber).forward(req, resp);
            return;
        }
        
        try {
            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);
            int quantity = Integer.parseInt(quantityStr);
            Integer status = null;
            
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                status = Integer.parseInt(statusStr);
            }
            
            // Create new room device
            RoomDevice newRoomDevice = new RoomDevice(roomId, deviceId, quantity, status);
            
            boolean success = roomDeviceDAO.insertRoomDevice(newRoomDevice);
            
            if (success) {
                req.setAttribute("success", "Room device added successfully!");
            } else {
                req.setAttribute("error", "Failed to add room device. Please try again.");
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid input. Please enter valid numbers.");
        }
        
        // Redirect back to view room device page with room number
        resp.sendRedirect("view-room-device?roomNumber=" + roomNumber);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

