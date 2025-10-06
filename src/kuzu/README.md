# Kuzu

Kuzu is an embedded graph database. It doesn't have an official Docker image for standalone deployment.

Kuzu is designed to be embedded in applications. To use Kuzu:

1. **Python**: Install via pip

   ```bash
   pip install kuzu
   ```

2. **C++**: Build from source or use pre-built libraries

3. **Node.js**: Install via npm

   ```bash
   npm install kuzu
   ```

## Example Usage (Python)

```python
import kuzu

# Create a database
db = kuzu.Database("./test_db")
conn = kuzu.Connection(db)

# Create schema
conn.execute("CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name))")
conn.execute("CREATE REL TABLE Knows(FROM Person TO Person)")

# Insert data
conn.execute("CREATE (:Person {name: 'Alice', age: 30})")
conn.execute("CREATE (:Person {name: 'Bob', age: 25})")
conn.execute("MATCH (a:Person), (b:Person) WHERE a.name = 'Alice' AND b.name = 'Bob' CREATE (a)-[:Knows]->(b)")

# Query
result = conn.execute("MATCH (a:Person)-[:Knows]->(b:Person) RETURN a.name, b.name")
while result.has_next():
    print(result.get_next())
```

## Reference

- [Kuzu GitHub](https://github.com/kuzudb/kuzu)
- [Kuzu Documentation](https://kuzudb.com)

## Notes

Kuzu is an embedded database and does not run as a standalone service. It's designed to be integrated directly into your application.

For a standalone graph database service, consider:

- [Neo4j](../neo4j/)
- [NebulaGraph](../nebulagraph/)
