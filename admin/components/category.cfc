component {

    variables.dsn = application.dsn;

    // Get all categories
    remote function getCategories(string search = "") returnformat="json" {
        try {
            var whereClause = "";

            if (len(trim(arguments.search))) {
                whereClause = "WHERE name LIKE '%#arguments.search#%' OR description LIKE '%#arguments.search#%'";
            }

            // Get categories
            var categoriesQuery = queryExecute("
                SELECT id, name, description, status, created_date
                FROM categories
                #preserveSingleQuotes(whereClause)#",
                {}, {datasource=variables.dsn});

            var result = {
                "success": true,
                "data": []
            };

            for (var row in categoriesQuery) {
                arrayAppend(result.data, {
                    "id": row.id,
                    "name": row.name,
                    "description": row.description,
                    "status": row.status,
                    "created_date": dateFormat(row.created_date, "mm/dd/yyyy")
                });
            }

            return result;

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving categories: " & e.message & " " & e.detail,
                "data": []
            };
        }
    }

    // Add new category
    remote function addCategory(string categoryName, string description = "", numeric status) returnformat="json" {
        try {
            queryExecute("
                INSERT INTO categories (name, description, status, created_date)
                VALUES (
                    :categoryName,
                    :description,
                    :status,
                    :createdDate
                )",
                {
                    categoryName: arguments.categoryName,
                    description: arguments.description,
                    status: arguments.status,
                    createdDate: dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss")
                },
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Category added successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error adding category: " & e.message
            };
        }
    }

    // Get category by ID for updation
    remote function getCategory(numeric categoryId) returnformat="json" {
        try {
            var categoryQuery = queryExecute("
                SELECT id, name, description, status
                FROM categories
                WHERE id = :categoryId",
                {categoryId: arguments.categoryId},
                {datasource=variables.dsn});

            if (categoryQuery.recordCount) {
                return {
                    "success": true,
                    "data": {
                        "id": categoryQuery.id,
                        "name": categoryQuery.name,
                        "description": categoryQuery.description,
                        "status": categoryQuery.status
                    }
                };
            } else {
                return {
                    "success": false,
                    "message": "Category not found"
                };
            }

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving category: " & e.message
            };
        }
    }

    // Update category
    remote function updateCategory(numeric categoryId, string categoryName, string description = "", numeric status) returnformat="json" {
        try {
            queryExecute("
                UPDATE categories 
                SET name = :categoryName,
                    description = :description,
                    status = :status
                WHERE id = :categoryId",
                {
                    categoryName: arguments.categoryName,
                    description: arguments.description,
                    status: arguments.status,
                    categoryId: arguments.categoryId
                },
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Category updated successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error updating category: " & e.message
            };
        }
    }

    // Delete category
    remote function deleteCategory(numeric categoryId) returnformat="json" {
        try {
            // Check if category has products
            var checkProducts = queryExecute("
                SELECT COUNT(*) as productCount
                FROM products
                WHERE category_id = :categoryId",
                {categoryId: arguments.categoryId},
                {datasource=variables.dsn});

            if (checkProducts.productCount > 0) {
                return {
                    "success": false,
                    "message": "Cannot delete category. It has " & checkProducts.productCount & " products associated with it."
                };
            }

            queryExecute("
                DELETE FROM categories 
                WHERE id = :categoryId",
                {categoryId: arguments.categoryId},
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Category deleted successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error deleting category: " & e.message
            };
        }
    }
}
