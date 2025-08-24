# sql-exploratory-data-analysis-project
 This is a practise/portfolio project written in SQL Server and using AdventureWorksDW2022 database [provided by Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms.)

# Task:
Familiarise yourself with the database AdventureWorksDW2022, focusing on data related to sales, customers and products. Include reports regarding data quality. Follow naming conventions that are used in the database, write the code in lower case. Use Power BI to create reports on sales, customers and products.
## 1. Explore the database structure
- Use build-in functionalities of SQL Server Management Studio (SSMS) to learn the structure of tables (sizes, datatypes, keys) and how they relate to each other (primary/foreign keys, redundant informations, facts and measures vs dimensions);
## 2. Handle missing and incorrect data
- Decide on how to approach zeros and nulls to avoid skewing the data aggregations;
- Check for duplicate rows;
- Remove trailing whitespaces;
- Fix incorrect values (negatives, out-of-range);
- Look for inconsistent date formatting that could cause errors;
- Check low cardinality dimension columns for inconsistent data (e.g. 'gender' column having 'Man', 'man', 'male' and 'm');
## in progress 3. Create a report
- Determine the influence of outlying values and decide if they should be included in your summary;
- Create a report in SQL and PowerBI with basic information about analysed data: averages, min and max values, orders per customer, customers per country, revenue per category and so on;
## plan for the future 4. prepare more complex aggregations
- change over time
- cumulative and performance analysis
- part-to-whole
- data segmentation
