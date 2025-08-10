
/*========================================================
Set of queries aimed at detecting errors in
selected tables. Types of errors looked for:
Nulls - with "is null";
Inconsistent  low cardinalities - with "select distinct";
Negative values - with sign() function;
Incompatible dates - by comparing date values in 2 columns;
Trailing spaces - by comparing length of raw and trimmed 
strings using len() and trim() functions;
Duplicates - with "having count(*) > 1";
----------------------------------------------------------
For tables with many columns INFORMATION_SCHEMA is used
together with string_agg() function and string 
concatenation to create the list of column names.
========================================================*/


/*============================================
			     DimCustomer
============================================*/

--create the list of columns to search through
--and check them for nulls
select
	string_agg(COLUMN_NAME + ' is null', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'DimCustomer'
and IS_NULLABLE = 'YES'

--copy the generated string and use it in query below
--choose columns important for analysis
select
	CustomerKey
	,BirthDate
	,MaritalStatus
	,Gender
	,YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from DimCustomer
where 	
       BirthDate            is null
	or MaritalStatus        is null
	or Gender               is null
	or YearlyIncome         is null
	or TotalChildren        is null
	or NumberChildrenAtHome is null
	or HouseOwnerFlag       is null
	or NumberCarsOwned      is null;

--check for errors in low cardinality columns
select distinct MaritalStatus from DimCustomer;
select distinct Gender from DimCustomer;

--check for negative numbers
select
	YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from DimCustomer
where 	
	   sign(YearlyIncome)         < 0
	or sign(TotalChildren)        < 0
	or sign(NumberChildrenAtHome) < 0
	or sign(HouseOwnerFlag)       < 0
	or sign(NumberCarsOwned)      < 0;

--look for incompatible dates
select
	BirthDate,
	DateFirstPurchase
from DimCustomer
where BirthDate >= DateFirstPurchase;


/*============================================
         	   ProspectiveBuyer
============================================*/

--choose columns important for analysis
--and check for nulls
select
	ProspectiveBuyerKey
	,BirthDate
	,MaritalStatus
	,Gender
	,YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
	,StateProvinceCode
from ProspectiveBuyer
where
	   ProspectiveBuyerKey  is null
	or BirthDate            is null
	or MaritalStatus        is null
	or Gender               is null
	or YearlyIncome         is null
	or TotalChildren        is null
	or NumberChildrenAtHome is null
	or HouseOwnerFlag       is null
	or NumberCarsOwned      is null
	or StateProvinceCode    is null;

--check for errors in low cardinality columns
select distinct MaritalStatus from ProspectiveBuyer;
select distinct Gender from ProspectiveBuyer;
select distinct StateProvinceCode from ProspectiveBuyer
order by StateProvinceCode;

--check for negative numbers
select
	YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from ProspectiveBuyer
where 
	   sign(YearlyIncome)          < 0
	or sign(TotalChildren)         < 0
	or sign(NumberChildrenAtHome)  < 0
	or sign(HouseOwnerFlag)        < 0
	or sign(NumberCarsOwned)       < 0


/*============================================
           		FactInternetSales
============================================*/

--choose columns important for analysis,
--don't include redundant data
select
	ProductKey
	,CustomerKey
	,SalesOrderNumber
	,SalesOrderLineNumber
	,OrderQuantity
	,UnitPrice
	,SalesAmount
from FactInternetSales;
--selected columns are all not nullable


/*============================================
         	  	FactResellerSales
============================================*/

--check for nulls
select 
	ProductKey
	,SalesOrderNumber
	,SalesOrderLineNumber
	,OrderQuantity
	,UnitPrice
	,ExtendedAmount
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
from FactResellerSales
where 
       OrderQuantity        is null 
	or UnitPrice            is null 
	or ExtendedAmount       is null 
	or UnitPriceDiscountPct is null 
	or DiscountAmount       is null 
	or ProductStandardCost  is null 
	or TotalProductCost     is null 
	or SalesAmount          is null;

--check strings for trailing spaces
select
	SalesOrderNumber
from FactResellerSales
where len(SalesOrderNumber) != len(trim(SalesOrderNumber));

--check for negative numbers
--how to check many columns:
--use the resulting string in WHERE clause
select
	string_agg('sign(' + COLUMN_NAME + ')' + ' < 0', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'FactResellerSales'
and NUMERIC_PRECISION is not null   --this filters out non-numbers
and COLUMN_NAME in (                --copied columns from earlier query
	 'ProductKey'
	,'SalesOrderNumber'
	,'SalesOrderLineNumber'
	,'OrderQuantity'
	,'UnitPrice'
	,'ExtendedAmount'
	,'UnitPriceDiscountPct'
	,'DiscountAmount'
	,'ProductStandardCost'
	,'TotalProductCost'
	,'SalesAmount'
);

select 
	ProductKey
	,SalesOrderNumber
	,SalesOrderLineNumber
	,OrderQuantity
	,UnitPrice
	,ExtendedAmount
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
from FactResellerSales
where --copy and format the result from previous query
	   sign(ProductKey) < 0 
	or sign(SalesOrderLineNumber) < 0 
	or sign(OrderQuantity) < 0 
	or sign(UnitPrice) < 0 
	or sign(ExtendedAmount) < 0 
	or sign(UnitPriceDiscountPct) < 0 
	or sign(DiscountAmount) < 0 
	or sign(ProductStandardCost) < 0 
	or sign(TotalProductCost) < 0 
	or sign(SalesAmount) < 0;


/*============================================
         	    	DimProduct
============================================*/

--check for nulls
select
	string_agg(COLUMN_NAME + ' is null', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'DimProduct'
and IS_NULLABLE = 'YES'
and COLUMN_NAME in (
	 'ProductKey'
	,'ProductSubcategoryKey'
	,'EnglishProductName'
	,'StandardCost'
	,'FinishedGoodsFlag'
	,'ListPrice'
	,'DealerPrice'
	,'StartDate'
	,'EndDate'
	,'Status'
);

select  
	ProductKey
	,ProductSubcategoryKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,Status
from DimProduct
where
	   ProductSubcategoryKey is null 
	or StandardCost		     is null 
	or ListPrice			 is null 
	or DealerPrice			 is null 
	or StartDate			 is null 
	or EndDate				 is null 
	or Status				 is null;

--check cardinalities
select distinct FinishedGoodsFlag from DimProduct;

--look at only finished products, not parts
select  
	ProductKey
	,ProductSubcategoryKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,Status
from DimProduct
where FinishedGoodsFlag = 1;
--errors found in 3 columns, consult report.

--check dates
select  
	ProductKey
	,ProductSubcategoryKey
	,EnglishProductName
	,StartDate
	,EndDate
	,Status
from DimProduct
where StartDate >= EndDate
--200 products have StartDate later than EndDate.

--check prices
select  
	ProductKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,Status
from DimProduct
where StandardCost >= DealerPrice
--note: 114 products sold below the cost. Might not be an error.

--check for duplicates
select  
	ProductSubcategoryKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,Status
	,count(*)
from DimProduct
group by 
	ProductSubcategoryKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,Status
having count(*) > 1

/*============================================
        	DimProductSubcategory
			    DimProductCategory
============================================*/

--check for missing names
select 
	EnglishProductSubcategoryName 
from DimProductSubcategory
where EnglishProductSubcategoryName is null;


select
	EnglishProductCategoryName
from DimProductCategory
where EnglishProductCategoryName is null;
