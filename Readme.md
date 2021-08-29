## MongoBI connector with docker

This is docker version to install MongoBI with your existed docker

## How to use

Start

```
docker run -d -p 3307:3307 -e MONGODB_CONNECTURI=mongodb://cluster0-shard-00-02.arnwg.mongodb.net:27017/?connect=direct -e MONGODB_USER=user -e MONGODB_PASSWORD=password mihthanh27/mongobi
```

Available env

```
ENV MONGODB_CONNECTURI localhost
ENV MONGODB_USER user
ENV MONGODB_PASSWORD password
ENV LISTEN_PORT 3307
```
