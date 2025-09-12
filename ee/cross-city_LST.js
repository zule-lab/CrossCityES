// Data ----------
// load study scale boundaries
var cities = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/cities');
var neighbourhoods = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/neighbourhoods');
var streets = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/roads');


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
var LandsatLST = require('users/sofiaermida/landsat_smw_lst:modules/Landsat_LST.js');

// select region of interest, date range, and landsat satellite
var geometry = cities;
var satellite = 'L8';
var date_start = '2024-06-01';
var date_end = '2024-08-31';
var use_ndvi = true;

// get landsat collection with added variables: NDVI, FVC, TPW, EM, LST
// clip image collection to city bounds
var LST = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi).map(function(image){return image.clip(cities)});

// convert to Celsius for easier analysis
var LSTc = LST.select('LST').map(function(image) {
  return image.subtract(273.15).set('system:time_start', image.get('system:time_start'));
  // multiply by band scale for true value? 2.75e-05
});

// PART 2: EXTRACTING LST //
// want to extract LST values at various scales in each city
// all assets were cleaned and produced in R - check github.com/icrichmond/cross-city-es for code

// FUNCTIONS ----

// Functions --------------
// what to include when reducing
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});


// get values across each geometry for each date in the image collection
var sample = function(images, reducer, region, scale) {
  return images
    .map(function(img) {
      return img.reduceRegions({
      collection: region,
      reducer: reducer,
      scale : scale
      }).map(function (feature) {
        return feature
        .set('date', img.date());
      });
    }).flatten();
};


// 1. City Scale
// extract mean LST value at each image in the image collection for each city
var CityLST = sample(LSTc, reducer, cities, 30);

// filter instances where list of temperatures is empty
CityLST = CityLST.filter(ee.Filter.neq('mean', null));


// Explicitly select output variables in the export (redundant with filter lines 56-57)
Export.table.toDrive({
  collection: CityLST,
  description: 'cities',
  selectors: ['CMANAME', 'date', 'count', 'mean', 'median', 'max', 'min', 'stdDev']
});


// 2. Neighbourhood Scale
// extract LST value at each date in the image collection for each neighbourhood
var neighbourhoodLST = sample(LSTc, reducer, neighbourhoods, 30);

neighbourhoodLST = neighbourhoodLST.filter(ee.Filter.neq('mean', null));

Export.table.toDrive({
  collection: neighbourhoodLST,
  description: 'neighbourhoods',
  selectors: ['city', 'hood', 'hood_id', 'date', 'count', 'mean', 'median', 'max', 'min', 'stdDev']
});


// 3. Street Scale
var StreetLST = sample(LSTc, reducer, streets, 30);
StreetLST = StreetLST.filter(ee.Filter.neq('mean', null));
Export.table.toDrive({
  collection: StreetLST,
  description: 'streets',
  selectors: ['CMANAME', 'streetid', 'class', 'date', 'count', 'mean', 'median', 'max', 'min', 'stdDev']
});


// 4. Visualize - figure for supplementary

var exImage= ee.ImageCollection(LSTc)
          .filter(ee.Filter.inList('system:index',ee.List(['LC08_018030_20240611'])));

var cmap1 = ['blue', 'cyan', 'green', 'yellow', 'red'];
Map.centerObject(exImage)
Map.addLayer(exImage.select('LST'),{min:0, max:50, palette:cmap1}, 'LST')
Map.addLayer(neighbourhoods.style({fillColor: '00000000'}))

// Make a little map.
var map = ui.Map();

// Make the little map display an inset of the big map.
var createInset = function() {
  var bounds = ee.Geometry.Rectangle(Map.getBounds());
  map.centerObject(bounds);
  map.clear();
  map.addLayer(bounds);
};

// Run it once to initialize.
createInset();

// Get a new inset map whenever you click on the big map.
Map.onClick(createInset);

// Display the inset map in the viewer.
map.style().set('position','bottom-left');
Map.add(map);
