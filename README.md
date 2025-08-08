# sql-exploratory-data-analysis-project
 This is a practise/portfolio project written in SQL Server and using AdventureWorksDW2022 database [provided by Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms.)

# Task:
Familiarise yourself with the database AdventureWorksDW2022, focusing on data related to customers and products. Create views that will help in doing data analysis. Prepare reports regarding data quality and basic insigths on the customers and products.
Follow naming conventions that are used in the database, write the code in lower case.
## 1. Explore the database structure
- Use build-in functionalities of SQL Server Management Studio (SSMS) to learn the structure of tables (sizes, datatypes, keys) and how they relate to each other (primary/foreign keys, redundant informations, facts and measures vs dimensions);
- Use draw.io to create database plan, focusing on primary and foreign keys. Make it easy to read and understand;
## 2. Handle missing and incorrect data
- Decide on how to approach zeros and nulls to avoid skewing the data aggregations;
- Check for duplicate rows;
- Remove trailing whitespaces;
- Fix incorrect values (negatives, out-of-range);
- Look for inconsistent date formatting that could cause errors;
- Check low cardinality dimension columns for inconsistent data (e.g. 'gender' column having 'Man', 'man' and 'm');
## 3. Prepare the views
- Combine data from the tables into views dedicated to customers and products. Select columns important for business analytics, like age, country, price, production cost and so on;
## 4. Create a summary
- Determine the influence of outlying values and decide if they should be included in summary;
- Create a report in SQL and a Dashboard in Excel with basic information about analysed data: averages, min and max values, orders per customer, customers per country, revenue per category and so on;
- Where applicable, use Excel to visualise the data;
