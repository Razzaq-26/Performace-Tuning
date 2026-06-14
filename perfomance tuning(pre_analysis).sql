
-- identify the server and database
-- what resources we have to perform the tuning likes,extended event, query store, DMV and any store procedure  etc

-- check the statistic  
   
   dbcc show_statistics('dbo.tablename', 'indexname')
   
   properties of  statistic 1. header 2. density vectore
      
    /* check statistic update or not rows_sampled and rows are showing 
    big diffferent and check which scan is using full or sample */
     
    update statistics dbo.votes PK_Votes_Id WITH FULLSCAN /* when the data is skewed, non_ unique*/

    update statistics dbo.votes PK_Votes_Id WITH sample /*when the data is unique  and by default of update stattistic on */

    update statistics dbo.votes PK_Votes_Id WITH sample 10 percent

-- cardinality estimationmodel version and compatiblity

    SELECT 
    name AS DatabaseName,
    compatibility_level
    FROM sys.databases;
    -- where name='databasename'

   ALTER DATABASE StackOverFlow
   SET COMPATIBILITY_LEVEL = 150;

-- how many indexes a table have 

    exec sp_helpindex 'TableName';

--next check the qurey's execution plan

 /* 1. find the expensive oprator, keylookup, sort, tempdb spilled
    2.index scan, table scan and clusterindex scan
    3. parallelisum 
    4. query wait the resources, pageiolatch, semaphome etc */

--- extended event, DVM AND EXECUTION plan these are useful for the query optimization

  /* create the index according to the query

   like cluster,noncluster, filter index and cloumnstore index */

   create index ix_votes_PostId on votes(PostId)

   drop index ix_votes_PostId on votes(PostId)

-- cardnality estimation model check 

    /* different execution plan if cardinality on/off */

    /* check statistic update or not rows_sampled and rows are showing 
    big diffferent the update the index as well as column index */

    SELECT
    s.name AS StatisticsName,
    sp.last_updated,
    sp.rows,
    sp.rows_sampled,
    sp.modification_counter
    FROM sys.stats s
    CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
    WHERE s.object_id = OBJECT_ID('dbo.tablename');

    /* View histogram of a specific index statistic */


    dbbcc show_statistics('dbo.votes', 'PK_Votes_Id')

---index seek is better for lager databases have millions of records

-- unable the statistic

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

-- degree of parallelisum (depence)

    EXEC sp_configure 'max degree of parallelism';

    select * from dbo.votes option (maxdop 4)

-- check the dop and cost of threshold

     SELECT
     name,
     value_in_use
     FROM sys.configurations
     WHERE name IN
     (
          'max degree of parallelism',
          'cost threshold for parallelism'
     );

---Join Algorithms

     /* Nested Loops: Compares tables row by row, best for small tables.

     Hash Match: Matches rows using a hash table,best for large tables.

     Merge Join: Merge two sorted tables, efficient when both are sorted. */

-- Sql Hints

     /*commands you add to a query to force the database to run it in a specific 
     way for the better performance */

     select 
     o.sales,
     c.country
     from Sales.Orders o
     left join Sales Customer c 
     on o. CustomerId= c.CustomerId
     option( hash join)

     
     select 
     o.sales,
     c.country
     from Sales.Orders o
     left join Sales Customer c  with (forceseek)
     on o. CustomerId= c.CustomerId
     --option( hash join)

     
     select 
     o.sales,
     c.country
     from Sales.Orders o
     left join Sales Customer c  with (index(Pk_Customer_A4AE64B87))
     on o. CustomerId= c.CustomerId

-- TIPS | SOL HINTS

    /* 1.Test hints in all project environments (DEV, PROD)
        as performance may vary.

     2.Hints are quick fixes (Workaround not Solution)
        You still have to find the cause and fix it */



 