package controller.housekeepingstaff;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.RoomDeviceDAO;
import dao.DeviceDAO;
import dao.RoomDAO;
import model.RoomDevice;
import model.Device;
import utils.IConstant;

@WebServlet(name="TakeDeviceForMaintenance", urlPatterns={"/housekeepingstaff/takeDeviceForMaintenance"})
public class TakeDeviceForMaintenance extends HttpServlet{
    private RoomDeviceDAO roomDeviceDAO;
    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        roomDeviceDAO = new RoomDeviceDAO();
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // <input type="hidden" name="action" value="report">
        //                     <input type="hidden" name="room_Task_ID" value="<%= roomTaskID%>">
        //                     <input type="hidden" name="room" value="<%= room %>">
        //                     <input type="hidden" name="status_want_update" value="Maintenance">
        String room = req.getParameter("room");
        System.out.println(room);
        ArrayList<RoomDevice> roomDevices = roomDeviceDAO.getRoomDevicesByRoomId((new RoomDAO()).getRoomByRoomNumber(room).getRoomId());
        
        // Tạo HashMap chứa roomDeviceId -> deviceName
        Map<Integer, String> deviceMap = new HashMap<>();
        for (RoomDevice rd : roomDevices) {
            Device device = deviceDAO.getDeviceById(rd.getDeviceId());
            if (device != null) {
                deviceMap.put(rd.getRoomDeviceId(), device.getDeviceName());
            }
        }

        req.setAttribute("deviceMap", deviceMap);
        req.getRequestDispatcher(IConstant.completeMaintain).forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
