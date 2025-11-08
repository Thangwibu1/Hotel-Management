package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import dao.RoomTaskDAO;
import model.Booking;
import model.BookingService;
import model.ChoosenService;
import model.RoomTask;
import utils.IConstant;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/booking-change")
public class BookingChangeController extends HttpServlet {

    private BookingDAO bookingDAO;
    private BookingServiceDAO bookingServiceDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        bookingServiceDAO = new BookingServiceDAO();
    }

    public boolean addBooking(ChoosenService newService, int bookingId) {
        boolean result = false;
        try {
            BookingService bs = new BookingService(bookingId, newService.getServiceId(), newService.getQuantity(), newService.getServiceDate(), 0);
            result = bookingServiceDAO.addBookingService(bs);
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        }
        return result;
    }

    public boolean updateBookingServiceStatus(int bookingServiceId, int status) {
        return bookingServiceDAO.updateBookingServiceStatus(bookingServiceId, status);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String[] serviceId = (String[])req.getParameterValues("newServiceId");
        String[] quantity = (String[])req.getParameterValues("newServiceQuantity");
        String[] date = (String[])req.getParameterValues("newServiceDate");
        String bookingId = req.getParameter("bookingId");
        String[] cancelService = req.getParameterValues("cancelService");

        List<ChoosenService> newServices = new ArrayList<>();
        if (serviceId != null) {
            for (int i = 0; i < serviceId.length; i++) {
                if (serviceId[i] != null && !serviceId[i].isEmpty() && quantity[i] != null && !quantity[i].isEmpty() && date[i] != null && !date[i].isEmpty()) {
                    ChoosenService newService = new ChoosenService(Integer.parseInt(serviceId[i]), Integer.parseInt(quantity[i]), LocalDate.parse(date[i]));
                    newServices.add(newService);
                    
                }
            }
        }
        // Store the new services in the database
        for (ChoosenService newService : newServices) {
            addBooking(newService, Integer.parseInt(bookingId));
            if (newService.getServiceId() == 3) {
                RoomTask roomTask = new RoomTask(Integer.parseInt(bookingId), null, newService.getServiceDate().atStartOfDay(),newService.getServiceDate().atTime(23, 59, 59), "Pending", null, 0);
                RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                boolean roomTaskAdded = roomTaskDAO.insertRoomTaskForService(roomTask);
                if (!roomTaskAdded) {
                    System.out.println("Sai me roi");
                }
            }
        }
        // Booking booking = bookingDAO.getBookingById(Integer.parseInt(bookingId));
        if (cancelService != null) {
            for (String id : cancelService) {
                updateBookingServiceStatus(Integer.parseInt(id), -1);
                if (bookingServiceDAO.getById(Integer.parseInt(id)).getServiceId() == 3) {
                    ArrayList<Integer> roomTaskIds = bookingServiceDAO.getRoomTaskIdByBookingServiceId(Integer.parseInt(id));
                    for (Integer roomTaskId : roomTaskIds) {
                        
                        RoomTaskDAO roomTaskDAO = new RoomTaskDAO();
                        RoomTask roomTask = roomTaskDAO.getRoomTaskById(roomTaskId);
                        if (roomTask != null && roomTask.getStatusClean().equals("Pending")) {
                            roomTaskDAO.deleteRoomTask(roomTaskId);
                            break;
                        }
                    }
                }
                // if (Integer.parseInt(id) == 3) {
                    
                // }
            }
        }
        resp.sendRedirect(IConstant.homeServlet);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
