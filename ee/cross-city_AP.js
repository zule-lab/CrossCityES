// Functions --------------
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true});  
  
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

var filter = function(images) {
  var start_date = '2021-05-01';
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
UV_raw = filter(UV_raw);
SO2_raw = filter(SO2_raw);
O3_raw = filter(O3_raw);
O3_trop_raw = filter(O3_trop_raw);
NO2_raw = filter(NO2_raw);
CO_raw = filter(CO_raw);

// Reduce Cities -------------
var UV_city = sample(UV_raw, reducer, cities, 1e3);
UV_city = UV_city.filter(ee.Filter.neq('absorbing_aerosol_index_mean', null))

var SO2_city = sample(SO2_raw, reducer, cities, 1e3);
SO2_city = SO2_city.filter(ee.Filter.neq('SO2_column_number_density_mean', null))

var O3_city = sample(O3_raw, reducer, cities, 1e3);
O3_city = O3_city.filter(ee.Filter.neq('O3_column_number_density_mean', null))

var O3_trop_city = sample(O3_trop_raw, reducer, cities, 1e3);
O3_trop_city = O3_trop_city.filter(ee.Filter.neq('ozone_tropospheric_vertical_column_mean', null))

var NO2_city = sample(NO2_raw, reducer, cities, 1e3);
NO2_city = NO2_city.filter(ee.Filter.neq('NO2_column_number_density_mean', null))

var CO_city = sample(CO_raw, reducer, cities, 1e3);
CO_city = CO_city.filter(ee.Filter.neq('CO_column_number_density_mean', null))

// Reduce Neighbourhoods ------
var UV_hood = sample(UV_raw, reducer, hoods, 1e3);
UV_hood = UV_hood.filter(ee.Filter.neq('absorbing_aerosol_index_mean', null))

var SO2_hood = sample(SO2_raw, reducer, hoods, 1e3);
SO2_hood = SO2_hood.filter(ee.Filter.neq('SO2_column_number_density_mean', null))

var O3_hood = sample(O3_raw, reducer, hoods, 1e3);
O3_hood = O3_hood.filter(ee.Filter.neq('O3_column_number_density_mean', null))

var O3_trop_hood = sample(O3_trop_raw, reducer, hoods, 1e3);
O3_trop_hood = O3_trop_hood.filter(ee.Filter.neq('ozone_tropospheric_vertical_column_mean', null))

var NO2_hood = sample(NO2_raw, reducer, hoods, 1e3);
NO2_hood = NO2_hood.filter(ee.Filter.neq('NO2_column_number_density_mean', null))

var CO_hood = sample(CO_raw, reducer, hoods, 1e3);
CO_hood = CO_hood.filter(ee.Filter.neq('CO_column_number_density_mean', null))

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