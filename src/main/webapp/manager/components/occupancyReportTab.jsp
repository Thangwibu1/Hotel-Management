<%-- 
    Document   : occupancyReportTab
    Created on : Nov 5, 2025, 12:27:56 AM
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
            <div class="occupancy-header">
                <h2 class="occupancy-title">Monthly Occupancy Rate</h2>
            </div>

            <table class="occupancy-table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>Occupancy Rate</th>
                        <th style="text-align: center;">Rooms Sold</th>
                        <th style="text-align: center;">Total Rooms</th>
                        <th style="text-align: center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="font-weight: 600;">January 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 72%;"></div>
                                </div>
                                <span class="progress-label">72%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,240</td>
                        <td style="text-align: center;">1,722</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-good">Good</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">February 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 68%;"></div>
                                </div>
                                <span class="progress-label">68%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,142</td>
                        <td style="text-align: center;">1,680</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-good">Good</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">March 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 75%;"></div>
                                </div>
                                <span class="progress-label">75%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,294</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-good">Good</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">April 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 82%;"></div>
                                </div>
                                <span class="progress-label">82%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,476</td>
                        <td style="text-align: center;">1,800</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">May 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 79%;"></div>
                                </div>
                                <span class="progress-label">79%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,363</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-good">Good</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">June 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 88%;"></div>
                                </div>
                                <span class="progress-label">88%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,584</td>
                        <td style="text-align: center;">1,800</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">July 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 92%;"></div>
                                </div>
                                <span class="progress-label">92%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,587</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">August 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 90%;"></div>
                                </div>
                                <span class="progress-label">90%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,553</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">September 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 85%;"></div>
                                </div>
                                <span class="progress-label">85%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,530</td>
                        <td style="text-align: center;">1,800</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">October 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 87%;"></div>
                                </div>
                                <span class="progress-label">87%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,501</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">November 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 81%;"></div>
                                </div>
                                <span class="progress-label">81%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,458</td>
                        <td style="text-align: center;">1,800</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-good">Good</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 600;">December 2025</td>
                        <td>
                            <div class="occupancy-progress">
                                <div class="progress-bar-container">
                                    <div class="progress-bar-fill" style="width: 89%;"></div>
                                </div>
                                <span class="progress-label">89%</span>
                            </div>
                        </td>
                        <td style="text-align: center;">1,536</td>
                        <td style="text-align: center;">1,725</td>
                        <td style="text-align: center;">
                            <span class="occupancy-status status-excellent">Excellent</span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Occupancy Statistics -->
            <div class="occupancy-stats">
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Average Occupancy Rate</div>
                    <div class="occupancy-stat-value">82.3%</div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Peak Month</div>
                    <div class="occupancy-stat-value" style="font-size: 18px;">July 2025 (92%)</div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Total Rooms Sold</div>
                    <div class="occupancy-stat-value">17,264</div>
                </div>
                <div class="occupancy-stat-card">
                    <div class="occupancy-stat-label">Available Capacity</div>
                    <div class="occupancy-stat-value">60 rooms</div>
                </div>
            </div>
        </div>
    </body>
</html>
