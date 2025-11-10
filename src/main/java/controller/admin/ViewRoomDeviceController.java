package controller.admin;

import dao.RoomDAO;
import dao.RoomDeviceDAO;
import dao.DeviceDAO;
import model.Room;
import model.RoomDevice;
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

@WebServlet("/admin/view-room-device")
public class ViewRoomDeviceController extends HttpServlet {

    private RoomDAO roomDAO;
    private RoomDeviceDAO roomDeviceDAO;
    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
        roomDeviceDAO = new RoomDeviceDAO();
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Staff admin = (Staff) session.getAttribute("admin");
        
        String roomNumber = req.getParameter("roomNumber");
        Room room = null;
        ArrayList<RoomDevice> roomDevices = new ArrayList<>();
        
        if (roomNumber != null && !roomNumber.trim().isEmpty()) {
            // Find room by room number
            room = roomDAO.getRoomByRoomNumber(roomNumber.trim());
            
            if (room != null) {
                // Get all room devices for this room
                roomDevices = roomDeviceDAO.getRoomDevicesByRoomId(room.getRoomId());
            } else {
                req.setAttribute("error", "Room not found with number: " + roomNumber);
            }
        }
        
        // Get all available devices for dropdown in add form
        ArrayList<Device> allDevices = deviceDAO.getAllDevices();
        
        req.setAttribute("admin", admin);
        req.setAttribute("room", room);
        req.setAttribute("roomDevices", roomDevices);
        req.setAttribute("allDevices", allDevices);
        req.setAttribute("searchedRoomNumber", roomNumber);
        req.getRequestDispatcher("/admin/viewRoomDevice.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

