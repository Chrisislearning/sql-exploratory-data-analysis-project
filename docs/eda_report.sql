
/*================================================
      eda report on AdventureWorksDW2022
  also consult PowerBI report in the same folder
=================================================*/

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

--basic info on countries
with CTE_country_customers as (
	select
		 g.EnglishCountryRegionName as Country
		,count(d.CustomerKey) as WebCustomers
	from eda.DimCustomer as d 
	join eda.DimGeography as g
	on d.GeographyKey = g.GeographyKey
	group by g.EnglishCountryRegionName
)
,	 CTE_country_sales as (
	select
		 t.SalesTerritoryCountry as Country
		,round(sum(s.SalesAmount), 2) as TotalSales
	from eda.vFactSalesCombined as s
	join eda.DimSalesTerritory as t
	on s.SalesTerritoryKey = t.SalesTerritoryKey
	group by t.SalesTerritoryCountry
)
,	CTE_country_items as (
	select 
		 t.SalesTerritoryCountry as Country
		,sum(s.OrderQuantity) as ItemsSold
	from eda.vFactSalesCombined as s
	join eda.DimSalesTerritory as t
	on s.SalesTerritoryKey = t.SalesTerritoryKey
	group by t.SalesTerritoryCountry
)
select
	 cc.Country
	,cc.WebCustomers
	,cs.TotalSales
	,ci.ItemsSold
from CTE_country_customers as cc
left join CTE_country_sales as cs
on cc.Country = cs.Country
left join CTE_country_items as ci
on cc.Country = ci.Country;

--basic info on categories of products
with CTE_category_products as (
	select
		 EnglishProductCategoryName as Category
		,count(EnglishProductCategoryName) as Products
	from eda.DimProduct
	where FinishedGoodsFlag = 1
	group by EnglishProductCategoryName
)
,	CTE_category_sales as (
	select
		 p.EnglishProductCategoryName as Category
		,round(sum(s.SalesAmount), 2) as TotalSales
	from eda.vFactSalesCombined as s
	join eda.DimProduct as p
	on s.ProductKey = p.ProductKey
	group by p.EnglishProductCategoryName
)
,	CTE_category_profit_margin as (
	select
		 p.EnglishProductCategoryName as Category
		 ,round(avg(s.SalesAmount - s.TotalProductCost), 2) as ProfitDollars
		 ,avg((s.SalesAmount - s.TotalProductCost) / s.SalesAmount * 100) as MarginPercent
	from eda.vFactSalesCombined as s
	join eda.DimProduct as p
	on s.ProductKey = p.ProductKey
	group by p.EnglishProductCategoryName
)
select
	 cp.Category
	,cp.Products
	,cs.TotalSales
	,pm.ProfitDollars as ProfitInUSD
	,pm.MarginPercent as MarginInPercent
from CTE_category_products as cp
left join CTE_category_sales as cs
on cp.Category = cs.Category
left join CTE_category_profit_margin as pm
on cp.Category = pm.Category;

--customers info with flags for purchasing habits
with CTE_cust_cat as (
	select 
		 CustomerKey
		,case
			when IncomeRange = 'High' and SpendingRange = 'High'
			then 'Yes'
			else ''
		 end as VIP
		,case
			when IncomeRange = 'High' and SpendingRange != 'High' and NoOfOrders < 4
			then 'Yes'
			else ''
		 end as PromisingCustomer
		,case
			when NoOfOrders > 10
			then 'Yes'
			else ''
		 end as RegularBuyer
	from eda.vCustomersSpendings
)
select 
	 c.CustomerKey
	,c.IncomeRange
	,c.SpendingRange
	,c.TotalSpending
	,c.NoOfOrders
	,c2.VIP
	,c2.PromisingCustomer
	,c2.RegularBuyer
from eda.vCustomersSpendings as c
left join CTE_cust_cat as c2
on c.CustomerKey = c2.CustomerKey;
