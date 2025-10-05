package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/search")
public class SearchController extends HttpServlet {
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
    }
}
