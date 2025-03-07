# Loan Management System

This project consists of creating a loan management system based on a relational database model. The system includes various tables and relationships to manage clients, products, approved loans, payments, and amortization details.

## Description

The system manages information related to loans requested by customers, their statuses, products related to loans, payment frequencies, and payments made. The main tables include:

- **TAB_ID**: Stores the names of tables created in the database along with their unique identifiers.
- **STATUS_TAB**: Contains different statuses for entities like countries, provinces, cities, and customers.
- **COUNTRIES**, **PROVINCES**, **CITIES**: Contain information related to countries, provinces, and cities.
- **CUSTOMERS**: Stores information about customers, including personal and contact details.
- **LOAN_APPLICATION**: Stores loan applications made by customers.
- **APPROVED_LOANS**: Contains the loans that have been approved.
- **AMORTIZATION_SCHEDULE**: Stores details about the amortization payments of approved loans.
- **PAYMENTS** and **PAYMENT_DETAILS**: Record payments made for approved loans.

### Relational Model

The relational database model is designed to ensure all tables are properly related through foreign keys, ensuring data integrity.

![Relational Model](./model/Relational_Model.png)

> The image of the relational model shows the created tables and their relationships.

## Files

- **CreateTables.sql**: Contains SQL scripts to create the tables and their relationships in the database, as well as the trigger to log created tables in the `TAB_ID` table.
- **Relational Model**: Image of the relational model that describes the tables and their relationships.

## Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/loan-management.git
