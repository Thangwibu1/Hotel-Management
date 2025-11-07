package controller.admin;

import dao.RoomDAO;
import model.Staff;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/completeRoom")
public class CompleteRoomController extends HttpServlet {

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

        // Get roomId from request parameter
        String roomIdStr = req.getParameter("roomId");
        
        if (roomIdStr != null && !roomIdStr.isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdStr);
                
                // Update room status to "Available"
                boolean updateSuccess = roomDAO.updateRoomStatus(roomId, "Available");
                
                if (updateSuccess) {
                    req.setAttribute("success", "Room has been marked as completed and is now available.");
                } else {
                    req.setAttribute("error", "Failed to update room status.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Invalid room ID.");
            }
        } else {
            req.setAttribute("error", "Room ID is missing.");
        }

        // Redirect back to getRoomWaiting controller
        resp.sendRedirect("./getRoomWaiting");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

