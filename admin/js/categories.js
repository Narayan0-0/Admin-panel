$(document).ready(() => {
    let searchTerm = "";

    // Load categories on page load
    loadCategories();

    // Search functionality
    $("#searchInput").on("keyup", function () {
        searchTerm = $(this).val();
        loadCategories();
    });

    // Add category form submission
    $("#addCategoryForm").submit(function (e) {
        e.preventDefault();

        $.ajax({
            url: "components/category.cfc?method=addCategory",
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    $("#addCategoryModal").modal("hide");
                    $("#addCategoryForm")[0].reset();
                    loadCategories();
                    showAlert("success", response.message);
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error adding category:", error);
                showAlert("danger", "Error adding category. Please try again.");
            },
        });
    });

    // Edit category form submission
    $("#editCategoryForm").submit(function (e) {
        e.preventDefault();

        $.ajax({
            url: "components/category.cfc?method=updateCategory",
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    $("#editCategoryModal").modal("hide");
                    loadCategories();
                    showAlert("success", response.message);
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error updating category:", error);
                showAlert("danger", "Error updating category. Please try again.");
            },
        });
    });

    // Load categories function
    function loadCategories() {
        $("#categoriesTableBody").html(
            '<tr><td colspan="5" class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div> Loading categories...</td></tr>'
        );

        $.ajax({
            url: "components/category.cfc?method=getCategories",
            type: "GET",
            data: {
                search: searchTerm,
            },
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    displayCategories(response.data);
                } else {
                    showAlert("danger", "Error loading categories: " + response.message);
                    $("#categoriesTableBody").html(
                        '<tr><td colspan="5" class="text-center text-danger">Error loading categories</td></tr>'
                    );
                }
            },
            error: (xhr, status, error) => {
                console.error("Error loading categories:", error);
                showAlert("danger", "Error loading categories. Please check your database connection.");
                $("#categoriesTableBody").html(
                    '<tr><td colspan="5" class="text-center text-danger">Error loading categories</td></tr>'
                );
            },
        });
    }

    // Display categories in table
    function displayCategories(categories) {
        var tbody = $("#categoriesTableBody");
        tbody.empty();

        if (categories.length === 0) {
            tbody.append('<tr><td colspan="5" class="text-center">No categories found</td></tr>');
            return;
        }

        $.each(categories, (index, category) => {
            var statusBadge =
                category.status == 1
                    ? '<span class="badge bg-success">Active</span>'
                    : '<span class="badge bg-danger">Inactive</span>';

            var row =
                "<tr>" +
                "<td>" +
                category.id +
                "</td>" +
                "<td>" +
                category.name +
                "</td>" +
                "<td>" +
                (category.description || "N/A") +
                "</td>" +
                "<td>" +
                statusBadge +
                "</td>" +
                "<td>" +
                '<button class="btn btn-sm btn-primary me-1" onclick="editCategory(' +
                category.id +
                ')" title="Edit Category"><i class="fas fa-edit"></i></button>' +
                '<button class="btn btn-sm btn-danger" onclick="deleteCategory(' +
                category.id +
                ')" title="Delete Category"><i class="fas fa-trash"></i></button>' +
                "</td>" +
                "</tr>";

            tbody.append(row);
        });
    }

    // Show alert function
    function showAlert(type, message) {
        // Remove existing alerts
        $(".alert").remove();

        var alertHtml =
            '<div class="alert alert-' +
            type +
            ' alert-dismissible fade show" role="alert">' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
            "</div>";

        $(".main-content .container-fluid").prepend(alertHtml);

        // Auto dismiss after 5 seconds
        setTimeout(() => {
            $(".alert").fadeOut(() => {
                $(".alert").remove();
            });
        }, 5000);
    }

    // Make functions globally available
    window.editCategory = (categoryId) => {
        $.ajax({
            url: "components/category.cfc?method=getCategory",
            type: "GET",
            data: { categoryId: categoryId },
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    var category = response.data;
                    $("#editCategoryId").val(category.id);
                    $("#editCategoryName").val(category.name);
                    $("#editDescription").val(category.description);
                    $("#editStatus").val(category.status);
                    $("#editCategoryModal").modal("show");
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error loading category details:", error);
                showAlert("danger", "Error loading category details");
            },
        });
    };

    window.deleteCategory = (categoryId) => {
        if (confirm("Are you sure you want to delete this category?")) {
            $.ajax({
                url: "components/category.cfc?method=deleteCategory",
                type: "POST",
                data: { categoryId: categoryId },
                dataType: "json",
                success: (response) => {
                    if (response.success) {
                        loadCategories();
                        showAlert("success", response.message);
                    } else {
                        showAlert("danger", response.message);
                    }
                },
                error: (xhr, status, error) => {
                    console.error("Error deleting category:", error);
                    showAlert("danger", "Error deleting category");
                },
            });
        }
    };
});
