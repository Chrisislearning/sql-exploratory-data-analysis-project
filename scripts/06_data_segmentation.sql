
/*=======================================
            Data_segmentation
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

--number of orders per income range
select * from eda.vCustomersSPendings





