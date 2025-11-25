-- Station registry - reads from CSV for easier community contributions
-- New stations are added via Sveltia CMS → GitHub PR workflow
-- CSV path is relative to project root when running `bun run sources`
SELECT
    station_id,
    station_name,
    sensor_type,
    latitude,
    longitude,
    station_type,
    storage_url,
    description,
    contributor_name,
    contributor_url,
    submitted_at,
    status
FROM read_csv_auto('sources/stations/stations.csv')
WHERE status = 'approved'
