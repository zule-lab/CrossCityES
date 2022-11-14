// PART 1: CALCULATING LST // 

/*
Author: Sofia Ermida (sofia.ermida@ipma.pt; @ermida_sofia)
This code is free and open. 
By using this code and any data derived with it, 
you agree to cite the following reference 
in any publications derived from them:
Ermida, S.L., Soares, P., Mantas, V., Göttsche, F.-M., Trigo, I.F., 2020. 
    Google Earth Engine open-source code for Land Surface Temperature estimation from the Landsat series.
    Remote Sensing, 12 (9), 1471; https://doi.org/10.3390/rs12091471
Example 1:
  This example shows how to compute Landsat LST from Landsat-8 over Coimbra
  This corresponds to the example images shown in Ermida et al. (2020)
    
*/

// link to the code that computes the Landsat LST
var LandsatLST = require('users/sofiaermida/landsat_smw_lst:modules/Landsat_LST.js')

// select region of interest, date range, and landsat satellite
var geometry = cities;
var satellite = 'L8';
var date_start = '2021-06-01';
var date_end = '2021-08-31';
var use_ndvi = true;

// get landsat collection with added variables: NDVI, FVC, TPW, EM, LST
// clip image collection to city bounds
var LST = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi).map(function(image){return image.clip(cities)});

// convert to Celsius for easier analysis 
var LSTc = LST.select('LST').map(function(image) {
  return image
    .subtract(273.15)
});


// PART 2: EXTRACTING LST // 
// want to extract LST values at various scales in each city
// all assets were cleaned and produced in R - check github.com/icrichmond/cross-city-es for code 

// 1. Mean
// Get mean of each pixel for the summer
var LSTcMean = LSTc.select('LST').mean()

print(LSTcMean)

// 1. City Scale 
// extract mean LST value at each image in the image collection for each city 
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true});  
  

var CityLST = LSTcMean.reduceRegions({
  'reducer': reducer,
  'scale': 30,
  'collection': cities
});

// filter instances where list of temperatures is empty 
CityLST = CityLST.filter(ee.Filter.neq('mean', null));

// Explicitly select output variables in the export (redundant with filter lines 56-57)
Export.table.toDrive({
  collection: CityLST,
  description: 'cities'
});


// 2. Neighbourhood Scale 
// extract LST value at each date in the image collection for each neighbourhood
var HoodLST = LSTcMean.reduceRegions({
  'reducer': reducer,
  'scale': 30,
  'collection': hoods
});

// save
HoodLST = HoodLST.filter(ee.Filter.neq('mean', null))

Export.table.toDrive({
  collection: HoodLST,
  description: 'neighbourhoods'
})

// 3. Street Scale 
// calculate average LST value for each street in each city
var StreetLST = LSTcMean.reduceRegions({
  'reducer': reducer,
  'scale': 30,
  'collection': roads
});

// save
StreetLST = StreetLST.filter(ee.Filter.neq('mean', null))

Export.table.toDrive({
  collection: StreetLST,
  description: 'streets'
})


// PART 3: VISUALIZING LST // 
// palettes
var cmap1 = ['blue', 'cyan', 'green', 'yellow', 'red'];
var cmap2 = ['F2F2F2','EFC2B3','ECB176','E9BD3A','E6E600','63C600','00A600']; 

// visualize LST
Map.addLayer(LSTcMean.select('LST'), {min:0, max:50, opacity:0.49, palette:cmap1},'LST')
// visualize city boundaries
var empty = ee.Image().byte();
var outline = empty.paint({
  featureCollection: hoods,
  color: 1,
  width: 3
});
Map.addLayer(outline, {colour: 'black'}, 'Boundaries')


/*

// Export image to the cloud 
// Retrieve the projection information from a band of the original image.
// Call getInfo() on the projection to request a client-side object containing
// the crs and transform information needed for the client-side Export function.
var projection = LSTcMean.projection().getInfo();


Export.image.toDrive({
  image: LSTcMean,
  description: 'LSTMeanExample',
  region: sample,
  scale: 30
});

*/