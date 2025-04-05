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
  yAxisTitle="Concentration (micrograms/m³)"
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
  yAxisTitle="Concentration (micrograms/m³)"
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

## 24-Hour Mean Analysis & Air Quality Insights

```sql pm_24hr_mean
-- Calculate 24-hour rolling mean for PM metrics
SELECT
  date_trunc('hour', timestamp) as hour,
  round(avg(pm1) OVER (
    ORDER BY date_trunc('hour', timestamp)
    ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
  ), 1) as pm1_24hr_mean,
  round(avg(pm2_5) OVER (
    ORDER BY date_trunc('hour', timestamp)
    ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
  ), 1) as pm2_5_24hr_mean,
  round(avg(pm10) OVER (
    ORDER BY date_trunc('hour', timestamp)
    ROWS BETWEEN 23 PRECEDING AND CURRENT ROW
  ), 1) as pm10_24hr_mean
FROM (
  SELECT
    date_trunc('hour', timestamp) as timestamp,
    avg(pm1) as pm1,
    avg(pm2_5) as pm2_5,
    avg(pm10) as pm10
  FROM station_01
  WHERE 
    timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
    and (pm1 is not null or pm2_5 is not null or pm10 is not null)
  GROUP BY date_trunc('hour', timestamp)
) AS hourly_data
WHERE hour >= (SELECT date_trunc('hour', min(timestamp)) + INTERVAL '23 hours' FROM station_01)
ORDER BY hour
```

<LineChart 
  data={pm_24hr_mean}
  x=hour
  y={["pm1_24hr_mean", "pm2_5_24hr_mean", "pm10_24hr_mean"]}
  title="24-Hour Rolling Mean of Particulate Matter"
  subtitle="Each point represents the average over the preceding 24 hours"
  yAxisTitle="Concentration (micrograms/m³)"
>
  <ReferenceLine y={10} label="WHO PM2.5 Guideline (10 micrograms/m³)" color=warning lineType=dashed/>
  <ReferenceLine y={20} label="WHO PM10 Guideline (20 micrograms/m³)" color=negative lineType=dashed/>
</LineChart>

```sql current_24hr_means
-- Calculate current 24-hour mean values
SELECT
  round(avg(pm1), 1) as pm1_mean,
  round(avg(pm2_5), 1) as pm2_5_mean,
  round(avg(pm10), 1) as pm10_mean,
  CASE
    WHEN avg(pm2_5) <= 12 AND avg(pm10) <= 20 THEN 'Good'
    WHEN avg(pm2_5) <= 35.4 AND avg(pm10) <= 50 THEN 'Moderate'
    WHEN avg(pm2_5) <= 55.4 AND avg(pm10) <= 100 THEN 'Unhealthy for Sensitive Groups'
    WHEN avg(pm2_5) <= 150.4 AND avg(pm10) <= 200 THEN 'Unhealthy'
    WHEN avg(pm2_5) <= 250.4 AND avg(pm10) <= 300 THEN 'Very Unhealthy'
    WHEN avg(pm2_5) > 250.4 OR avg(pm10) > 300 THEN 'Hazardous'
    ELSE 'Insufficient Data'
  END as air_quality_category,
  'Based on 24-hour mean PM2.5 and PM10 values' as aqi_note
FROM station_01
WHERE 
  timestamp >= (SELECT max(timestamp) - INTERVAL '24 hours' FROM station_01)
```

<BigValue
  data={current_24hr_means}
  value=air_quality_category
  title="Current Air Quality Index (AQI) Category"
  subtitle="Based on 24-hour mean PM2.5 and PM10 values"
/>

```sql aqi_card_data
-- Format the mean values for cards with colored indicators
SELECT
  pm1_mean,
  pm2_5_mean,
  pm10_mean,
  CASE
    WHEN pm2_5_mean <= 12 THEN 'positive'
    WHEN pm2_5_mean <= 35.4 THEN 'warning'
    ELSE 'negative'
  END as pm2_5_color,
  CASE
    WHEN pm10_mean <= 20 THEN 'positive'
    WHEN pm10_mean <= 50 THEN 'warning'
    ELSE 'negative'
  END as pm10_color
FROM ${current_24hr_means}
```

### 24-Hour Mean Values

<BigValue
  data={aqi_card_data}
  value=pm1_mean
  title="PM1 24hr Mean"
  subtitle="micrograms/m³"
/>

<BigValue
  data={aqi_card_data}
  value=pm2_5_mean
  title="PM2.5 24hr Mean"
  subtitle="micrograms/m³"
  color=pm2_5_color
/>

<BigValue
  data={aqi_card_data}
  value=pm10_mean
  title="PM10 24hr Mean"
  subtitle="micrograms/m³"
  color=pm10_color
/>

```sql hourly_pattern
-- Calculate average PM levels by hour of day
SELECT
  date_part('hour', timestamp) as hour_of_day,
  round(avg(pm1), 1) as avg_pm1,
  round(avg(pm2_5), 1) as avg_pm2_5,
  round(avg(pm10), 1) as avg_pm10
FROM station_01
WHERE
  timestamp::date between '${inputs.date_filter.start}' and ('${inputs.date_filter.end}'::date + INTERVAL '1 day')
  AND (pm1 IS NOT NULL OR pm2_5 IS NOT NULL OR pm10 IS NOT NULL)
GROUP BY hour_of_day
ORDER BY hour_of_day
```

<LineChart
  data={hourly_pattern}
  x=hour_of_day
  y={["avg_pm1", "avg_pm2_5", "avg_pm10"]}
  title="Average PM Levels by Hour of Day"
  subtitle="Shows when particulate matter tends to be highest and lowest"
  yAxisTitle="Concentration (micrograms/m³)"
  xAxisTitle="Hour of Day (24h)"
/>

<Details title='Understanding Particulate Matter and Air Quality'>
  ## Particulate Matter Explained
  
  - **PM1**: Ultra-fine particles (diameter less than 1 micrometer) that can penetrate deep into lungs and potentially enter bloodstream
  - **PM2.5**: Fine inhalable particles (diameter less than 2.5 micrometers) that pose the greatest health risks
  - **PM10**: Coarse inhalable particles (diameter less than 10 micrometers)
  
  ## Air Quality Guidelines
  
  The World Health Organization (WHO) guidelines for 24-hour mean concentrations:
  - **PM2.5**: 15 micrograms/m³ (2021 updated guideline)
  - **PM10**: 45 micrograms/m³ (2021 updated guideline)
  
  ## Health Impacts
  
  - **Good** (PM2.5 &le; 12 micrograms/m³): Little to no risk
  - **Moderate** (PM2.5 12-35.4 micrograms/m³): Unusually sensitive individuals may experience respiratory symptoms
  - **Unhealthy for Sensitive Groups** (PM2.5 35.5-55.4 micrograms/m³): People with respiratory or heart conditions, the elderly and children should limit prolonged outdoor exertion
  - **Unhealthy** (PM2.5 55.5-150.4 micrograms/m³): Everyone may begin to experience health effects; sensitive groups should avoid outdoor activity
  - **Very Unhealthy** and **Hazardous**: Health warnings of emergency conditions for the entire population
</Details>