---
title: Atmospheric Pressure
---

<LastRefreshed/>

<Details title='About this dashboard'>
  This dashboard analyzes atmospheric pressure data from My DIY weather station (Cloud Native way). You can select a date range to view specific data.
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

## Pressure Statistics Summary

```sql main_data
-- Get the base pressure data we need
select
  timestamp,
  pressure
from station_01
where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
```

```sql summary_stats
select
  round(min(pressure), 2) as min_pressure,
  round(max(pressure), 2) as max_pressure,
  round(avg(pressure), 2) as avg_pressure
from ${main_data}
```

<DataTable
  data={summary_stats}
  title="Pressure Statistics Summary (hPa)"
/>

## Pressure Over Time

```sql pressure_extremes
select
  timestamp,
  pressure,
  case
    when pressure = (select max(pressure) from ${main_data})
    then 'Highest: ' || round(pressure, 1) || ' hPa'
    when pressure = (select min(pressure) from ${main_data})
    then 'Lowest: ' || round(pressure, 1) || ' hPa'
  end as label
from ${main_data}
where pressure = (select max(pressure) from ${main_data})
   or pressure = (select min(pressure) from ${main_data})
```

<LineChart
  data={main_data}
  x=timestamp
  y=pressure
  yAxisTitle="Pressure (hPa)"
  title="Atmospheric Pressure Over Time"
  subtitle="Pressure readings from weather station"
  markers=true
  markerSize=4
  lineWidth=2
  chartAreaHeight=250
  xFmt="yyyy-MM-dd HH:mm:ss"
  step=true
  echartsOptions={{
      dataZoom: {
          show: true,
          bottom: 10
      },
      grid: {
          bottom: 50
      }
  }}
>
  <ReferenceLine y={1013.25} label="Standard Pressure" color=neutral lineType=dashed hideValue=true/>
  <ReferencePoint 
    data={pressure_extremes} 
    x=timestamp 
    y=pressure 
    label=label 
    labelPosition=top 
    color=negative 
    symbolSize=8
  />
</LineChart>
