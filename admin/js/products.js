$(document).ready(() => {
  let currentSearch = ""

  loadProducts()
  loadCategories()

  $("#searchInput").on("keyup", function () {
    currentSearch = $(this).val()
    loadProducts()
  })

  $("#addProductForm").submit(function (e) {
    e.preventDefault()
    console.log($("#productImage").val());
    
    let formData = new FormData(this);
    console.log(formData);

    $.ajax({
      url: "components/product.cfc?method=addProduct",
      type: "POST",
      data: formData,
      contentType: false,
      processData: false,
      dataType: "json",
      success: (response) => {
        if (response.success) {
          $("#addProductModal").modal("hide")
          $("#addProductForm")[0].reset()
          loadProducts()
          showAlert("success", response.message)
        } else {
          showAlert("danger", response.message)
        }
      },
      error: (xhr, status, error) => {
        console.error("Error adding product:", error)
        showAlert("danger", "Error adding product. Please try again.")
      },
    })
  })

  $("#editProductForm").submit(function (e) {
    e.preventDefault()

    $.ajax({
      url: "components/product.cfc?method=updateProduct",
      type: "POST",
      data: $(this).serialize(),
      dataType: "json",
      success: (response) => {
        if (response.success) {
          $("#editProductModal").modal("hide")
          loadProducts()
          showAlert("success", response.message)
        } else {
          showAlert("danger", response.message)
        }
      },
      error: (xhr, status, error) => {
        console.error("Error updating product:", error)
        showAlert("danger", "Error updating product. Please try again.")
      },
    })
  })

  function loadCategories() {
    $.ajax({
      url: "components/product.cfc?method=getCategories",
      type: "GET",
      dataType: "json",
      success: (response) => {
        if (response.success) {
          var options = '<option value="">Select Category</option>'
          $.each(response.data, (index, category) => {
            options += '<option value="' + category.id + '">' + category.name + "</option>"
          })
          $("#addCategorySelect, #editCategorySelect").html(options)
        } else {
          console.error("Error loading categories:", response.message)
        }
      },
      error: (xhr, status, error) => {
        console.error("Error loading categories:", error)
      },
    })
  }

  function loadProducts() {
    $("#productsTableBody").html(
      '<tr><td colspan="7" class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div> Loading products...</td></tr>',
    )

    $.ajax({
      url: "components/product.cfc?method=getProducts",
      type: "GET",
      data: {
        search: currentSearch,
      },
      dataType: "json",
      success: (response) => {
        if (response.success) {
          displayProducts(response.data)
        } else {
          showAlert("danger", "Error loading products: " + response.message)
          $("#productsTableBody").html(
            '<tr><td colspan="7" class="text-center text-danger">Error loading products</td></tr>',
          )
        }
      },
      error: (xhr, status, error) => {
        console.error("Error loading products:", error)
        showAlert("danger", "Error loading products. Please check your database connection.")
        $("#productsTableBody").html(
          '<tr><td colspan="7" class="text-center text-danger">Error loading products</td></tr>',
        )
      },
    })
  }

  function displayProducts(products) {
    var tbody = $("#productsTableBody")
    tbody.empty()

    if (products.length === 0) {
      tbody.append('<tr><td colspan="7" class="text-center">No products found</td></tr>')
      return
    }

    $.each(products, (index, product) => {
      var statusBadge =
        product.status == 1
          ? '<span class="badge bg-success">Active</span>'
          : '<span class="badge bg-danger">Inactive</span>'

      var imageHtml = product.image
        ? '<img src="../' +
          product.image +
          '" alt="' +
          product.name +
          '" class="product-image" style="width:50px;height:50px;object-fit:cover;" onerror="this.src=\'https://via.placeholder.com/50\';">'
        : '<div class="product-image bg-light d-flex align-items-center justify-content-center" style="width:50px;height:50px;"><i class="fas fa-image text-muted"></i></div>'

      var row =
        "<tr>" +
        "<td>" +
        product.id +
        "</td>" +
        "<td>" +
        imageHtml +
        "</td>" +
        "<td>" +
        product.name +
        "</td>" +
        "<td>" +
        product.category_name +
        "</td>" +
        "<td>$" +
        Number.parseFloat(product.price).toFixed(2) +
        "</td>" +
        "<td>" +
        statusBadge +
        "</td>" +
        "<td>" +
        '<button class="btn btn-sm btn-primary me-1" onclick="editProduct(' +
        product.id +
        ')" title="Edit Product"><i class="fas fa-edit"></i></button>' +
        '<button class="btn btn-sm btn-danger" onclick="deleteProduct(' +
        product.id +
        ')" title="Delete Product"><i class="fas fa-trash"></i></button>' +
        "</td>" +
        "</tr>"

      tbody.append(row)
    })
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

  window.editProduct = (productId) => {
    $.ajax({
      url: "components/product.cfc?method=getProduct",
      type: "GET",
      data: { productId: productId },
      dataType: "json",
      success: (response) => {
        if (response.success) {
          var product = response.data
          $("#editProductId").val(product.id)
          $("#editProductName").val(product.name)
          $("#editCategorySelect").val(product.category_id)
          $("#editPrice").val(product.price)
          $("#editDescription").val(product.description)
          $("#editStatus").val(product.status)
          $("#editProductImage").val("")

          if (product.image) {
            $("#currentImage")
              .attr("src", "../" + product.image)
              .show()
            $("#currentImageDiv").show()
          } else {
            $("#currentImage").hide()
            $("#currentImageDiv").hide()
          }

          $("#editProductModal").modal("show")
        } else {
          showAlert("danger", response.message)
        }
      },
      error: (xhr, status, error) => {
        console.error("Error loading product details:", error)
        showAlert("danger", "Error loading product details")
      },
    })
  }

  window.deleteProduct = (productId) => {
    if (confirm("Are you sure you want to delete this product? This action cannot be undone.")) {
      $.ajax({
        url: "components/product.cfc?method=deleteProduct",
        type: "POST",
        data: { productId: productId },
        dataType: "json",
        success: (response) => {
          if (response.success) {
            loadProducts()
            showAlert("success", response.message)
          } else {
            showAlert("danger", response.message)
          }
        },
        error: (xhr, status, error) => {
          console.error("Error deleting product:", error)
          showAlert("danger", "Error deleting product")
        },
      })
    }
  }
})
