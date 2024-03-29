#!/bin/sh

# curl -fsSL https://deno.land/install.sh | sh

# setup a temporary server while motis is being set up
# this is pure hack
# timeout 30 deno run --allow-net --allow-env server.ts

# Remove old build data
rm -rf config.ini motis* data/*

./downloadMotis.sh
./downloadGtfs.sh
./downloadOsm.sh


# Write config.ini
#
#paths=osm:input/pays-de-la-loire.osm.pbf
#paths=osm:input/basse-normandie.osm.pbf
#paths=osm:input/haute-normandie.osm.pbf

cat <<EOT >> config.ini
modules=intermodal
modules=address
modules=ppr
modules=nigiri

intermodal.router=nigiri
server.static_path=motis/web
dataset.no_schedule=true
nigiri.num_days=14

[import]
paths=schedule-bretagne:input/bretagne.gtfs.zip
paths=schedule-pdll:input/pays-de-la-loire.gtfs.zip
paths=schedule-ter:input/ter.gtfs.zip
paths=schedule-intercites:input/intercites.gtfs.zip
paths=schedule-tgv:input/tgv.gtfs.zip
paths=osm:input/ouest.osm.pbf

[ppr]
profile=motis/ppr-profiles/default.json

EOT

echo "Will first launch motis"

./motis/motis --mode test 
# Start MOTIS
#./motis/motis --server.port $PORT
