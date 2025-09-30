package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import dao.ServiceDAO;
import model.Room;
import model.RoomType;
import model.Service;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "RentalRoomController", urlPatterns = {"/rentalRoom"})
public class RentalRoomController extends HttpServlet {
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roomId = req.getParameter("roomId");
        String roomTypeId = req.getParameter("roomTypeId");
        Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
        RoomType roomType = roomTypeDAO.getRoomTypeById(Integer.parseInt(roomTypeId));
        ArrayList<Service> services = serviceDAO.getAllService();
        if (room != null && roomType != null && services != null) {
            req.setAttribute("services", services);
            req.setAttribute("room", room);
            req.setAttribute("roomType", roomType);
            req.getRequestDispatcher(IConstant.rentalPage).forward(req, resp);

        } else {
            resp.sendRedirect("home");
        }
    }
}
