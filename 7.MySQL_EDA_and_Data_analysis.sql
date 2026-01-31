Create database ivf_equipment ;

use ivf_equipment;

select * from ivf_equipment_utilization;
select * from ivf_equipment_master;

select count(*) as total_records from ivf_equipment_utilization;
describe ivf_equipment_utilization;

set sql_safe_updates = 0;
update ivf_equipment_utilization
set utilization_pct = utilization_pct * 100;
set sql_safe_updates = 1;

-- first business moment 
-- mean(avarage)  utilization across all equipment.

select 
avg(max_capacity_hrs) as avg_max_capacity_hrs,
avg(utilization_hrs) as avg_utilization_hrs,
avg(utilization_pct) as avg_utilizatin_percent,
avg(idle_hrs) as avg_idle_hrs,
avg(technical_downtime_hrs) as avg_techinical_downtime_hrs,
avg(planned_maintenance_hrs) as avg_planned_maintenance_hrs,
avg(workflow_delay_events) as avg_workflow_delay,
avg(avg_delay_minutes) as avg_delay_minutes,
avg(total_cases_day_lab) as avg_total_cases
from ivf_equipment_utilization;
 
 
 -- median (middle value) not affected by outliers.
select 
avg(max_capacity_hrs) as median_max_capacity,
avg(utilization_hrs) as avg_utilization_hrs,
avg(utilization_pct) as avg_utilizatin_percent,
avg(idle_hrs) as avg_idle_hrs,
avg(technical_downtime_hrs) as avg_techinical_downtime_hrs,
avg(planned_maintenance_hrs) as avg_planned_maintenance_hrs,
avg(workflow_delay_events) as avg_workflow_delay,
avg(avg_delay_minutes) as avg_delay_minutes,
avg(total_cases_day_lab) as avg_total_cases
from(
	select
		max_capacity_hrs, utilization_hrs, utilization_pct, idle_hrs,
        technical_downtime_hrs, planned_maintenance_hrs, workflow_delay_events,
        avg_delay_minutes, total_cases_day_lab,
        
        row_number() over (order by max_capacity_hrs) as m1,
        row_number() over (order by utilization_hrs) as m2,
        row_number() over (order by utilization_pct) as m3,
        row_number() over (order by idle_hrs) as m4,
        row_number() over (order by technical_downtime_hrs) as m5,
        row_number() over (order by planned_maintenance_hrs) as m6,
        row_number() over (order by workflow_delay_events) as m7,
        row_number() over (order by avg_delay_minutes) as m8,
        row_number() over (order by total_cases_day_lab) as m9,
        count(*) over () as cnt
	from ivf_equipment_utilization) t
where 
	m1 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m2 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m3 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m4 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or
    m5 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m6 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m7 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m8 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) or 
    m9 in (floor((cnt + 1)/2), ceil((cnt + 1)/2)) ;
 
-- mode (most repeted value)
select 
	(select max_capacity_hrs
    from ivf_equipment_utilization 
    group by max_capacity_hrs
    order by count(*) desc 
    limit 1) as mode_max_capacity_hrs,
    
    (select utilization_hrs
    from ivf_equipment_utilization
    group by utilization_hrs
    order by count(*) desc
    limit 1) as mode_utilication_hrs,
    
    (select utilization_pct
    from ivf_equipment_utilization
    group by utilization_pct
    order by count(*) desc 
    limit 1) as mode_utilization_pct,
    
    
	(select idle_hrs
    from ivf_equipment_utilization
    group by idle_hrs 
    order by count(*) desc
    limit 1) as mode_idle_hrs,
    
    (select  technical_downtime_hrs
    from ivf_equipment_utilization
    group by  technical_downtime_hrs 
    order by count(*) desc
    limit 1) as mode_technical_downtime_hrs,
    
    (select  planned_maintenance_hrs
    from ivf_equipment_utilization
    group by  planned_maintenance_hrs
    order by count(*) desc
    limit 1) as mode_planned_maintenance_hrs,
    
    (select workflow_delay_events
    from ivf_equipment_utilization 
    group by workflow_delay_events
    order by count(*) desc
    limit 1) as mode_workflow_delay_events,
    
    (select avg_delay_minutes
    from ivf_equipment_utilization
    group by avg_delay_minutes
    order by count(*) desc
    limit 1) as mode_avg_delay_minutes,
    
    (select total_cases_day_lab
    from ivf_equipment_utilization
    group by total_cases_day_lab
    order by count(*) desc 
    limit 1) as mode_total_cases_day_lab;
    

/* max_capacity_hrs, utilization_hrs, utilization_pct, idle_hrs,
        technical_downtime_hrs, planned_maintenance_hrs, workflow_delay_events,
        avg_delay_minutes, total_cases_day_lab, */
        
-- variance 
SELECT 
    VAR_POP(max_capacity_hrs) AS var_max_capacity_hrs,
    VAR_POP(utilization_hrs) AS var_utilization_hrs,
    var_pop(utilization_pct) as var_utilization_pct,
    var_pop(idle_hrs) as var_idle_hrs,
    var_pop(technical_downtime_hrs) as var_technical_downtime_hrs,
    var_pop(planned_maintenance_hrs) as var_planned_maintenance_hrs,
    var_pop(workflow_delay_events) as var_workflow_delay_events,
    var_pop(avg_delay_minutes) as var_avg_delay_minutes,
    var_pop(total_cases_day_lab) as var_total_cases_day_lab
from ivf_equipment_utilization;

-- deviation 
select 
	stddev_samp(max_capacity_hrs) as std_max_capacity_hrs,
    stddev_samp(utilization_hrs) as std_utilization_hrs,
    stddev_samp(utilization_pct) as std_utilization_pct,
    stddev_samp(idle_hrs) as std_idle_hrs,
    stddev_samp(technical_downtime_hrs) as std_technical_downtime_hrs,
    stddev_samp(planned_maintenance_hrs) as std_planned_maintenance_hrs,
    stddev_samp(workflow_delay_events) as std_workflow_delay_events,
    stddev_samp(avg_delay_minutes) as std_avg_delay_minutes,
    stddev_samp(total_cases_day_lab) as std_total_cases_day_lab
from ivf_equipment_utilization;

-- Range
select
	min(max_capacity_hrs) as min_max_capacty,
	max(max_capacity_hrs) as max_max_capacity,
    max(max_capacity_hrs) - min(max_capacity_hrs) as max_capacity_range,
        
    min(utilization_hrs) as min_utilization_hrs,
    max(utilization_hrs) as max_utilization_hrs,
    max(utilization_hrs) - min(utilization_hrs) as utilization_hrs_range,
    
    min(utilization_pct) as min_utilization_pct,
    max(utilization_pct) as max_utilization_pct,
    max(utilization_pct) - min(utilization_pct) as utilization_pct_range,
    
    min(idle_hrs) as min_idle_hrs,
    max(idle_hrs) as max_idle_hrs,
    max(idle_hrs) - min(idle_hrs) as idle_hrs_range,
    
    min(technical_downtime_hrs) as min_technical_downtime_hrs,
    max(technical_downtime_hrs) as max_technical_downtime_hrs,
    max(technical_downtime_hrs) - min(technical_downtime_hrs) as technical_downtime_hrs_range,
    
    min(planned_maintenance_hrs) as min_planned_maintenance_hrs,
    max(planned_maintenance_hrs) as max_planned_maintenance_hrs,
    max(planned_maintenance_hrs) - min(planned_maintenance_hrs) as planned_maintenance_hrs_range,
    
    min(workflow_delay_events) as min_workflow_delay_events,
    max(workflow_delay_events) as max_workflow_delay_events,
    max(workflow_delay_events) - min(workflow_delay_events) as workflow_delay_events_range,
    
    min(avg_delay_minutes) as min_avg_delay_minutes,
    max(avg_delay_minutes) as max_avg_delay_minutes,
    max(avg_delay_minutes) - min(avg_delay_minutes) as avg_delay_minutes_range,
    
    min(total_cases_day_lab) as min_total_cases_day_lab,
    max(total_cases_day_lab) as max_total_cases_day_lab,
    max(total_cases_day_lab) - min(total_cases_day_lab) as total_cases_day_lab_range
from ivf_equipment_utilization;



-- skewness 
select 
	(select 
		avg(power(max_capacity_hrs - avg_m, 3))/
		power(stddev_samp(max_capacity_hrs), 3)
	from ivf_equipment_utilization,
    (select avg(max_capacity_hrs) as avg_m from ivf_equipment_utilization) a
    ) as skew_max_capacity_hrs,
    
	(select
		avg(power(utilization_hrs - avg_uh, 3))/
        power(stddev_samp(utilization_hrs), 3)
	from ivf_equipment_utilization,
    (select avg(utilization_hrs) as avg_uh from ivf_equipment_utilization) b
    ) as skew_utilization_hrs,
    
    (select
		avg(power(utilization_pct - avg_up, 3))/
        power(stddev_samp(utilization_pct), 3)
	from ivf_equipment_utilization,
    (select avg(utilization_pct) as avg_up from ivf_equipment_utilization) c
    ) as skew_utilization_pct,
    
    (select 
		avg(power(idle_hrs - avg_i, 3)) /
        power(stddev_samp(idle_hrs), 3)
	from ivf_equipment_utilization,
	(select avg(idle_hrs) as avg_i from ivf_equipment_utilization) d
    ) as skew_idle_hrs,
    
    (select 
		avg(power(technical_downtime_hrs - avg_t, 3)) /
        power(stddev_samp(technical_downtime_hrs), 3)
	from ivf_equipment_utilization, 
    (select avg(technical_downtime_hrs) as avg_t from ivf_equipment_utilization) e
    ) as skew_technical_downtime_hrs,
    
    (select
		avg(power(planned_maintenance_hrs - avg_p, 3)) /
        power(stddev_samp(planned_maintenance_hrs), 3)
	from ivf_equipment_utilization,
    (select avg(planned_maintenance_hrs) as avg_p from ivf_equipment_utilization) f
    ) as skwe_planned_maintenance_hrs,
    
    (select 
		avg(power(workflow_delay_events - avg_w, 3))/
        power(stddev_samp(workflow_delay_events), 3)
	from ivf_equipment_utilization,
    (select avg(workflow_delay_events) as avg_w from ivf_equipment_utilization) g
    ) as skwe_workflow_delay_events,
    
    (select
		avg(power(avg_delay_minutes - avg_a, 3))/
        power(stddev_samp(avg_delay_minutes), 3)
	from ivf_equipment_utilization,
    (select avg(avg_delay_minutes) as avg_a from ivf_equipment_utilization) h
    ) as skew_avg_delay_minutes,
    
    (select
		avg(power(total_cases_day_lab - avg_t, 3))/
        power(stddev_samp(total_cases_day_lab), 3)
	from ivf_equipment_utilization,
    (select avg(total_cases_day_lab) as avg_t from ivf_equipment_utilization) i 
    ) as skew_total_cases_day_lab;
    

-- kurtosis 
select
	(select
		avg(power(max_capacity_hrs - avg_m, 4))/
		power(stddev_pop(max_capacity_hrs), 4) - 3
	from ivf_equipment_utilization,
       (select avg(max_capacity_hrs) as avg_m  from ivf_equipment_utilization) a
	) as kurto_max_capacity_hrs,
      
	(select
		avg(power(utilization_hrs - avg_u, 4))/
        power(stddev_pop(utilization_hrs), 4) - 3
	from ivf_equipment_utilization,
		(select avg(utilization_hrs) as avg_u from ivf_equipment_utilization) b
	) as kurto_utilization_hrs,
    
	(select
		avg(power(utilization_pct - avg_ut, 4))/
        power(stddev_pop(utilization_pct),  4) - 3
	from ivf_equipment_utilization,
		(select avg(utilization_pct) as avg_ut from ivf_equipment_utilization) c
	) as kurto_utilization_pct,
    
	(select
		avg(power(utilization_pct - avg_u, 4))/
        power(stddev_pop(utilization_pct), 4) - 3
	from ivf_equipment_utilization,
		(select avg(utilization_pct) as avg_u from ivf_equipment_utilization) c
	) as kurto_utilization_pct,
    
	(select 
		avg(power(idle_hrs - avg_i, 4))/
        power(stddev_pop(idle_hrs), 4) - 3
	from ivf_equipment_utilization,
		(select avg(idle_hrs) as avg_i from ivf_equipment_utilization) d
	) as kurto_idle_hrs,
    
	(select
		avg(power(technical_downtime_hrs - avg_t, 4))/
        power(stddev_pop(technical_downtime_hrs), 4) - 3
	from ivf_equipment_utilization,
		(select avg(technical_downtime_hrs) as avg_t from ivf_equipment_utilization) e 
	) as kurto_technical_downtime_hrs,
    
   (select
		avg(power(planned_maintenance_hrs - avg_p, 4))/
		power(stddev_pop(planned_maintenance_hrs), 4) - 3
    from ivf_equipment_utilization,
		(select avg(planned_maintenance_hrs) as avg_p from ivf_equipment_utilization) f
	) as kurto_planned_maintenance_hrs,
    
    (select 
		avg(power(workflow_delay_events - avg_w, 4))/
        power(stddev_pop(workflow_delay_events), 4) - 3
	from ivf_equipment_utilization,
		(select avg(workflow_delay_events) as avg_w from ivf_equipment_utilization) g
	) as kurto_workflow_delay_events,
        
    (select
		avg(power(avg_delay_minutes - avg_d, 4))/
        power(stddev_pop(avg_delay_minutes), 4) - 3 
	from ivf_equipment_utilization,
		(select avg(avg_delay_minutes) as avg_d from ivf_equipment_utilization) h
	)as kurto_avg_delay_minutes,
    
    (select 
		avg(power(total_cases_day_lab - avg_t, 4))/
        power(stddev_pop(total_cases_day_lab), 4) - 3
	from ivf_equipment_utilization,
		(select avg(total_cases_day_lab) as avg_t from ivf_equipment_utilization) i
	) as kurto_total_cases_day_lab;
    

-- EDA operations 
select * from ivf_equipment_utilization;

/*  date, iab_id, equipment_id, max_capacity_hrs, utilization_hrs, utilization_pct, idle_hrs,
        technical_downtime_hrs, planned_maintenance_hrs, workflow_delay_events,
        avg_delay_minutes, primary_procedure, redundancy_avaliable, total_cases_day_lab, */

-- null check
select 
	sum(date is null) as null_date,
    sum(lab_id is null) as null_lab_id,
    sum(equipment_id is null) as null_equipment_id,
	sum(max_capacity_hrs is null) as null_max_capacity,
    sum(utilization_hrs is null) as null_utilization_hrs,
    sum(utilization_pct is null) as null_utilization_pct,
    sum(idle_hrs is null) as null_idle_hrs,
	sum(technical_downtime_hrs is null) as null_technical_downtime,
    sum(planned_maintenance_hrs is null) as null_planned_maintenance,
    sum(workflow_delay_events is null) as null_workflow,
	sum(avg_delay_minutes is null) as null_avg_delay_min,
    sum(primary_procedure is null) as null_primary_procedure,
    sum(redundancy_available is null) as null_redundancy_aval,
    sum(total_cases_day_lab is null) as null_total_cases_day
from ivf_equipment_utilization;

select * from ivf_equipment_utilization
	where trim(utilization_hrs) = ' '
	 or trim(utilization_pct) = ' ' 
     or trim(idle_hrs) = ' ';
   

-- duplicates 
 select
	 count(*) - count(distinct date) as dup_date,
	 count(*) - count(distinct lab_id) as dup_lab_id,
     count(*) - count(distinct equipment_id) as dup_eqipment_id,
     count(*) - count(distinct max_capacity_hrs) as dup_max_capacity,
     count(*) - count(distinct utilization_hrs) as dup_utilization_hrs,
     count(*) - count(distinct utilization_pct) as dup_utilization_ptc,
     count(*) - count(distinct idle_hrs) as dup_idle_hrs,
     count(*) - count(distinct technical_downtime_hrs) as dup_technical_downtime,
     count(*) - count(distinct planned_maintenance_hrs) as dup_planned_maintenance,
     count(*) - count(distinct workflow_delay_events) as dup_workflow_dely,
     count(*) - count(distinct avg_delay_minutes) as dup_avg_delay_min,
     count(*) - count(distinct primary_procedure) as dup_primary_procedure,
     count(*) - count(distinct redundancy_available) as dup_redundancy,
     count(*) - count(distinct total_cases_day_lab) as dup_tatal_cases
from ivf_equipment_utilization;

use ivf_equipment;

-- find quartiles
WITH quartiles AS (
    SELECT
        max_capacity_hrs,
        NTILE(4) OVER (ORDER BY max_capacity_hrs) AS tile
    FROM ivf_equipment_utilization
)
SELECT
    MAX(CASE WHEN tile = 1 THEN max_capacity_hrs END) AS Q1,
    MIN(CASE WHEN tile = 4 THEN max_capacity_hrs END) AS Q3
FROM quartiles;

WITH quartiles AS (
    SELECT
        max_capacity_hrs,
        NTILE(4) OVER (ORDER BY max_capacity_hrs) AS tile
    FROM ivf_equipment_utilization
),
bounds AS (
    SELECT
        MAX(CASE WHEN tile = 1 THEN max_capacity_hrs END) AS Q1,
        MIN(CASE WHEN tile = 4 THEN max_capacity_hrs END) AS Q3
    FROM quartiles
)
SELECT *
FROM ivf_equipment_utilization, bounds
WHERE max_capacity_hrs < Q1 - 1.5 * (Q3 - Q1)
   OR max_capacity_hrs > Q3 + 1.5 * (Q3 - Q1);





select * from ivf_equipment_utilization;

-- bivariate analysis
-- utilization va idle time 
select 
	avg(utilization_pct) as avg_utilization,
    avg(idle_hrs) as avg_idle
from ivf_equipment_utilization 
group by equipment_id;


-- downtime impact on utilization 
select 
	technical_downtime_hrs,
    avg(utilization_pct) as avg_utilization 
from ivf_equipment_utilization 
group by technical_downtime_hrs;


-- Time based analysis 
-- daily utilization trend 
select 
	date,
    avg(utilization_pct) as daily_utilization
from ivf_equipment_utilization
group by date 
order by date;

-- peak load days
select 
	date,
    sum(total_cases_day_lab) as tatal_cases
from ivf_equipment_utilization
group by date 
order by tatal_cases desc;


-- operational efficiency analysis 
-- equipment under utilization 
select 
	equipment_id,
    utilization_pct
from ivf_equipment_utilization
where utilization_pct < 50;

-- effect of redundancy
select 
	redundancy_available,
    avg(utilization_pct) as avg_utilization 
from ivf_equipment_utilization
group by redundancy_available; 


-- workflow & delay Analysis
-- avarage delay by procedure
select 
	primary_procedure,
    avg(avg_delay_minutes) as avg_delay
from ivf_equipment_utilization
group by primary_procedure;

-- high delay equipment
select 
	equipment_id,
    avg(avg_delay_minutes) as avg_delay
from ivf_equipment_wtilization
group by equipment_id
having avg_delay > 30;



select * from data_set;
