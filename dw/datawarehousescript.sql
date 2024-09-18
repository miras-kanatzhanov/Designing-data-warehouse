# We dont have 11th territoryID 
# We change SalesTerritoryKey to TerritoryID so we would have geographical list employees
# Allmost all employees have SalesTerritoryKey of 11, which is out of the spectrum

UPDATE Employee
SET SalesTerritoryKey = 10
WHERE SalesTerritoryKey = 11;

ALTER TABLE Employee 
CHANGE COLUMN SalesTerritoryKey TerritoryID INT;

# Employee with EmployeeBusinessEntityID = 224 has 2 rows. We need to leave only 1 row.
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 224 and StartDate='2004-02-08 00:00:00';
UPDATE salesdeveloperdb.employee
SET
    StartDate = '2004-02-08 00:00:00'
WHERE 
    EmployeeBusinessEntityID = 224;
    
# Employee with EmployeeBusinessEntityID = 234 has 2 rows. We need to leave only 1 row
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 234 and StartDate='2004-03-04 00:00:00';
UPDATE salesdeveloperdb.employee
SET
    StartDate = '2004-03-04 00:00:00'
WHERE 
    EmployeeBusinessEntityID = 224;
    
# Employee with EmployeeBusinessEntityID = 250 has 3 rows. We need to leave only 1 row
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 250 and StartDate='2006-03-28 00:00:00';
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 250 and StartDate='2006-08-31 00:00:00';
    
UPDATE salesdeveloperdb.employee
SET
    StartDate = '2006-03-28 00:00:00'
WHERE 
    EmployeeBusinessEntityID = 250;

# Employee with EmployeeBusinessEntityID = 4 has 2 rows. We need to leave only 1 row
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 4 and StartDate='2003-01-05 00:00:00';

UPDATE salesdeveloperdb.employee
SET
    StartDate = '2003-01-05 00:00:00'
WHERE 
    EmployeeBusinessEntityID = 4;
    
# Employee with EmployeeBusinessEntityID = 16 has 2 rows. We need to leave only 1 row
DELETE FROM `salesdeveloperdb`.employee
WHERE
    EmployeeBusinessEntityID = 16 and StartDate='2003-01-20 00:00:00';

UPDATE salesdeveloperdb.employee
SET
    StartDate = '2003-01-20 00:00:00'
WHERE 
    EmployeeBusinessEntityID = 16;

# Populating dimension_employee table in the datawarehouse
insert into `datawarehouse`.dimension_employee (EmployeeBusinessEntityID, TerritoryID, HireDate, Gender, BaseRate, VacationHours, SickLeaveHours, CurrentFlag, DepartmentName, StartDate, EndDate)
select EmployeeBusinessEntityID, TerritoryID, HireDate, Gender, BaseRate, VacationHours, SickLeaveHours, CurrentFlag, DepartmentName, StartDate, EndDate
from `salesdeveloperdb`.employee;

    
# Merging product and productsubcategory and creating dimension_product
CREATE TABLE dimension_product_temp AS
SELECT ProductCategory.Name as CategoryName, ProductSubcategoryID as ProductSubcategoryID_temp, ProductCategory.ProductCategoryID
FROM productcategory
LEFT JOIN productsubcategory ON productcategory.ProductCategoryID =  productsubcategory.ProductCategoryID ;

CREATE TABLE dimension_product AS
SELECT * FROM dimension_product_temp
LEFT JOIN product ON dimension_product_temp.ProductSubcategoryID_temp = product.ProductSubcategoryID
UNION
SELECT * FROM dimension_product_temp
RIGHT JOIN product ON dimension_product_temp.ProductSubcategoryID_temp = product.ProductSubcategoryID;

# Populating dimension_product  table in the datawarehouse
insert into `datawarehouse`.dimension_product 
select ProductID, StandardCost, ListPrice, SellStartDate, SellEndDate, DiscontinuedDate, ProductCategoryID, CategoryName
from `salesdeveloperdb`.dimension_product;