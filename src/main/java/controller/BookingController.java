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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
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

    protected int bookingHandle(int roomId, int guessId, LocalDateTime checkInDate, LocalDateTime checkOutDate, LocalDate bookingDate) {
        int returnValue = 0;

        Booking newBooking = new Booking(guessId, roomId, checkInDate, checkOutDate, bookingDate, "Reserved");
        try {
            returnValue = bookingDAO.addBookingV2(newBooking);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(returnValue);
        return returnValue;
    }

    protected boolean bookingServiceHandle(List<ChoosenService> services, int bookingId) {
        boolean resutlt = false;

        for (ChoosenService service : services) {
            try {
                BookingService newBookingService = new BookingService(bookingId, service.getServiceId(), service.getQuantity(), service.getServiceDate(), 0);
                resutlt = bookingServiceDAO.addBookingService(newBookingService);
                resutlt = true;
            } catch (Exception e) {
                e.printStackTrace();
                resutlt = false;
                break;
            }

        }

        return resutlt;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /*
         * http://localhost:8080/PRJ_Assignment/booking?roomId=1&bookingDate=2025-09-28&guestId=1&fullName=Nguy%3Fn+Van+An&email=nguyenvanan%40email.com&checkInDate=2025-09-27&checkOutDate=2025-09-30&
         * serviceId=1&serviceQuantity=1&serviceDate=2025-09-27&
         * serviceId=1&serviceQuantity=1&serviceDate=2025-09-28&
         * serviceId=3&serviceQuantity=1&serviceDate=2025-09-27
         * */
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

        ArrayList<ChoosenService> services = new ArrayList<>();
        String[] serviceId = (String[]) req.getParameterValues("serviceId");
        String[] serviceQuantity = (String[]) req.getParameterValues("serviceQuantity");
        String[] serviceDate = (String[]) req.getParameterValues("serviceDate");
        if (serviceId != null && serviceQuantity != null && serviceDate != null) {
            for (int i = 0; i < serviceId.length; i++) {
                ChoosenService tmpService = new ChoosenService(Integer.parseInt(serviceId[i]), Integer.parseInt(serviceQuantity[i]), LocalDate.parse(serviceDate[i]));
                services.add(tmpService);
            }
        }
        int newBookingId = 0;
        try {
            newBookingId = bookingHandle(Integer.parseInt(roomId), Integer.parseInt(guestId), inDateTime, outDateTime, bookDate);
            if (newBookingId > 0) {
                roomDAO.updateRoomStatus(Integer.parseInt(roomId), "Occupied");
                boolean bookingServiceResult = bookingServiceHandle(services, newBookingId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Room viewRoom = roomDAO.getRoomById(Integer.parseInt(roomId));
        ArrayList<Service> servicesList = new ArrayList<>();
        for (ChoosenService service : services) {
            servicesList.add(serviceDAO.getServiceById(service.getServiceId()));
        }
        Guest viewGuest = guestDAO.getGuestById(Integer.parseInt(guestId));

        req.setAttribute("booking", bookingDAO.getBookingById(newBookingId));

        req.setAttribute("chosenServices", services);
        req.setAttribute("roomType", roomTypeDAO.getRoomTypeById(viewRoom.getRoomTypeId()));
        req.setAttribute("room", viewRoom);
        req.setAttribute("guest", viewGuest);
        req.setAttribute("services", servicesList);

        req.getRequestDispatcher(IConstant.bookingDashboard).forward(req, resp);
    }
}
