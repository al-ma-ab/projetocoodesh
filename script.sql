
    CREATE TABLE customers (
        customer_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        phone VARCHAR(15),
        email VARCHAR(100),
        street VARCHAR(150),
        city VARCHAR(100),
        state VARCHAR(50),
        zip_code VARCHAR(10)
    );

    CREATE TABLE orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT,
        order_status VARCHAR(50),
        order_date DATETIME,
        required_date DATETIME,
        shipped_date DATETIME,
        store_id INT,
        staff_id INT,
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
        FOREIGN KEY (store_id) REFERENCES stores(store_id),
        FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
    );

    CREATE TABLE staffs (
        staff_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        phone VARCHAR(15),
        email VARCHAR(100),
        active BOOLEAN,
        store_id INT,
        manager_id INT,
        FOREIGN KEY (store_id) REFERENCES stores(store_id),
        FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
    );

    CREATE TABLE stores (
        store_id INT AUTO_INCREMENT PRIMARY KEY,
        store_name VARCHAR(100),
        phone VARCHAR(15),
        email VARCHAR(100),
        street VARCHAR(150),
        city VARCHAR(100),
        state VARCHAR(50),
        zip_code VARCHAR(10)
    );

    CREATE TABLE order_items (
        order_item_id INT AUTO_INCREMENT PRIMARY KEY,
        order_id INT,
        product_id INT,
        quantity INT,
        list_price DECIMAL(10, 2),
        discount DECIMAL(10, 2),
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
    );

    CREATE TABLE categories (
        category_id INT AUTO_INCREMENT PRIMARY KEY,
        category_name VARCHAR(100)
    );

    CREATE TABLE products (
        product_id INT AUTO_INCREMENT PRIMARY KEY,
        product_name VARCHAR(100),
        brand_id INT,
        category_id INT,
        model_year INT,
        list_price DECIMAL(10, 2),
        FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
    );

    CREATE TABLE stocks (
        store_id INT,
        product_id INT,
        quantity INT,
        PRIMARY KEY (store_id, product_id),
        FOREIGN KEY (store_id) REFERENCES stores(store_id),
        FOREIGN KEY (product_id) REFERENCES products(product_id)
    );

    CREATE TABLE brands (
        brand_id INT AUTO_INCREMENT PRIMARY KEY,
        brand_name VARCHAR(100)
    );

    -- Inserindo dados

    INSERT INTO customers (first_name, last_name, phone, email, street, city, state, zip_code) VALUES
    ('John', 'Doe', '1234567890', 'john.doe@example.com', '123 Main St', 'Anytown', 'CA', '12345'),
    ('Jane', 'Smith', '0987654321', 'jane.smith@example.com', '456 Side St', 'Othertown', 'NY', '67890');

    INSERT INTO stores (store_name, phone, email, street, city, state, zip_code) VALUES
    ('Store 1', '1231231234', 'store1@example.com', '789 Center St', 'Sometown', 'TX', '13579'),
    ('Store 2', '4564564567', 'store2@example.com', '321 Another St', 'Differtown', 'FL', '24680');

    INSERT INTO staffs (first_name, last_name, phone, email, active, store_id, manager_id) VALUES
    ('Alice', 'Johnson', '1112223333', 'alice.johnson@example.com', TRUE, 1, NULL),
    ('Bob', 'Williams', '4445556666', 'bob.williams@example.com', TRUE, 2, 1);

    INSERT INTO products (product_name, brand_id, category_id, model_year, list_price) VALUES
    ('Product A', 1, 1, 2023, 29.99),
    ('Product B', 2, 1, 2023, 39.99);

    INSERT INTO order_items (order_id, product_id, quantity, list_price, discount) VALUES
    (1, 1, 2, 29.99, 0.00),
    (1, 2, 1, 39.99, 5.00);

    -- Consultas

    -- Listar todos os Clientes que não tenham realizado uma compra
    SELECT c.customer_id, c.first_name, c.last_name, c.phone, c.email
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_id IS NULL;

    -- Listar Produtos que não tenham sido comprados
    SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, p.list_price
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    WHERE oi.order_id IS NULL;

    -- Listar Produtos em Estoque
    SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, p.list_price, s.quantity
    FROM products p
    JOIN stocks s ON p.product_id = s.product_id
    WHERE s.quantity > 0;

    -- Agrupar a quantidade de vendas que uma determinada Marca por Loja
    SELECT s.store_id, s.store_name, p.brand_id, b.brand_name, SUM(oi.quantity) AS total_sales
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN stocks st ON p.product_id = st.product_id
    JOIN stores s ON st.store_id = s.store_id
    JOIN brands b ON p.brand_id = b.brand_id
    GROUP BY s.store_id, s.store_name, p.brand_id, b.brand_name
    ORDER BY s.store_id, b.brand_name;

    -- Listar os Funcionários que não estejam relacionados a um Pedido
    SELECT s.staff_id, s.first_name, s.last_name, s.phone, s.email
    FROM staffs s
    LEFT JOIN orders o ON s.staff_id = o.staff_id
    WHERE o.order_status IS NULL;
    