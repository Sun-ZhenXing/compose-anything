# DuckDB

DuckDB is an in-process SQL OLAP database management system designed to support analytical query workloads. It's embedded, zero-dependency, and extremely fast.

## Usage

```bash
docker compose up -d
```

## Access

### Interactive Shell

Access DuckDB CLI:

```bash
docker compose exec duckdb duckdb /data/duckdb.db
```

### Execute Queries

Run queries directly:

```bash
docker compose exec duckdb duckdb /data/duckdb.db -c "SELECT 1"
```

### Execute SQL File

```bash
docker compose exec duckdb duckdb /data/duckdb.db < query.sql
```

## Example Usage

```sql
-- Create a table
CREATE TABLE users (id INTEGER, name VARCHAR);

-- Insert data
INSERT INTO users VALUES (1, 'Alice'), (2, 'Bob');

-- Query data
SELECT * FROM users;

-- Load CSV file
COPY users FROM '/import/users.csv' (HEADER);

-- Export to CSV
COPY users TO '/data/users_export.csv' (HEADER);

-- Read Parquet file directly
SELECT * FROM '/import/data.parquet';
```

## Features

- **Embeddable**: No separate server process needed
- **Fast**: Vectorized query execution engine
- **Feature-rich**: Full SQL support with window functions, CTEs, etc.
- **File formats**: Native support for CSV, JSON, Parquet
- **Extensions**: PostgreSQL-compatible extensions

## Mounting Data Files

To import data files, mount them as volumes:

```yaml
volumes:
  - ./data:/import:ro
```

Then access files in SQL:

```sql
SELECT * FROM '/import/data.csv';
```

## Notes

- DuckDB is designed for analytical (OLAP) workloads, not transactional (OLTP)
- The database file is stored in `/data/duckdb.db`
- Data persists in the named volume `duckdb_data`
- DuckDB can query files directly without importing them
- For production workloads, ensure sufficient memory is allocated

## References

- [DuckDB Official Documentation](https://duckdb.org/docs/)
- [DuckDB Docker Image](https://hub.docker.com/r/davidgasquez/duckdb)
