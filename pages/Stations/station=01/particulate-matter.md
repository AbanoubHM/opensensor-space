---
title: Particulate Matter Analysis
---

<LastRefreshed/>

<Details title='About this dashboard'>
  This dashboard shows particulate matter measurements from the PMS5003 sensor, which began collecting data on April 4, 2025.
</Details>

```sql date_range_data
select 
  (min(timestamp)) as min_date,
  (max(timestamp)) as max_date
from station_01
```

<DateRange
  name=date_filter
  data={date_range_data}
  dates=min_date
  end={date_range_data[0].max_date}
  title="Select Date Range"
  presetRanges={['Last 7 Days', 'Last 30 Days', 'All Time']}
  defaultValue={'All Time'}
/>

## Particulate Matter Concentrations

```sql pm_hourly
-- Get hourly PM data with adjusted date range
select
  date_trunc('hour', timestamp) as hour,
  round(avg(pm1), 1) as pm1,
  round(avg(pm2_5), 1) as pm2_5,
  round(avg(pm10), 1) as pm10
from station_01
where 
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  and (pm1 is not null or pm2_5 is not null or pm10 is not null)
group by 1
order by 1
```

<LineChart 
  data={pm_hourly}
  x=hour
  y={["pm1", "pm2_5", "pm10"]}
  title="Hourly Particulate Matter Concentrations"
  yAxisTitle="Concentration (μg/m³)"
/>

## Particle Count by Size

```sql particle_counts
-- Get hourly particle counts with adjusted date range
SELECT
  date_trunc('hour', timestamp) as hour,
  round(avg(particles_03um)) as "0.3μm",
  round(avg(particles_05um)) as "0.5μm", 
  round(avg(particles_10um)) as "1.0μm"
FROM station_01
WHERE
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  and (particles_03um is not null or particles_05um is not null or particles_10um is not null)
GROUP BY 1
ORDER BY 1
```

<LineChart
  data={particle_counts}
  x=hour
  y={["0.3μm", "0.5μm", "1.0μm"]}
  title="Particle Counts - Small Particles"
  yAxisTitle="Particles per 0.1L of air"
/>

```sql large_particle_counts
-- Get hourly large particle counts with adjusted date range
SELECT
  date_trunc('hour', timestamp) as hour,
  round(avg(particles_25um)) as "2.5μm",
  round(avg(particles_50um)) as "5.0μm",
  round(avg(particles_100um)) as "10.0μm"
FROM station_01
WHERE
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  and (particles_25um is not null or particles_50um is not null or particles_100um is not null)
GROUP BY 1
ORDER BY 1
```

<LineChart
  data={large_particle_counts}
  x=hour
  y={["2.5μm", "5.0μm", "10.0μm"]}
  title="Particle Counts - Large Particles"
  yAxisTitle="Particles per 0.1L of air"
/>

## Daily Average Trends

```sql daily_pm
-- Daily average PM data with adjusted date range
select
  date_trunc('day', timestamp) as day,
  round(avg(pm1), 1) as pm1,
  round(avg(pm2_5), 1) as pm2_5,
  round(avg(pm10), 1) as pm10
from station_01
where 
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  and (pm1 is not null or pm2_5 is not null or pm10 is not null)
group by 1
order by 1
```

<LineChart 
  data={daily_pm}
  x=day
  y={["pm1", "pm2_5", "pm10"]}
  title="Daily Average Particulate Matter"
  yAxisTitle="Concentration (μg/m³)"
/>

## Latest Measurements

```sql latest_measurements
-- Get the latest measurements
SELECT
  timestamp,
  round(pm1, 1) as pm1,
  round(pm2_5, 1) as pm2_5,
  round(pm10, 1) as pm10,
  round(particles_03um) as "0.3μm",
  round(particles_05um) as "0.5μm",
  round(particles_10um) as "1.0μm",
  round(particles_25um) as "2.5μm",
  round(particles_50um) as "5.0μm",
  round(particles_100um) as "10.0μm"
FROM station_01
WHERE
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  AND (pm1 IS NOT NULL OR pm2_5 IS NOT NULL OR pm10 IS NOT NULL)
ORDER BY timestamp DESC
LIMIT 5
```

<DataTable
  data={latest_measurements}
  title="Latest Particulate Matter Readings"
/>