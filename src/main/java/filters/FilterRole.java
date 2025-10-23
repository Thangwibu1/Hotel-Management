package filters;

import model.Guest;
import model.Staff;
import utils.IConstant;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class FilterRole implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("FilterAdmin init");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession();
        String url = request.getRequestURI();
        Staff staff = (Staff) session.getAttribute("userStaff");
        if (staff != null && !url.contains("logout")) {
            String role = staff.getRole().toLowerCase();
            if (!url.contains(role)) {
                switch (role) {
                    case "admin":
                        response.sendRedirect(IConstant.adminRole);
                        return;
                    case "receptionist":
                        response.sendRedirect(IConstant.receptionistRole);
                        return;
                    case "manager":
                        response.sendRedirect(IConstant.managerRole);
                        return;
                    case "housekeeping":
                        response.sendRedirect(request.getContextPath() + IConstant.housekeeping);
                        return;
                    case "servicestaff":
                        response.sendRedirect(IConstant.serviceRole);
                        return;
                }
            }
        }
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
