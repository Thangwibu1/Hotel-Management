package controller;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Booking;
import org.omg.CORBA.ARG_OUT;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
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

    protected boolean bookingHandle(int roomId, int guessId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate) {
        Booking newBooking = new Booking(guessId, roomId, checkInDate, checkOutDate, bookingDate, "Pending");
        return bookingDAO.addBooking(newBooking);
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
// booking?roomId=1&bookingDate=2025-09-27&guestId=1&fullName=Nguy%3Fn+Van+An&email=nguyenvanan%40email.com&checkInDate=2025-09-27&checkOutDate=2025-09-30&
// selectedServices=1&quantity_1=1&serviceDate_1=2025-09-29&selectedServices=2&quantity_2=2&serviceDate_2=2025-09-27
        String roomId = req.getParameter("roomId");
        String guestId = req.getParameter("guestId");

        String checkInDate = req.getParameter("checkInDate");
        String checkOutDate = req.getParameter("checkOutDate");
        String bookingDate = req.getParameter("bookingDate");
        //Convert to LocalDateTime
        LocalDate inDate = LocalDate.parse(checkInDate);
        LocalDate outDate = LocalDate.parse(checkOutDate);
        LocalDate bookDate = LocalDate.parse(bookingDate);
        //Change to 00:00:00 and 23:59:59
        LocalDateTime inDateTime = inDate.atStartOfDay();
        LocalDateTime outDateTime = outDate.atTime(23, 59, 59);

        int quantity = 0;
        LocalDate serviceDate;
        String[] selectedServices = req.getParameterValues("selectedServices");
        if (selectedServices != null) {
            for (String serviceId : selectedServices) {
                int id = Integer.parseInt(serviceId);
                String quantityParam = req.getParameter("quantity_" + id);
                String serviceDateParam = req.getParameter("serviceDate_" + id);
                quantity = Integer.parseInt(quantityParam);
                serviceDate = LocalDate.parse(serviceDateParam);
            }
        }

    }
}
