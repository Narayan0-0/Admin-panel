<cfset pageTitle = "Products Management - CarryClub Admin">
<cfset currentPage = "admin">
<cfset currentSection = "products">

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
                    <h2 class="page-title">Products Management</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="fas fa-plus"></i> Add Product
                    </button>
                </div>
                
                <!-- Search -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="d-flex justify-content-start">
                            <label class="me-2 align-self-center">Search:</label>
                            <input type="text" class="form-control" id="searchInput" style="width: 300px;" placeholder="Search products...">
                        </div>
                    </div>
                </div>
                
                <!-- Products Table -->
                <div class="table-responsive">
                    <table class="table table-striped" id="productsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Product Name</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="productsTableBody">
                            <tr>
                                <td colspan="7" class="text-center">
                                    <div class="spinner-border" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    Loading products...
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="addProductForm" enctype='multipart/form-data'>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Product Name *</label>
                                <input type="text" class="form-control" name="productName" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Category *</label>
                                <select class="form-select" name="categoryId" id="addCategorySelect" required>
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Price *</label>
                                <input type="number" class="form-control" name="price" step="0.01" min="0" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Status *</label>
                                <select class="form-select" name="status" required>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <textarea class="form-control" name="description" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Product Image</label>
                        <input type="file" class="form-control" id="productImage" name="productImage" placeholder="e.g., product1.jpg">
                        <!--- <input type="text" class="form-control" name="productImage" placeholder="e.g., product1.jpg">
                        <small class="text-muted">Enter image filename (image should be in /images/products/ folder)</small> --->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editProductForm">
                <input type="hidden" name="productId" id="editProductId">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Product Name *</label>
                                <input type="text" class="form-control" name="productName" id="editProductName" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Category *</label>
                                <select class="form-select" name="categoryId" id="editCategorySelect" required>
                                    <option value="">Select Category</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Price *</label>
                                <input type="number" class="form-control" name="price" id="editPrice" step="0.01" min="0" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Status *</label>
                                <select class="form-select" name="status" id="editStatus" required>
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <textarea class="form-control" name="description" id="editDescription" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Product Image</label>
                        <input type="text" class="form-control" name="productImage" id="editProductImage" placeholder="e.g., product1.jpg">
                        <small class="text-muted">Leave empty to keep current image</small>
                    </div>
                    <div class="mb-3" id="currentImageDiv">
                        <label class="form-label">Current Image</label>
                        <div>
                            <img id="currentImage" src="/placeholder.svg" alt="Current Product Image" style="max-width: 100px; max-height: 100px; display: none;">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--- Include admin footer --->
<cfinclude template="includes/admin_footer.cfm">

<script src="js/products.js"></script>
