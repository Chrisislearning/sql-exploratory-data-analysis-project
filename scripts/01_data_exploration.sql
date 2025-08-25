
/*=================================================
1. Data exploration: check the structure of and 
	relations between tables and columns.
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

/*=================================================
2. Create Entity-Relationship Diagram, remove from 
	it unneccessary tables and denormalize the rest,
	choose columns that will be needed.
	Create schema "eda" and use "select into"
	to create new tables in it.
=================================================*/

create schema eda;

--FactInternetSales 
select 
	 ProductKey
	,OrderDateKey
	,CustomerKey
	,CurrencyKey
	,SalesTerritoryKey
	,SalesOrderNumber + cast(SalesOrderLineNumber as nvarchar) as SalesSurrogateKey
	,OrderQuantity
	,UnitPrice
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
	,cast(OrderDate as date) as OrderDate
into eda.FactInternetSales
from FactInternetSales;

--FactInternetSalesReason plus DimSalesReason
select 
	 r.SalesOrderNumber + cast(r.SalesOrderLineNumber as nvarchar) as SalesSurrogateKey
	,d.SalesReasonName
	,d.SalesReasonReasonType
into eda.FactInternetSalesReason
from FactInternetSalesReason as r
join DimSalesReason as d
on r.SalesReasonKey = d.SalesReasonKey;

--FactResellerSales plus DimReseller
select 
	 s.ProductKey
	,s.OrderDateKey
	,s.ResellerKey
	,r.GeographyKey as ResellerGeographyKey
	,s.CurrencyKey
	,s.SalesTerritoryKey
	,s.SalesOrderNumber + cast(SalesOrderLineNumber as nvarchar) as SalesSurrogateKey
	,s.OrderQuantity
	,s.UnitPrice
	,s.ExtendedAmount
	,s.UnitPriceDiscountPct
	,s.DiscountAmount
	,s.ProductStandardCost
	,s.TotalProductCost
	,s.SalesAmount
	,s.TaxAmt
	,s.Freight
	,cast(s.OrderDate as date) as OrderDate
	,r.BusinessType as ResellerBusinessType
	,r.ProductLine
	,r.AnnualSales as ResellerAnnualSales
	,r.AnnualRevenue as ResellerAnnualRevenue
into eda.FactResellerSales
from FactResellerSales as s
join DimReseller as r
on s.ResellerKey = r.ResellerKey;

--DimSalesTerritory
select 
	 SalesTerritoryKey
	,SalesTerritoryAlternateKey
	,SalesTerritoryRegion
	,SalesTerritoryCountry
	,SalesTerritoryGroup
into eda.DimSalesTerritory
from DimSalesTerritory;

--DimGeography
select
	 GeographyKey
	,City 
	,StateProvinceCode 
	,StateProvinceName 
	,CountryRegionCode
	,EnglishCountryRegionName
	,SalesTerritoryKey
into eda.DimGeography
from DimGeography;

--DimCustomer
select
	 CustomerKey
	,GeographyKey
	,BirthDate 
	,MaritalStatus
	,YearlyIncome 
	,TotalChildren 
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned 
	,DateFirstPurchase
into eda.DimCustomer
from DimCustomer;


--FactCurrencyRate
select
	 CurrencyKey
	,DateKey
	,AverageRate
	,EndOfDayRate
	,cast(Date as date) as RateDate
into eda.FactCurrencyRate
from FactCurrencyRate


--DimCurrency
select
	*
into eda.DimCurrency
from DimCurrency

--DimDate
select 
	 DateKey
	,FullDateAlternateKey
	,DayNumberOfWeek
	,EnglishDayNameOfWeek
	,DayNumberOfMonth
	,DayNumberOfYear
	,WeekNumberOfYear
	,EnglishMonthName
	,MonthNumberOfYear
	,CalendarQuarter
	,CalendarYear
	,CalendarSemester
	,FiscalQuarter
	,FiscalYear
	,FiscalSemester
into eda.DimDate
from DimDate;

--DimProduct plus ProductSubcategoryKey plus ProductCategoryKey
select
	 p.ProductKey
	,p.ProductAlternateKey
	,c.EnglishProductCategoryName
	,s.EnglishProductSubcategoryName
	,p.EnglishProductName
	,p.StandardCost
	,p.FinishedGoodsFlag
	,p.ListPrice
	,p.ProductLine
	,p.DealerPrice
	,p.ModelName
	,p.EnglishDescription
	,cast(p.StartDate as date) as StartDate
	,cast(p.EndDate as date) as EndDate
	,p.Status as ProductionStatus
into eda.DimProduct
from DimProduct as p
left join DimProductSubcategory as s
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
left join DimProductCategory as c
on s.ProductCategoryKey = c.ProductCategoryKey;
