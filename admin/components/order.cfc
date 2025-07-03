component {

    // Database connection settings
    variables.dsn = application.dsn;

    // Get all orders
    remote function getOrders(string search = "", string status = "") returnformat="json" {
        try {
            var whereClause = "WHERE 1=1";

            if (len(trim(search))) {
                whereClause &= " AND (o.id LIKE '%#search#%' OR u.name LIKE '%#search#%' OR u.email LIKE '%#search#%')";
            }

            if (len(trim(status))) {
                whereClause &= " AND o.status = '#status#'";
            }

            // Get orders
            var ordersQuery = queryExecute("
                SELECT o.id, o.total_amount, o.status, o.created_date,
                       u.name as customer_name, u.email as customer_email
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                #preserveSingleQuotes(whereClause)#",
                {}, {datasource=variables.dsn});

            var result = {
                "success": true,
                "data": []
            };

            for (var row in ordersQuery) {
                arrayAppend(result.data, {
                    "id": row.id,
                    "customer_name": row.customer_name ?: "Guest",
                    "customer_email": row.customer_email ?: "",
                    "total_amount": row.total_amount,
                    "status": row.status,
                    "created_date": dateFormat(row.created_date, "mm/dd/yyyy")
                });
            }

            return result;

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving orders: " & e.message & " " & e.detail,
                "data": []
            };
        }
    }

    // Get order details
    remote function getOrderDetails(numeric orderId) returnformat="json" {
        try {
            // Get order info
            var orderQuery = queryExecute("
                SELECT o.id, o.total_amount, o.status, o.created_date,
                       u.name as customer_name, u.email as customer_email
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                WHERE o.id = :orderId",
                {orderId: {value: orderId, cfsqltype: "cf_sql_integer"}},
                {datasource=variables.dsn});

            // Get order items
            var itemsQuery = queryExecute("
                SELECT oi.quantity, oi.price,
                       p.name as product_name, p.image as product_image
                FROM order_items oi
                LEFT JOIN products p ON oi.product_id = p.id
                WHERE oi.order_id = :orderId",
                {orderId: {value: orderId, cfsqltype: "cf_sql_integer"}},
                {datasource=variables.dsn});

            if (orderQuery.recordCount) {
                var items = [];
                for (var row in itemsQuery) {
                    arrayAppend(items, {
                        "product_name": row.product_name,
                        "product_image": row.product_image,
                        "quantity": row.quantity,
                        "price": row.price,
                        "total": row.quantity * row.price
                    });
                }

                return {
                    "success": true,
                    "data": {
                        "id": orderQuery.id,
                        "customer_name": orderQuery.customer_name ?: "Guest",
                        "customer_email": orderQuery.customer_email ?: "",
                        "total_amount": orderQuery.total_amount,
                        "status": orderQuery.status,
                        "created_date": dateFormat(orderQuery.created_date, "mm/dd/yyyy hh:nn tt"),
                        "items": items
                    }
                };
            } else {
                return {
                    "success": false,
                    "message": "Order not found"
                };
            }

        } catch (any e) {
            return {
                "success": false,
                "message": "Error retrieving order details: " & e.message
            };
        }
    }

    // Update order status
    remote function updateOrderStatus(numeric orderId, string status) returnformat="json" {
        try {
            queryExecute("
                UPDATE orders 
                SET status = :status
                WHERE id = :orderId",
                {
                    status: {value: status, cfsqltype: "cf_sql_varchar"},
                    orderId: {value: orderId, cfsqltype: "cf_sql_integer"}
                },
                {datasource=variables.dsn});

            return {
                "success": true,
                "message": "Order status updated successfully"
            };

        } catch (any e) {
            return {
                "success": false,
                "message": "Error updating order status: " & e.message
            };
        }
    }
}
