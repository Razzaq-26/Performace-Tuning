
--extra details about hte transaction like locks,time,cpu,progamename,time

    sp_who2
 
--normal details about the transaction

    sp_who

--whoisactive we have download the store procedure

    sp_whoisactive

-- compatibility level of database

   SELECT name, compatibility_level
    FROM sys.databases
 
--how to check what is last transaction in the sesiion

   DBCC INPUTBUFFER(72)

---check how the log file space is used

   DBCC SQLPERF(LOGSPACE);

-- CHECK THE LOGEST TRANSACTION

   DBCC OPENTRAN;

--- what type of wait it is 

   select * from sys.dm_os_waiting_tasks
   where session_id=81

--- session information

    select * from sys.dm_exec_sessions
    where session_id=70

-- extract the query by using the column "sql_handle" with the help of the below quries

    select * from sys.dm_exec_requests
    where session_id=55

    select * from 
    sys.dm_exec_sql_text(0x020000006C92B0233D3CB5B13630E44CE8FE532972FDADB00000000000000000000000000000000000000000)

-- to extract the most recent transaction in the session with help of "most_recently_sql_handle" column

    select * from sys.dm_exec_connections
    where session_id=72

  select * from 
  sys.dm_exec_sql_text(0x020000006C92B0233D3CB5B13630E44CE8FE532972FDADB00000000000000000000000000000000000000000)
  
-- types of the wait_type for the resource are 1070 like pageiolatch

  select * from sys.dm_os_wait_stats

--memory grant besased the wait type is resource_semaphore

  select * from sys.dm_exec_query_memory_grants