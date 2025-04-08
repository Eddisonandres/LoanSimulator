BEGIN
    -- Insert default statuses for INSERT_STATUS
    INSERT_STATUS('GA', 'GENERAL', 'Active');
    INSERT_STATUS('GI', 'GENERAL', 'Inactive');
    INSERT_STATUS('GS', 'GENERAL', 'Suspended');

    INSERT_STATUS('PA', 'PRODUCT', 'Available');
    INSERT_STATUS('PD', 'PRODUCT', 'Discontinued');

    INSERT_STATUS('LP', 'LOAN', 'Pending Approval');
    INSERT_STATUS('LA', 'LOAN', 'Approved');
    INSERT_STATUS('LR', 'LOAN', 'Rejected');
    INSERT_STATUS('LC', 'LOAN', 'Closed'); 

    INSERT_STATUS('MA', 'Matrial status', 'Married');
    INSERT_STATUS('MS', 'Matrial status', 'Single');
    INSERT_STATUS('MW', 'Matrial status', 'Widowed');
    INSERT_STATUS('MD', 'Matrial status', 'Divorced');
    INSERT_STATUS('ME', 'Matrial status', 'Separated');

    INSERT_STATUS('GM', 'GENDER', 'MALE');
    INSERT_STATUS('GF', 'GENDER', 'FEMALE');
    INSERT_STATUS('GO', 'GENDER', 'OTHER');

    INSERT_STATUS ('SP', 'SCHEDULE', 'Pending');
    INSERT_STATUS ('SA', 'SCHEDULE', 'Paid');
    INSERT_STATUS ('SR', 'SCHEDULE', 'Partially Paid');

    -- Countries
    INSERT_COUNTRY('CANADA');

    -- Provinces
    INSERT_PROVINCE('Alberta', 1);
    INSERT_PROVINCE('British Columbia', 1);
    INSERT_PROVINCE('Manitoba', 1);
    INSERT_PROVINCE('New Brunswick', 1);
    INSERT_PROVINCE('Newfoundland and Labrador', 1);
    INSERT_PROVINCE('Northwest Territories', 1);
    INSERT_PROVINCE('Nova Scotia', 1);
    INSERT_PROVINCE('Nunavut', 1);
    INSERT_PROVINCE('Ontario', 1);
    INSERT_PROVINCE('Prince Edward Island', 1);
    INSERT_PROVINCE('Quebec', 1);
    INSERT_PROVINCE('Saskatchewan', 1);
    INSERT_PROVINCE('Yukon', 1);
    
    -- Cities
    INSERT_CITY('Toronto', 10);
    INSERT_CITY('Ottawa', 10);
    INSERT_CITY('Mississauga', 10);
    INSERT_CITY('Brampton', 10);
    INSERT_CITY('Hamilton', 10);
    INSERT_CITY('London', 10);
    INSERT_CITY('Markham', 10);
    INSERT_CITY('Vaughan', 10);
    INSERT_CITY('Kitchener', 10);
    INSERT_CITY('Windsor', 10);
    INSERT_CITY('Richmond Hill', 10);
    INSERT_CITY('Burlington', 10);
    INSERT_CITY('Greater Sudbury', 10);
    INSERT_CITY('Oshawa', 10);
    INSERT_CITY('Barrie', 10);
    INSERT_CITY('St. Catharines', 10);
    INSERT_CITY('Cambridge', 10);
    INSERT_CITY('Guelph', 10);
    INSERT_CITY('Kingston', 10);
    INSERT_CITY('Thunder Bay', 10);

    -- Customers
    INSERT_CUSTOMER('andres', 'perez', '12-09-1984', 1, 'andres@gmail.com','123456789', '90 Wilson drive', 'Professor', 100000, 'MA', 'GM');
    INSERT_CUSTOMER('John', 'Smith', '15-07-1990', 1, 'john.smith@email.com', '9876543210', '123 Main St', 'Engineer', 85000, 'MA', 'GM');
    
    INSERT_CUSTOMER('Emily', 'Johnson', '22-11-1985', 3, 'emily.johnson@email.com', '4561237890', '45 King St', 'Doctor', 120000, 'MS', 'GF');
    INSERT_CUSTOMER('Michael', 'Brown', '08-03-1978', 5, 'michael.brown@email.com', '7894561230', '78 Queen St', 'Teacher', 75000, 'MD', 'GM');
    INSERT_CUSTOMER('Jessica', 'Davis', '30-09-1992', 10, 'jessica.davis@email.com', '3216549870', '12 York Rd', 'Data Analyst', 95000, 'MA', 'GF');
    INSERT_CUSTOMER('Daniel', 'Wilson', '05-06-1980', 1, 'daniel.wilson@email.com', '8529637410', '56 Bayview Ave', 'Software Developer', 110000, 'MS', 'GM');
    INSERT_CUSTOMER('Laura', 'Martinez', '19-04-1995', 4, 'laura.martinez@email.com', '9632587410', '88 Front St', 'Nurse', 70000, 'MD', 'GF');
    INSERT_CUSTOMER('Kevin', 'Anderson', '12-12-1983', 1, 'kevin.anderson@email.com', '1597534680', '23 High Park', 'Accountant', 88000, 'MA', 'GM');
    INSERT_CUSTOMER('Sophia', 'Taylor', '25-08-1991', 1, 'sophia.taylor@email.com', '7539514560', '34 Elm St', 'Marketing Manager', 102000, 'MS', 'GF');
    INSERT_CUSTOMER('David', 'White', '07-01-1987', 6, 'david.white@email.com', '3571598520', '67 Birch St', 'Architect', 97000, 'MD', 'GM');
    INSERT_CUSTOMER('Emma', 'Harris', '14-02-1998', 1, 'emma.harris@email.com', '7418529630', '99 Oak St', 'HR Specialist', 78000, 'MA', 'GF');
    
    -- Products
    INSERT_PRODUCT('Personal Loan');
    INSERT_PRODUCT('Credit Card');
    INSERT_PRODUCT('Mortgage');

    -- Payment frequency
    INSERT_PAYMENT_FREQUENCY(1, 'Monthly');
    INSERT_PAYMENT_FREQUENCY(3, 'Quarterly');
    INSERT_PAYMENT_FREQUENCY(12, 'Yearly');
    -- Term months
    INSERT_TERM_MONTHS(12, 'One-year loan term');
    INSERT_TERM_MONTHS(24, 'Two-year loan term');
    INSERT_TERM_MONTHS(36, 'Three-year loan term');

    -- Rates
    INSERT_PRODUCT_INTEREST_RATE(1, 1, 0.0750, TO_DATE('2025-01-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(2, 1, 0.0750, TO_DATE('2025-01-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(3, 1, 0.0750, TO_DATE('2025-01-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(2, 2, 0.0625, TO_DATE('2025-02-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(2, 3, 0.0625, TO_DATE('2025-02-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(3, 2, 0.0575, TO_DATE('2025-03-01', 'YYYY-MM-DD'));
    INSERT_PRODUCT_INTEREST_RATE(3, 3, 0.0575, TO_DATE('2025-03-01', 'YYYY-MM-DD'));
    
    COMMIT;
END;