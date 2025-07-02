<cfset pageTitle = "Admin Dashboard - CarryClub">
<cfset currentPage = "admin">

<!--- Include admin header --->
<cfinclude template="includes/admin_header.cfm">

<!--- Include admin navigation --->
<cfinclude template="includes/admin_nav.cfm">

<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                <h2 class="page-title">Admin Dashboard</h2>
                <p class="page-subtitle">System stats</p>
                
                <!-- Stats Cards -->
                <div class="row">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <a href="products.cfm" style="text-decoration: none;">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                    <i class="fas fa-shopping-bag"></i>
                                </div>
                                <div class="stat-content">
                                        <h3 id="totalProducts">0</h3>
                                        <p>PRODUCTS</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <a href="orders.cfm" style="text-decoration: none;">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                                <div class="stat-content">
                                        <h3 id="totalOrders">0</h3>
                                        <p>ORDERS</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <a href="customers.cfm" style="text-decoration: none">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="stat-content">
                                    <h3 id="totalUsers">0</h3>
                                    <p>ACTIVE USERS</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <div class="col-lg-3 col-md-6 mb-4">
                        <a href="categories.cfm" style="text-decoration: none">
                            <div class="stat-card">
                                <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                                    <i class="fas fa-tags"></i>
                                </div>
                                <div class="stat-content">
                                    <h3 id="totalCategories">0</h3>
                                    <p>CATEGORIES</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!--- Include admin footer --->
<cfinclude template="includes/admin_footer.cfm">

<script>
$(document).ready(function() {
    // Load dashboard stats
    loadDashboardStats();
});

function loadDashboardStats() {
    $.ajax({
        url: 'components/product.cfc?method=getDashboardStats',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.success) {
                $('#totalProducts').text(response.data.products);
                $('#totalOrders').text(response.data.orders);
                $('#totalUsers').text(response.data.users);
                $('#totalCategories').text(response.data.categories);
            }
        },
        error: function() {
            console.log('Error loading dashboard stats');
        }
    });
}
</script>
