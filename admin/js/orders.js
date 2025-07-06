$(document).ready(() => {
    let searchTerm = ""
    let statusFilter = ""
  
    loadOrders()
  
    $("#searchInput").on("keyup", function () {
      searchTerm = $(this).val()
      loadOrders()
    })

    $("#statusFilter").change(function () {
      statusFilter = $(this).val()
      loadOrders()
    })
  
    $("#updateStatusForm").submit(function (e) {
      e.preventDefault()
  
      $.ajax({
        url: "components/order.cfc?method=updateOrderStatus",
        type: "POST",
        data: $(this).serialize(),
        dataType: "json",
        success: (response) => {
          if (response.success) {
            $("#updateStatusModal").modal("hide")
            loadOrders()
            showAlert("success", response.message)
          } else {
            showAlert("danger", response.message)
          }
        },
        error: (xhr, status, error) => {
          console.error("Error updating order status:", error)
          showAlert("danger", "Error updating order status. Please try again.")
        },
      })
    })
  
    function loadOrders() {
      $("#ordersTableBody").html(
        '<tr><td colspan="6" class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div> Loading orders...</td></tr>',
      )
  
      $.ajax({
        url: "components/order.cfc?method=getOrders",
        type: "GET",
        data: {
          search: searchTerm,
          status: statusFilter,
        },
        dataType: "json",
        success: (response) => {
          if (response.success) {
            displayOrders(response.data)
            updateTableInfo(response.total)
          } else {
            showAlert("danger", "Error loading orders: " + response.message)
            $("#ordersTableBody").html(
              '<tr><td colspan="6" class="text-center text-danger">Error loading orders</td></tr>',
            )
          }
        },
        error: (xhr, status, error) => {
          console.error("Error loading orders:", error)
          showAlert("danger", "Error loading orders. Please check your database connection.")
          $("#ordersTableBody").html('<tr><td colspan="6" class="text-center text-danger">Error loading orders</td></tr>')
        },
      })
    }
  
    function displayOrders(orders) {
      var tbody = $("#ordersTableBody")
      tbody.empty()
  
      if (orders.length === 0) {
        tbody.append('<tr><td colspan="6" class="text-center">No orders found</td></tr>')
        return
      }
  
      $.each(orders, (index, order) => {
        var statusBadge = getStatusBadge(order.status)
  
        var row =
          "<tr>" +
          "<td>" +
          order.id +
          "</td>" +
          "<td>" +
          order.customer_name +
          "</td>" +
          "<td>$" +
          Number.parseFloat(order.total_amount).toFixed(2) +
          "</td>" +
          "<td>" +
          statusBadge +
          "</td>" +
          "<td>" +
          order.created_date +
          "</td>" +
          "<td>" +
          '<button class="btn btn-sm btn-info me-1" onclick="viewOrderDetails(' +
          order.id +
          ')" title="View Details"><i class="fas fa-eye"></i></button>' +
          '<button class="btn btn-sm btn-primary" onclick="updateOrderStatus(' +
          order.id +
          ", '" +
          order.status +
          '\')" title="Update Status"><i class="fas fa-edit"></i></button>' +
          "</td>" +
          "</tr>"
  
        tbody.append(row)
      })
    }
  
    function getStatusBadge(status) {
      var badgeClass = ""
      switch (status) {
        case "pending":
          badgeClass = "bg-warning"
          break
        case "processing":
          badgeClass = "bg-info"
          break
        case "shipped":
          badgeClass = "bg-primary"
          break
        case "delivered":
          badgeClass = "bg-success"
          break
        case "cancelled":
          badgeClass = "bg-danger"
          break
        default:
          badgeClass = "bg-secondary"
      }
      return '<span class="badge ' + badgeClass + '">' + status.toUpperCase() + "</span>"
    }
  
    function updateTableInfo(total) {
      $("#tableInfo").text("Total entries: " + total)
    }
  
    function showAlert(type, message) {
      $(".alert").remove()
  
      var alertHtml =
        '<div class="alert alert-' +
        type +
        ' alert-dismissible fade show" role="alert">' +
        message +
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
        "</div>"
  
      $(".main-content .container-fluid").prepend(alertHtml)
  
      // Auto dismiss after 5 seconds
      setTimeout(() => {
        $(".alert").fadeOut(() => {
          $(".alert").remove()
        })
      }, 5000)
    }
  
    window.viewOrderDetails = (orderId) => {
      $.ajax({
        url: "components/order.cfc?method=getOrderDetails",
        type: "GET",
        data: { orderId: orderId },
        dataType: "json",
        success: (response) => {
          if (response.success) {
            var order = response.data
            var detailsHtml =
              '<div class="row">' +
              '<div class="col-md-6">' +
              "<h6>Order Information</h6>" +
              "<p><strong>Order ID:</strong> " +
              order.id +
              "</p>" +
              "<p><strong>Customer:</strong> " +
              order.customer_name +
              "</p>" +
              "<p><strong>Email:</strong> " +
              order.customer_email +
              "</p>" +
              "<p><strong>Status:</strong> " +
              order.status.toUpperCase() +
              "</p>" +
              "<p><strong>Order Date:</strong> " +
              order.created_date +
              "</p>" +
              "<p><strong>Total Amount:</strong> $" +
              Number.parseFloat(order.total_amount).toFixed(2) +
              "</p>" +
              "</div>" +
              '<div class="col-md-6">' +
              "<h6>Order Items</h6>" +
              '<div class="table-responsive">' +
              '<table class="table table-sm">' +
              "<thead>" +
              "<tr>" +
              "<th>Product</th>" +
              "<th>Qty</th>" +
              "<th>Price</th>" +
              "<th>Total</th>" +
              "</tr>" +
              "</thead>" +
              "<tbody>"
  
            $.each(order.items, (index, item) => {
              detailsHtml +=
                "<tr>" +
                "<td>" +
                item.product_name +
                "</td>" +
                "<td>" +
                item.quantity +
                "</td>" +
                "<td>$" +
                Number.parseFloat(item.price).toFixed(2) +
                "</td>" +
                "<td>$" +
                Number.parseFloat(item.total).toFixed(2) +
                "</td>" +
                "</tr>"
            })
  
            detailsHtml += "</tbody>" + "</table>" + "</div>" + "</div>" + "</div>"
  
            $("#orderDetailsContent").html(detailsHtml)
            $("#orderDetailsModal").modal("show")
          } else {
            showAlert("danger", response.message)
          }
        },
        error: (xhr, status, error) => {
          console.error("Error loading order details:", error)
          showAlert("danger", "Error loading order details")
        },
      })
    }
  
    window.updateOrderStatus = (orderId, currentStatus) => {
      $("#updateOrderId").val(orderId)
      $("#updateStatus").val(currentStatus)
      $("#updateStatusModal").modal("show")
    }
  })
