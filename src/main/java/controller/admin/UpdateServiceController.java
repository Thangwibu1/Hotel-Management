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

@WebServlet("/admin/UpdateServiceController")
public class UpdateServiceController extends HttpServlet {

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
        String serviceIdStr = req.getParameter("serviceId");
        String serviceName = req.getParameter("serviceName");
        String serviceType = req.getParameter("serviceType");
        String priceStr = req.getParameter("price");

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            
            // Check if service ID is 3 (protected service)
            if (serviceId == 3) {
                session.setAttribute("error", "Service ID 3 cannot be modified.");
                resp.sendRedirect("./GetServiceAdminController");
                return;
            }

            BigDecimal price = new BigDecimal(priceStr);

            boolean updateSuccess = serviceDAO.updateService(serviceId, serviceName, serviceType, price);

            if (updateSuccess) {
                session.setAttribute("success", "Service updated successfully.");
            } else {
                session.setAttribute("error", "Failed to update service.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid service ID or price format.");
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

