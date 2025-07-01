component {
    
    variables.dsn = application.dsn;
    
    public struct function getActiveProducts() {
        try {
            var qProducts = queryExecute("
                SELECT p.id, p.name, p.description, p.price, p.image, 
                       c.name as category_name
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                WHERE p.status = 1 AND (c.status = 1 OR c.status IS NULL)
                ORDER BY p.created_date DESC
            ", {}, {datasource: variables.dsn});
            
            var result = {
                success: true,
                data: []
            };
            
            for(var row in qProducts) {
                arrayAppend(result.data, {
                    id: row.id,
                    name: row.name,
                    description: row.description,
                    price: row.price,
                    image: row.image,
                    category_name: row.category_name ?: "Uncategorized"
                });
            }
            
            return result;
            
        } catch(any e) {
            return {
                success: false,
                message: "Error retrieving products: " & e.message,
                data: []
            };
        }
    }
    
    public struct function getActiveCategories() {
        try {
            var qCategories = queryExecute("
                SELECT id, name, description
                FROM categories
                WHERE status = 1
                ORDER BY name
            ", {}, {datasource: variables.dsn});
            
            var result = {
                success: true,
                data: []
            };
            
            for(var row in qCategories) {
                arrayAppend(result.data, {
                    id: row.id,
                    name: row.name,
                    description: row.description
                });
            }
            
            return result;
            
        } catch(any e) {
            return {
                success: false,
                message: "Error retrieving categories: " & e.message,
                data: []
            };
        }
    }
}
