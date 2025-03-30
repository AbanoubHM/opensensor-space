---
title: Temperature and Humidity
---

<Details title='About this dashboard'>
  This dashboard analyzes My DIY weather station data. You can select a date range to view specific data points from station 01.
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
  presetRanges={['Last 7 Days', 'Last 30 Days', 'Month to Date', 'Year to Date', 'All Time']}
  defaultValue={'Last 7 Days'}
/>

# Weather Station Data: {inputs.date_filter.start} to {inputs.date_filter.end}

## Weather Station Information

Weather station is located at coordinates: 30.0626, 31.4916

## Weather Statistics Summary

```sql summary_stats
  select
    round(min(temperature), 2) as min_temp,
    round(max(temperature), 2) as max_temp,
    round(avg(temperature), 2) as avg_temp,
    round(min(humidity), 2) as min_humidity,
    round(max(humidity), 2) as max_humidity,
    round(avg(humidity), 2) as avg_humidity,
    round(min(pressure), 2) as min_pressure,
    round(max(pressure), 2) as max_pressure,
    round(avg(pressure), 2) as avg_pressure
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
```

<DataTable
  data={summary_stats}
  title="Weather Statistics Summary"
/>

```sql weather_data
  select
    timestamp,
    temperature,
    humidity
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
  order by timestamp
```

```sql temp_extremes
  select
    timestamp,
    temperature,
    case
      when temperature = (select max(temperature) from station_01 
                          where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      then 'Highest: ' || round(temperature, 1) || '°C'
      when temperature = (select min(temperature) from station_01 
                          where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      then 'Lowest: ' || round(temperature, 1) || '°C'
    end as label
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
    and (
      temperature = (select max(temperature) from station_01 
                     where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      or
      temperature = (select min(temperature) from station_01 
                     where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
    )
```

```sql humidity_extremes
  select
    timestamp,
    humidity,
    case
      when humidity = (select max(humidity) from station_01 
                       where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      then 'Highest: ' || round(humidity, 1) || '%'
      when humidity = (select min(humidity) from station_01 
                       where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      then 'Lowest: ' || round(humidity, 1) || '%'
    end as label
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
    and (
      humidity = (select max(humidity) from station_01 
                  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
      or
      humidity = (select min(humidity) from station_01 
                  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}')
    )
```

## Temperature Over Time

<LineChart
  data={weather_data}
  x=timestamp
  y=temperature
  yAxisTitle="Temperature (°C)"
  title="Temperature Over Time"
  subtitle="Temperature readings from weather station"
  markers=true
  markerSize=4
  lineWidth=2
  chartAreaHeight=250
  xFmt="yyyy-MM-dd HH:mm:ss"
  step=true
>
  <ReferenceLine y={25} label="Comfort Upper Limit" color=warning lineType=dashed hideValue=true/>
  <ReferenceLine y={18} label="Comfort Lower Limit" color=info lineType=dashed hideValue=true/>
  <ReferenceArea yMin={18} yMax={25} label="Comfort Zone" color=positive opacity=0.1 labelPosition=right/>
  <ReferencePoint 
    data={temp_extremes} 
    x=timestamp 
    y=temperature 
    label=label 
    labelPosition=top 
    color=negative 
    symbolSize=8
  />
  <Callout 
    x={summary_stats[0].max_temp > 25 ? summary_stats[0].max_temp : 26} 
    y={25} 
    labelPosition=right 
    labelWidth=150
    color=warning
  >
    Temperatures above 25°C
    may cause discomfort
  </Callout>
</LineChart>

## Humidity Over Time

<LineChart
  data={weather_data}
  x=timestamp
  y=humidity
  yAxisTitle="Humidity (%)"
  title="Humidity Over Time"
  subtitle="Humidity readings from weather station"
  markers=true
  markerSize=4
  lineWidth=2
  chartAreaHeight=250
  xFmt="yyyy-MM-dd HH:mm:ss"
  color=info
  step=true
>
  <ReferenceLine y={60} label="High Humidity" color=negative lineType=dashed hideValue=true/>
  <ReferenceLine y={30} label="Low Humidity" color=warning lineType=dashed hideValue=true/>
  <ReferenceArea yMin={30} yMax={60} label="Comfort Zone" color=positive opacity=0.1 labelPosition=right/>
  <ReferencePoint 
    data={humidity_extremes} 
    x=timestamp 
    y=humidity 
    label=label 
    labelPosition=top 
    color=negative 
    symbolSize=8
  />
  <Callout 
    x={summary_stats[0].max_humidity > 60 ? summary_stats[0].max_humidity : 65} 
    y={60} 
    labelPosition=right 
    labelWidth=150
    color=negative
  >
    High humidity can cause
    mold growth and discomfort
  </Callout>
</LineChart>

## Temperature and Humidity Stacked View

```sql stacked_weather_data
  select
    timestamp,
    temperature,
    humidity,
    'Temperature' as metric_type
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
  
  UNION ALL
  
  select
    timestamp,
    humidity as temperature,
    humidity,
    'Humidity' as metric_type
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
  order by timestamp, metric_type
```

<LineChart
  data={stacked_weather_data}
  x=timestamp
  y=temperature
  series=metric_type
  title="Temperature and Humidity Stacked View"
  subtitle="Combined view showing both metrics"
  markers=true
  markerSize=3
  lineWidth=2
  chartAreaHeight=300
  xFmt="yyyy-MM-dd HH:mm:ss"
  yAxisTitle="Value"
  step=true
>
  <ReferenceLine y={25} label="Temp Comfort Upper" color=warning lineType=dashed hideValue=true/>
  <ReferenceLine y={18} label="Temp Comfort Lower" color=info lineType=dashed hideValue=true/>
  <ReferenceLine y={60} label="Humidity Upper" color=negative lineType=dotted hideValue=true/>
  <ReferenceLine y={30} label="Humidity Lower" color=warning lineType=dotted hideValue=true/>
</LineChart>

## Temperature vs Humidity

```sql temp_vs_humidity
  select 
    date_trunc('hour', timestamp) as hour,
    extract('hour' from timestamp) as hour_of_day,
    date_trunc('day', timestamp)::string as day,
    avg(temperature) as temperature,
    avg(humidity) as humidity
  from station_01
  where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
  group by 
    date_trunc('hour', timestamp),
    extract('hour' from timestamp),
    date_trunc('day', timestamp)::string
  order by hour
```

```sql regression
WITH 
coeffs AS (
    SELECT
        regr_slope(humidity, temperature) AS slope,
        regr_intercept(humidity, temperature) AS intercept,
        regr_r2(humidity, temperature) AS r_squared
    FROM ${temp_vs_humidity}
)

SELECT 
    min(temperature) AS x, 
    max(temperature) AS x2, 
    min(temperature) * slope + intercept AS y, 
    max(temperature) * slope + intercept AS y2, 
    'Trend: ' || ROUND(slope, 2) || 'x + ' || ROUND(intercept, 2) || ' (R² = ' || ROUND(r_squared, 3) || ')' AS label
FROM coeffs, ${temp_vs_humidity}
GROUP BY slope, intercept, r_squared
```

<ScatterPlot
  data={temp_vs_humidity}
  x=temperature
  y=humidity
  series=day
  tooltipTitle=hour
  xAxisTitle="Temperature (°C)"
  yAxisTitle="Humidity (%)"
  title="Temperature vs Humidity Correlation by Day"
  pointSize=12
  shape="circle"
>
  <ReferenceArea xMin={18} xMax={25} yMin={30} yMax={60} label="Comfort Zone" color=positive opacity=0.1 border=true/>
  <ReferenceLine data={regression} x=x y=y x2=x2 y2=y2 label=label color=base-content-muted lineType=solid/>
  <Callout x={22} y={75} labelPosition=top labelWidth=150>
    High humidity with moderate temperature
    indicates potential discomfort
  </Callout>
  <Callout x={15} y={20} labelPosition=bottom labelWidth=150>
    Low humidity with low temperature
    can cause dry skin and respiratory issues
  </Callout>
</ScatterPlot>