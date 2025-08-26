/*===================================================
				Basic aggregations
===================================================*/


--summary of companys "big numbers" - highest level of aggregation
select 'Total sales' as MeasureName, round(sum(SalesAmount), 2) as MeasureValue from eda.vFactSalesCombined
union all
select 'Total profit', round(sum(UnitPrice - ProductStandardCost), 2) from eda.vFactSalesCombined
union all
select 'Average item price', round(avg(UnitPrice), 2) from eda.vFactSalesCombined
union all
select 'Average profit per item', round(avg(UnitPrice - ProductStandardCost), 2) from eda.vFactSalesCombined
union all
select 'Total orders', count(SalesSurrogateKey) from eda.vFactSalesCombined
union all
select 'Total sold items', sum(OrderQuantity) from eda.vFactSalesCombined
union all
select 'Total products', count(distinct ProductKey) from eda.DimProduct where FinishedGoodsFlag = 1
union all
select 'Total website customers', count(distinct CustomerKey) from eda.FactInternetSales;


--total customers per country
--based on internet sales
select
	 g.EnglishCountryRegionName as CountryName
	,count(d.CustomerKey) as Customers
from eda.DimCustomer as d 
join eda.DimGeography as g
on d.GeographyKey = g.GeographyKey
group by g.EnglishCountryRegionName
order by count(d.CustomerKey) desc

--total sales per country
select
	 t.SalesTerritoryCountry as Country
	,round(sum(s.SalesAmount), 2) as TotalSales
from eda.vFactSalesCombined as s
join eda.DimSalesTerritory as t
on s.SalesTerritoryKey = t.SalesTerritoryKey
group by t.SalesTerritoryCountry
order by round(sum(s.SalesAmount), 2) desc

--total products per category
select
	 EnglishProductCategoryName as Category
	,count(EnglishProductCategoryName) as Products
from eda.DimProduct
where FinishedGoodsFlag = 1
group by EnglishProductCategoryName
order by count(EnglishProductCategoryName) desc

--total sales per category
select
	 p.EnglishProductCategoryName as Category
	,round(sum(s.SalesAmount), 2) as TotalSales
from eda.vFactSalesCombined as s
join eda.DimProduct as p
on s.ProductKey = p.ProductKey
group by p.EnglishProductCategoryName
order by round(sum(s.SalesAmount), 2) desc

--average profit and margin per category
select
	 p.EnglishProductCategoryName as Category
	 ,round(avg(s.SalesAmount - s.TotalProductCost), 2) as ProfitDollars
	 ,avg((s.SalesAmount - s.TotalProductCost) / s.SalesAmount * 100) as MarginPercent
from eda.vFactSalesCombined as s
join eda.DimProduct as p
on s.ProductKey = p.ProductKey
group by p.EnglishProductCategoryName

--items sold per country
select 
	 t.SalesTerritoryCountry as Country
	,sum(s.OrderQuantity) as ItemsSold
from eda.vFactSalesCombined as s
join eda.DimSalesTerritory as t
on s.SalesTerritoryKey = t.SalesTerritoryKey
group by t.SalesTerritoryCountry
order by sum(s.OrderQuantity) desc

--orders per customer
select 
	CustomerKey
	,count(SalesSurrogateKey) PlacedOrders
	--no need for OrderQuantity as they all = 1
from eda.FactInternetSales
group by CustomerKey
order by count(SalesSurrogateKey) desc
