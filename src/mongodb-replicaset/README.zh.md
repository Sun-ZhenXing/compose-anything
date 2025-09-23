# MongoDB

```bash
docker exec -it mongodb-mongo1-1 mongosh
```

初始化副本集：

```js
use admin
db.auth('root', '$MONGO_ROOT_PASSWORD')
config = {
  _id: "rs0",
  members: [
    {_id: 0, host: "192.168.31.38:27017"},
    {_id: 1, host: "192.168.31.38:27018"},
    {_id: 2, host: "192.168.31.38:27019"},
  ]
}
rs.initiate(config)
exit
```
