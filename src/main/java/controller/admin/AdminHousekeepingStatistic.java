package controller.admin;

import dao.RoomTaskDAO;
import dao.StaffDAO;
import model.RoomTask;
import model.Staff;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/admin/housekeeping-statistic")
public class AdminHousekeepingStatistic extends HttpServlet {

    private RoomTaskDAO roomTaskDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        roomTaskDAO = new RoomTaskDAO();
        staffDAO = new StaffDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Staff admin = null;
        if (session != null) {
            admin = (Staff) session.getAttribute("userStaff");
        }
        req.setAttribute("admin", admin);

        ArrayList<RoomTask> roomTasks = roomTaskDAO.getAllRoom();
        ArrayList<Staff> staffs = staffDAO.getStaffsByRole("housekeeping");
        HashMap<Integer, ArrayList<RoomTask>> roomTaskByStaff = new HashMap<>();
        for (Staff staff : staffs) {
            ArrayList<RoomTask> tmp = new ArrayList<>();
            for (RoomTask roomTask : roomTasks) {
                if (roomTask.getStaffID() == staff.getStaffId()) {
                    tmp.add(roomTask);
                }
            }
            roomTaskByStaff.put(staff.getStaffId(), tmp);
        }
        req.setAttribute("roomTaskByStaff", roomTaskByStaff);
        req.setAttribute("staffs", staffs);
        req.getRequestDispatcher("housekeeping-statistic.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
