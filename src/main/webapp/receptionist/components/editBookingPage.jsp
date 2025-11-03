<%-- 
    Document   : editBookingPage
    Created on : Nov 3, 2025, 11:39:43 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>JSP Page</title>
    </head>
    <body>
        <div class="edit-booking container">
            <div class="page-header">
                <div class="title-wrap">
                    <div class="title">Edit Booking</div>
                    <div class="sub-id">ID: 1</div>
                    <span class="status">CONFIRMED</span>
                </div>
                <div class="actions">
                    <button class="btn">Cancel</button>
                    <button class="btn btn-primary">Save Changes</button>
                </div>
            </div>

            <div class="notice">Booking is confirmed. All fields can be edited. Room availability will be re-checked when changing dates or room.</div>

            <div class="grid-2">
                <section class="card">
                    <h3>Guest Information</h3>
                    <div class="field">
                        <label>Full Name</label>
                        <input class="control" value="John Smith"/>
                    </div>
                    <div class="row">
                        <div class="field">
                            <label>Number of Guests</label>
                            <select class="control"><option>2 Guests</option></select>
                        </div>
                        <div class="field">
                            <label>Email Address</label>
                            <input class="control" value="john.smith@email.com"/>
                        </div>
                    </div>
                    <div class="field">
                        <label>Phone Number</label>
                        <input class="control" value="+1 (555) 123-4567"/>
                    </div>
                </section>

                <section class="card">
                    <h3>Stay & Room Information</h3>
                    <div class="row">
                        <div class="field">
                            <label>Check-in Date</label>
                            <input type="date" class="control" value="2024-01-15"/>
                        </div>
                        <div class="field">
                            <label>Check-out Date</label>
                            <input type="date" class="control" value="2024-01-18"/>
                        </div>
                    </div>
                    <div class="field">
                        <label>Total Duration</label>
                        <input class="control" value="3 nights"/>
                    </div>
                    <div class="field">
                        <label>Room</label>
                        <select class="control"><option>Room 102 – Standard Double ($129)</option></select>
                    </div>
                </section>
            </div>

            <div class="grid-2" style="margin-top:16px">
                <section class="card">
                    <h3>Additional Information</h3>
                    <div class="row">
                        <div class="field">
                            <label>Deposit Amount ($)</label>
                            <input class="control" value="0"/>
                        </div>
                        <div class="field">
                            <label>Special Requests</label>
                            <input class="control" placeholder="Late check-in, breakfast…"/>
                        </div>
                    </div>
                    <div class="field">
                        <label>Internal Notes</label>
                        <textarea class="control" placeholder="Staff notes…"></textarea>
                    </div>
                </section>

                <section class="card">
                    <h3>Additional Services (Editable)</h3>
                    <div class="service-line">
                        <input class="control" placeholder="Service name">
                        <input class="control" type="number" placeholder="Qty">
                        <input class="control" type="date">
                        <button class="btn">Remove</button>
                    </div>
                    <div class="service-line">
                        <input class="control" placeholder="Breakfast">
                        <input class="control" type="number" value="1">
                        <input class="control" type="date" value="2024-01-16">
                        <button class="btn">Remove</button>
                    </div>
                    <div class="chip" style="margin-top:10px">+ Add Service</div>
                </section>
            </div>

            <section class="card" style="margin-top:16px">
                <h3>Updated Payment Summary</h3>
                <div class="summary">
                    <div class="sum-row"><span>Room Charges (3 nights × $129)</span><span>$387.00</span></div>
                    <div class="sum-row"><span class="muted">Previous total</span><span class="muted">$387.00</span></div>
                    <div class="sum-row">
                        <span class="sum-total">New Total Amount</span>
                        <span class="sum-total">$387.00</span>
                    </div>
                </div>
            </section>

            <div class="footer-bar">
                <button class="btn">Cancel</button>
                <button class="btn btn-primary">Save Changes</button>
            </div>
        </div>
    </body>
</html>
