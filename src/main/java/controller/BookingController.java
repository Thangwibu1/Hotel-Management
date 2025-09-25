package controller;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        guestDAO = new GuestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            //        roomId
            //        guestId
//                    fullName
//                    email
//                    checkInDate
//                    checkOutDate
//                    selectedService(array)
        String roomId = req.getParameter("roomId");
        String guestId = req.getParameter("guestId");
        String checkInDate = req.getParameter("checkInDate");
        String checkOutDate = req.getParameter("checkOutDate");
        String[] selectedServices = req.getParameterValues("selectedService");

        ArrayList<Booking> b = bookingDAO.getAllBookings();
        for (Booking booking : b) {
            System.out.println(booking);
        }
    }
}
