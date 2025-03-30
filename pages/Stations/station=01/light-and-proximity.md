---
title: Light and Proximity
---
<LastRefreshed/>

<Details title='About this dashboard'>
  This dashboard analyzes light (Lux) and proximity sensor readings from My DIY weather station. You can select a date range to view specific data.
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

## Sensor Statistics Summary

```sql main_data
-- Get the base light and proximity data we need
select
  timestamp,
  lux,
  proximity
from station_01
where timestamp::date between '${inputs.date_filter.start}' and '${inputs.date_filter.end}'
```

```sql summary_stats
select
  round(min(lux), 2) as min_lux,
  round(max(lux), 2) as max_lux,
  round(avg(lux), 2) as avg_lux,
  round(min(proximity), 2) as min_proximity,
  round(max(proximity), 2) as max_proximity,
  round(avg(proximity), 2) as avg_proximity
from ${main_data}
```

<DataTable
  data={summary_stats}
  title="Light (Lux) and Proximity Statistics Summary"
/>

## Light Level (Lux) Over Time

```sql lux_extremes
select
  timestamp,
  lux,
  case
    when lux = (select max(lux) from ${main_data})
    then 'Brightest: ' || round(lux, 1) || ' Lux'
    when lux = (select min(lux) from ${main_data})
    then 'Darkest: ' || round(lux, 1) || ' Lux'
  end as label
from ${main_data}
where lux = (select max(lux) from ${main_data})
   or lux = (select min(lux) from ${main_data})
```

<LineChart
  data={main_data}
  x=timestamp
  y=lux
  yAxisTitle="Light Level (Lux)"
  title="Light Level Over Time"
  subtitle="Light sensor readings from weather station"
  markers=true
  markerSize=4
  lineWidth=2
  chartAreaHeight=250
  xFmt="yyyy-MM-dd HH:mm:ss"
  step=true
  color=accent
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
  <ReferencePoint 
    data={lux_extremes} 
    x=timestamp 
    y=lux 
    label=label 
    labelPosition=top 
    color=negative 
    symbolSize=8
  />
</LineChart>

## Proximity Sensor Reading Over Time

```sql proximity_extremes
select
  timestamp,
  proximity,
  case
    when proximity = (select max(proximity) from ${main_data})
    then 'Highest Value: ' || round(proximity, 1)
    when proximity = (select min(proximity) from ${main_data})
    then 'Lowest Value: ' || round(proximity, 1)
  end as label
from ${main_data}
where proximity = (select max(proximity) from ${main_data})
   or proximity = (select min(proximity) from ${main_data})
```

<LineChart
  data={main_data}
  x=timestamp
  y=proximity
  yAxisTitle="Proximity Reading"
  title="Proximity Sensor Readings Over Time"
  subtitle="Proximity sensor readings (interpretation depends on sensor)"
  markers=true
  markerSize=4
  lineWidth=2
  chartAreaHeight=250
  xFmt="yyyy-MM-dd HH:mm:ss"
  step=true
  color=neutral
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
  <ReferencePoint 
    data={proximity_extremes} 
    x=timestamp 
    y=proximity 
    label=label 
    labelPosition=top 
    color=negative 
    symbolSize=8
  />
</LineChart>
