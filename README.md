# Demo ClickHouse geo searches

This demo shows how use `ClickHouse` for geo searches.

## Requirements

- `docker-compose`
- `make` (unless you want to launch the commands manually)
- `jq` to do JSON magic
- `git` to down load a gazetteer

## Run it

The Makefile is self documented. Type `make help` to get its content:

```txt
up                             Start all the containers required run the demo
git-download-gazetteer         Download gazetteer for Andorra
clickhouse-import-gazetteer    Parse gazetteer geoJsons and import them in ClickHouse
clickhouse-find-location       Find location based on point inside polygon
down                           Shut down all the containers and removes their volume
```

Execute the commands in this order to run the demo.

The demo will:

- Do a shallow clone from [Who's on first gazetteer](https://whosonfirst.org/) for Andorra.
- It will filter our all the location geoJSONs that don't have polygons and transform the rest to be imported to ClickHouse in a searchable fashion.
- Do a `pointInPolygon` based search to find to in which location certain coordinates are in.
