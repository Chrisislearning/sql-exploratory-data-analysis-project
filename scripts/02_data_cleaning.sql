
/*========================================================
Set of queries aimed at detecting errors in
tables. Types of errors looked for:
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


/*========================================================
			         DimCustomer
========================================================*/

--create the list of columns to search through
--and check them for nulls
select
	string_agg(COLUMN_NAME + ' is null', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'eda'
and TABLE_NAME = 'DimCustomer'
and IS_NULLABLE = 'YES';

--copy the generated string and use it in query below
--choose columns important for analysis
select
	 BirthDate
	,MaritalStatus
	,YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
	,DateFirstPurchase
from eda.DimCustomer
where 
	   BirthDate			is null 
	or MaritalStatus		is null 
	or YearlyIncome			is null 
	or TotalChildren		is null 
	or NumberChildrenAtHome is null 
	or HouseOwnerFlag		is null 
	or NumberCarsOwned		is null 
	or DateFirstPurchase	is null;
	   
--check for errors in low cardinality columns
select distinct MaritalStatus from eda.DimCustomer;

--check for negative numbers
select
	 YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from eda.DimCustomer
where 	
	   sign(YearlyIncome)         < 0
	or sign(TotalChildren)        < 0
	or sign(NumberChildrenAtHome) < 0
	or sign(HouseOwnerFlag)       < 0
	or sign(NumberCarsOwned)      < 0;

--look for incompatible dates
select
	 BirthDate
	,DateFirstPurchase
from eda.DimCustomer
where BirthDate >= DateFirstPurchase;


/*========================================================
			         DimDate
========================================================*/

select distinct EnglishDayNameOfWeek from eda.DimDate;
select distinct EnglishMonthName from eda.DimDate;


/*========================================================
         			 DimGeography
========================================================*/

--nulls
select
	 City 
	,StateProvinceCode 
	,StateProvinceName 
	,CountryRegionCode 
	,EnglishCountryRegionName 
	,SalesTerritoryKey
	from eda.DimGeography
where
	   City						 is null
	or StateProvinceCode         is null
	or StateProvinceName		 is null
	or CountryRegionCode		 is null
	or EnglishCountryRegionName  is null
	or SalesTerritoryKey		 is null;

--check for errors in low cardinality columns
select distinct StateProvinceName from DimGeography;
select distinct CountryRegionCode from DimGeography;
select distinct EnglishCountryRegionName from DimGeography;


/*========================================================
           			FactInternetSales
========================================================*/

--choose columns important for analysis,
--don't include redundant data
select
	 ProductKey
	,OrderDateKey
	,CustomerKey
	,CurrencyKey
	,SalesTerritoryKey
	,SalesSurrogateKey
	,OrderQuantity
	,UnitPrice
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
	,OrderDate
from eda.FactInternetSales
where
	   ProductKey           is null
	or OrderDateKey         is null
	or CustomerKey          is null
	or CurrencyKey          is null
	or SalesTerritoryKey    is null
	or SalesSurrogateKey    is null
	or OrderQuantity        is null
	or UnitPrice            is null
	or UnitPriceDiscountPct is null
	or DiscountAmount       is null
	or ProductStandardCost  is null
	or TotalProductCost     is null
	or SalesAmount          is null
	or OrderDate            is null;

/*========================================================
         	  	FactResellerSales
========================================================*/

--check for nulls
select
	string_agg(COLUMN_NAME,',')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'eda'
and TABLE_NAME = 'FactResellerSales'
and IS_NULLABLE = 'YES';

select 
	  ResellerGeographyKey
	 ,SalesSurrogateKey
	 ,OrderQuantity
	 ,UnitPrice
	 ,ExtendedAmount
	 ,UnitPriceDiscountPct
	 ,DiscountAmount
	 ,ProductStandardCost
	 ,TotalProductCost
	 ,SalesAmount
	 ,TaxAmt
	 ,Freight
	 ,OrderDate
	 ,ProductLine
	 ,ResellerAnnualSales
	 ,ResellerAnnualRevenue
from eda.FactResellerSales
where 
	    ResellerGeographyKey	is null
	 or SalesSurrogateKey		is null
	 or OrderQuantity			is null
	 or UnitPrice				is null
	 or ExtendedAmount			is null
	 or UnitPriceDiscountPct	is null
	 or DiscountAmount			is null
	 or ProductStandardCost		is null
	 or TotalProductCost		is null
	 or SalesAmount				is null
	 or TaxAmt					is null
	 or Freight					is null
	 or OrderDate				is null
	 or ProductLine				is null
	 or ResellerAnnualSales		is null
	 or ResellerAnnualRevenue	is null;

--check cardinality
select distinct ResellerBusinessType from eda.FactResellerSales;
select distinct ProductLine from eda.FactResellerSales;

--check for negative numbers
--get list of columns
select
	string_agg('sign(' + COLUMN_NAME + ')' + ' < 0', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'eda'
and TABLE_NAME = 'FactResellerSales'
and NUMERIC_PRECISION is not null;   --this filters out non-numbers

select 
	 *
from eda.FactResellerSales
where --copy and format the result from previous query
	   sign(ProductKey)			   < 0 
	or sign(OrderDateKey)		   < 0 
	or sign(ResellerKey)		   < 0 
	or sign(ResellerGeographyKey)  < 0 
	or sign(CurrencyKey)		   < 0 
	or sign(SalesTerritoryKey)     < 0 
	or sign(OrderQuantity)		   < 0 
	or sign(UnitPrice)			   < 0 
	or sign(ExtendedAmount)		   < 0 
	or sign(UnitPriceDiscountPct)  < 0 
	or sign(DiscountAmount)		   < 0 
	or sign(ProductStandardCost)   < 0 
	or sign(TotalProductCost)	   < 0 
	or sign(SalesAmount)		   < 0 
	or sign(TaxAmt)				   < 0 
	or sign(Freight)			   < 0 
	or sign(ResellerAnnualSales)   < 0 
	or sign(ResellerAnnualRevenue) < 0;

/*========================================================
         	    	DimProduct
========================================================*/

--check for nulls
select
	string_agg(COLUMN_NAME + ' is null', ' or ')
from INFORMATION_SCHEMA.COLUMNS
where TABLE_SCHEMA = 'eda'
and TABLE_NAME = 'DimProduct'
and IS_NULLABLE = 'YES';

select  
	*
from 
	(select * from eda.DimProduct  --filter out parts
	where FinishedGoodsFlag = 1)t
where
	   ProductAlternateKey			 is null 
	or EnglishProductCategoryName	 is null 
	or EnglishProductSubcategoryName is null 
	or StandardCost					 is null 
	or ListPrice					 is null 
	or ProductLine					 is null 
	or DealerPrice					 is null 
	or ModelName					 is null
	or StartDate					 is null;
--errors found in 4 columns, consult report.
	
--check cardinalities
select distinct EnglishProductCategoryName from eda.DimProduct;
select distinct EnglishProductSubcategoryName from eda.DimProduct;
select distinct ProductLine from eda.DimProduct;


--check rows with errors for possible duplicates
--with corrected data
select
	 ProductKey
	,ProductAlternateKey
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,ProductionStatus
from eda.DimProduct
where ProductKey in (210, 211)
   or EnglishProductName in ('HL Road Frame - Black, 58', 'HL Road Frame - Red, 58');

select
	*
from eda.DimProduct
where ProductLine is null
and FinishedGoodsFlag = 1;

--check dates
select  
	*
from eda.DimProduct
where StartDate >= EndDate;
--200 products have StartDate later than EndDate.

--check prices
select  
	*
from eda.DimProduct
where StandardCost >= DealerPrice;
--note: 114 products sold below the cost. Might not be an error.

--check for duplicates
select  
	 EnglishProductCategoryName
	,EnglishProductSubcategoryName
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,ProductionStatus
	,count(*)
from eda.DimProduct
group by 
	 EnglishProductCategoryName
	,EnglishProductSubcategoryName
	,EnglishProductName
	,StandardCost
	,FinishedGoodsFlag
	,ListPrice
	,DealerPrice
	,StartDate
	,EndDate
	,ProductionStatus
having count(*) > 1;


/*========================================================
         	    	FactCurrencyRate
========================================================*/

select * from eda.FactCurrencyRate
where AverageRate <= 0
or EndOfDayRate <= 0;

select distinct CurrencyName from eda.FactCurrencyRate;

/*========================================================
         	    	FactInternetSalesReason
========================================================*/

select distinct SalesReasonName from eda.FactInternetSalesReason;
select distinct SalesReasonReasonType from eda.FactInternetSalesReason;
