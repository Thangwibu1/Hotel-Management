package controller.service;

import dao.BookingServiceDAO;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.BookingService;
import model.Staff;
import utils.IConstant;

@WebServlet(name = "EditStatusServiceController", urlPatterns = {"/service-staff/editStatusServiceController"})
public class EditStatusServiceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            HttpSession session = request.getSession();
            Staff staff = (Staff) session.getAttribute("userStaff");
            
            // L?y data t? form
            String bookingServiceIdStr = request.getParameter("booking_Service_ID");
            String statusCurrentStr = request.getParameter("status_Curent");
            String staffImplementID = request.getParameter("staff_implement");
            
            // L?y data update
            int status_Update = Integer.parseInt(request.getParameter("status_Update"));
            
            int bookingServiceId = Integer.parseInt(bookingServiceIdStr);
            int statusCurrent = Integer.parseInt(statusCurrentStr);
            int staffImplement = staff.getStaffId();
            
            // L?y BookingService t? database
            BookingServiceDAO bd = new BookingServiceDAO();
            BookingService bookingService = bd.getBookingServiceByBookingServiceId(bookingServiceId);
            
            // L?y staffID t? booking (có th? null)
            Integer staffIdObject = bookingService.getStaffID();
            int staffInBookingID; 
            if (staffIdObject == null) {
                staffInBookingID = 0; // Ch?a có staff assign
            } else {
                staffInBookingID = staffIdObject; // ?ã có staff assign
            }
            
            System.out.println("=== DEBUG INFO ===");
            System.out.println("Booking Service ID: " + bookingServiceId);
            System.out.println("Status Current (DB): " + bookingService.getStatus());
            System.out.println("Status Update (Target): " + status_Update);
            System.out.println("Staff Implement (Current): " + staffImplement);
            System.out.println("Staff In Booking (DB): " + staffInBookingID);
            
            boolean result = false;
            String url = IConstant.viewBookingServiceCardController;

            if (staffInBookingID != 0) {
                if (staffImplement == staffInBookingID) {
                    System.out.println("Staff authorized");
                    if (bookingService.getStatus() == 1) {
                        if (status_Update == 2) {
                            result = bd.updateBookingServiceStatus(bookingServiceId, 2);
                            if (result) {
                                request.setAttribute("COLOR", "alert-success");
                                request.setAttribute("THONGBAO", "Service completed successfully!");
                            } else {
                                request.setAttribute("COLOR", "alert-danger");
                                request.setAttribute("THONGBAO", "Failed to update status!");
                            }
                        } else {
                            request.setAttribute("COLOR", "alert-danger");
                            request.setAttribute("THONGBAO", "Can only mark as Completed from InProgress!");
                        }
                    } else {
                        request.setAttribute("COLOR", "alert-danger");
                        request.setAttribute("THONGBAO", "Booking is not in InProgress status!");
                    }
                } else {
                    request.setAttribute("COLOR", "alert-danger");
                    request.setAttribute("THONGBAO", "You are not authorized to update this booking!");
                }
            } 
            else {
                if (bookingService.getStatus() == 0) {
                    if (status_Update == 1) {
                        result = bd.updateBookingServiceStatus(bookingServiceId, 1, staffImplement);
                        if (result) {
                            request.setAttribute("COLOR", "alert-success");
                            request.setAttribute("THONGBAO", "Service confirmed successfully!");
                        } else {
                            request.setAttribute("COLOR", "alert-danger");
                            request.setAttribute("THONGBAO", "Failed to confirm service!");
                        }
                    } 
                    else if (status_Update == -1) {
                        System.out.println("=== Pending -> Canceled ===");
                        LocalDate serviceDate = bookingService.getServiceDate();
                        LocalDate today = LocalDate.now();
                        if (serviceDate.isAfter(today) ) {
                            result = bd.updateBookingServiceStatus(bookingServiceId, -1, staffImplement);
                            System.out.println("Pending -> Canceled: " + result);
                            
                            if (result) {
                                request.setAttribute("COLOR", "alert-success");
                                request.setAttribute("THONGBAO", "Service canceled successfully!");
                            } else {
                                request.setAttribute("COLOR", "alert-danger");
                                request.setAttribute("THONGBAO", "Failed to cancel service!");
                            }
                        } else {
                            request.setAttribute("COLOR", "alert-danger");
                            request.setAttribute("THONGBAO", "Cannot cancel - service date has already passed!");
                        }
                    } else {
                        request.setAttribute("COLOR", "alert-danger");
                        request.setAttribute("THONGBAO", "Invalid status update!");
                    }
                } else {
                    request.setAttribute("COLOR", "alert-danger");
                    request.setAttribute("THONGBAO", "Booking is not in Pending status!");
                }
            }
            
            System.out.println("======DEBUG EDIT=============\n");
            System.out.println(bookingService.toString());

            String colorText = (String) request.getAttribute("COLOR");
            String message = (String) request.getAttribute("THONGBAO");
            if (message != null) {
                session.setAttribute("SUCCESS_MESSAGE", message);
                if(colorText != null){
                    session.setAttribute("COLOR_TEXT", colorText);
                }
            }
          
            
            response.sendRedirect(url + "?bookingServiceId=" + bookingServiceId );
            
        } catch (Exception e) {
            e.printStackTrace();
          
            request.setAttribute("THONGBAO", "System error occuralert-danger!");
            request.getRequestDispatcher(IConstant.viewBookingServiceCardController).forward(request, response);
        } 
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
}