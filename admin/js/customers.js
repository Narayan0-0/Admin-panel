$(document).ready(() => {
    let searchTerm = "";
    let roleFilter = "";

    // Load customers on page load
    loadCustomers();

    // Search functionality
    $("#searchInput").on("keyup", function () {
        searchTerm = $(this).val();
        loadCustomers();
    });

    // Role filter change
    $("#roleFilter").change(function () {
        roleFilter = $(this).val();
        loadCustomers();
    });

    // Add customer form submission
    $("#addCustomerForm").submit(function (e) {
        e.preventDefault();

        $.ajax({
            url: "components/customer.cfc?method=addCustomer",
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    $("#addCustomerModal").modal("hide");
                    $("#addCustomerForm")[0].reset();
                    loadCustomers();
                    showAlert("success", response.message);
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error adding customer:", error);
                showAlert("danger", "Error adding customer. Please try again.");
            },
        });
    });

    // Edit customer form submission
    $("#editCustomerForm").submit(function (e) {
        e.preventDefault();

        $.ajax({
            url: "components/customer.cfc?method=updateCustomer",
            type: "POST",
            data: $(this).serialize(),
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    $("#editCustomerModal").modal("hide");
                    loadCustomers();
                    showAlert("success", response.message);
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error updating customer:", error);
                showAlert("danger", "Error updating customer. Please try again.");
            },
        });
    });

    // Load customers function
    function loadCustomers() {
        $("#customersTableBody").html(
            '<tr><td colspan="7" class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div> Loading customers...</td></tr>',
        );

        $.ajax({
            url: "components/customer.cfc?method=getCustomers",
            type: "GET",
            data: {
                search: searchTerm,
                role: roleFilter,
            },
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    displayCustomers(response.data);
                } else {
                    showAlert("danger", "Error loading customers: " + response.message);
                    $("#customersTableBody").html(
                        '<tr><td colspan="7" class="text-center text-danger">Error loading customers</td></tr>',
                    );
                }
            },
            error: (xhr, status, error) => {
                console.error("Error loading customers:", error);
                showAlert("danger", "Error loading customers. Please check your database connection.");
                $("#customersTableBody").html(
                    '<tr><td colspan="7" class="text-center text-danger">Error loading customers</td></tr>',
                );
            },
        });
    }

    // Display customers in table
    function displayCustomers(customers) {
        var tbody = $("#customersTableBody");
        tbody.empty();

        if (customers.length === 0) {
            tbody.append('<tr><td colspan="7" class="text-center">No customers found</td></tr>');
            return;
        }

        $.each(customers, (index, customer) => {
            var statusBadge =
                customer.status == 1
                    ? '<span class="badge bg-success">Active</span>'
                    : '<span class="badge bg-danger">Inactive</span>';

            var roleBadge =
                customer.role === "admin"
                    ? '<span class="badge bg-danger">Admin</span>'
                    : '<span class="badge bg-primary">Customer</span>';

            var row =
                "<tr>" +
                "<td>" +
                customer.id +
                "</td>" +
                "<td>" +
                customer.name +
                "</td>" +
                "<td>" +
                customer.email +
                "</td>" +
                "<td>" +
                roleBadge +
                "</td>" +
                "<td>" +
                statusBadge +
                "</td>" +
                "<td>" +
                customer.created_date +
                "</td>" +
                "<td>" +
                '<button class="btn btn-sm btn-primary me-1" onclick="editCustomer(' +
                customer.id +
                ')" title="Edit Customer"><i class="fas fa-edit"></i></button>' +
                '<button class="btn btn-sm btn-danger" onclick="deleteCustomer(' +
                customer.id +
                ')" title="Delete Customer"><i class="fas fa-trash"></i></button>' +
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
    window.editCustomer = (userId) => {
        $.ajax({
            url: "components/customer.cfc?method=getCustomer",
            type: "GET",
            data: { userId: userId },
            dataType: "json",
            success: (response) => {
                if (response.success) {
                    var customer = response.data;
                    $("#editUserId").val(customer.id);
                    $("#editName").val(customer.name);
                    $("#editEmail").val(customer.email);
                    $("#editRole").val(customer.role);
                    $("#editStatus").val(customer.status);
                    $("#editCustomerModal").modal("show");
                } else {
                    showAlert("danger", response.message);
                }
            },
            error: (xhr, status, error) => {
                console.error("Error loading customer details:", error);
                showAlert("danger", "Error loading customer details");
            },
        });
    };

    window.deleteCustomer = (userId) => {
        if (confirm("Are you sure you want to delete this customer?")) {
            $.ajax({
                url: "components/customer.cfc?method=deleteCustomer",
                type: "POST",
                data: { userId: userId },
                dataType: "json",
                success: (response) => {
                    if (response.success) {
                        loadCustomers();
                        showAlert("success", response.message);
                    } else {
                        showAlert("danger", response.message);
                    }
                },
                error: (xhr, status, error) => {
                    console.error("Error deleting customer:", error);
                    showAlert("danger", "Error deleting customer");
                },
            });
        }
    };
});
