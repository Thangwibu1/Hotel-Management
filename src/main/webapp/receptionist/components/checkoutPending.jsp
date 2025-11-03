<%-- 
    Document   : checkoutPending
    Created on : Oct 12, 2025, 5:46:00 PM
    Author     : trinhdtu
--%>

<%@page import="utils.IConstant"%>
<%@page import="model.BookingActionRow"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <h3 style="margin-top:0">Pending Check-out</h3>
        <table id="tblCheckins">
            <thead><tr><th>Guest</th><th>Room</th><th>Check-out Date</th><th>Action</th></tr></thead>
            <tbody>

                <%
                    ArrayList<BookingActionRow> bookings = (ArrayList<BookingActionRow>) request.getAttribute("PENDING_CHECKOUT");
                    if (bookings != null && !bookings.isEmpty()) {
                        for (BookingActionRow row : bookings) {
                %>
                
                <tr>
                    <td>
                        <div><%= row.getGuest().getFullName()%></div>
                        <div class="muted" style="font-size:14px"><%= row.getGuest().getEmail()%></div>
                        <div class="muted" style="font-size:14px"><%= row.getGuest().getPhone()%></div>
                    </td>
                    <td>
                        <div><%= row.getRoom().getRoomNumber()%></div>
                        <div class="muted" style="font-size:14px"><%= row.getRoomType().getTypeName()%></div>
                    </td>
                    <td><%= row.getBooking().getCheckOutDate().format(IConstant.dateFormat)%></td>
                    <td>
                        <button class="btn primary btnGenerateBill" 
                                onclick="showBillPopup('<%= row.getBooking().getBookingId()%>')">
                            Generate Bill & Check Out
                        </button>
                    </td>
                </tr>
                <%
                        }
                    }
                %>

            </tbody>
        </table>
        <jsp:include page="../components/guestBill.jsp" />
        
        <script>
            let currentBookingId = null;
            
            function showBillPopup(bookingId) {
                currentBookingId = bookingId;
                // Show popup
                document.getElementById('billPopup').style.display = 'flex';
            }
            
            function closeBillPopup() {
                document.getElementById('billPopup').style.display = 'none';
                currentBookingId = null;
            }
            
            let selectedPaymentMethod = null;
            
            function selectPayment(method) {
                selectedPaymentMethod = method;
                
                // Remove active class from all buttons
                document.getElementById('cardPaymentBtn').classList.remove('active');
                document.getElementById('cashPaymentBtn').classList.remove('active');
                
                // Add active class to selected button
                if (method === 'card') {
                    document.getElementById('cardPaymentBtn').classList.add('active');
                } else if (method === 'cash') {
                    document.getElementById('cashPaymentBtn').classList.add('active');
                }
            }
            
            function completeCheckout() {
                if (currentBookingId) {
                    window.location.href = './checkOutController?bookingId=' + currentBookingId;
                }
            }
        </script>
    </body>
</html>
