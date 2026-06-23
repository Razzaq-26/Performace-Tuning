--1.monitor index usage

   --list all index of a table
    
      exec sp_helpindex 'dbo.YourTable';


   --monitor index uses
    
      select * from sys.indexes

            -- or
    
      select * from sys.tables

            --or DVMs

      select * from sys.dm_db_index_usage_stats

           -- combined

    select 
    tbl.name as TableName,
    idx.name as IndexName,
    idx.type_desc as IndexType,
    idx.is_unique as IsUnique,
    idx.is_primary_key as IsPrimaryKey,
    idx.is_disabled as IsDisabled,
    s.user_seeks as UserSeeks,
    s.user_scans as UserScans,
    s.user_lookups as UserLookUp,
    s.user_updates as UserUpdate,
    COALESCE(s.last_user_seek, s.last_user_scan) LastUpdate
    from sys.indexes idx
    join sys.tables  tbl
    on idx.object_id = tbl.object_id
    left join sys.dm_db_index_usage_stats s
    on s.object_id=idx.object_id
    where idx.name is not null
    order by tbl.name, idx.name

--2. monitor mixing indexes

    select * from sys.index_columns

    select * from sys.columns where name ='votes_id'

    select * from sys.dm_db_missing_index_groups
     
      

 --3. monitor duplicate indexes or how a cloumn shares the multiple index
    
      SELECT
tbl.name AS TableName,
col.name AS IndexColumn,
idx.name AS IndexName,
idx.type_desc AS IndexType,
COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic oN idx.object_id=ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id 
ORDER BY ColumnCount DESC  


-- statistics update
select
SCHEMA_NAME(t.schema_id) AS SchemaName,
t.name AS TableName,
s.name AS StatisticName,
sp.last_updated As LastUpdate,
DATEDIFF(day, sp.last_updated, GETDATE()) As LastUpdateDay,
sp.rows AS 'Rows',
sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS S
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY
sp.modification_counter DESC;

--how to update by updating that perticular statistic or whole table( weakly or database size)

update statistics dbo.comments PK_Comments__Id

update statistics dbo.comments

4-- fragmentation

    select * from sys.dm_db_index_physical_stats(DB_ID(), NULL,NULL,NULL,'LIMITED')


    SELECT
tbl.name AS TableName,
idx.name AS IndexName,
s.avg_fragmentation_in_percent,
s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL,'LIMITED') AS s
INNER join sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx
ON idx.object_id = s.object_id
AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

--- apply according to the percantage

10% to 30% go for reorgnaize

30%> go for rebuild

ALTER INDEX xp_StackOverFlow_PostLinks_  ON dbo.postlinks REORGANIZE

ALTER INDEX idx_Customers_cs_Country ON Sales. Customers rebuild
 
