/*=================================================
1. Data exploration
	Check the structure of and relations
	between tables and columns.
=================================================*/


-- list of all the tables in the database
select * from INFORMATION_SCHEMA.TABLES;

--list of all the columns in the database
select * from INFORMATION_SCHEMA.COLUMNS;

--selected columns of the above
select 
	TABLE_NAME
	,COLUMN_NAME
	,IS_NULLABLE
	,DATA_TYPE
	,CHARACTER_MAXIMUM_LENGTH
	,case
		when NUMERIC_PRECISION is not null
		then NUMERIC_PRECISION
		when DATETIME_PRECISION is not null
		then DATETIME_PRECISION
	end as DATA_PRECISION
from INFORMATION_SCHEMA.COLUMNS
order by TABLE_NAME;


/*
list of tables relevant to customers, products or both,
together with their columns used as keys.
Use it to generate Entity-Relationship Diagram.
Don't include keys relating to unneeded tables.
-------------------------------------------------------
Customers:

	DimCustomer 
		PK CustomerKey 
		FK GeographyKey

	ProspectiveBuyer 
		PK ProspectiveBuyerKey
-------------------------------------------------------
Products:
	
	DimProduct 
		PK ProductKey 
		FK ProductSubcategoryKey

	DimProductCategory 
		PK ProductCategoryKey

	DimProductSubcategory 
		PK ProductSubcategoryKey 
		FK ProductCategoryKey
-------------------------------------------------------
Both:

	FactInternetSales 
		PK SalesOrderNumber, SalesOrderLineNumber 
		FK ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey, CurrencyKey, SalesTerritoryKey
	
	FactResellerSales 
		PK SalesOrderNumber, SalesOrderLineNumber 
		FK ProductKey, OrderDateKey, DueDateKey, ShipDateKey, ResellerKey, EmployeeKey, PromotionKey, CurrencyKey, SalesTerritoryKey
*/
