# Biko Shop CRUD Map and Form Fields

Database: `biko_ordering_inventory`

## 1. CRUD Map Table

The following table shows the CRUD operations and corresponding pages for all 11 database tables.

| Table | Pages | Create | Read | Update | Delete |
|---|---|:---:|:---:|:---:|:---:|
| Customer | Customers | ✓ | ✓ | ✓ | ✓ |
| Employee | Employees | ✓ | ✓ | ✓ | ✓ |
| Category | Categories | ✓ | ✓ | ✓ | ✓ |
| Supplier | Suppliers | ✓ | ✓ | ✓ | ✓ |
| Product | Products | ✓ | ✓ | ✓ | ✓ |
| Order | Orders | ✓ | ✓ | ✓ | ✓ |
| Order_Detail | Inside Orders page, using an Add Item row | ✓ | ✓ | ✓ | ✓ |
| Payment | Payments | ✓ | ✓ | ✓ | ✓ |
| Inventory | Inventory | ✓ | ✓ | ✓ | ✓ |
| Purchase | Purchases | ✓ | ✓ | ✓ | ✓ |
| Purchase_Detail | Inside Purchases page, using an Add Item row | ✓ | ✓ | ✓ | ✓ |

`Order_Detail` and `Purchase_Detail` do not need separate pages. They are managed inside their respective parent pages when adding products to orders or purchases.

## 2. Form Fields for the Two Most Important Tables

The two most important tables selected are Product and Order because they handle product management and customer transactions.

### A. Product Table

| Column Name | Form Control | Required? |
|---|---|---|
| product_id | Auto-generated ID | No |
| category_id | Dropdown | Yes |
| product_name | Text input | Yes |
| description | Textarea | No |
| unit_price | Number input (₱) | Yes |

Purpose: It allows the administrator to add, edit, and manage biko products, categories, descriptions, and prices.

### B. Order Table

| Column Name | Form Control | Required? |
|---|---|---|
| order_id | Auto-generated ID | No |
| customer_id | Customer dropdown | Yes |
| employee_id | Employee dropdown | Yes |
| order_date | Automatic date and time | Automatic |
| order_status | Dropdown | Yes |

Purpose: Allows the administrator to create, view, and manage customer orders.

### Order_Detail Integration

The `Order_Detail` table is managed inside the Orders page through an **Add Item** row.

| Column Name | Form Control | Required? |
|---|---|---|
| product_id | Product dropdown | Yes |
| quantity | Number input | Yes |
| unit_price | Auto-filled number input | Yes |

Purpose: Allows the administrator to add multiple products and specify their quantities and prices within one order.

## 3. Additional Implementation Notes

- Primary keys with `AUTO_INCREMENT` are generated automatically.
- Foreign keys should use dropdowns to select existing records.
- `Order_Detail` is managed inside the Orders page.
- `Purchase_Detail` is managed inside the Purchases page.
- Product quantities and reorder levels are managed through the Inventory page.
- Payment information is recorded through the Payments page.
- Required fields must be validated before submitting a form.
- Prices and payment amounts should use Philippine Peso (₱).

