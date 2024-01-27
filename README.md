# database-commands
Data Definition Language (DDL), Data Query Language (DQL), Data Manipulation Language (DML) and Transaction Control Language (TCL) in Microsoft SQL Server.

The project contains the representation of the data of a telephone company in a relational database. The database has 1-m and m-n type relationships.

### The project contains scripts for:
1. Creating the database and tables ([Tables](https://github.com/Iri25/db-sql-Iri25/blob/main/Tables.sql)).
2. Queries with `distinct, where, group by, having, sum, count aggregating functions` and `like, %, and, or, >, < operators` ([Queries](https://github.com/Iri25/db-sql-Iri25/blob/main/Queries.sql)).
3. Procedures change the type of a column, add a 'default value' constraint for a field, create/delete a table, add a new field, create/delete a foreign key constraint, bring the database to a certain version. For each of the scripts there is another script which
implements the inverse of the operation ([Procedures](https://github.com/Iri25/db-sql-Iri25/blob/main/Procedures.sql)).
4. CRUD operations encapsulated in stored procedures ([CRUD Operations](https://github.com/Iri25/db-sql-Iri25/blob/main/CRUD%20Operations.sql)).
5. Views over selected tables for CRUD operations and creating non-clustered indexes ([Viewa and Indexes](https://github.com/Iri25/db-sql-Iri25/blob/main/Views%20and%20Indexes.sql)).
6. Rollback for stored procedures that insert data, dirty reads, non-repeatable reads, phantom reads, deadlock ([Transactions folder](https://github.com/Iri25/database-commands/blob/main/Transactions)).
11. Database testing ([Database Testing folder](https://github.com/Iri25/db-sql-Iri25/tree/main/Database%20Testing)).

#### The database testing folder contains scripts with the tables:
- Tests: contains information about various test configurations
- Tables: contains the lists of tables that could be part of the test
- TestTables: is the connection table between Tests and Tables and contains the list of tables involved in each test
- Views: a set of views existing in the database and which are used in testing the performance of particular queries
- TestViews: is the connection table between Tests and Views and contains the list of views involved in each test
- TestRuns: contains the execution results of various tests. Each test run requires the following:
  - deleting the data from the tables associated with the test (in the order given by the Position field);
  - inserting records into tables in the reverse order given by Position (the number of inserted records is given by the NoOfRows field);
  - Evaluation of the execution time of the views
- TestRunTables: contains information about the performance in which the records of each table associated with the test are inserted
- TestRunViews: contains information about the performance of each view in the test

To test the performance of the database, stored procedures were created to evaluate and store the test results. Tests were made for tables that have:
- one field as primary key and no foreign key,
- one field as primary key and at least one foreign key,
- two fields as primary key.

Views were also made that contain:
- SELECT command on a table,
- SELECT command applied to at least two tables,
- SELECT command applied to at least two tables and having a GROUP BY clause.


12. Windows application developed in the .NET framework that contains windows through which a user can manipulate the data of 2 tables in a 1-n relationship (parent table and child table). Data sets and data adapters are used for communication with the database. ([Telephone Company V1 folder](https://github.com/Iri25/database-commands/tree/main/Telephone%20Company%20V1)).

#### The application implements the following functionalities:
  - displaying the records of the parent table;
  - when selecting a record from the parent, all the records of the child table are displayed
  - when selecting a record from the child table, it is allowed to delete or update its data
  - when selecting a record from the parent table, it is allowed to add a new record to the child table.


13. Windows application developed in the .NET framework that contains generic master-detail windows through which a user can manipulate the data of several tables in a 1-n relationship. Window title and structure, controls and stored procedures/queries used to access and manipulate data are set in a configuration file. Datasets and data adapters are used to communicate with the database.([Telephone Company V2 folder](https://github.com/Iri25/database-commands/tree/main/Telephone%20Company%20V2)).

#### The application allows:
- enough generic windows so that the changes for the management of other data are made exclusively at the level of the configuration file and not in the source code
