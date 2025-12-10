package controller.receptionist;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.PaymentDAO;
import model.PaymentWithRoomDTO;

/**
 * Controller để hiển thị danh sách payments
 * @author trinhdtu
 */
@WebServlet(urlPatterns = {"/receptionist/ViewPayment"})
public class ViewPaymentController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();

    /**
     * Processes requests for both HTTP GET and POST methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy tham số search từ request
            String searchRoomNumber = request.getParameter("searchRoom");
            ArrayList<PaymentWithRoomDTO> paymentList;
            
            // Nếu có tham số search, tìm theo room number
            if (searchRoomNumber != null && !searchRoomNumber.trim().isEmpty()) {
                paymentList = paymentDAO.searchPaymentsByRoomNumber(searchRoomNumber.trim());
                request.setAttribute("searchRoom", searchRoomNumber.trim());
            } else {
                // Nếu không, lấy tất cả payments
                paymentList = paymentDAO.getAllPaymentsWithRoomInfo();
            }
            
            // Đặt danh sách payments vào request attribute
            request.setAttribute("paymentList", paymentList);
            request.setAttribute("CURRENT_TAB", "payment");
            
            // Forward đến trang JSP
            request.getRequestDispatcher("/receptionist/viewPayment.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while loading payments: " + e.getMessage());
            request.getRequestDispatcher("/receptionist/viewPayment.jsp").forward(request, response);
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
        return "View Payment Controller";
    }
}

