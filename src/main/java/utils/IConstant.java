package utils;

import java.time.format.DateTimeFormatter;

public interface IConstant {
    public static final DateTimeFormatter localDateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    public static final DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");

// Name for refactor
    public static final String adminFilter = "admin";

    public static final String receptionistRole = "receptionist";
    public static final String managerRole = "manager";
    public static final String adminRole =  "./" + adminFilter + "/admin";
    public static final String housekeeping = "/housekeepingstaff/homeHouseKeeping.jsp";
    public static final String serviceStaff = "service-staff";

    public static final String systemConfigServlet = "SystemController";
    public static final String systemConfigController = "./" + adminFilter + "/system";
    public static final String addStaffServlet = "/" + adminFilter + "add-staff";
    public static final String removeStaffServlet = "/" + adminFilter + "remove-staff";
    public static final String bookingChangeServlet = "booking-change";
    public static final String getBookingInfoServlet = "getBookingInfo";
    public static final String bookingServlet = "booking";
    public static final String homeServlet = "home";
    public static final String loginServlet = "login";
    public static final String registerServlet = "register";
    public static final String logoutServlet = "logout";
    public static final String rentalServlet = "rentalRoom";
    public static final String viewBookingServlet = "viewBooking";
    public static final String detailBooking = "detailBooking";
    public static final String searchController = "search";

    public static final String takeRoomForCleanController = "takeRoomForCleanController";

    public static final String systemConfigPage = "/" + adminFilter + "/systemConfig.jsp";
    public static final String adminPage = "/" + adminFilter + "/adminPage.jsp";
    public static final String editServicePage = "editService.jsp";
    public static final String detailBookingPage = "detailBooking.jsp";
    public static final String bookingDashboard = "bookingDashboard.jsp";
    public static final String viewHisttoryRental = "viewHistoryRental.jsp";
    public static final String staffDashboard = "staffDashboard.jsp";
    public static final String homePage = "home.jsp";
    public static final String loginPage = "loginPage.jsp";
    public static final String registerPage = "registerPage.jsp";
    public static final String rentalPage = "rentalPage.jsp";
    public static final String registerSuccess = "registerSuccess.jsp";
}
