# Contributing Stations to OpenSensor

## Quick Start

1. Go to [opensensor-cms.netlify.app](https://opensensor-cms.netlify.app)
2. Sign in with GitHub
3. Fill out the station form
4. Submit → PR created → Auto-validated → Merged

## Workflow Overview

```mermaid
flowchart LR
    A[User] -->|1. Submit Form| B[Sveltia CMS]
    B -->|2. Creates YAML| C[contributions-clean branch]
    C -->|3. Triggers| D[Process Workflow]
    D -->|4. Creates PR| E[main branch PR]
    E -->|5. Triggers| F[Validation Workflow]
    F -->|6. Auto-approve| G[Merge Ready]
```

## Detailed Flow

```mermaid
sequenceDiagram
    participant U as User
    participant CMS as Sveltia CMS
    participant CB as contributions-clean
    participant GH as GitHub Actions
    participant PR as Pull Request
    participant S3 as S3 Storage

    U->>CMS: Submit station form
    CMS->>CB: Create YAML file
    CB->>GH: Trigger process workflow
    GH->>GH: DuckDB: YAML → CSV
    GH->>PR: Create PR with CSV
    PR->>GH: Trigger validation
    GH->>S3: aws s3 ls --no-sign-request
    S3-->>GH: ✓ Files exist
    GH->>PR: Update status: approved
    GH->>PR: Comment results
```

## Branches

| Branch | Purpose |
|--------|---------|
| `main` | Production - Evidence dashboard |
| `contributions-clean` | CMS submissions (YAML files) |

## Files

| File | Description |
|------|-------------|
| `content/stations/*.yml` | Station submissions (on contributions-clean) |
| `sources/stations/stations.csv` | Station registry (on main) |
| `scripts/merge-station-contributions.sql` | DuckDB script to merge YAML → CSV |

## Station Status

- `pending` - Awaiting validation
- `approved` - Validated and visible on dashboard

## Requirements

Your S3 storage URL must:
- Be publicly accessible (no auth required)
- Contain Parquet files in the expected structure
- Follow the path format: `s3://bucket/path/to/station/`
