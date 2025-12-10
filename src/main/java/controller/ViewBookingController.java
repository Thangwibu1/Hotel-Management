package controller;

import dao.*;
import model.Booking;
import model.Room;
import model.RoomType;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/viewBooking")
public class ViewBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;
    private BookingServiceDAO bookingServiceDAO;
    private ServiceDAO serviceDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        guestDAO = new GuestDAO();
        bookingServiceDAO = new BookingServiceDAO();
        serviceDAO = new ServiceDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int guestId = Integer.parseInt(req.getParameter("guestId"));
        ArrayList<Booking> bookings = bookingDAO.getBookingByGuestId(guestId);
        req.setAttribute("bookings", bookings);
        ArrayList<Room> rooms = new ArrayList<>();
        for (Booking booking : bookings) {
            rooms.add(roomDAO.getRoomById(booking.getRoomId()));
        }
        req.setAttribute("rooms", rooms);
        ArrayList<RoomType> roomTypes = roomTypeDAO.getAllRoomType();
        req.setAttribute("roomTypes", roomTypes);

        req.getRequestDispatcher(IConstant.viewHisttoryRental).forward(req, resp);
    }
}
