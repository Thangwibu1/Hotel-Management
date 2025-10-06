package controller;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Booking;
import model.Room;
import model.RoomType;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /*/PRJ_Assignment/home?
        check-in=2025-10-01
        &check-out=2025-10-05&
        guests=2&room-type=2
        * */
        String checkIn = req.getParameter("check-in");
        String checkOut = req.getParameter("check-out");
        String guests = req.getParameter("guests");
        String roomType = req.getParameter("room-type");

        LocalDate checkInDate = LocalDate.parse(checkIn);
        LocalDate checkOutDate = LocalDate.parse(checkOut);

        LocalDateTime checkInDateTime = checkInDate.atStartOfDay();

        LocalDateTime checkOutDateTime = checkOutDate.atTime(23, 59, 59);

        int numberOfGuests = Integer.parseInt(guests);

        ArrayList<Booking> bookings = bookingDAO.getBookingByCheckInCheckOutDate(checkInDateTime, checkOutDateTime);

        ArrayList<Room> allRooms = roomDAO.getAllRoom();

        ArrayList<Room> availableRooms = new ArrayList<>();

        for (Room room : allRooms) {
            boolean isBooked = false;
            for (Booking booking : bookings) {
                if (room.getRoomId() == booking.getRoomId()) {
                    isBooked = true;
                    break;
                }
            }
            if (isBooked == false) {
                availableRooms.add(room);
            }
        }

        for (Room room : availableRooms) {
            System.out.println(room);
        }

        ArrayList<RoomType> roomTypes = roomTypeDAO.getAllRoomType();

        req.setAttribute("availableRooms", availableRooms);
        req.setAttribute("roomTypes", roomTypes);
        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);
        req.setAttribute("guests", numberOfGuests);
        req.setAttribute("roomType", roomType);

        // Forward đến trang searchResult.jsp
        req.getRequestDispatcher("searchResult.jsp").forward(req, resp);
    }
}
