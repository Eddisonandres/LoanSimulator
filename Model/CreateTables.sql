-- tab_id: stores table names and their corresponding unique IDs.
CREATE table TAB_ID (
    TABLE_NAME VARCHAR2(30)  NOT NULL,  -- Name of the table
    NUMBER_ID NUMBER default 0 NOT NULL,  -- Unique identifier for the table
    CONSTRAINT UN_TAB_ID UNIQUE (TABLE_NAME)  -- Unique constraint on table name
);

-- status_tab: stores various status options for entities (countries, provinces, cities, etc.)
CREATE table STATUS_TAB (
    STATUS_ID CHAR(2) NOT NULL, -- Unique identifier for each status
    STATUS_TYPE VARCHAR2(50) NOT NULL, -- The type of status (e.g., country, province, customer)
    STATUS_NAME VARCHAR2(50) NOT NULL, -- Descriptive name for the status
    CONSTRAINT PK_STATUS_TAB PRIMARY KEY (STATUS_ID) -- Primary key consisting only of STATUS_ID
);

-- trigger to insert a row in the TAB_ID table for every table created 
CREATE OR REPLACE TRIGGER AFTER_TABLE_CREATE
    -- The trigger is set to fire AFTER a CREATE event on the schema
    AFTER CREATE ON SCHEMA
DECLARE
    v_table_name VARCHAR2(100);
BEGIN
    -- Check if the event is related to creating a TABLE
    IF ora_dict_obj_type = 'TABLE' THEN
        -- Get the name of the table that was created from the DDL event
        v_table_name := ora_dict_obj_name;

        -- Insert the table name and a default NUMBER_ID (0) into the TAB_ID table
        INSERT INTO TAB_ID (TABLE_NAME, NUMBER_ID) 
        VALUES (v_table_name, 0);
    end if;
END;

-- countries: stores country information, referencing STATUS_TAB for the country's status.
CREATE table COUNTRIES (
    COUNTRY_ID NUMBER NOT NULL,  -- Unique identifier for each country
    COUNTRY_NAME VARCHAR2(100) NOT NULL,  -- Name of the country
    COUNTRY_STATUS CHAR(2) default 'GA' NOT NULL,  -- The country's status, linked to STATUS_TAB
    CONSTRAINT PK_COUNTRIES PRIMARY KEY (COUNTRY_ID),  -- Primary key for the countries table
    CONSTRAINT UNIQUE_COUNTRY UNIQUE (COUNTRY_NAME), -- Unique country name
    FOREIGN KEY (COUNTRY_STATUS) REFERENCES STATUS_TAB(STATUS_ID)  -- Foreign key referencing STATUS_TAB
);

-- provinces: stores province information, linking with countries and province status.
CREATE table PROVINCES (
    PROVINCE_ID NUMBER NOT NULL,  -- Unique identifier for each province
    PROVINCE_NAME VARCHAR2(100),  -- Name of the province
    COUNTRY_ID NUMBER NOT NULL,  -- Foreign key referencing the country
    PROVINCE_STATUS CHAR(2) DEFAULT 'GA' NOT NULL,  -- The province's status, linked to STATUS_TAB
    CONSTRAINT PK_PROVINCES PRIMARY KEY (PROVINCE_ID),  -- Primary key for the provinces table
    CONSTRAINT UNIQUE_PROVINCE UNIQUE (PROVINCE_NAME), -- Unique province name
    FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID),  -- Foreign key referencing the country
    FOREIGN KEY (PROVINCE_STATUS) REFERENCES STATUS_TAB(STATUS_ID)  -- Foreign key referencing the status from STATUS_TAB
);


-- cities: stores city information, linking with provinces and countries.
CREATE table CITIES (
    CITY_ID NUMBER NOT NULL,  -- Unique identifier for each city
    CITY_NAME VARCHAR2(100) NOT NULL,  -- Name of the city
    PROVINCE_ID NUMBER NOT NULL,  -- Foreign key referencing the province
    CITY_STATUS CHAR(2) DEFAULT 'GA' NOT NULL,  -- The city's status, linked to STATUS_TAB
    CONSTRAINT PK_CITIES PRIMARY KEY (CITY_ID),  -- Primary key for the cities table
    CONSTRAINT UNIQUE_CITY UNIQUE (CITY_NAME), -- Unique city name
    FOREIGN KEY (PROVINCE_ID) REFERENCES PROVINCES(PROVINCE_ID),  -- Foreign key referencing the province
    FOREIGN KEY (CITY_STATUS) REFERENCES STATUS_TAB(STATUS_ID) -- Foreign key referencing the status from STATUS_TAB
);

-- customers: stores customer information, referencing customer status from STATUS_TAB.
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER NOT NULL,  -- Unique identifier for each customer
    CUSTOMER_FIRSTNAME VARCHAR2(100) NOT NULL,  -- Customer's first name
    CUSTOMER_LASTNAME VARCHAR2(100) NOT NULL,  -- Customer's last name
    DATE_OF_BIRTH DATE,  -- Customer's date of birth
    RESIDENCE_CITY_ID NUMBER,  -- Current residence city, references CITIES table
    EMAIL VARCHAR2(150) NOT NULL,  -- Customer's email address
    PHONE_NUMBER VARCHAR2(20),  -- Customer's phone number
    ADDRESS VARCHAR2(250),  -- Customer's home address
    OCCUPATION VARCHAR2(100),  -- Customer's profession or occupation
    INCOME NUMBER(12,2),  -- Customer's monthly income
    MARITAL_STATUS_ID CHAR(2),  -- Customer's marital status (e.g., Single, Married)
    GENDER_ID CHAR(2),  -- Customer's gender (M = Male, F = Female, O = Other)
    DATE_CREATED DATE DEFAULT sysdate NOT NULL,  -- Date the customer record was created
    CUSTOMER_STATUS CHAR(2) DEFAULT 'GA' NOT NULL,  -- Status of the customer, references STATUS_TAB
    CONSTRAINT PK_CUSTOMERS PRIMARY KEY (CUSTOMER_ID),  -- Primary key for the table
    FOREIGN KEY (CUSTOMER_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Links status to STATUS_TAB
    FOREIGN KEY (RESIDENCE_CITY_ID) REFERENCES CITIES(CITY_ID),  -- Links residence city to CITIES table
    FOREIGN KEY (GENDER_ID) REFERENCES STATUS_TAB(STATUS_ID),  -- Links residence city to CITIES table
    FOREIGN KEY (MARITAL_STATUS_ID) REFERENCES STATUS_TAB(STATUS_ID)  -- Links residence city to CITIES table
);

-- products: stores product information, referencing product status from STATUS_TAB.
CREATE table PRODUCTS (
    PRODUCT_ID NUMBER NOT NULL,  -- Unique identifier for each product
    PRODUCT_NAME VARCHAR2(100) NOT NULL,  -- Name of the product
    DATE_CREATED DATE default sysdate NOT NULL,  -- Date the product was created
    PRODUCT_STATUS CHAR(2) DEFAULT 'PA' NOT NULL,  -- The product's status, linked to STATUS_TAB
    CONSTRAINT PK_PRODUCTS PRIMARY KEY (PRODUCT_ID),  -- Primary key for the products table
    FOREIGN KEY (PRODUCT_STATUS) REFERENCES STATUS_TAB(STATUS_ID)  -- Foreign key referencing the status from STATUS_TAB
);

-- payment_frequencies: stores payment frequency information for loans.
CREATE table PAYMENT_FREQUENCIES (
    FREQUENCY_ID NUMBER NOT NULL,  -- Unique identifier for each payment frequency
    FREQUENCY_MONTHS NUMBER NOT NULL, -- Frequency of payment in months
    DESCRIPTION VARCHAR2(20) NOT NULL,  -- Description of the payment frequency (e.g., monthly, yearly)
    FREQUENCY_STATUS CHAR(2) DEFAULT 'GA' NOT NULL, -- The payment frequency's status, linked to STATUS_TAB
    CONSTRAINT PK_PAYMENT_FREQUENCIES PRIMARY KEY (FREQUENCY_ID),  -- Primary key for the payment frequencies table
    FOREIGN KEY (FREQUENCY_STATUS) REFERENCES STATUS_TAB(STATUS_ID)  -- Foreign key referencing the status from STATUS_TAB
);

-- term_months: stores term months to use in the loans
CREATE TABLE TERM_MONTHS (
    TERM_ID NUMBER NOT NULL,  -- Unique identifier for each loan term
    TERM_LENGTH NUMBER NOT NULL,  -- Loan term duration in months
    DESCRIPTION VARCHAR2(50),  -- Optional description (e.g., "Short-term loan", "Long-term loan")
    TERM_STATUS CHAR(2) DEFAULT 'GA' NOT NULL, -- The payment frequency's status, linked to STATUS_TAB
    CONSTRAINT PK_TERM_MONTHS PRIMARY KEY (TERM_ID),  -- Primary key for the term months table
    FOREIGN KEY (TERM_STATUS) REFERENCES STATUS_TAB(STATUS_ID)  -- Foreign key referencing the status from STATUS_TAB
);

-- product_interest_rate: stores the rate per product and term
CREATE TABLE PRODUCT_INTEREST_RATES (
    RATE_ID NUMBER NOT NULL,  -- Unique identifier for the interest rate
    PRODUCT_ID NUMBER(2) NOT NULL,  -- Foreign key referencing the product
    TERM_ID NUMBER NOT NULL,  -- Foreign key referencing the loan term in months
    INTEREST_RATE NUMBER(5,4) NOT NULL,  -- Interest rate percentage (e.g., 7.50 for 7.5%)
    DATE_EFFECTIVE DATE NOT NULL,  -- The date when the interest rate becomes effective
    INTERES_RATE_STATUS CHAR(2) DEFAULT 'GA' NOT NULL, -- The payment frequency's status, linked to STATUS_TAB
    CONSTRAINT PK_PRODUCT_INTEREST_RATES PRIMARY KEY (RATE_ID),  -- Primary key constraint
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),  -- Foreign key linking to PRODUCTS table
    FOREIGN KEY (TERM_ID) REFERENCES TERM_MONTHS(TERM_ID),  -- Foreign key linking to TERM_MONTHS table
    FOREIGN KEY (INTERES_RATE_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Foreign key referencing the status from STATUS_TAB
    CONSTRAINT UN_INTEREST_RATE_ID UNIQUE (PRODUCT_ID, TERM_ID)
);

-- loan_application: stores information about loan applications, referencing customers, products, and payment frequency.
CREATE table LOAN_APPLICATION (
    APPLICATION_ID NUMBER NOT NULL,  -- Unique identifier for each loan application
    CUSTOMER_ID NUMBER NOT NULL,  -- Foreign key referencing the customer
    PRODUCT_ID NUMBER(2) NOT NULL,  -- Foreign key referencing the product
    DATE_CREATED DATE NOT NULL,  -- Date the loan application was created
    LOAN_AMOUNT NUMBER(10,2) NOT NULL,  -- Loan amount requested
    PAYMENT_FREQUENCY_ID NUMBER NOT NULL,  -- Foreign key referencing the payment frequency
    TERM_MONTHS_ID NUMBER NOT NULL,  -- Term length in months for the loan
    RATE_ID NUMBER NOT NULL, -- rate of the loan
    START_DATE DATE NOT NULL,  -- Start date for the loan
    APPLICATION_STATUS CHAR(2) DEFAULT 'LP' NOT NULL,  -- The application status, linked to STATUS_TAB
    OBSERVATIONS VARCHAR2(250),  -- Optional observations about the loan application
    CONSTRAINT PK_LOAN_APPLICATION PRIMARY KEY (APPLICATION_ID),  -- Primary key for the loan application table
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),  -- Foreign key referencing the customer
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),  -- Foreign key referencing the product
    FOREIGN KEY (APPLICATION_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Foreign key referencing the status from STATUS_TAB
    FOREIGN KEY (PAYMENT_FREQUENCY_ID) REFERENCES PAYMENT_FREQUENCIES(FREQUENCY_ID),  -- Foreign key referencing the payment frequency
    FOREIGN KEY (TERM_MONTHS_ID) REFERENCES TERM_MONTHS(TERM_ID),  -- Foreign key referencing the term month
    FOREIGN KEY (RATE_ID) REFERENCES PRODUCT_INTEREST_RATES(RATE_ID)  -- Foreign key referencing the rate
);

-- approved_loans: stores information about approved loans, linked to loan applications, customers, and products.
CREATE table APPROVED_LOANS (
    LOAN_ID VARCHAR(6) NOT NULL,  -- Unique identifier for each approved loan
    APPLICATION_ID NUMBER NOT NULL,  -- Foreign key referencing the loan application
    DATE_CREATED DATE NOT NULL,  -- Date the loan application was created
    CUSTOMER_ID NUMBER NOT NULL,  -- Foreign key referencing the customer
    PRODUCT_ID NUMBER NOT NULL,  -- Foreign key referencing the product
    RATE_ID NUMBER NOT NULL, -- rate of the loan
    TERM_MONTHS_ID NUMBER NOT NULL,  -- Term length in months for the approved loan
    APPROVED_AMOUNT NUMBER(10,2) NOT NULL,  -- The approved loan amount
    START_DATE DATE NOT NULL,  -- Start date for the loan
    END_DATE DATE NOT NULL,  -- End date for the loan
    APPLICATION_STATUS CHAR(2) DEFAULT 'LA' NOT NULL,  -- Status of the loan application, linked to STATUS_TAB
    OBSERVATIONS VARCHAR2(250),  -- Optional observations about the approved loan
    CONSTRAINT PK_APPROVED_LOANS PRIMARY KEY (LOAN_ID),  -- Primary key for the approved loans table
    FOREIGN KEY (APPLICATION_ID) REFERENCES LOAN_APPLICATION(APPLICATION_ID),  -- Foreign key referencing the loan application
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),  -- Foreign key referencing the customer
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),  -- Foreign key referencing the product
    FOREIGN KEY (APPLICATION_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Foreign key referencing the status from STATUS_TAB
    FOREIGN KEY (TERM_MONTHS_ID) REFERENCES TERM_MONTHS(TERM_ID),  -- Foreign key referencing the term month
    FOREIGN KEY (RATE_ID) REFERENCES PRODUCT_INTEREST_RATES(RATE_ID)  -- Foreign key referencing the rate
);

-- amortization_schedule: stores the amortization details for approved loans.
CREATE table AMORTIZATION_SCHEDULE (
    LOAN_ID VARCHAR(6) NOT NULL,  -- Foreign key referencing the approved loan
    NUMBER_INSTALLMENT NUMBER(3) NOT NULL,  -- The installment number
    TOTAL_INSTALLMENT NUMBER(10,2) NOT NULL,  -- Total installment amount
    PRINCIPAL NUMBER(10,2) NOT NULL,  -- Principal portion of the installment
    INTEREST NUMBER(10,2) NOT NULL,  -- Interest portion of the installment
    REMAINING_BALANCE NUMBER(10,2) NOT NULL,  -- Remaining loan balance
    INSTALLMENT_DATE DATE NOT NULL,  -- Date the installment is due
    PRINCIPAL_PAYMENT NUMBER(10,2) DEFAULT 0 NOT NULL,  -- Principal payment for this installment
    INTEREST_PAYMENT NUMBER(10,2) DEFAULT 0 NOT NULL,  -- Interest payment for this installment
    PENALTY_FEE NUMBER(10,2) DEFAULT 0 NOT NULL,  -- Any penalty fees for late payment
    TOTAL_PAYMENT NUMBER(10,2) DEFAULT 0 NOT NULL,  -- Total payment for this installment (including penalties)
    PAYMENT_STATUS CHAR(2) DEFAULT 'SP' NOT NULL,  -- Status of the payment, linked to STATUS_TAB
    CONSTRAINT PK_AMORTIZATION_SCHEDULE PRIMARY KEY (LOAN_ID, NUMBER_INSTALLMENT),  -- Composite primary key for loan ID and installment number
    FOREIGN KEY (LOAN_ID) REFERENCES APPROVED_LOANS(LOAN_ID),  -- Foreign key referencing the approved loan
    FOREIGN KEY (PAYMENT_STATUS) REFERENCES STATUS_TAB(STATUS_ID)
);

-- amortization_schedule: stores the amortization details for approved loans.
CREATE table AMORTIZATION_SCHEDULE_TEMP (
    APPLICATION_ID NUMBER NOT NULL,  -- Foreign key referencing the approved loan
    NUMBER_INSTALLMENT NUMBER(3) NOT NULL,  -- The installment number
    TOTAL_INSTALLMENT NUMBER(10,2) NOT NULL,  -- Total installment amount
    PRINCIPAL NUMBER(10,2) NOT NULL,  -- Principal portion of the installment
    INTEREST NUMBER(10,2) NOT NULL,  -- Interest portion of the installment
    REMAINING_BALANCE NUMBER(10,2) NOT NULL,  -- Remaining loan balance
    INSTALLMENT_DATE DATE NOT NULL,  -- Date the installment is due
    CONSTRAINT PK_AMORTIZATION_SCHEDULE_TEMP PRIMARY KEY (APPLICATION_ID, NUMBER_INSTALLMENT),  -- Composite primary key for loan ID and installment number
    FOREIGN KEY (APPLICATION_ID) REFERENCES LOAN_APPLICATION(APPLICATION_ID)  -- Foreign key referencing the approved loan
);

-- payments: stores information about payments made for approved loans.
CREATE table PAYMENTS (
    PAYMENT_ID NUMBER NOT NULL,  -- Unique identifier for each payment
    LOAN_ID VARCHAR2(6) NOT NULL,  -- Foreign key referencing the approved loan
    PAYMENT_AMOUNT NUMBER(10,2) NOT NULL,  -- Amount paid in this payment
    PAYMENT_DATE DATE NOT NULL,  -- Date the payment was made
    PAYMENT_STATUS CHAR(2) DEFAULT 'GA' NOT NULL,  -- Status of the payment, linked to STATUS_TAB
    OBSERVATIONS VARCHAR2 (250),  -- Optional observations about the payment
    CONSTRAINT PK_PAYMENTS PRIMARY KEY (PAYMENT_ID),  -- Primary key for the payments table
    FOREIGN KEY (PAYMENT_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Foreign key referencing the status from STATUS_TAB
    FOREIGN KEY (LOAN_ID) REFERENCES APPROVED_LOANS(LOAN_ID)  -- Foreign key referencing the approved loan
);

-- payment_details: stores detailed information about each payment made for amortization.
CREATE table PAYMENT_DETAILS (
    PAYMENT_ID NUMBER NOT NULL,  -- Foreign key referencing the payment
    LOAN_ID VARCHAR2(6) NOT NULL,  -- Foreign key referencing the approved loan
    NUMBER_INSTALLMENT NUMBER(3) NOT NULL,  -- Installment number related to the payment
    PAYMENT_AMOUNT NUMBER(10,2) NOT NULL,  -- Amount of the payment
    PAYMENT_DATE DATE NOT NULL,  -- Date the payment was made
    PAYMENT_STATUS CHAR(2) DEFAULT 'GA' NOT NULL,  -- Status of the payment, linked to STATUS_TAB
    OBSERVATIONS VARCHAR2 (250),  -- Optional observations about the payment
    CONSTRAINT PK_PAYMENT_DETAILS PRIMARY KEY (PAYMENT_ID),  -- Primary key for the payment details table
    FOREIGN KEY (PAYMENT_ID) REFERENCES PAYMENTS(PAYMENT_ID),  -- Foreign key referencing the payment
    FOREIGN KEY (PAYMENT_STATUS) REFERENCES STATUS_TAB(STATUS_ID),  -- Foreign key referencing the status from STATUS_TAB
    CONSTRAINT FK_PAYMENT_DETAILS FOREIGN KEY (LOAN_ID, NUMBER_INSTALLMENT)  -- Composite foreign key referencing the amortization schedule
        REFERENCES AMORTIZATION_SCHEDULE(LOAN_ID, NUMBER_INSTALLMENT)
);