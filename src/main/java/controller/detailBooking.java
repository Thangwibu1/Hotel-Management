package controller;

import dao.*;
import model.*;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/detailBooking")
public class DetailBooking extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;
    private BookingServiceDAO bookingServiceDAO;
    private ServiceDAO serviceDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        guestDAO = new GuestDAO();
        bookingServiceDAO = new BookingServiceDAO();
        serviceDAO = new ServiceDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        int guestId = Integer.parseInt(req.getParameter("guestId"));
        Booking booking = bookingDAO.getBookingById(bookingId);
        req.setAttribute("booking", booking);
        Room room = roomDAO.getRoomById(booking.getRoomId());
        req.setAttribute("room", room);
        RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
        req.setAttribute("roomType", roomType);
        Guest guest = guestDAO.getGuestById(guestId);
        req.setAttribute("guest", guest);
        List<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
        req.setAttribute("bookingServices", bookingServices);
        List<Service> serviceDetailForBookingService = new ArrayList<>();
        for (BookingService bookingService : bookingServices) {
            serviceDetailForBookingService.add(serviceDAO.getServiceById(bookingService.getServiceId()));
        }
        req.setAttribute("services", serviceDetailForBookingService);
        List<Service> services = serviceDAO.getAllService();
        req.setAttribute("allServices", services);
        ArrayList<Booking> bookings = bookingDAO.getBookingByGuestId(guestId);
        req.setAttribute("bookings", bookings);
        ArrayList<Room> rooms = new ArrayList<>();
        for (Booking bookig : bookings) {
            rooms.add(roomDAO.getRoomById(bookig.getRoomId()));
        }
        req.setAttribute("rooms", rooms);
        ArrayList<RoomType> roomTypes = roomTypeDAO.getAllRoomType();
        req.setAttribute("roomTypes", roomTypes);
        req.getRequestDispatcher(IConstant.detailBookingPage).forward(req, resp);
    }
}