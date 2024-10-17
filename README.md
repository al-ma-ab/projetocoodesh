# DBA Challenge 20240802


## Introdução

Nesse desafio trabalharemos utilizando a base de dados da empresa Bike Stores Inc com o objetivo de obter métricas relevantes para equipe de Marketing e Comercial.

Com isso, teremos que trabalhar com várioas consultas utilizando conceitos como `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `GROUP BY` e `COUNT`.

### Antes de começar
 
- O projeto deve utilizar a Linguagem específica na avaliação. Por exempo: SQL, T-SQL, PL/SQL e PSQL;
- Considere como deadline da avaliação a partir do início do teste. Caso tenha sido convidado a realizar o teste e não seja possível concluir dentro deste período, avise a pessoa que o convidou para receber instruções sobre o que fazer.
- Documentar todo o processo de investigação para o desenvolvimento da atividade (README.md no seu repositório); os resultados destas tarefas são tão importantes do que o seu processo de pensamento e decisões à medida que as completa, por isso tente documentar e apresentar os seus hipóteses e decisões na medida do possível.
 
 
## O projeto

- Criar as consultas utilizando a linguagem escolhida;
- Entregar o código gerado do Teste.


## Estrutura do Banco de Dados

### Tabelas e Criação

#### Tabela: `customers`


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


#### Tabela: orders

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

#### Tabela: staffs

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

#### Tabela: stores

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

#### Tabela: order_items

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


#### Tabela: categories

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100)
);


#### Tabela: produtos
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


#### Tabela: stocks
CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

#### Tabela: brands
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100)
);



#### Inserindo os dados

-- Inserir Clientes
INSERT INTO customers (first_name, last_name, phone, email, street, city, state, zip_code) VALUES
('John', 'Doe', '1234567890', 'john.doe@example.com', '123 Main St', 'Anytown', 'CA', '12345'),
('Jane', 'Smith', '0987654321', 'jane.smith@example.com', '456 Side St', 'Othertown', 'NY', '67890');

-- Inserir Lojas
INSERT INTO stores (store_name, phone, email, street, city, state, zip_code) VALUES
('Store 1', '1231231234', 'store1@example.com', '789 Center St', 'Sometown', 'TX', '13579'),
('Store 2', '4564564567', 'store2@example.com', '321 Another St', 'Differtown', 'FL', '24680');

-- Inserir Funcionários
INSERT INTO staffs (first_name, last_name, phone, email, active, store_id, manager_id) VALUES
('Alice', 'Johnson', '1112223333', 'alice.johnson@example.com', TRUE, 1, NULL),
('Bob', 'Williams', '4445556666', 'bob.williams@example.com', TRUE, 2, 1);

-- Inserir Produtos
INSERT INTO products (product_name, brand_id, category_id, model_year, list_price) VALUES
('Product A', 1, 1, 2023, 29.99),
('Product B', 2, 1, 2023, 39.99);

-- Inserir Itens de Pedidos
INSERT INTO order_items (order_id, product_id, quantity, list_price, discount) VALUES
(1, 1, 2, 29.99, 0.00),
(1, 2, 1, 39.99, 5.00);



#### Inserindo os dados


# Listar todos Clientes que não tenham realizado uma compra;
SELECT c.customer_id, c.first_name, c.last_name, c.phone, c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


# Listar os Produtos que não tenham sido comprados
SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, p.list_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;


# Listar os Produtos sem Estoque;
SELECT p.product_id, p.product_name, p.brand_id, p.category_id, p.model_year, p.list_price, s.quantity
FROM products p
JOIN stocks s ON p.product_id = s.product_id
WHERE s.quantity > 0;


# Agrupar a quantidade de vendas que uma determinada Marca por Loja
SELECT
    s.store_id,
    s.store_name,
    p.brand_id,
    b.brand_name,
    SUM(oi.quantity) AS total_sales
FROM
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    stocks st ON p.product_id = st.product_id
JOIN 
    stores s ON st.store_id = s.store_id
JOIN 
    brands b ON p.brand_id = b.brand_id
GROUP BY 
    s.store_id, s.store_name, p.brand_id, b.brand_name
ORDER BY 
    s.store_id, b.brand_name;



# Listar os Funcionarios que não estejam relacionados a um Pedido.
SELECT s.staff_id, s.first_name, s.last_name, s.phone, s.email
FROM staffs s
LEFT JOIN orders o ON s.staff_id = o.staff_id
WHERE o.order_status IS NULL;


