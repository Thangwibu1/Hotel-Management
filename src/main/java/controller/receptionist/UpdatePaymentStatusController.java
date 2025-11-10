package controller.receptionist;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PaymentDAO;

/**
 * Controller để cập nhật status của payment
 * @author trinhdtu
 */
@WebServlet(urlPatterns = {"/receptionist/UpdatePaymentStatus"})
public class UpdatePaymentStatusController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Processes requests for both HTTP GET and POST methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy paymentId và status mới từ request
            String paymentIdStr = request.getParameter("paymentId");
            String newStatus = request.getParameter("status");
            String searchRoom = request.getParameter("searchRoom");
            
            // Validate input
            if (paymentIdStr == null || paymentIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/receptionist/ViewPayment?error=missing_payment_id");
                return;
            }
            
            if (newStatus == null || newStatus.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/receptionist/ViewPayment?error=missing_status");
                return;
            }
            
            // Validate status value
            if (!newStatus.equals("Completed") && !newStatus.equals("Failed")) {
                response.sendRedirect(request.getContextPath() + "/receptionist/ViewPayment?error=invalid_status");
                return;
            }
            
            int paymentId = Integer.parseInt(paymentIdStr);
            
            // Cập nhật status trong database
            boolean success = paymentDAO.updatePaymentStatus(paymentId, newStatus);
            
            // Redirect về trang ViewPayment với thông báo
            String redirectUrl = request.getContextPath() + "/receptionist/ViewPayment";
            if (searchRoom != null && !searchRoom.trim().isEmpty()) {
                redirectUrl += "?searchRoom=" + searchRoom;
                redirectUrl += success ? "&success=true" : "&error=update_failed";
            } else {
                redirectUrl += success ? "?success=true" : "?error=update_failed";
            }
            
            response.sendRedirect(redirectUrl);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/receptionist/ViewPayment?error=invalid_payment_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/receptionist/ViewPayment?error=system_error");
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

    @Override
    public String getServletInfo() {
        return "Update Payment Status Controller";
    }
}

