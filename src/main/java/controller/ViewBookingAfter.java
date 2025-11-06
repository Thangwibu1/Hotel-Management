package controller;

import dao.BookingDAO;
import dao.ServiceDAO;
import model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/viewBookingAfter")
public class ViewBookingAfter extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        req.setAttribute("booking", bookingDAO.getBookingById(newBookingId));
//
//        req.setAttribute("chosenServices", services);
//        req.setAttribute("roomType", roomTypeDAO.getRoomTypeById(viewRoom.getRoomTypeId()));
//        req.setAttribute("room", viewRoom);
//        req.setAttribute("guest", viewGuest);
//        req.setAttribute("services", servicesList);
//        Booking booking = req.getAttribute("booking") != null ? (Booking) req.getAttribute("booking") : null;
//        ArrayList<ChoosenService> chosenServices = req.getAttribute("chosenServices") != null ? (ArrayList<ChoosenService>) req.getAttribute("chosenServices") : null;
//        RoomType roomType = req.getAttribute("roomType") != null ? (RoomType) req.getAttribute("roomType") : null;
//        Room room = req.getAttribute("room") != null ? (Room) req.getAttribute("room") : null;
//        ArrayList<Service> services = req.getAttribute("services") != null ? (ArrayList<Service>) req.getAttribute("services") : null;
//        Guest guest = req.getAttribute("guest") != null ? (Guest) req.getAttribute("guest") : null;
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        Booking booking = (new BookingDAO()).getBookingById(bookingId);
        ArrayList<BookingService> bookingServices = (new dao.BookingServiceDAO()).getBookingServiceByBookingId(bookingId);
        Room room = (new dao.RoomDAO()).getRoomById(booking.getRoomId());
        Guest guest = (new dao.GuestDAO()).getGuestById(booking.getGuestId());
        ArrayList<Service> services = new ArrayList<>();
        services = (new ServiceDAO()).getAllService();
        RoomType roomType = (new dao.RoomTypeDAO()).getRoomTypeById(room.getRoomTypeId());
        req.setAttribute("roomType", roomType);
        req.setAttribute("room", room);
        req.setAttribute("guest", guest);
        req.setAttribute("services", services);
        req.setAttribute("bookingServices", bookingServices);
        req.setAttribute("booking", booking);
        req.getRequestDispatcher("./bookingDashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost( req, resp);
    }
}
