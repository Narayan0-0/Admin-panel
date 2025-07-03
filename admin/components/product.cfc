component {

    variables.dsn = application.dsn;

    remote function getProducts(string search = "") returnformat="json" {
        try {
            var whereClause = "";

            if (len(trim(arguments.search))) {
                whereClause = "WHERE p.name LIKE '%#arguments.search#%' OR p.description LIKE '%#arguments.search#%'";
            }

            var productsQuery = queryExecute("
                SELECT p.id, p.name, p.description, p.price, p.image, p.status, p.created_date,
                       c.name as category_name, p.category_id
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                #preserveSingleQuotes(whereClause)#",
                {}, {datasource=variables.dsn});

            var result = {
                "success": true,
                "data": []
            };

            for (var row in productsQuery) {
                arrayAppend(result.data, {
                    "id": row.id,
                    "name": row.name,
                    "description": row.description,
                    "price": row.price,
                    "image": row.image,
                    "status": row.status,
                    "category_name": row.category_name ?: "No Category",
                    "category_id": row.category_id ?: 0,
                    "created_date": dateFormat(row.created_date, "mm/dd/yyyy")
                });
            }

            return result;

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving products: " & e.message & " " & e.detail,
                "data": []
            };
        }
    }

    remote function addProduct(
        string productName,
        numeric categoryId,
        numeric price,
        string description,
        numeric status,
        string productImage = ""
    ) returnformat="json" {
        // writeDump(arguments);abort;
        try {

            // Upload to ./images/ (relative to web root)
            var uploadDir = expandPath("/admin/images");
            var uploadResult = fileUpload(
                uploadDir, 
                "productImage", 
                "image/*", 
                "makeunique"
            );

            // Construct relative path to store in DB (for later retrieval)
            
            // writeDump(imagePath);abort;


            var imagePath = "";
            if (len(trim(arguments.productImage))) {
                var imagePath = "/admin/images/" & uploadResult.serverFile;
            } else {
                imagePath = "images/placeholder.jpg";
            }

            queryExecute("
                INSERT INTO products (name, category_id, price, description, image, status, created_date)
                VALUES (
                    :productName,
                    :categoryId,
                    :price,
                    :description,
                    :imagePath,
                    :status,
                    :createdDate
                )",
                {
                    productName: arguments.productName,
                    categoryId: arguments.categoryId,
                    price: arguments.price,
                    description: arguments.description,
                    imagePath: imagePath,
                    status: arguments.status,
                    createdDate: dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss")
                },
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Product added successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error adding product: " & e.message
            };
        }
    }

    remote function getProduct(numeric productId) returnformat="json" {
        try {
            var productQuery = queryExecute("
                SELECT p.id, p.name, p.description, p.price, p.image, p.status, p.category_id,
                       c.name as category_name
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                WHERE p.id = :productId",
                {productId: arguments.productId},
                {datasource=variables.dsn});

            if (productQuery.recordCount) {
                return {
                    "success": true,
                    "data": {
                        "id": productQuery.id,
                        "name": productQuery.name,
                        "description": productQuery.description,
                        "price": productQuery.price,
                        "image": productQuery.image,
                        "status": productQuery.status,
                        "category_id": productQuery.category_id,
                        "category_name": productQuery.category_name
                    }
                };
            } else {
                return {
                    "success": false,
                    "message": "Product not found"
                };
            }

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving product: " & e.message
            };
        }
    }

    remote function updateProduct(
        numeric productId,
        string productName,
        numeric categoryId,
        numeric price,
        string description,
        numeric status,
        string productImage = ""
    ) returnformat="json" {
        try {
            var queryParams = {
                productName: arguments.productName,
                categoryId: arguments.categoryId,
                price: arguments.price,
                description: arguments.description,
                status: arguments.status,
                productId: arguments.productId
            };

            var updateQuery = "
                UPDATE products 
                SET 
                    name = :productName,
                    category_id = :categoryId,
                    price = :price,
                    description = :description,
                    status = :status";

            if (len(trim(arguments.productImage))) {
                updateQuery &= ", image = :imagePath";
                queryParams.imagePath = "images/" & arguments.productImage;
            }

            updateQuery &= " WHERE id = :productId";

            queryExecute(updateQuery, queryParams, {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Product updated successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error updating product: " & e.message
            };
        }
    }

    remote function deleteProduct(numeric productId) returnformat="json" {
        try {
            queryExecute("
                DELETE FROM products 
                WHERE id = :productId",
                {productId: arguments.productId},
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Product deleted successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error deleting product: " & e.message
            };
        }
    }

    remote function getCategories() returnformat="json" {
        try {
            var categoriesQuery = queryExecute("
                SELECT id, name
                FROM categories
                ORDER BY name",
                {},
                {datasource=variables.dsn});

            var result = {
                "success": true,
                "data": []
            };

            for (var row in categoriesQuery) {
                arrayAppend(result.data, {
                    "id": row.id,
                    "name": row.name
                });
            }

            return result;

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving categories: " & e.message,
                "data": []
            };
        }
    }

    remote function getDashboardStats() returnformat="json" {
        try {
            var productsCount = queryExecute("
                SELECT COUNT(*) as total FROM products WHERE status = 1",
                {},
                {datasource=variables.dsn});

            var categoriesCount = queryExecute("
                SELECT COUNT(*) as total FROM categories WHERE status = 1",
                {},
                {datasource=variables.dsn});

            var ordersCount = queryExecute("
                SELECT COUNT(*) as total FROM orders",
                {},
                {datasource=variables.dsn});

            var usersCount = queryExecute("
                SELECT COUNT(*) as total FROM users WHERE status = 1",
                {},
                {datasource=variables.dsn});

            return {
                "success": true,
                "data": {
                    "products": productsCount.total,
                    "orders": ordersCount.total,
                    "users": usersCount.total,
                    "categories": categoriesCount.total
                }
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving dashboard stats: " & e.message,
                "data": {
                    "products": 0,
                    "orders": 0,
                    "users": 0,
                    "categories": 0
                }
            };
        }
    }
}