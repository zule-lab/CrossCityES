// Functions --------------
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});  

/*  don't want to map over every image - going to calculate metrics on mean summer temperature
var sample = function(images, reducer, region, scale) {
  return images
    .map(function(img) {
      return img.reduceRegions({
      collection: region,
      reducer: reducer,
      scale : scale
      });
    }).flatten();
};
*/

var filter = function(images) {
  var start_date = '2021-06-01';
  var end_date = '2021-08-31';
  return images.filter(ee.Filter.date(start_date, end_date));
};


// Images -------------
var UV_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_AER_AI');
var SO2_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_SO2');
var O3_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_O3');
var O3_trop_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_O3_TCL');
var NO2_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_NO2');
var CO_raw = ee.ImageCollection('COPERNICUS/S5P/OFFL/L3_CO');

// Filter -------------
var UV_raw = filter(UV_raw);
var SO2_raw = filter(SO2_raw);
var O3_raw = filter(O3_raw);
var O3_trop_raw = filter(O3_trop_raw);
var NO2_raw = filter(NO2_raw);
var CO_raw = filter(CO_raw);

print(UV_raw)
// Mean ----------------
var UV_mean = UV_raw.select('absorbing_aerosol_index').mean();
var SO2_mean = SO2_raw.select('SO2_column_number_density').mean();
var O3_mean = O3_raw.select('O3_column_number_density').mean();
var O3_trop_mean = O3_trop_raw.select('ozone_tropospheric_vertical_column').mean();
var NO2_mean = NO2_raw.select('NO2_column_number_density').mean();
var CO_mean = CO_raw.select('CO_column_number_density').mean();


// Reduce Cities -------------
var UV_city = UV_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
UV_city = UV_city.filter(ee.Filter.neq('mean', null))

var SO2_city = SO2_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
SO2_city = SO2_city.filter(ee.Filter.neq('mean', null))

var O3_city = O3_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
O3_city = O3_city.filter(ee.Filter.neq('mean', null))

var O3_trop_city = O3_trop_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
O3_trop_city = O3_trop_city.filter(ee.Filter.neq('mean', null))

var NO2_city = NO2_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
NO2_city = NO2_city.filter(ee.Filter.neq('mean', null))

var CO_city = CO_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': cities});
CO_city = CO_city.filter(ee.Filter.neq('mean', null))

// Reduce Neighbourhoods ------
var UV_hood = UV_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
UV_hood = UV_hood.filter(ee.Filter.neq('mean', null))

var SO2_hood = SO2_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
SO2_hood = SO2_hood.filter(ee.Filter.neq('mean', null))

var O3_hood = O3_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
O3_hood = O3_hood.filter(ee.Filter.neq('mean', null))

var O3_trop_hood = O3_trop_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
O3_trop_hood = O3_trop_hood.filter(ee.Filter.neq('mean', null))

var NO2_hood = NO2_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
NO2_hood = NO2_hood.filter(ee.Filter.neq('mean', null))

var CO_hood = CO_mean.reduceRegions({
  'reducer': reducer,
  'scale': 1113.2,
  'collection': hoods});
CO_hood = CO_hood.filter(ee.Filter.neq('mean', null))


// Export ----------------
// city scale
Export.table.toDrive({
  collection: UV_city,
  description: 'UV_city',
  folder: 'Data/SENTINEL_Pollution/'
})
Export.table.toDrive({
  collection: SO2_city,
  description: 'SO2_city',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: O3_city,
  description: 'O3_city',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: O3_trop_city,
  description: 'O3_trop_city',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: NO2_city,
  description: 'NO2_city',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: CO_city,
  description: 'CO_city',
  folder: 'Data/SENTINEL_Pollution'
})

// neighbourhood scale
Export.table.toDrive({
  collection: UV_hood,
  description: 'UV_hood',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: SO2_hood,
  description: 'SO2_hood',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: O3_hood,
  description: 'O3_hood',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: O3_trop_hood,
  description: 'O3_trop_hood',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: NO2_hood,
  description: 'NO2_hood',
  folder: 'Data/SENTINEL_Pollution'
})
Export.table.toDrive({
  collection: CO_hood,
  description: 'CO_hood',
  folder: 'Data/SENTINEL_Pollution'
})

// Print/Map -------------
print(UV_raw);
print(UV_city.limit(10));

Map.addLayer(hoods)