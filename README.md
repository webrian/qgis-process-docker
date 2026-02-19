# Simple Docker container for qgis_process

* Build the image
```
docker compose build qgis_process
```

* Run the container
```
docker compose run --rm qgis_process
```

* Run the simple demo model
````
docker compose run --rm qgis_process run models/simple.model3 --input_csv=models/cities.csv --output=models/cities.shp
```