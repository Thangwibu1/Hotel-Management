<%-- 
    Document   : guestBill
    Created on : Oct 16, 2025, 9:24:45 PM
    Author     : trinhdtu
--%>

<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!-- Bill Popup Fragment -->
<div id="billPopup" class="bill-overlay" style="display: none;">
    <div class="bill-modal">
        <div class="bill-header">
            <div class="bill-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
                <h2>Guest Bill</h2>
            </div>
            <button class="bill-close" onclick="closeBillPopup()">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <div class="bill-content">
            <div class="hotel-info">
                <h3 id="hotelName">Grand Hotel</h3>
                <p id="hotelAddress">123 Hotel Street, City</p>
                <p id="billNumber">Bill #091693</p>
            </div>

            <div class="bill-divider"></div>

            <div class="bill-items">
                <div class="bill-item">
                    <span id="roomInfo">Room 301 - Standard Single</span>
                    <span id="roomCharge" class="bill-amount">$8010.00</span>
                </div>
                <div class="bill-item">
                    <span>Service charges</span>
                    <span id="serviceCharge" class="bill-amount">$90.00</span>
                </div>
                <div class="bill-item">
                    <span id="taxLabel">Taxes (10%)</span>
                    <span id="taxAmount" class="bill-amount">$810.00</span>
                </div>
            </div>

            <div class="bill-divider"></div>

            <div class="bill-total">
                <span>Total Amount</span>
                <span id="totalAmount" class="bill-total-amount">$8910.00</span>
            </div>

            <div class="payment-methods">
                <button class="payment-btn" id="cardPaymentBtn" onclick="selectPayment('card')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                        <line x1="1" y1="10" x2="23" y2="10"></line>
                    </svg>
                    Card Payment
                </button>
                <button class="payment-btn" id="cashPaymentBtn" onclick="selectPayment('cash')">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="1" x2="12" y2="23"></line>
                        <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                    </svg>
                    Cash Payment
                </button>
            </div>

            <button class="complete-checkout-btn" onclick="completeCheckout()">
                Complete Check-out
            </button>
        </div>
    </div>
</div>