CREATE DATABASE IF NOT EXISTS geo;

USE geo;

CREATE TABLE IF NOT EXISTS location_polygon (
    `id` UInt64,
    `name` String,
    `country_code` FixedString(2),
    `polygon` Array(Tuple(Float32, Float32))
) Engine = Memory;