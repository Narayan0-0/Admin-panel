<cfset pageTitle = "Categories Management - CarryClub Admin">
<cfset currentPage = "admin">
<cfset currentSection = "categories">

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
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="page-title">Categories</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        Add Category
                    </button>
                </div>
                
                <!-- Filters -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <label class="me-2">Show</label>
                            <select class="form-select" id="entriesPerPage" style="width: auto;">
                                <option value="10">10</option>
                                <option value="25">25</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select>
                            <span class="ms-2">entries</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-end">
                            <label class="me-2 align-self-center">Search:</label>
                            <input type="text" class="form-control" id="searchInput" style="width: 200px;" placeholder="Search categories...">
                        </div>
                    </div>
                </div>
                
                <!-- Categories Table -->
                <div class="table-responsive">
                    <table class="table table-striped" id="categoriesTable">
                        <thead>
                            <tr>
                                <th>Category Id</th>
                                <th>Category Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="categoriesTableBody">
                            <!-- Categories will be loaded here via AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addCategoryForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Category Name</label>
                        <input type="text" class="form-control" name="categoryName" placeholder="Category" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" rows="3" placeholder="Category description..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" name="status" required>
                            <option value="1">Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Category Modal -->
<div class="modal fade" id="editCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editCategoryForm">
                <input type="hidden" name="categoryId" id="editCategoryId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Category Name</label>
                        <input type="text" class="form-control" name="categoryName" id="editCategoryName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" name="status" id="editStatus" required>
                            <option value="1">Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Edit Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--- Include admin footer --->
<cfinclude template="includes/admin_footer.cfm">

<script src="js/categories.js"></script>
