Tile Tools
==========

Many [slippy maps](https://en.wikipedia.org/wiki/Tiled_web_map) use raster tiles, which are served from URLs like `http://.../Z/X/Y.png`, where `Z` is the zoom level, and `X` and `Y` are the coordinates.

This repository includes some tools for working with tiles in that format.

`tile-downloader.sh` downloads a set of tiles, and combines them into one huge image. You'll need to have ImageMagick installed.

`tile-viewer.html` is a basic [Leaflet]() setup, which is helpful for viewing such sets of tiles.
