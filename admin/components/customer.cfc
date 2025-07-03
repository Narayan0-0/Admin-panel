component {
    
    // Database connection settings
    variables.dsn = application.dsn;
    
    // Get all customers
    remote function getCustomers(string search = "", string role = "") returnformat="json" {
        try {
            var whereClause = "WHERE 1=1";
            
            if (len(trim(arguments.search))) {
                whereClause = whereClause & " AND (name LIKE '%" & arguments.search & "%' OR email LIKE '%" & arguments.search & "%')";
            }
            
            if (len(trim(arguments.role))) {
                whereClause = whereClause & " AND role = '" & arguments.role & "'";
            }
            
            // Get customers
            var customersQuery = queryExecute("
                SELECT id, name, email, role, status, created_date
                FROM users
                " & preserveSingleQuotes(whereClause), 
                {}, 
                {datasource: variables.dsn}
            );
            
            var result = {
                "success" = true,
                "data" = []
            };
            
            for (var row in customersQuery) {
                arrayAppend(result.data, {
                    "id" = row.id,
                    "name" = row.name,
                    "email" = row.email,
                    "role" = row.role,
                    "status" = row.status,
                    "created_date" = dateFormat(row.created_date, "mm/dd/yyyy")
                });
            }
            
            return result;
            
        } catch (any e) {
            return {
                "success" = false,
                "message" = "Error retrieving customers: " & e.message & " " & e.detail,
                "data" = []
            };
        }
    }
    
    // Add new customer
    remote function addCustomer(required string name, required string email, required string password, required string role, required numeric status) returnformat="json" {
        try {
            // Check if email already exists
            var checkEmail = queryExecute("
                SELECT COUNT(*) as emailCount
                FROM users
                WHERE email = :email", 
                {email: {value: arguments.email, cfsqltype: "cf_sql_varchar"}}, 
                {datasource: variables.dsn}
            );
            
            if (checkEmail.emailCount > 0) {
                return {
                    "success" = false,
                    "message" = "Email address already exists"
                };
            }
            
            queryExecute("
                INSERT INTO users (name, email, password, role, status, created_date)
                VALUES (:name, :email, :password, :role, :status, :created_date)", 
                {
                    name: {value: arguments.name, cfsqltype: "cf_sql_varchar"},
                    email: {value: arguments.email, cfsqltype: "cf_sql_varchar"},
                    password: {value: arguments.password, cfsqltype: "cf_sql_varchar"},
                    role: {value: arguments.role, cfsqltype: "cf_sql_varchar"},
                    status: {value: arguments.status, cfsqltype: "cf_sql_integer"},
                    created_date: {value: now(), cfsqltype: "cf_sql_timestamp"}
                }, 
                {datasource: variables.dsn}
            );
            
            return {
                "success" = true,
                "message" = "Customer added successfully"
            };
            
        } catch (any e) {
            return {
                "success" = false,
                "message" = "Error adding customer: " & e.message
            };
        }
    }
    
    // Get customer by ID
    remote function getCustomer(required numeric userId) returnformat="json" {
        try {
            var customerQuery = queryExecute("
                SELECT id, name, email, role, status
                FROM users
                WHERE id = :userId", 
                {userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}}, 
                {datasource: variables.dsn}
            );
            
            if (customerQuery.recordCount) {
                return {
                    "success" = true,
                    "data" = {
                        "id" = customerQuery.id[1],
                        "name" = customerQuery.name[1],
                        "email" = customerQuery.email[1],
                        "role" = customerQuery.role[1],
                        "status" = customerQuery.status[1]
                    }
                };
            } else {
                return {
                    "success" = false,
                    "message" = "Customer not found"
                };
            }
            
        } catch (any e) {
            return {
                "success" = false,
                "message" = "Error retrieving customer: " & e.message
            };
        }
    }
    
    // Update customer
    remote function updateCustomer(required numeric userId, required string name, required string email, string password = "", required string role, required numeric status) returnformat="json" {
        try {
            // Check if email already exists for other users
            var checkEmail = queryExecute("
                SELECT COUNT(*) as emailCount
                FROM users
                WHERE email = :email
                AND id != :userId", 
                {
                    email: {value: arguments.email, cfsqltype: "cf_sql_varchar"},
                    userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}
                }, 
                {datasource: variables.dsn}
            );
            
            if (checkEmail.emailCount > 0) {
                return {
                    "success" = false,
                    "message" = "Email address already exists"
                };
            }
            
            if (len(trim(arguments.password))) {
                queryExecute("
                    UPDATE users 
                    SET name = :name,
                        email = :email,
                        password = :password,
                        role = :role,
                        status = :status
                    WHERE id = :userId", 
                    {
                        name: {value: arguments.name, cfsqltype: "cf_sql_varchar"},
                        email: {value: arguments.email, cfsqltype: "cf_sql_varchar"},
                        password: {value: arguments.password, cfsqltype: "cf_sql_varchar"},
                        role: {value: arguments.role, cfsqltype: "cf_sql_varchar"},
                        status: {value: arguments.status, cfsqltype: "cf_sql_integer"},
                        userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}
                    }, 
                    {datasource: variables.dsn}
                );
            } else {
                queryExecute("
                    UPDATE users 
                    SET name = :name,
                        email = :email,
                        role = :role,
                        status = :status
                    WHERE id = :userId", 
                    {
                        name: {value: arguments.name, cfsqltype: "cf_sql_varchar"},
                        email: {value: arguments.email, cfsqltype: "cf_sql_varchar"},
                        role: {value: arguments.role, cfsqltype: "cf_sql_varchar"},
                        status: {value: arguments.status, cfsqltype: "cf_sql_integer"},
                        userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}
                    }, 
                    {datasource: variables.dsn}
                );
            }
            
            return {
                "success" = true,
                "message" = "Customer updated successfully"
            };
            
        } catch (any e) {
            return {
                "success" = false,
                "message" = "Error updating customer: " & e.message
            };
        }
    }
    
    // Delete customer
    remote function deleteCustomer(required numeric userId) returnformat="json" {
        try {
            // Check if customer has orders
            var checkOrders = queryExecute("
                SELECT COUNT(*) as orderCount
                FROM orders
                WHERE user_id = :userId", 
                {userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}}, 
                {datasource: variables.dsn}
            );
            
            if (checkOrders.orderCount > 0) {
                return {
                    "success" = false,
                    "message" = "Cannot delete customer. They have " & checkOrders.orderCount & " orders associated."
                };
            }
            
            queryExecute("
                DELETE FROM users 
                WHERE id = :userId", 
                {userId: {value: arguments.userId, cfsqltype: "cf_sql_integer"}}, 
                {datasource: variables.dsn}
            );
            
            return {
                "success" = true,
                "message" = "Customer deleted successfully"
            };
            
        } catch (any e) {
            return {
                "success" = false,
                "message" = "Error deleting customer: " & e.message
            };
        }
    }
    
}