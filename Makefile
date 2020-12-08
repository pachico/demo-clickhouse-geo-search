.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Start all the containers required run the demo
	docker-compose up -d

git-download-gazetteer: ## Download gazetteer for Andorra
	git clone  --depth 1 --single-branch --no-tags git@github.com:whosonfirst-data/whosonfirst-data-admin-ad.git resources/gazetteer

clickhouse-import-gazetteer: ## Parse gazetteer geoJsons and import them in ClickHouse
	find resources/gazetteer/data/ -type f -regex ".*/[0-9]*.geojson" \
    -exec cat {} + \
    | jq 'select(.geometry.type == "Polygon")' \
    | jq '{id, name:(.properties["wof:name"]), country_code:(.properties["iso:country"]) ,polygon:(.geometry["coordinates"][])}' -c \
    | docker-compose exec -T clickhouse clickhouse-client --query="INSERT INTO geo.location_polygon FORMAT JSONEachRow"

clickhouse-find-location: ## Find location based on point inside polygon
	docker-compose exec clickhouse bash -c "clickhouse-client --query=\"SELECT id, name FROM geo.location_polygon WHERE pointInPolygon((1.5995782462755148, 42.56633318931792), polygon) = 1 FORMAT PrettyCompactMonoBlock\""

down: ## Shut down all the containers and removes their volume
	docker-compose down --volumes --remove-orphans