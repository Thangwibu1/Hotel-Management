package filters;

import model.Staff;
import utils.IConstant;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class FilterAdmin implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println( "FilterAdmin init");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession(false);
        String url = request.getRequestURI();
        System.out.println(url);
        Staff admin = (Staff) session.getAttribute("userStaff");
        if (admin == null) {
            response.sendRedirect("../" + IConstant.loginPage);
            return;
        } else if (!"admin".equals(admin.getRole().toLowerCase())) {
            response.sendRedirect("../" + IConstant.loginPage);
            return;
        } else if (!url.contains("/admin/")) {
            System.out.println("DEBUG");
            request.getRequestDispatcher("./admin").forward(request, response);
        }
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
