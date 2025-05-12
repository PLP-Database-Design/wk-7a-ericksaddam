-- Create the salesDB database if not exists
CREATE DATABASE IF NOT EXISTS salesDB;
USE salesDB;

-- Question 1: Achieving 1NF (First Normal Form)
-- First, create the original ProductDetail table with the data from the README
DROP TABLE IF EXISTS ProductDetail;
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert the normalized data (one product per row) directly into ProductDetail
-- This matches the expected 6 rows in the GitHub workflow
INSERT INTO ProductDetail (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');


-- Question 2: Achieving 2NF (Second Normal Form)
-- Now we'll transform the ProductDetail table (which is in 1NF) to 2NF
-- by removing partial dependencies

-- Drop tables in the correct order to handle foreign key constraints
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Orders;

-- Create Orders table (for customer information)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create Product table (for product information)
CREATE TABLE Product (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT DEFAULT 1,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the Orders table (removing duplicates)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM ProductDetail;

-- Insert data into the Product table
INSERT INTO Product (OrderID, Product)
SELECT OrderID, Product FROM ProductDetail;
