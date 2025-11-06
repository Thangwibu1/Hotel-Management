package utils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public interface IConstant {

    public static final DateTimeFormatter localDateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    public static final DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    // ham format date
    public static String formatDate(LocalDate dateToFormat) {
        if (dateToFormat == null) {
            return "";
        }
        return dateToFormat.format(dateFormat);
    }
    
    // Name for refactor
    public static final String adminFilter = "admin";
    public static final String housekeepingFilter = "housekeepingstaff";
    public static final String serviceFilter = "service-staff";

    public static final String receptionistRole = "./receptionist/receptionist";
    public static final String managerRole = "manager";
    public static final String adminRole =  "./" + adminFilter + "/admin";
    public static final String housekeeping = "/" + housekeepingFilter + "/homeHouseKeeping.jsp";
    public static final String serviceStaff = "service-staff"; //folder service
    public static final String serviceRole = "./" + serviceFilter + "/registerServiceController";

    public static final String systemConfigServlet = "SystemController";
    public static final String systemConfigController = "./" + adminFilter + "/system";
    public static final String addStaffServlet = "/" + adminFilter + "add-staff";
    public static final String removeStaffServlet = "/" + adminFilter + "remove-staff";
    public static final String housekeepingStatistic = "/" + adminFilter + "housekeeping-statistic";
    public static final String bookingChangeServlet = "booking-change";
    public static final String getBookingInfoServlet = "getBookingInfo";
    public static final String bookingServlet = "booking";
    public static final String homeServlet = "home";
    public static final String loginServlet = "login";
    public static final String registerServlet = "register";
    public static final String logoutServlet = "logout";
    public static final String rentalServlet = "rentalRoom";
    public static final String viewBookingServlet = "viewBooking";
    public static final String detailBooking = "./detailBooking";
    public static final String searchController = "search";
    public static final String cancelBookingServlet = "cancelBooking";
    
    //    --------------------receptionist servlet------------------------
    public static final String dashboardReceptionistController = "./Dashboard";
    public static final String bookingController = "./BookingsController";
    public static final String getPendingCheckinController = "./GetPendingCheckinController";
    public static final String roomsStatusReceptionistController = "./RoomsStatusBoard";
    public static final String bookingViewController = "./ViewBookingController";
    public static final String bookingEditController = "./EditBookingController";
    public static final String bookingDeleteController = "./DeleteBookingController";

    
    public static final String takeRoomForCleanController = "./takeRoomForCleanController";
    public static final String makeNewRoomTaskController = "./makeNewRoomTaskController";
    public static final String updateStatusCleanRoomController = "./UpdateStatusCleanRoomController";
    public static final String detailProfileStaffController = "./detailProfileStaffController";
    public static final String completeIngroressTask = "./completeIngroressTask.jsp";
    public static final String detailProfileStaffPage = "./detailProfileStaffPage.jsp";
    public static final String completeMaintain = "./completeMaintain.jsp";
    public static final String takeDeviceForNoteMaintenanceController = "./takeDeviceForNoteMaintenanceController";
    public static final String updateMaintain = "./updateMaintain.jsp";
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
    //    --------------------receptionist page------------------------
    public static final String receptionistPage = "/receptionist/receptionistPage.jsp";


    // -------------------------service constant--------------------------------
    public static final String pendingText = "Pending";
    public static final String inProgressText = "In Progress";
    public static final String completedText = "Completed";
    public static final String canceledText = "Canceled";
    
    //---service page-----------------------------------------------------------
    public static final String registerServicePage = "./registerServicePage.jsp";
    public static final String updateStatusServicePage = "./updateStatusServicePage.jsp";
    public static final String reportServicePage = "./reportServicePage.jsp";
    public static final String listServiceTodayPage = "./listServiceTodayPage.jsp";
    public static final String employeePerformancePage = "./employeePerformancePage.jsp";
    public static final String serviceRevenuePage = "./serviceRevenuePage.jsp";
    public static final String viewBookingServiceCardPage = "./viewBookingServiceCardPage.jsp";
    //---service servlet--------------------------------------------------------
    public static final String registerServiceController = "./registerServiceController";
    public static final String reportServiceController = "./reportServiceController";
    public static final String updateStatusServiceController = "./updateStatusServiceController";
    public static final String makeNewServiceController = "./makeNewServiceController";
    public static final String listServiceTodayController = "./listServiceTodayController";
    public static final String employeePerformanceController = "./employeePerformanceController";
    public static final String serviceRevenueController = "./serviceRevenueController";
    public static final String takeIncomeByTimeController = "./takeIncomeByTimeController";
    public static final String searchBookingByTimeController = "./searchBookingByTimeController";
    public static final String viewBookingServiceCardController = "./viewBookingServiceCardController";
    public static final String editStatusServiceController = "./editStatusServiceController";
}
