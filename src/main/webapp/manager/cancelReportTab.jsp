<%-- 
    Document   : cancelReportTab
    Created on : Nov 5, 2025, 12:27:00 AM
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
        <div class="card" style="padding: 32px;">
            <div class="cancel-header">
                <h2 class="cancel-title">Monthly Cancellation Statistics</h2>
            </div>

            <table class="cancel-table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th style="text-align: center;">Cancellations</th>
                        <th style="text-align: center;">Total Bookings</th>
                        <th style="text-align: center;">Rate</th>
                        <th>Main Reason</th>
                        <th style="text-align: center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="font-weight: 600;">January 2025</td>
                        <td style="text-align: center;">18</td>
                        <td style="text-align: center;">420</td>
                        <td style="text-align: center; font-weight: 600;">4.3%</td>
                        <td>Weather</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">February 2025</td>
                        <td style="text-align: center;">22</td>
                        <td style="text-align: center;">385</td>
                        <td style="text-align: center; font-weight: 600;">5.7%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-high">High</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">March 2025</td>
                        <td style="text-align: center;">15</td>
                        <td style="text-align: center;">445</td>
                        <td style="text-align: center; font-weight: 600;">3.4%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">April 2025</td>
                        <td style="text-align: center;">12</td>
                        <td style="text-align: center;">485</td>
                        <td style="text-align: center; font-weight: 600;">2.5%</td>
                        <td>Found Better</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-low">Low</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">May 2025</td>
                        <td style="text-align: center;">19</td>
                        <td style="text-align: center;">450</td>
                        <td style="text-align: center; font-weight: 600;">4.2%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">June 2025</td>
                        <td style="text-align: center;">16</td>
                        <td style="text-align: center;">520</td>
                        <td style="text-align: center; font-weight: 600;">3.1%</td>
                        <td>Schedule Change</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">July 2025</td>
                        <td style="text-align: center;">21</td>
                        <td style="text-align: center;">580</td>
                        <td style="text-align: center; font-weight: 600;">3.6%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">August 2025</td>
                        <td style="text-align: center;">24</td>
                        <td style="text-align: center;">560</td>
                        <td style="text-align: center; font-weight: 600;">4.3%</td>
                        <td>Weather</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">September 2025</td>
                        <td style="text-align: center;">20</td>
                        <td style="text-align: center;">495</td>
                        <td style="text-align: center; font-weight: 600;">4%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">October 2025</td>
                        <td style="text-align: center;">17</td>
                        <td style="text-align: center;">510</td>
                        <td style="text-align: center; font-weight: 600;">3.3%</td>
                        <td>Schedule Change</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-moderate">Moderate</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">November 2025</td>
                        <td style="text-align: center;">23</td>
                        <td style="text-align: center;">465</td>
                        <td style="text-align: center; font-weight: 600;">4.9%</td>
                        <td>Personal</td>
                        <td style="text-align: center;">
                            <span class="cancel-status status-high">High</span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Cancellation Reasons Breakdown -->
            <div class="reasons-section">
                <h3 class="reasons-title">Cancellation Reasons Breakdown</h3>

                <table class="reasons-table">
                    <thead>
                        <tr>
                            <th>Reason</th>
                            <th style="text-align: center;">Count</th>
                            <th style="text-align: right;">Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="font-weight: 600;">Personal Issues</td>
                            <td style="text-align: center;">112</td>
                            <td style="text-align: right; font-weight: 600;">47.9%</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Weather Conditions</td>
                            <td style="text-align: center;">43</td>
                            <td style="text-align: right; font-weight: 600;">18.4%</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Schedule Changes</td>
                            <td style="text-align: center;">38</td>
                            <td style="text-align: right; font-weight: 600;">16.2%</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Found Better Deal</td>
                            <td style="text-align: center;">24</td>
                            <td style="text-align: right; font-weight: 600;">10.3%</td>
                        </tr>
                        <tr>
                            <td style="font-weight: 600;">Health Issues</td>
                            <td style="text-align: center;">17</td>
                            <td style="text-align: right; font-weight: 600;">7.3%</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Cancellation Statistics -->
            <div class="cancel-stats">
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Total Cancellations</div>
                    <div class="cancel-stat-value">234</div>
                </div>
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Average Cancellation Rate</div>
                    <div class="cancel-stat-value">4.0%</div>
                </div>
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Lowest Month</div>
                    <div class="cancel-stat-value" style="font-size: 18px;">April (2.5%)</div>
                </div>
                <div class="cancel-stat-card">
                    <div class="cancel-stat-label">Top Reason</div>
                    <div class="cancel-stat-value" style="font-size: 16px;">Personal Issues</div>
                </div>
            </div>
        </div>
    </body>
</html>
