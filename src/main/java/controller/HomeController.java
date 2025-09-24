package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Guest;
import model.Room;
import model.RoomType;
import model.Staff;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy attributes từ session (đã được set trong LoginController)
        Boolean isLogin = (Boolean) req.getSession().getAttribute("isLogin");
        Staff userStaff = (Staff) req.getSession().getAttribute("userStaff");
        Guest userGuest = (Guest) req.getSession().getAttribute("userGuest");

        // Set lại vào request để JSP có thể sử dụng
        req.setAttribute("isLogin", isLogin != null ? isLogin : false);
        req.setAttribute("userStaff", userStaff);
        req.setAttribute("userGuest", userGuest);

        ArrayList<Room> rooms = roomDAO.getAllRoom();
        ArrayList<RoomType> roomTypes = roomTypeDAO.getAllRoomType();
        req.setAttribute("rooms", rooms);
        req.setAttribute("roomTypes", roomTypes);
        req.getRequestDispatcher(IConstant.homePage).forward(req, resp);
        // test thui


    }
}
