/*=================================================================
			Analysis of trends (changes over time)
=================================================================*/

--sales, profit and orders over time
--per Year, Quarter, Month
select 
	 datepart(yyyy, OrderDate) as DateYear
	,datepart(qq, OrderDate) as DateQuarter
	,datepart(mm, OrderDate) as DateMonth
	,round(sum(SalesAmount), 2) as Sales
	,round(sum(SalesAmount - TotalProductCost), 2) as Profit
	,count(OrderQuantity) as NoOfOrders
from eda.vFactSalesCombined
group by 
	 datepart(yyyy, OrderDate) 
	,datepart(qq, OrderDate) 
	,datepart(mm, OrderDate) 
order by
	 datepart(yyyy, OrderDate) 
	,datepart(qq, OrderDate) 
	,datepart(mm, OrderDate);

--running totals of Sales, Profit and Orders
select
	 DateYear
	,DateQuarter
	,DateMonth
	,sum(TotalSales) over (order by DateYear, DateQuarter, DateMonth) as SalesRunningTotal
	,sum(Profit) over (order by DateYear, DateQuarter, DateMonth) as ProfitRunningTotal
	,sum(NoOfOrders) over (order by DateYear, DateQuarter, DateMonth) as OrdersRunningTotal
from (
	select 
		 datepart(yyyy, OrderDate) as DateYear
		,datepart(qq, OrderDate) as DateQuarter
		,datepart(mm, OrderDate) as DateMonth
		,round(sum(SalesAmount), 2) as TotalSales
		,round(sum(SalesAmount - TotalProductCost), 2) as Profit
		,count(OrderQuantity) as NoOfOrders
	from eda.vFactSalesCombined
	group by datepart(yyyy, OrderDate), datepart(qq, OrderDate), datepart(mm, OrderDate)
	)t;

--comparing quarterly sales year to year
with CTE_sales_quarter as (
select
	 round(sum(s.SalesAmount), 2) as QuarterlySales
	,d.FiscalYear as FiscalYear
	,d.FiscalQuarter as FiscalQuarter
from eda.vFactSalesCombined as s
join eda.DimDate as d on
s.OrderDateKey = d.DateKey
group by d.FiscalYear, d.FiscalQuarter
)
select
     FiscalYear
	,FiscalQuarter
	,QuarterlySales
	,round(avg(QuarterlySales) over(partition by FiscalYear), 2) as QuarterlySalesAverageForYear
	,lag(QuarterlySales, 4) over(order by(FiscalYear)) as QuarterSalesPriorYear
	,QuarterlySales - lag(QuarterlySales, 4) over(order by(FiscalYear)) as YtYDifference
from CTE_sales_quarter
order by FiscalYear, FiscalQuarter;

--yearly sales compared to previous year
with CTE_sales_year as (
select
	 round(sum(s.SalesAmount), 2) as YearlySales
	,d.FiscalYear as FiscalYear
	--,lag(d.FiscalYear) over(order by d.FiscalYear) as PreviousYear
from eda.vFactSalesCombined as s
join eda.DimDate as d on
s.OrderDateKey = d.DateKey
group by d.FiscalYear
)
select
	 YearlySales
	,FiscalYear
	,lag(YearlySales) over(order by FiscalYear) as PreviousYearSales
	,YearlySales - lag(YearlySales) over(order by FiscalYear) as YtYDifference
from CTE_sales_year;
