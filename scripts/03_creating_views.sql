/*============================================
Creating views for ease of aggregating

Used functions: datediff(), getdate()
============================================*/

/*======================================
DimCustomer and ProspectiveBuyerKey
Combined into vClientsDemographics
======================================*/

create view vClientsDemographics as (
select
	CustomerKey as PersonKey
	,datediff(year, BirthDate, getdate()) as age
	,MaritalStatus
	,Gender
	,YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from DimCustomer
union all
select
	ProspectiveBuyerKey as PersonKey
	,datediff(year, BirthDate, getdate()) as age
	,MaritalStatus
	,Gender
	,YearlyIncome
	,TotalChildren
	,NumberChildrenAtHome
	,HouseOwnerFlag
	,NumberCarsOwned
from ProspectiveBuyer
);

/*======================================
FactInternetSales and FactResellerSales
Combined into vSalesCombined
======================================*/

create view vSalesCombined as (
select
	ProductKey
	,SalesOrderNumber
	,SalesOrderLineNumber
	,OrderQuantity
	,UnitPrice
	,SalesAmount
from FactInternetSales
union all
select 
	ProductKey
	,SalesOrderNumber
	,SalesOrderLineNumber
	,OrderQuantity
	,UnitPrice
	,SalesAmount
from FactResellerSales
);

/*======================================
data from DimCustomer joined with sum
of their spendings from FactInternetSales
combined into vCustomersInternetSales
======================================*/

create view vCustomersInternetSales as (
select
	c.CustomerKey
	,datediff(year, c.BirthDate, getdate()) as age
	,c.MaritalStatus
	,c.Gender
	,c.YearlyIncome
	,c.TotalChildren
	,c.NumberChildrenAtHome
	,c.HouseOwnerFlag
	,c.NumberCarsOwned
	,sum(s.SalesAmount) as TotalSpendings
from DimCustomer as c
left join FactInternetSales as s
on c.CustomerKey = s.CustomerKey
group by 
	c.CustomerKey
	,datediff(year, c.BirthDate, getdate())
	,c.MaritalStatus
	,c.Gender
	,c.YearlyIncome
	,c.TotalChildren
	,c.NumberChildrenAtHome
	,c.HouseOwnerFlag
	,c.NumberCarsOwned
);

/*======================================
DimProduct table with names for 
categories and subcategories
======================================*/

create view vProductsWithCategories as (
select  
	 p.ProductKey
	,c.EnglishProductCategoryName as ProductCategory
	,s.EnglishProductSubcategoryName as ProductSubcategory
	,p.EnglishProductName as ProductName
	,p.StandardCost
	,p.FinishedGoodsFlag
	,p.ListPrice
	,p.DealerPrice
	,p.StartDate
	,p.EndDate
	,p.Status
from DimProduct as p
left join DimProductSubcategory as s
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
left join DimProductCategory as c
on s.ProductCategoryKey = c.ProductCategoryKey
);
