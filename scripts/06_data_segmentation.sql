
/*=======================================
            Data segmentation
=======================================*/

--products split into price ranges
select
     PriceRange
    ,count(*) as NoOfProducts
from (
    select
         ProductKey
        ,ListPrice
        ,case
            when ListPrice < 500 then 'Low'
            when ListPrice < 2000 then 'Medium'
            else 'High'
        end as PriceRange
    from eda.DimProduct
    where ListPrice is not null
)t
group by PriceRange
order by count(*) desc;

--Customers with assigned categories
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
