/*============================================
Creating views for ease of aggregating
============================================*/

/*======================================
FactInternetSales and FactResellerSales
Combined into vFactSalesCombined
======================================*/

create view eda.vFactSalesCombined as
select
	 ProductKey
	,OrderDateKey
	,CurrencyKey
	,SalesTerritoryKey
	,SalesSurrogateKey
	,OrderQuantity
	,UnitPrice
	,UnitPrice as ExtendedAmount
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
	,OrderDate
from eda.FactInternetSales
union all
select 
	 ProductKey
	,OrderDateKey
	,CurrencyKey
	,SalesTerritoryKey
	,SalesSurrogateKey
	,OrderQuantity
	,UnitPrice
	,ExtendedAmount
	,UnitPriceDiscountPct
	,DiscountAmount
	,ProductStandardCost
	,TotalProductCost
	,SalesAmount
	,OrderDate
from eda.FactResellerSales
