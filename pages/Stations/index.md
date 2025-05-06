---
title: Stations
description: 
hide_title: true
---

## My Weather Stations


```sql stations
SELECT 
    '01' AS station_id,
    30.0626 AS latitude,
    31.4916 AS longitude,
    'Indoor' AS station_type,
    's3://us-west-2.opendata.source.coop/youssef-harby/weather-station-realtime-parquet/parquet/station=01/' AS storage_url;
```

<DataTable
  data={stations}
  title="Weather Stations"
  columns={[
    { key: 'station_id', name: 'Station ID' },
    { key: 'latitude', name: 'Latitude' },
    { key: 'longitude', name: 'Longitude' },
    { key: 'station_type', name: 'Station Type' },
    { key: 'storage_url', name: 'Storage URL' }
  ]}
/>

<PointMap 
    data={stations} 
    lat=latitude 
    long=longitude  
    pointName=station_id 
    height=200
/>