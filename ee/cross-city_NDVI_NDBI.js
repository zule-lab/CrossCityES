// Data Import + Cloud Removal -----------------------------------
// code from this tutorial: https://developers.google.com/earth-engine/tutorials/community/sentinel-2-s2cloudless

// Sentinel-2 surface reflectance data for the composite.
var s2Sr = ee.ImageCollection('COPERNICUS/S2_SR');

// The ROI is determined from the map.
var roi = cities;
Map.centerObject(cities, 11);

// Dates over which to create a median composite.
var start = ee.Date('2021-06-01');
var end = ee.Date('2021-08-30');

// S2 L2A for surface reflectance bands.
s2Sr = s2Sr
.filterDate(start, end)
.filterBounds(roi)
.select(['B2', 'B3', 'B4', 'B5', 'B8', 'B11'])
.filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 10));


// Calculating NDVI & NDBI ------------------------------------------------------------------------------
var addNDVI = function(image) {
  var ndvi = image.normalizedDifference(['B8', 'B4']).rename('NDVI');
  return image.addBands(ndvi);
};

var addNDBI = function(image) {
  var ndbi = image.normalizedDifference(['B11', 'B8']).rename('NDBI');
  return image.addBands(ndbi);
};


var s2Sr_NDVI = s2Sr.map(addNDVI);
var s2Sr_NDVI_NDBI = s2Sr_NDVI.map(addNDBI);

var indices = s2Sr_NDVI_NDBI.select(['NDVI', 'NDBI'])
var indicesMean = indices.mean()


// Reducing to Regions ------------------------------------------------------------------------------------
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});  


var NDVI_NDBI_city = indicesMean.reduceRegions({
  'collection': cities,
  'reducer': reducer,
  'scale': 10 
});

var NDVI_NDBI_hood = indicesMean.reduceRegions({
  'reducer': reducer,
  'scale': 10, 
  'collection': hoods});

var NDVI_NDBI_roads = indicesMean.reduceRegions({
  'reducer': reducer,
  'scale': 10, 
  'collection': roads});


// Export --------------------------------------------------------------------------------------------------
// city scale
Export.table.toDrive({
  collection: NDVI_NDBI_city,
  description: 'cities'
})

// neighbourhood scale
Export.table.toDrive({
  collection: NDVI_NDBI_hood,
  description: 'neighbourhoods'
})

// street scale
Export.table.toDrive({
  collection: NDVI_NDBI_roads,
  description: 'streets'
})



// Visualize ----------------------------------------------------------------------------------------------
var NDVIpalette = ['FFFFFF', 'CE7E45', 'DF923D', 'F1B555', 'FCD163', '99B718', '74A901', '66A000', '529400', '3E8601', '207401', '056201', '004C00', '023B01', '012E01', '011D01', '011301'];
Map.addLayer(NDVI_NDBI_city.select('NDVI_mean'), NDVIpalette, 'NDVI');
