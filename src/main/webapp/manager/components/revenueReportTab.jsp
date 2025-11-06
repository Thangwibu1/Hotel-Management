<%-- 
    Document   : revenueReportTab
    Created on : Nov 5, 2025, 12:30:11 AM
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
            <div class="report-header">
                <h2 class="report-title">Monthly Revenue</h2>
                <div class="time-filters">
                    <div class="form-group">
                        <label class="form-label required" for="month">Month</label>
                        <select id="adults" class="form-select" required>
                            <option value="1">1 Adult</option>
                            <option value="2" selected>2 Adults</option>
                            <option value="3">3 Adults</option>
                            <option value="4">4 Adults</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="month">Year</label>
                        <select id="adults" class="form-select" required>
                            <option value="1">1 Adult</option>
                            <option value="2" selected>2 Adults</option>
                            <option value="3">3 Adults</option>
                            <option value="4">4 Adults</option>
                        </select>
                    </div>
                </div>
            </div>

            <table class="revenue-table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th style="text-align: right;">Revenue</th>
                        <th style="text-align: right;">Rooms Sold</th>
                        <th style="text-align: right;">Change</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>October 2025</td>
                        <td style="text-align: right; font-weight: 600;">$385,000</td>
                        <td style="text-align: right;">1,250</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +12.5%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>September 2025</td>
                        <td style="text-align: right; font-weight: 600;">$342,000</td>
                        <td style="text-align: right;">1,180</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +8.3%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>August 2025</td>
                        <td style="text-align: right; font-weight: 600;">$415,000</td>
                        <td style="text-align: right;">1,420</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +15.7%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>July 2025</td>
                        <td style="text-align: right; font-weight: 600;">$425,000</td>
                        <td style="text-align: right;">1,480</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +18.2%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>June 2025</td>
                        <td style="text-align: right; font-weight: 600;">$368,000</td>
                        <td style="text-align: right;">1,240</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +9.5%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>May 2025</td>
                        <td style="text-align: right; font-weight: 600;">$352,000</td>
                        <td style="text-align: right;">1,190</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +6.8%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>April 2025</td>
                        <td style="text-align: right; font-weight: 600;">$338,000</td>
                        <td style="text-align: right;">1,150</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +5.2%
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>March 2025</td>
                        <td style="text-align: right; font-weight: 600;">$325,000</td>
                        <td style="text-align: right;">1,120</td>
                        <td style="text-align: right;">
                            <span class="change-badge">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <line x1="12" y1="19" x2="12" y2="5"></line>
                                <polyline points="5 12 12 5 19 12"></polyline>
                                </svg>
                                +3.8%
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Summary Cards -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-label">Average Monthly Revenue</div>
                    <div class="summary-value">$368,750</div>
                </div>
                <div class="summary-card">
                    <div class="summary-label">Best Month</div>
                    <div class="summary-value" style="font-size: 18px;">July 2025 ($425,000)</div>
                </div>
                <div class="summary-card">
                    <div class="summary-label">Total Revenue</div>
                    <div class="summary-value">$2,950,000</div>
                </div>
            </div>
        </div>
    </body>
</html>
