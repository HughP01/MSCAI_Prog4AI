CREATE database ECommerceDB;
USE EcommerceDB;

CREATE TABLE Users ( 
	user_id INT AUTO_INCREMENT PRIMARY KEY, 
	username VARCHAR(150) UNIQUE NOT NULL,
	password_hash VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL );
    
CREATE TABLE Products ( 
product_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(150) NOT NULL, 
description TEXT, 
price FLOAT, 
stock INT ) ;

CREATE TABLE Orders ( 
order_id INT AUTO_INCREMENT PRIMARY KEY, 
user_id INT, 
total_amount FLOAT, 
order_date DATE, 
FOREIGN KEY (user_id) REFERENCES Users(user_id) ) ;

CREATE TABLE OrderItems ( 
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
 order_id INT, 
 product_id INT, 
 quantity INT, 
 FOREIGN KEY (order_id) REFERENCES Orders(order_id ),
 FOREIGN KEY (product_id) REFERENCES Products(product_id) ) ;
