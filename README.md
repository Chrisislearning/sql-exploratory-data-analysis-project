# sql-exploratory-data-analysis-project
 This is a practise/portfolio project written in SQL Server and using AdventureWorksDW2022 database [provided by Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms.)

# Task:
Familiarise yourself with the database, focusing on data related to customers and products. Create views that will help in data analysis. Prepare reports regarding data quality and basic insigths on the customers and products.
Follow naming conventions that are used in the database, write the code in lower case.
## 1.Explore the database structure
- Use build-in functionalities of SQL Server Management Studio (SSMS) to learn the structure of tables (sizes, datatypes, keys, indexes) and how they relate to each other (primary/foreign keys, redundant informations, measures vs dimensions);
- Use draw.io to create database plan, focusing on primary and foreign keys. Make it easy to read and understand;
## 2.Handle missing and incorrect data
- Decide on how to approach zeros and nulls to avoid skewing the data aggregations;
- Remove trailing whitespaces;
- Fix incorrect values (negatives, out-of-range);
- Look for inconsistent date formatting that could cause errors;
- Check low granularity dimension columns for inconsistent data (e.g. 'gender' column having 'Man', 'man' and 'm');
## 3.

