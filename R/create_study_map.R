create_study_map <- function(){
  

# palette -----------------------------------------------------------------
  # Water
  watercol <- '#99acc3'
  
  # Land
  canadacol <- '#ddc48d'
  citycol <- "#8C6D54"
  
  # Map etc
  gridcol1 <- '#323232'
  gridcol2 <- '#73776F'
  
  

# data download -----------------------------------------------------------

  
  #### DATA ####
  # download OSM data 
  ## Canada boundary
  bounds <- ne_download(
    scale = 'large',
    type = 'states',
    category = 'cultural',
    returnclass = 'sf'
  )
  keepAdmin <- c('United States of America', 'Canada', 'Greenland')
  keepb <- bounds[bounds$admin %in% keepAdmin,]
  
  ## cities
  # code adapted from https://www.supplychaindataanalytics.com/geocoding-with-osmdata-in-r/
  cities = as.data.frame(matrix(nrow=7,ncol=3))
  colnames(cities) = c("location","lat","long")
  cities$location = c("Vancouver, Canada",      #1
                      "Calgary, Canada",    #2
                      "Winnipeg, Canada",     #3
                      "Toronto, Canada",        #4 
                      "Ottawa, Canada", #5
                      "Montreal, Canada", #6
                      "Halifax, Canada"   #7
  )
  for(i in 1:nrow(cities)){
    coordinates = getbb(cities$location[i])
    cities$long[i] = (coordinates[1,1] + coordinates[1,2])/2
    cities$lat[i] = (coordinates[2,1] + coordinates[2,2])/2
  }
  cities <- st_as_sf(cities, coords = c("long", "lat"))
  cities <- st_set_crs(cities, st_crs(keepb))  
  

# map ---------------------------------------------------------------------
  cities$city <- gsub("(.*),.*", "\\1", cities$location)

  
  ## main map
  thememain <- theme(panel.border = element_rect(linewidth = 1, fill = NA),
                     panel.background = element_rect(fill = watercol),
                     panel.grid = element_line(color = gridcol1, linewidth = 0.2),
                     axis.text = element_text(size = 11, color = 'black'),
                     axis.title = element_blank() 
                     #plot.background = element_rect(fill = NA, colour = NA)
  )

  
  
  # bbox for larger Canada map 
  can <- bounds[bounds$admin == 'Canada',]
  bb <- st_bbox(st_buffer(can, 2.5))
  
  
  main <- ggplot() +
    geom_sf(fill = canadacol, color = 'grey32', size = 0.1, data = bounds) +
    geom_sf(color = citycol, size = 4.5, data = cities) +
    geom_label_repel(data = cities, aes(label = city, geometry = geometry), stat = "sf_coordinates", 
                      min.segment.length = 0, colour = citycol, segment.colour = citycol) + 
    coord_sf(xlim = c(bb['xmin'], bb['xmax'] + 2.5),
             ylim = c(bb['ymin'], bb['ymax'])) +
    #geom_rect(aes(xmin = -74.0788, xmax = -73.3894, ymin = 45.3414), ymax = 45.7224, 
    #          fill = NA, colour = "black", size = 0.5)  + 
    thememain
  
  
  ggsave(
    'graphics/study-system.png',
    main,
    width = 10,
    height = 10,
    dpi = 450
  )
  
  
}