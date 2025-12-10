package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookingDAO;
import utils.IConstant;

@WebServlet("/cancelBooking")
public class CancelBookingController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int bookingId = req.getParameter("bookingId") != null ? Integer.parseInt(req.getParameter("bookingId")) : 0;
        boolean result = (new BookingDAO()).updateBookingStatus(bookingId, "Canceled");
        if (result) {
            req.getRequestDispatcher("./" + IConstant.viewBookingServlet).forward(req, resp);
        } else {
            req.getRequestDispatcher("./" + IConstant.viewBookingServlet).forward(req, resp);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO Auto-generated method stub
        doPost(req, resp);
    }
}
