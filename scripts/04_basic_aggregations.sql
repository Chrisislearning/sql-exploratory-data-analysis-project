/*===================================================
                Basic aggregations
===================================================*/


--summary of companys "big numbers" - highest level of aggregation
select 'Total sales' as MeasureName, sum(SalesAmount) as MeasureValue from eda.vFactSalesCombined
union all
select 'Total profit', sum(UnitPrice - ProductStandardCost) from eda.vFactSalesCombined
union all
select 'Average item price', avg(UnitPrice) from eda.vFactSalesCombined
union all
select 'Average profit per item', avg(UnitPrice - ProductStandardCost) from eda.vFactSalesCombined
union all
select 'Total orders', count(SalesSurrogateKey) from eda.vFactSalesCombined
union all
select 'Total sold items', sum(OrderQuantity) from eda.vFactSalesCombined
union all
select 'Total products', count(distinct ProductKey) from eda.DimProduct where FinishedGoodsFlag = 1
union all
select 'Total website customers', count(distinct CustomerKey) from eda.FactInternetSales;


--total customers by country
--based on internet sales
select 
	 count(d.CustomerKey) as CustomerCount
	,g.EnglishCountryRegionName as CountryName
from eda.DimCustomer as d 
join eda.DimGeography as g
on d.GeographyKey = g.GeographyKey
group by g.EnglishCountryRegionName
order by count(d.CustomerKey) desc

--total sales by country
select 
	 round(sum(s.SalesAmount), 2) as TotalSales
	,t.SalesTerritoryCountry as Country
from eda.vFactSalesCombined as s
join eda.DimSalesTerritory as t
on s.SalesTerritoryKey = t.SalesTerritoryKey
group by t.SalesTerritoryCountry
order by round(sum(s.SalesAmount), 2) desc

--total products by category
select
	 EnglishProductCategoryName as Category
	,count(EnglishProductCategoryName) as Products
from eda.DimProduct
where FinishedGoodsFlag = 1
group by EnglishProductCategoryName
order by count(EnglishProductCategoryName) desc

--total sales by category
select 
	 round(sum(s.SalesAmount), 2) as TotalSales
	,p.EnglishProductCategoryName as Category
from eda.vFactSalesCombined as s
join eda.DimProduct as p
on s.ProductKey = p.ProductKey
group by p.EnglishProductCategoryName
order by round(sum(s.SalesAmount), 2) desc

--average profit and margin by category
select
	 p.EnglishProductCategoryName as Category
	 ,round(avg(s.SalesAmount - s.TotalProductCost), 2) as ProfitDollars
	 ,avg((s.SalesAmount - s.TotalProductCost) / s.SalesAmount * 100) as MarginPercent
from eda.vFactSalesCombined as s
join eda.DimProduct as p
on s.ProductKey = p.ProductKey
group by p.EnglishProductCategoryName

--items sold by country
select 
	 sum(s.OrderQuantity) as ItemsSold
	,t.SalesTerritoryCountry
from eda.vFactSalesCombined as s
join eda.DimSalesTerritory as t
on s.SalesTerritoryKey = t.SalesTerritoryKey
group by t.SalesTerritoryCountry
order by sum(s.OrderQuantity) desc
