<%-- 
    Document   : topGuestTab
    Created on : Nov 5, 2025, 12:29:16 AM
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
            <div class="guests-header">
                <svg class="guests-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                <h2 class="guests-title">Top 10 Frequent Guests</h2>
            </div>

            <table class="guests-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Guest Name</th>
                        <th>Email</th>
                        <th style="text-align: center;">Visits</th>
                        <th style="text-align: right;">Total Spent</th>
                        <th style="text-align: center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><span class="rank-badge">1</span></td>
                        <td style="font-weight: 600;">John Smith</td>
                        <td style="color: var(--muted);">john.smith@email.com</td>
                        <td style="text-align: center; font-weight: 600;">24</td>
                        <td style="text-align: right; font-weight: 600;">$48,500</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-vip">VIP</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">2</span></td>
                        <td style="font-weight: 600;">Emma Johnson</td>
                        <td style="color: var(--muted);">emma.j@email.com</td>
                        <td style="text-align: center; font-weight: 600;">21</td>
                        <td style="text-align: right; font-weight: 600;">$42,300</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-vip">VIP</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">3</span></td>
                        <td style="font-weight: 600;">Michael Brown</td>
                        <td style="color: var(--muted);">michael.b@email.com</td>
                        <td style="text-align: center; font-weight: 600;">19</td>
                        <td style="text-align: right; font-weight: 600;">$38,200</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-vip">VIP</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">4</span></td>
                        <td style="font-weight: 600;">Sarah Davis</td>
                        <td style="color: var(--muted);">sarah.davis@email.com</td>
                        <td style="text-align: center; font-weight: 600;">17</td>
                        <td style="text-align: right; font-weight: 600;">$34,800</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-gold">Gold</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">5</span></td>
                        <td style="font-weight: 600;">David Wilson</td>
                        <td style="color: var(--muted);">d.wilson@email.com</td>
                        <td style="text-align: center; font-weight: 600;">15</td>
                        <td style="text-align: right; font-weight: 600;">$31,500</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-gold">Gold</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">6</span></td>
                        <td style="font-weight: 600;">Lisa Anderson</td>
                        <td style="color: var(--muted);">lisa.a@email.com</td>
                        <td style="text-align: center; font-weight: 600;">14</td>
                        <td style="text-align: right; font-weight: 600;">$28,900</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-gold">Gold</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">7</span></td>
                        <td style="font-weight: 600;">Robert Taylor</td>
                        <td style="color: var(--muted);">robert.t@email.com</td>
                        <td style="text-align: center; font-weight: 600;">13</td>
                        <td style="text-align: right; font-weight: 600;">$26,700</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-silver">Silver</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">8</span></td>
                        <td style="font-weight: 600;">Jennifer Lee</td>
                        <td style="color: var(--muted);">jennifer.lee@email.com</td>
                        <td style="text-align: center; font-weight: 600;">12</td>
                        <td style="text-align: right; font-weight: 600;">$24,500</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-silver">Silver</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">9</span></td>
                        <td style="font-weight: 600;">James Martin</td>
                        <td style="color: var(--muted);">j.martin@email.com</td>
                        <td style="text-align: center; font-weight: 600;">11</td>
                        <td style="text-align: right; font-weight: 600;">$22,800</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-silver">Silver</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="rank-badge">10</span></td>
                        <td style="font-weight: 600;">Mary Garcia</td>
                        <td style="color: var(--muted);">mary.garcia@email.com</td>
                        <td style="text-align: center; font-weight: 600;">10</td>
                        <td style="text-align: right; font-weight: 600;">$21,200</td>
                        <td style="text-align: center;">
                            <span class="status-badge status-silver">Silver</span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- Guest Statistics -->
            <div class="guest-stats">
                <div class="stat-card">
                    <div class="stat-label">Average Visits per Guest</div>
                    <div class="stat-value">15.6 visits</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Average Spending per Guest</div>
                    <div class="stat-value">$31,940</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">VIP Guests</div>
                    <div class="stat-value">3 guests (30%)</div>
                </div>
            </div>
        </div>
    </body>
</html>
