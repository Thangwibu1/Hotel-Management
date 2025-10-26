<%-- 
    Document   : EmployeePerformancePage
    Created on : Oct 26, 2025, 5:46:40 PM
    Author     : TranHongGam
--%>

<%@page import="model.BookingService"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        ArrayList<BookingService> bookingServiceList = (ArrayList<BookingService>)request.getAttribute("LIST_PERFORMANCE_BOOKING_SERVICE");
        if(bookingServiceList == null || bookingServiceList.isEmpty()){ 
            System.out.println("Da vo thanh cong");
        }
        for (BookingService bs : bookingServiceList) {
                System.out.println(bs.toString());
        }
        
        %>
       
        <h1>Hello World! This is employeePerformancePage </h1>
    </body>
</html>
