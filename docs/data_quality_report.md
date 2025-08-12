
# Out of 7 tables, only DimProduct contains errors:

- All products not flagged as "finished goods" have no cost listed. If this is meant as production cost then probably should not be null.
2 products flagged as "finished goods" have no cost and no prices listed, and they are marked as "current", so still produced- needs to be clarified.

- 200 products have their start date later than end date. Probably not needed for this analysis, but significant % of dates is incorrect, check with source.
For the same product, possible solution is to set the EndDate equal to StartDate of the new production batch of said product.

- 114 products are sold below the production cost. Might not be an error in database. Check with Sales.
