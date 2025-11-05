<%-- 
    Document   : servicesReportTab
    Created on : Nov 5, 2025, 12:28:51 AM
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
            <div class="services-header">
                <h2 class="services-title">Most Used Services</h2>
            </div>

            <table class="services-table">
                <thead>
                    <tr>
                        <th>Service Name</th>
                        <th style="text-align: center;">Requests</th>
                        <th style="text-align: right;">Revenue</th>
                        <th>Satisfaction</th>
                        <th style="text-align: right;">Trend</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="font-weight: 600;">Room Service</td>
                        <td style="text-align: center;">4,520</td>
                        <td style="text-align: right; font-weight: 600;">$226,000</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 94%;"></div>
                                </div>
                                <span class="bar-label">94%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+12.5%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Spa & Wellness</td>
                        <td style="text-align: center;">2,890</td>
                        <td style="text-align: right; font-weight: 600;">$289,000</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 96%;"></div>
                                </div>
                                <span class="bar-label">96%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+18.3%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Restaurant</td>
                        <td style="text-align: center;">3,650</td>
                        <td style="text-align: right; font-weight: 600;">$182,500</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 92%;"></div>
                                </div>
                                <span class="bar-label">92%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+8.7%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Laundry Service</td>
                        <td style="text-align: center;">1,840</td>
                        <td style="text-align: right; font-weight: 600;">$27,600</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 90%;"></div>
                                </div>
                                <span class="bar-label">90%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+5.2%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Car Rental</td>
                        <td style="text-align: center;">980</td>
                        <td style="text-align: right; font-weight: 600;">$49,000</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 88%;"></div>
                                </div>
                                <span class="bar-label">88%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+3.8%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Airport Transfer</td>
                        <td style="text-align: center;">1,250</td>
                        <td style="text-align: right; font-weight: 600;">$37,500</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 95%;"></div>
                                </div>
                                <span class="bar-label">95%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+10.1%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Gym & Fitness</td>
                        <td style="text-align: center;">2,340</td>
                        <td style="text-align: right; font-weight: 600;">Free</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 89%;"></div>
                                </div>
                                <span class="bar-label">89%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+6.4%</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">Concierge Service</td>
                        <td style="text-align: center;">1,680</td>
                        <td style="text-align: right; font-weight: 600;">$8,400</td>
                        <td>
                            <div class="satisfaction-bar">
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 97%;"></div>
                                </div>
                                <span class="bar-label">97%</span>
                            </div>
                        </td>
                        <td style="text-align: right;">
                            <span class="trend-badge">+15.2%</span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Service Statistics -->
            <div class="service-stats">
                <div class="service-stat-card">
                    <div class="service-stat-label">Total Service Requests</div>
                    <div class="service-stat-value">19,150</div>
                </div>
                <div class="service-stat-card">
                    <div class="service-stat-label">Total Service Revenue</div>
                    <div class="service-stat-value">$820,000</div>
                </div>
                <div class="service-stat-card">
                    <div class="service-stat-label">Average Satisfaction</div>
                    <div class="service-stat-value">92.6%</div>
                </div>
                <div class="service-stat-card">
                    <div class="service-stat-label">Most Popular Service</div>
                    <div class="service-stat-value" style="font-size: 18px;">Room Service</div>
                </div>
            </div>
        </div>
    </body>
</html>
