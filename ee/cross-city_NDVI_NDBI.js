// Data Import + Cloud Removal -----------------------------------
// code from this tutorial: https://developers.google.com/earth-engine/tutorials/community/sentinel-2-s2cloudless

// Sentinel-2 Level 1C data.  Bands B7, B8, B8A and B10 from this
// dataset are needed as input to CDI and the cloud mask function.
var s2 = ee.ImageCollection('COPERNICUS/S2');
// Cloud probability dataset.  The probability band is used in
// the cloud mask function.
var s2c = ee.ImageCollection('COPERNICUS/S2_CLOUD_PROBABILITY');
// Sentinel-2 surface reflectance data for the composite.
var s2Sr = ee.ImageCollection('COPERNICUS/S2_SR');

// The ROI is determined from the map.
var roi = cities;
Map.centerObject(cities, 11);

// Dates over which to create a median composite.
var start = ee.Date('2021-06-01');
var end = ee.Date('2021-08-30');

// S2 L1C for Cloud Displacement Index (CDI) bands.
s2 = s2.filterBounds(roi).filterDate(start, end)
    .select(['B7', 'B8', 'B8A', 'B10']);
// S2Cloudless for the cloud probability band.
s2c = s2c.filterDate(start, end).filterBounds(roi);
// S2 L2A for surface reflectance bands.
s2Sr = s2Sr.filterDate(start, end).filterBounds(roi)
    .select(['B2', 'B3', 'B4', 'B5', 'B8', 'B11']);

// Join two collections on their 'system:index' property.
// The propertyName parameter is the name of the property
// that references the joined image.
function indexJoin(collectionA, collectionB, propertyName) {
  var joined = ee.ImageCollection(ee.Join.saveFirst(propertyName).apply({
    primary: collectionA,
    secondary: collectionB,
    condition: ee.Filter.equals({
      leftField: 'system:index',
      rightField: 'system:index'})
  }));
  // Merge the bands of the joined image.
  return joined.map(function(image) {
    return image.addBands(ee.Image(image.get(propertyName)));
  });
}

// Aggressively mask clouds and shadows.
function maskImage(image) {
  // Compute the cloud displacement index from the L1C bands.
  var cdi = ee.Algorithms.Sentinel2.CDI(image);
  var s2c = image.select('probability');
  var cirrus = image.select('B10').multiply(0.0001);

  // Assume low-to-mid atmospheric clouds to be pixels where probability
  // is greater than 65%, and CDI is less than -0.5. For higher atmosphere
  // cirrus clouds, assume the cirrus band is greater than 0.01.
  // The final cloud mask is one or both of these conditions.
  var isCloud = s2c.gt(65).and(cdi.lt(-0.5)).or(cirrus.gt(0.01));

  // Reproject is required to perform spatial operations at 20m scale.
  // IR NOTE: changed scale from 20 m as in tutorial to 10 m so that pixels can be used to calculate NDVI at 10 m scale
  isCloud = isCloud.focal_min(3).focal_max(16);
  isCloud = isCloud.reproject({crs: cdi.projection(), scale: 10});

  // Project shadows from clouds we found in the last step. This assumes we're working in
  // a UTM projection.
  var shadowAzimuth = ee.Number(90)
      .subtract(ee.Number(image.get('MEAN_SOLAR_AZIMUTH_ANGLE')));

  // With the following reproject, the shadows are projected 5km.
  isCloud = isCloud.directionalDistanceTransform(shadowAzimuth, 50);
  isCloud = isCloud.reproject({crs: cdi.projection(), scale: 100});

  isCloud = isCloud.select('distance').mask();
  return image.select('B2', 'B3', 'B4', 'B8', 'B11').updateMask(isCloud.not());
}

// Join the cloud probability dataset to surface reflectance.
var withCloudProbability = indexJoin(s2Sr, s2c, 'cloud_probability');
// Join the L1C data to get the bands needed for CDI.
var withS2L1C = indexJoin(withCloudProbability, s2, 'l1c');

// Map the cloud masking function over the joined collection.
var masked = ee.ImageCollection(withS2L1C.map(maskImage));


// Calculating NDVI & NDBI ------------------------------------------------------------------------------
var addNDVI = function(image) {
  var ndvi = image.normalizedDifference(['B8', 'B4']).rename('NDVI');
  return image.addBands(ndvi);
};

var addNDBI = function(image) {
  var ndbi = image.normalizedDifference(['B11', 'B8']).rename('NDBI');
  return image.addBands(ndbi);
};


var masked_NDVI = masked.map(addNDVI);
var masked_NDVI_NDBI = masked_NDVI.map(addNDBI);

var indices = masked_NDVI_NDBI.select(['NDVI', 'NDBI'])
var indicesMean = indices.select(['NDVI', 'NDBI']).mean()


// Reducing to Regions ------------------------------------------------------------------------------------
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});  


var NDVI_NDBI_city = indicesMean.reduceRegions({
  'reducer': reducer,
  'scale': 10, 
  'collection': cities});

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
Map.addLayer(NDVI_NDBI_city.select('NDVI_mean'));