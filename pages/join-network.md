---
title: Join the Weather Station Network
description: Build your own cloud-native weather station and contribute to the network
---

This project is designed to be easily replicated and expanded into a community-driven environmental monitoring network. I welcome contributions from anyone interested in setting up their own weather station and sharing the data.

## How to Participate

1. **Build your own station** - Follow the setup instructions in this page
2. **Choose your storage** - Use [Source Cooperative](https://source.coop) or your own S3-compatible storage
3. **Submit a PR** - Add your station to the network with your station ID (UUID), location coordinates, and storage URL
4. **Share your insights** - Contribute dashboard improvements or custom visualizations

## Benefits of Contributing

By creating a distributed network of weather stations using this architecture, we can build a more comprehensive picture of environmental conditions across different locations while maintaining individual ownership of the data collection points.

## Required Hardware Components

<Grid cols=2>
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/raspberry-pi-zero-2-w?variant=42101934587987" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/files/PiZ2WHfront_0abdb823-7474-4aa9-bffa-4990fe440574_768x768_crop_center.png?v=1723211856" alt="Raspberry Pi Zero 2 W" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">Raspberry Pi Zero 2 W + Headers</h3>
      <p class="text-xs text-center mt-1">The brain of your weather station</p>
    </a>
  </div>
  
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/raspberry-pi-12-5w-micro-usb-power-supply?variant=39493050237011" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/products/PSU_UK_768x768_crop_center.jpg?v=1635179995" alt="Raspberry Pi Power Supply" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">Raspberry Pi 12.5W Micro USB Power Supply</h3>
      <p class="text-xs text-center mt-1">For Pi Zero 2 W (or any compatible power supply)</p>
    </a>
  </div>
  
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/zero-adaptor-kit?variant=10462230279" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/products/Zero_2_of_5_daabacb7-b187-4089-86c7-575aeafb1d0d_768x768_crop_center.JPG?v=1448481941" alt="Raspberry Pi Zero Adaptor Kit" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">Raspberry Pi Zero Adaptor Kit</h3>
      <p class="text-xs text-center mt-1">Micro HDMI converter for easy troubleshooting</p>
    </a>
  </div>
  
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/microsd-card-with-raspberry-pi-os?variant=53501816832379" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/files/SD_CARD_128GB_768x768_crop_center.png?v=1729672748" alt="Raspberry Pi Official microSD Card" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">microSD Card with Raspberry Pi OS</h3>
      <p class="text-xs text-center mt-1">Pre-installed (or any other SD card)</p>
    </a>
  </div>
  
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/enviro?variant=31155658457171" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/products/Enviro-Plus-pHAT-on-white-2_1500x1500_crop_center.jpg?v=1573820030" alt="Enviro+ Air Quality Version" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">Enviro+ (Air Quality Version)</h3>
      <p class="text-xs text-center mt-1">The main sensor package with temperature, humidity, pressure, gas, and light sensors</p>
    </a>
  </div>
  
  <div class="border rounded-lg p-4 my-2 mx-1 hover:shadow-md transition">
    <a href="https://shop.pimoroni.com/products/pms5003-particulate-matter-sensor-with-cable?variant=29075640352851" target="_blank" class="flex flex-col items-center">
      <img src="https://shop.pimoroni.com/cdn/shop/products/PMS5003_particulate_matter_sensor_with_cable_1_of_4_768x768_crop_center.JPG?v=1560514915" alt="PMS5003 Particulate Matter Sensor" class="w-48 h-48 object-contain mb-3" />
      <h3 class="font-bold text-center">PMS5003 Particulate Matter Sensor</h3>
      <p class="text-xs text-center mt-1">For PM1.0, PM2.5, and PM10 air quality monitoring</p>
    </a>
  </div>
</Grid>

## Technical Requirements

### Hardware Requirements
- Raspberry Pi Zero 2 W (or any Raspberry Pi model)
- Pimoroni Enviro+ Air Quality sensor package
- PMS5003 Particulate Matter sensor (recommended for air quality monitoring)
- microSD card with Raspberry Pi OS (min. 8GB)
- Power supply for Raspberry Pi
- Optional: GPS module for mobile installations (for location tracking)

### Software Setup

To get your weather station up and running, you'll need to:

1. **Install the Official Enviro+ Python Library** - Set up the official [Enviro+ Python environment](https://github.com/pimoroni/enviroplus-python) first following their installation instructions:
   ```bash
   git clone https://github.com/pimoroni/enviroplus-python
   cd enviroplus-python
   sudo ./install.sh
   ```

2. **Extend the Environment with Additional Libraries** - Once the official Enviro+ environment is set up, install the additional required libraries:
   ```bash
   pip install awscli fastparquet pandas
   ```

3. **Set Up Your Own Copy of the Parquet-Edge Project**:
   - First, fork the [parquet-edge repository](https://github.com/Youssef-Harby/parquet-edge/) to your own GitHub account
   - Clone your forked repository to your Raspberry Pi
   - Customize the configuration:
     - Update the station ID in `config.py` (e.g., change from "01" to your unique station ID)
     - Configure your S3 credentials in the GitHub Actions workflow files (`.github/workflows/*.yml`)
     - Adjust any data collection parameters as needed for your specific deployment

<Alert status="warning">
  <strong>Important:</strong> You must update the S3 credentials in the GitHub Actions workflows to match your own storage provider. If you're using Source Cooperative, you'll need to set up your own Access Key and Secret Key.
</Alert>

#### How the Data Collection System Works

The parquet-edge repository handles the following aspects of weather station operation:

1. **Sensor Data Collection**: Reads data from all Enviro+ sensors at 1-second intervals
2. **Local Storage**: Writes data to local Parquet files in the proper partitioning structure
3. **Cloud Synchronization**: Uses built-in GitHub Actions workflows to sync data to your S3-compatible storage
4. **Offline Operation**: Continues collecting data when internet is unavailable and syncs when connection is restored
5. **Aggregation**: Creates daily aggregated files for more efficient historical analysis

After your weather station is up and running, you can send an email with your station info to me@youssefharby.com and I will add it to a stations_db.parquet which includes all the stations data to be used in this dashboard.

### Data Structure Guidelines

To ensure compatibility with the network, please follow these data structure guidelines:

1. **File format**: Use Parquet files with consistent schema
2. **Data frequency**: Record data at 1-second intervals, with files covering 5-minute periods

#### Near Real-Time Data (5-minute files)

These files contain 1-second interval readings aggregated into 5-minute chunks for near real-time monitoring:

```sql
station={STATION_ID}/year={year}/month={month}/day={day}/data_{time}.parquet
```

Example: 
```sql
s3://us-west-2.opendata.source.coop/youssef-harby/weather-station-realtime-parquet/parquet/station=01/year=2025/month=04/day=05/data_0145.parquet
```

View example files:
- [Near real-time 5-minute file (data_0145.parquet)](https://source.coop/youssef-harby/weather-station-realtime-parquet/parquet/station=01/year=2025/month=04/day=05/data_0145.parquet)
- [Near real-time 5-minute file (data_1800.parquet)](https://source.coop/youssef-harby/weather-station-realtime-parquet/parquet/station=01/year=2025/month=04/day=05/data_1800.parquet)

This structure is used in the [Near Real-Time Dashboard](/Stations/station=01/near-real-time) to show the most recent readings.

#### Daily Aggregated Data (for historical analysis)

For more efficient historical data analysis, 1-minute averages are aggregated into daily files:

```sql
station={STATION_ID}/year={year}/month={month}/{year}_{month}_{day}.parquet
```

Example:
```sql
s3://us-west-2.opendata.source.coop/youssef-harby/weather-station-realtime-parquet/1m_avg_daily/station=01/year=2025/month=04/2025_04_05.parquet
```

View example files:
- [Daily aggregated file (2025_04_05.parquet)](https://source.coop/youssef-harby/weather-station-realtime-parquet/1m_avg_daily/station=01/year=2025/month=04/2025_04_05.parquet)
- [Daily aggregated file (2025_04_04.parquet)](https://source.coop/youssef-harby/weather-station-realtime-parquet/1m_avg_daily/station=01/year=2025/month=04/2025_04_04.parquet)

This structure is used for all the historical dashboards and trend analysis.

#### Station ID Guidelines

* Use a unique identifier for your station (UUID) instead of simple identifiers like "02" or "03"

## Mobile Stations

Coming soon...

This dashboard is built with [Evidence](https://evidence.dev), which allows us to query and visualize the Parquet data directly in the browser - no backend required!
