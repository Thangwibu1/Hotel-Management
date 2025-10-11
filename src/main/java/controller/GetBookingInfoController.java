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

@WebServlet("/getBookingInfo")
public class GetBookingInfoController extends HttpServlet {

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
        //Lay thong tin booking
        req.setAttribute("booking", booking);
        //Lay thong tin room
        Room room = roomDAO.getRoomById(booking.getRoomId());
        req.setAttribute("room", room);
        //Lay thong tin roomType
        RoomType roomType = roomTypeDAO.getRoomTypeById(room.getRoomTypeId());
        req.setAttribute("roomType", roomType);

        //Lay thong tin bookingService
        List<BookingService> bookingServices = bookingServiceDAO.getBookingServiceByBookingId(bookingId);
        req.setAttribute("chosenServices", bookingServices);

        //Lay tat ca service de doi chieu hien thi
        List<Service> services = serviceDAO.getAllService();
        req.setAttribute("allServices", services);
        req.getRequestDispatcher(IConstant.editServicePage).forward(req, resp);

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
