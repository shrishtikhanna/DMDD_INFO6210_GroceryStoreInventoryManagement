# GroceryStoreInventoryManagement
A database design model for a grocery store inventory.
# Database Purpose
The purpose of this database is to track and monitor the data used by a grocery store to keep its inventory stocked and available for potential customers. This way they will not need to worry about running out of items. Some of the functionalities of the database include managing employees, products and suppliers.The primary users are administrators who are in charge of managing the store and keeping items and shelves stocked.


# Business Problems Addressed
1. Allow store managers to keep a record of all employees including their personal information, the store they work at, their job title, and department.
2. Provide and track the amount of inventory at each store location to prevent running out of product or over-ordering.
3. Track orders and deliveries to hold suppliers accountable for making timely deliveries.
4. Keep a record of all customers to provide marketing with customer contact information and addresses.
5. Maintain sales records generating reports in the case of an audit and for predicting future revenues.


# Business Rules
1. Each employee must work at exactly one store and in exactly one department
2. Each employee and customer (person) must have an address
3. Each sale must be to exactly one customer and performed by exactly one employee
4. Each sale must include at least one product
5. Each product must belong to exactly one category
6. Each store must have inventory of at least one product
7. Each store and supplier must have exactly one address
8. Each order must be delivered in one or more shipments, each of which is received by exactly one employee
9. Each order must be for exactly one store and contain one or more line items

