package utils;

import java.time.format.DateTimeFormatter;

public interface IConstant {
    public static final DateTimeFormatter localDateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    public static final DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    public static final String bookingServlet = "booking";
    public static final String homeServlet = "home";
    public static final String loginServlet = "login";
    public static final String registerServlet = "register";
    public static final String logoutServlet = "logout";
    public static final String rentalServlet = "rentalRoom";
    public static final String staffDashboard = "staffDashboard.jsp";
    public static final String homePage = "home.jsp";
    public static final String loginPage = "loginPage.jsp";
    public static final String registerPage = "registerPage.jsp";
    public static final String rentalPage = "rentalPage.jsp";
}
