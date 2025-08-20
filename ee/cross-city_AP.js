// Data ----------
// load study scale boundaries
var cities = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/cities');
var neighbourhood = ee.FeatureCollection('projects/ee-isabellarichmond66/assets/neighbourhoods');

// Functions --------------
// what to include when reducing
var reducer = ee.Reducer.mean()
.combine({reducer2: ee.Reducer.median(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.max(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.min(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.stdDev(), outputPrefix: null, sharedInputs: true})
.combine({reducer2: ee.Reducer.count(), outputPrefix: null, sharedInputs: true});  


// filter images by date
var filter = function(images) {
  var start_date = '2024-06-01';
  var end_date = '2024-08-31';
  return images.filter(ee.Filter.date(start_date, end_date));
};

// cloud mask for pixels with less than 5% cloud cover
var cloudMask = function(image) {
      return image.updateMask(image.select("cloud_fraction").lt(0.1));
    };



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
        .set('date', img.date())
      });
    }).flatten();
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
var NO2_raw = filter(NO2_raw);
var CO_raw = filter(CO_raw);



// Map the cloud masking functions over NO2 data


// Band ----------------
// select relevant band for each image collection
// cloud mask for those where its relevant 
var UV_band = UV_raw.select('absorbing_aerosol_index');
var SO2_band = SO2_raw.select(['SO2_column_number_density', 'cloud_fraction'])
  .map(cloudMask)
  .select('SO2_column_number_density');
var O3_band = O3_raw.select(['O3_column_number_density', 'cloud_fraction'])
  .map(cloudMask)
  .select('O3_column_number_density');
var O3_trop_band = O3_trop_raw.select('ozone_tropospheric_vertical_column');
var NO2_band = NO2_raw.select(['tropospheric_NO2_column_number_density','cloud_fraction'])
  .map(cloudMask)
  .select('tropospheric_NO2_column_number_density');
var CO_band = CO_raw.select('CO_column_number_density');


// Reduce Cities -------------
var UV_city = sample(UV_band, reducer, cities, 1113.2);
UV_city = UV_city.filter(ee.Filter.neq('mean', null));

var SO2_city = sample(SO2_band, reducer, cities, 1113.2);
SO2_city = SO2_city.filter(ee.Filter.neq('mean', null));

var O3_city = sample(O3_band, reducer, cities, 1113.2);
O3_city = O3_city.filter(ee.Filter.neq('mean', null));

var O3_trop_city = sample(O3_trop_band, reducer, cities, 1113.2);
O3_trop_city = O3_trop_city.filter(ee.Filter.neq('mean', null));

var NO2_city = sample(NO2_band, reducer, cities, 1113.2);
NO2_city = NO2_city.filter(ee.Filter.neq('mean', null));

var CO_city = sample(CO_band, reducer, cities, 1113.2);
CO_city = CO_city.filter(ee.Filter.neq('mean', null));

// Reduce Neighbourhoods ------
var UV_neighbourhood = sample(UV_band, reducer, neighbourhood, 1113.2);
UV_neighbourhood = UV_neighbourhood.filter(ee.Filter.neq('mean', null));

var SO2_neighbourhood = sample(SO2_band, reducer, neighbourhood, 1113.2);
SO2_neighbourhood = SO2_neighbourhood.filter(ee.Filter.neq('mean', null));

var O3_neighbourhood = sample(O3_band, reducer, neighbourhood, 1113.2);
O3_neighbourhood = O3_neighbourhood.filter(ee.Filter.neq('mean', null));

var O3_trop_neighbourhood = sample(O3_trop_band, reducer, neighbourhood, 1113.2);
O3_trop_neighbourhood = O3_trop_neighbourhood.filter(ee.Filter.neq('mean', null));

var NO2_neighbourhood = sample(NO2_band, reducer, neighbourhood, 1113.2);
NO2_neighbourhood = NO2_neighbourhood.filter(ee.Filter.neq('mean', null));

var CO_neighbourhood = sample(CO_band, reducer, neighbourhood, 1113.2);
CO_neighbourhood = CO_neighbourhood.filter(ee.Filter.neq('mean', null));

print(CO_city.first())

// Export ----------------
// select columns i want (not geometry)
var desirable_fields_city = ['CMANAME', 'date', 'count', 'mean', 'median', 'max', 'min', 'stdDev']
var desirable_fields_neighbourhood = ['city', 'hood', 'hood_id', 'date', 'count', 'mean', 'median', 'max', 'min', 'stdDev']

// city scale
Export.table.toDrive({
  collection: UV_city,
  description: 'UV_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})

Export.table.toDrive({
  collection: SO2_city,
  description: 'SO2_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})
Export.table.toDrive({
  collection: O3_city,
  description: 'O3_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})
Export.table.toDrive({
  collection: O3_trop_city,
  description: 'O3_trop_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})
Export.table.toDrive({
  collection: NO2_city,
  description: 'NO2_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})
Export.table.toDrive({
  collection: CO_city,
  description: 'CO_city',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_city
})

// neighbourhood scale
Export.table.toDrive({
  collection: UV_neighbourhood,
  description: 'UV_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})
Export.table.toDrive({
  collection: SO2_neighbourhood,
  description: 'SO2_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})
Export.table.toDrive({
  collection: O3_neighbourhood,
  description: 'O3_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})
Export.table.toDrive({
  collection: O3_trop_neighbourhood,
  description: 'O3_trop_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})
Export.table.toDrive({
  collection: NO2_neighbourhood,
  description: 'NO2_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})
Export.table.toDrive({
  collection: CO_neighbourhood,
  description: 'CO_neighbourhood',
  folder: 'Data/SENTINEL_Pollution',
  selectors: desirable_fields_neighbourhood
})

// Print/Map -------------
//print(UV_raw);
//print(UV_city.limit(10));

Map.addLayer(NO2_raw.first())