<!-- Admin Sidebar -->
<div class="admin-sidebar">
    <div class="sidebar-header">
        <div class="sidebar-brand">
            <i class="fa-solid fa-bag-shopping"></i>
            <span>&nbsp;CarryClub</span>
        </div>
    </div>
    
    <div class="sidebar-menu">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'dashboard' OR NOT isDefined('currentSection'), 'active', '')#" href="index.cfm">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>&nbsp;Dashboard</span>
                </a>
            </li>
            
            <li class="nav-section-header">INTERFACE</li>
            
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'products', 'active', '')#" href="products.cfm">
                    <i class="fas fa-shopping-bag"></i>
                    <span>&nbsp;Products</span>
                </a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'categories', 'active', '')#" href="categories.cfm">
                    <i class="fas fa-tags"></i>
                    <span>&nbsp;Categories</span>
                </a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'orders', 'active', '')#" href="orders.cfm">
                    <i class="fas fa-shopping-cart"></i>
                    <span>&nbsp;Orders</span>
                </a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'customers', 'active', '')#" href="customers.cfm">
                    <i class="fas fa-users"></i>
                    <span>&nbsp;Customers</span>
                </a>
            </li>
            
            <li class="nav-item">
                <a class="nav-link #iif(currentSection EQ 'reports', 'active', '')#" href="reports.cfm">
                    <i class="fas fa-chart-bar"></i>
                    <span>&nbsp;Reports</span>
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- Admin Header -->
<div class="admin-header">
    <div class="header-content">
        <div class="header-left">
            <h1>Admin</h1>
        </div>
        <div class="header-right">
            <div class="user-info">
                <span class="user-name">adminUser</span>
                <div class="user-avatar">
                    <img src="https://www.w3schools.com/howto/img_avatar.png" alt="Admin" style="width: 32px; height: 32px; border-radius: 50%;">
                </div>
                <div class="dropdown">
                    <button class="btn dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#profile">Profile</a></li>
                        <li><a class="dropdown-item" href="#settings">Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="../index.cfm">Back to Site</a></li>
                        <li>
                            <form method="post" action="../index.cfm">
                                <button type="submit" name="action" value="logout" class="dropdown-item">Logout</button>
                            </form>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
