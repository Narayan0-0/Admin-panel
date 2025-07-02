<cfset pageTitle = "Reports - CarryClub Admin">
<cfset currentPage = "admin">
<cfset currentSection = "reports">

<!--- Check if user is admin --->
<!--- <cfif NOT session.isLoggedIn OR session.user.role NEQ "admin">
    <cflocation url="../index.cfm" addtoken="false">
</cfif> --->

<!--- Include admin header --->
<cfinclude template="includes/admin_header.cfm">

<!--- Include admin navigation --->
<cfinclude template="includes/admin_nav.cfm">

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                <h2 class="page-title">Reports & Analytics</h2>
                <p class="page-subtitle">Business insights and performance metrics</p>
                
                <!-- Date Range Filter -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Date Range</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="form-label">From Date</label>
                                        <input type="date" class="form-control" id="fromDate">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">To Date</label>
                                        <input type="date" class="form-control" id="toDate">
                                    </div>
                                </div>
                                <button class="btn btn-primary mt-3" onclick="generateReports()">Generate Reports</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Quick Reports</h5>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-outline-primary" onclick="loadQuickReport('today')">Today's Sales</button>
                                    <button class="btn btn-outline-primary" onclick="loadQuickReport('week')">This Week</button>
                                    <button class="btn btn-outline-primary" onclick="loadQuickReport('month')">This Month</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Summary Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="stat-content">
                                <h3 id="totalRevenue">$0.00</h3>
                                <p>TOTAL REVENUE</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="stat-content">
                                <h3 id="totalOrdersCount">0</h3>
                                <p>TOTAL ORDERS</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="stat-content">
                                <h3 id="averageOrder">$0.00</h3>
                                <p>AVERAGE ORDER</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <div class="stat-card">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-content">
                                <h3 id="newCustomers">0</h3>
                                <p>NEW CUSTOMERS</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Sales Overview</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="salesChart" height="100"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Order Status</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="orderStatusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Reports Tables -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Top Selling Products</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Sales</th>
                                                <th>Revenue</th>
                                            </tr>
                                        </thead>
                                        <tbody id="topProductsTable">
                                            <!-- Top products will be loaded here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Recent Orders</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody id="recentOrdersTable">
                                            <!-- Recent orders will be loaded here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--- Include admin footer --->
<cfinclude template="includes/admin_footer.cfm">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="js/reports.js"></script>
