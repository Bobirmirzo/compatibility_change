--Compatibility check
SELECT name, compatibility_level
FROM sys.databases

-- Check whether query store is enabled
SELECT desired_state_desc ,
actual_state_desc ,
readonly_reason,
current_storage_size_mb ,
max_storage_size_mb ,
max_plans_per_query
FROM sys.database_query_store_options ;


-- Enable query store for the database
ALTER DATABASE [AdventureWorksDW2016_EXT]
SET QUERY_STORE = ON
    (
      OPERATION_MODE = READ_WRITE,
      DATA_FLUSH_INTERVAL_SECONDS = 900,
      QUERY_CAPTURE_MODE = AUTO,
      MAX_STORAGE_SIZE_MB = 1000,
      INTERVAL_LENGTH_MINUTES = 1
    );


--Following query returns information about queries and plans in the Query Store.
SELECT Txt.query_text_id, pl.compatibility_level, Txt.query_sql_text, Pl.plan_id, Qry.query_id, Qry.query_hash, Qry.last_compile_start_time, Qry.last_execution_time --,  Qry.*
FROM sys.query_store_plan AS Pl
INNER JOIN sys.query_store_query AS Qry
    ON Pl.query_id = Qry.query_id
INNER JOIN sys.query_store_query_text AS Txt
    ON Qry.query_text_id = Txt.query_text_id;


-- Check runtime stats
SELECt 
	   Txt.query_sql_text, 
	   pl.compatibility_level, 
	   pl.query_plan,
	   pl.plan_id,
	   SUM(count_executions) AS 'sum_execution_count', 
	   AVG(max_duration) as 'avg_max_duration', 
	   AVG(max_cpu_time) as 'avg_max_cpu_time', 
	   AVG(max_logical_io_reads) as 'avg_max_logical_reads',
	   AVG(max_physical_io_reads) as 'avg_max_physical_reads'
FROM sys.query_store_runtime_stats st
LEFT JOIN sys.query_store_plan AS pl
    ON st.plan_id = pl.plan_id
LEFT JOIN sys.query_store_query AS Qry
    ON pl.query_id = Qry.query_id
LEFT JOIN sys.query_store_query_text AS Txt
    ON Qry.query_text_id = Txt.query_text_id
GROUP BY Txt.query_sql_text, pl.compatibility_level, pl.plan_id, pl.query_plan
ORDER BY query_sql_text, pl.compatibility_level

-- Upgrade compatibility
ALTER DATABASE AdventureWorksDW2016_EXT
SET COMPATIBILITY_LEVEL=150

-- Force plan
SELECT 
	query_id,
	plan_id
FROM sys.query_store_plan WHERE query_plan = ''

EXEC sp_query_store_force_plan 44, 2

--check whether query plan is forced or not
SELECT * FROM sys.query_store_plan