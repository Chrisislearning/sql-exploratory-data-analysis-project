

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

/*======================================
        customers assigned to 
        income and spending groups
======================================*/
create view eda.vCustomersSpendings as
with CTE_Sales as (
    select
         s.CustomerKey
        ,sum(s.SalesAmount) as TotalSpending
        ,case
            when sum(s.SalesAmount) < 200 then 'Low'
            when sum(s.SalesAmount) < 3000 then 'Medium'
            else 'High'
         end as SpendingRange
        ,count(s.SalesSurrogateKey) as NoOfOrders
    from eda.FactInternetSales as s
    group by s.CustomerKey
    )
select
     s.CustomerKey
    ,case
       when c.YearlyIncome < 40000 then 'Low'
       when c.YearlyIncome < 70000 then 'Medium'
       else 'High'
     end as IncomeRange
    ,s.SpendingRange
    ,s.TotalSpending
    ,s.NoOfOrders
from CTE_Sales as s
join eda.DimCustomer as c
on s.CustomerKey = c.CustomerKey;
