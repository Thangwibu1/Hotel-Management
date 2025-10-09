package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookingDAO;
import dao.BookingServiceDAO;
import model.BookingService;
import model.ChoosenService;
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String[] serviceId = (String[])req.getParameterValues("newServiceId");
        String[] quantity = (String[])req.getParameterValues("newServiceQuantity");
        String[] date = (String[])req.getParameterValues("newServiceDate");
        String bookingId = req.getParameter("bookingId");

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
        }
        resp.sendRedirect(IConstant.homeServlet);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
