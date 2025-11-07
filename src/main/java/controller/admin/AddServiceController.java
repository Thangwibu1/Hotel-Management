package controller.admin;

import dao.ServiceDAO;
import model.Staff;
import utils.IConstant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/AddServiceController")
public class AddServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Staff admin = null;
        if (session != null) {
            admin = (Staff) session.getAttribute("userStaff");
        }
        
        // Redirect to login if not logged in or not an admin
        if (admin == null || !"admin".equalsIgnoreCase(admin.getRole())) {
            resp.sendRedirect("../" + IConstant.loginPage);
            return;
        }

        // Get parameters from request
        String serviceName = req.getParameter("serviceName");
        String serviceType = req.getParameter("serviceType");
        String priceStr = req.getParameter("price");

        try {
            // Validate inputs
            if (serviceName == null || serviceName.trim().isEmpty()) {
                session.setAttribute("error", "Service name is required.");
                resp.sendRedirect("./GetServiceAdminController");
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                session.setAttribute("error", "Price is required.");
                resp.sendRedirect("./GetServiceAdminController");
                return;
            }

            BigDecimal price = new BigDecimal(priceStr);

            // Validate price is not negative
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                session.setAttribute("error", "Price cannot be negative.");
                resp.sendRedirect("./GetServiceAdminController");
                return;
            }

            boolean addSuccess = serviceDAO.addService(serviceName, serviceType, price);

            if (addSuccess) {
                session.setAttribute("success", "Service added successfully.");
            } else {
                session.setAttribute("error", "Failed to add service.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid price format.");
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
        }

        resp.sendRedirect("./GetServiceAdminController");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}

