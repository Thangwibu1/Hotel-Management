package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Room;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RentalRoomController", urlPatterns = {"/rentalRoom"})
public class RentalRoomController extends HttpServlet {
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roomId = req.getParameter("roomId");
        String roomTypeId = req.getParameter("roomTypeId");
        Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
        req.setAttribute("room", room);
        req.setAttribute("roomType", roomTypeDAO.getRoomTypeById(Integer.parseInt(roomTypeId)));
        req.getRequestDispatcher("/views/rentalRoom.jsp").forward(req, resp);
    }
}
