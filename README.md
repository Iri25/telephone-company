

Mini project with DDL, DML scripts, such as creating a database, tables, views, indexing, updating and modifying data, deleting, filtering queries, aggregating functions, sorting and grouping fields. Also, data validation, CRUD operations.


The project contains the representation of the data of a telephone company in a relational database, Microsoft SQL Server. The database has 1-m and m-n type relationships.
The project contains scripts for:
- Creating the database and tables ([Tables](https://github.com/Iri25/db-sql-Iri25/blob/main/Tables.sql)).
- Queries with `distinct, where, group by, having, sum, count functions` and `like, %, and, or, >, < operators` ([Queries](https://github.com/Iri25/db-sql-Iri25/blob/main/Queries.sql)).
- Procedures change the type of a column, add a 'default value' constraint for a field, create/delete a table, add a new field, create/delete a foreign key constraint, bring the database to a certain version. For each of the scripts there is another script which
implements the inverse of the operation ([Procedures](https://github.com/Iri25/db-sql-Iri25/blob/main/Procedures.sql)).
- CRUD operations encapsulated in stored procedures ([CRUD Operations](https://github.com/Iri25/db-sql-Iri25/blob/main/CRUD%20Operations.sql)).
- Views over selected tables for CRUD operations and creating non-clustered indexes ([Viewa and Indexes](https://github.com/Iri25/db-sql-Iri25/blob/main/Views%20and%20Indexes.sql)).
- Database testing folder ([Database Testing](https://github.com/Iri25/db-sql-Iri25/tree/main/Database%20Testing)).

The database testing folder contains scripts with the tables:
- Tests: contains information about various test configurations
- Tables: contains the lists of tables that could be part of the test
- TestTables: is the connection table between Tests and Tables and contains the list of tables involved in each test
- Views: a set of views existing in the database and which are used in testing the performance of particular queries
- TestViews: is the connection table between Tests and Views and contains the list of views involved in each test
- TestRuns: contains the execution results of various tests. Each test run requires the following:
1) deleting the data from the tables associated with the test (in the order given by the Position field);
2) inserting records into tables in the reverse order given by Position (the number of inserted records is given by the NoOfRows field);
3) Evaluation of the execution time of the views
- TestRunTables: contains information about the performance in which the records of each table associated with the test are inserted
- TestRunViews: contains information about the performance of each view in the test


