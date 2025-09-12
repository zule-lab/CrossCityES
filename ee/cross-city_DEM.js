// Script to calculate mean + std variation in building height at multiple scales

// Data ----------
// load study scale boundaries
var cities = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/cities');
var neighbourhoods = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/neighbourhoods');
var streets = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/roads');

// load Canadian buildings
var canBuildings = ee.FeatureCollection('projects/sat-io/open-datasets/MSBuildings/Canada')

// import heights
var dsm = ee.ImageCollection("projects/sat-io/open-datasets/OPEN-CANADA/CAN_ELV/HRDEM_1M_DSM")
var dtm = ee.ImageCollection("projects/sat-io/open-datasets/OPEN-CANADA/CAN_ELV/HRDEM_1M_DTM")

// calculate DEM
var dem = dsm.mosaic().subtract(dtm.mosaic());

// mask buildings
var building_mask = canBuildings.reduceToImage(['FID'], ee.Reducer.anyNonZero());

// mask DEM 
var dem_mask = dem.mask(building_mask);


// Extract Heights ----------

var city_dem = dem_mask.reduceRegions({collection: cities,
                                      reducer: ee.Reducer.mean().combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true}),
                                      scale: 5
});

var neighbourhoods_dem = dem_mask.reduceRegions({collection: neighbourhoods,
                                      reducer: ee.Reducer.mean().combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true}),
                                      scale: 5
});

var streets_dem = dem_mask.reduceRegions({collection: streets,
                                      reducer: ee.Reducer.mean().combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true}),
                                      scale: 5
});

// Export ----------
Export.table.toDrive({
  collection: city_dem,
  description: "cities",
  selectors: ['CMANAME',	'mean', 'stdDev'],
  fileFormat: "CSV"
});

Export.table.toDrive({
  collection: neighbourhoods_dem,
  description: "neighbourhoods",
  selectors: ['city', 'hood', 'mean', 'stdDev'],
  fileFormat: "CSV"
});

Export.table.toDrive({
  collection: streets_dem,
  description: "streets",
  selectors: ['CMANAME', 'streetid', 'mean', 'stdDev'],
  fileFormat: "CSV"
});

// Visualize ----------
Map.addLayer(streets);
Map.addLayer(dem_mask);
