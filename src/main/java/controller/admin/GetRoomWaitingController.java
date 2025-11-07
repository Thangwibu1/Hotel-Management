package controller.admin;

import dao.RoomDAO;
import model.Room;
import model.Staff;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/getRoomWaiting")
public class GetRoomWaitingController extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Staff admin = null;
        if (session != null) {
            admin = (Staff) session.getAttribute("userStaff");
        }
        
        // Redirect to login if not logged in or not an admin
        if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("../" + IConstant.loginPage);
            return;
        }

        req.setAttribute("admin", admin);

        // Get all rooms with status "Waiting"
        ArrayList<Room> waitingRooms = roomDAO.getRoomsByStatus("Waiting");
        req.setAttribute("waitingRooms", waitingRooms);

        req.getRequestDispatcher(IConstant.viewWaitingRoomPage).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

