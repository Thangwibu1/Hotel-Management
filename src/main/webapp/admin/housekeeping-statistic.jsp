<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RoomTask" %>
<%@ page import="model.Staff" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Housekeeping Statistics - Luxury Hotel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;600;700&family=Montserrat:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { 
            --gold: #c9ab81;
            --gold-dark: #b8941f;
            --black: #000000;
            --white: #FFFFFF;
            --off-white: #FAFAFA;
            --gray-light: #F5F5F5;
            --gray: #666666;
            --border: #E0E0E0;
            
            --font-serif: 'Cormorant Garamond', serif;
            --font-sans: 'Montserrat', sans-serif;
        }
        
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
        }
        
        body { 
            font-family: var(--font-sans);
            background: var(--off-white);
            color: var(--black);
            line-height: 1.6;
        }
        
        /* === HEADER === */
        .header { 
            background: var(--black);
            border-bottom: 2px solid var(--gold);
            padding: 1.5rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header .container { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        
        .admin-info { 
            font-family: var(--font-serif);
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--white);
            letter-spacing: 0.5px;
        }
        
        .admin-info strong {
            color: var(--gold);
        }
        
        .header-actions { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
        }
        
        .header-actions a { 
            color: var(--white);
            text-decoration: none;
            padding: 0.6rem 1.5rem;
            border: 2px solid var(--gold);
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }
        
        .header-actions a:hover { 
            background: var(--gold);
            color: var(--black);
        }
        
        /* === MAIN CONTENT === */
        .main-container { 
            max-width: 1400px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }
        
        .card { 
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            padding: 2.5rem;
            margin-bottom: 2rem;
        }
        
        .card h2 { 
            font-family: var(--font-serif);
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--black);
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--gold);
            letter-spacing: 1px;
        }
        
        .card h2 i {
            color: var(--gold);
            margin-right: 1rem;
        }
        
        .btn { 
            display: inline-block;
            padding: 0.75rem 2rem;
            border: 2px solid;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-family: var(--font-sans);
            text-decoration: none;
        }
        
        .back-button { 
            background: var(--gray);
            color: var(--white);
            border-color: var(--gray);
            margin-bottom: 2rem;
        }
        
        .back-button:hover { 
            background: #5a6268;
            border-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .back-button i {
            margin-right: 0.5rem;
        }
        
        /* === TABLE === */
        table { 
            width: 100%;
            border-collapse: collapse;
            background: var(--white);
            margin-top: 1rem;
        }
        
        th, td { 
            padding: 1.2rem;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        
        th { 
            background: var(--gray-light);
            font-family: var(--font-sans);
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--black);
        }
        
        td {
            color: var(--gray);
            font-size: 0.95rem;
        }
        
        tr:hover { 
            background: var(--off-white);
        }
        
        /* Task List Styling */
        td ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        td li {
            padding: 0.6rem 1rem;
            margin: 0.4rem 0;
            background: var(--off-white);
            border-left: 3px solid var(--gold);
            border-radius: 4px;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        
        td li:hover {
            background: var(--gray-light);
            transform: translateX(5px);
        }
        
        td li strong {
            color: var(--black);
            font-weight: 600;
        }
        
        /* Status badges */
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: 0.5rem;
        }
        
        .status-clean {
            background: #E8F5E9;
            color: #2E7D32;
        }
        
        .status-dirty {
            background: #FFEBEE;
            color: #C62828;
        }
        
        .status-progress {
            background: #FFF3E0;
            color: #F57C00;
        }
        
        .no-tasks {
            color: var(--gray);
            font-style: italic;
            padding: 0.5rem 0;
        }
        
        /* Staff name highlight */
        .staff-name {
            font-weight: 600;
            color: var(--black);
            font-size: 1rem;
        }
        
        .staff-name i {
            color: var(--gold);
            margin-right: 0.5rem;
        }
        
        /* === ANIMATIONS === */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes slideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        /* === RESPONSIVE === */
        @media (max-width: 768px) {
            .header .container {
                flex-direction: column;
                gap: 1rem;
            }
            
            .header-actions {
                flex-direction: column;
                width: 100%;
            }
            
            .header-actions a {
                width: 100%;
                text-align: center;
            }
            
            .card {
                padding: 1.5rem;
            }
            
            .card h2 {
                font-size: 2rem;
            }
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 0.8rem;
            }
        }
    </style>
</head>
<body>

<%
    Staff admin = (Staff) request.getAttribute("admin");
%>

<div class="header">
    <div class="container">
        <div class="admin-info">
            <% if (admin != null) { %>
                Welcome, <strong><%= admin.getFullName() %></strong> (<%= admin.getRole() %>)
            <% } else { %>
                Welcome, Admin
            <% } %>
        </div>
        <div class="header-actions">
            <a href="<%= request.getContextPath() %>/admin/system"><i class="fas fa-cog"></i> System Config</a>
            <a href="<%= request.getContextPath() %>/admin/housekeeping-statistic"><i class="fas fa-chart-bar"></i> Housekeeping</a>
            <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
</div>

<div class="main-container">
    <div class="card">
        <h2><i class="fas fa-chart-line"></i> Housekeeping Staff Statistics</h2>
        <a href="<%= request.getContextPath() %>/admin/admin" class="back-button btn">
            <i class="fas fa-arrow-left"></i> Back to Admin Page
        </a>
        <%
            HashMap<Integer, ArrayList<RoomTask>> roomTaskByStaff = (HashMap<Integer, ArrayList<RoomTask>>) request.getAttribute("roomTaskByStaff");
            ArrayList<Staff> staffs = (ArrayList<Staff>) request.getAttribute("staffs");
        %>

        <table>
            <thead>
                <tr>
                    <th><i class="fas fa-user"></i> Staff Name</th>
                    <th><i class="fas fa-tasks"></i> Tasks (Room - Status)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (staffs != null && !staffs.isEmpty() && roomTaskByStaff != null) {
                        for (Staff staff : staffs) {
                            ArrayList<RoomTask> tasks = roomTaskByStaff.get(staff.getStaffId());
                %>
                <tr>
                    <td class="staff-name">
                        <i class="fas fa-user-circle"></i> <%= staff.getFullName() %>
                    </td>
                    <td>
                        <% if (tasks != null && !tasks.isEmpty()) { %>
                            <ul>
                                <% for (RoomTask task : tasks) { 
                                    String statusClass = "";
                                    String statusText = task.getStatusClean();
                                    if ("Clean".equalsIgnoreCase(statusText)) {
                                        statusClass = "status-clean";
                                    } else if ("Dirty".equalsIgnoreCase(statusText)) {
                                        statusClass = "status-dirty";
                                    } else {
                                        statusClass = "status-progress";
                                    }
                                %>
                                    <li>
                                        <i class="fas fa-door-open" style="color: var(--gold);"></i>
                                        <strong>Room <%= task.getRoomID() %></strong> 
                                        <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                                    </li>
                                <% } %>
                            </ul>
                        <% } else { %>
                            <span class="no-tasks">
                                <i class="fas fa-info-circle"></i> No tasks assigned.
                            </span>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="2" style="text-align: center; color: var(--gray); font-style: italic; padding: 3rem;">
                        <i class="fas fa-inbox" style="font-size: 3rem; color: var(--gold); display: block; margin-bottom: 1rem;"></i>
                        No housekeeping staff or task data found.
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
