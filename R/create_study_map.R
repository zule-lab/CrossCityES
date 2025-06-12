create_study_map <- function(mun_bound_clean, da_bound_clean, mun_road_clean, can_hood, can_trees,
                             mun_bound_trees, neighbourhood_bound_trees, road_bound_trees){
  

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
  

  cities$city <- gsub("(.*),.*", "\\1", cities$location)

  
# main map ----------------------------------------------------------------

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
    thememain + 
    ggtitle('A) Seven Study Cities')
  

# city map ----------------------------------------------------------------
mtlbound <- mun_bound_clean %>% filter(CMANAME == "Montreal")
mtldas <- st_intersection(da_bound_clean, mtlbound)  
mtltrees <- can_trees %>% filter(city == "Montreal")
mtlfinal <- mun_bound_trees %>% filter(CMANAME == "Montreal")


city <- ggplot() +
  geom_sf(data = mtldas, alpha = 0.5) + 
  geom_sf(data = mtltrees, colour = 'darkgreen', size = 0.01) +
  geom_sf(data = mtlfinal, colour = 'black', fill = NA, linewidth = 1) + 
  coord_sf(xlim = c(7600454, 7636840), ylim = c(1225208, 1268951), expand = FALSE) +
  ggtitle('B) City Scale')
  

# neighbourhood map  ------------------------------------------------------
mtlnhoods <- can_hood %>% filter(city == "Montreal")
mtlnhoodfinal <- neighbourhood_bound_trees %>% filter(city == "Montreal")


nhoods <- ggplot() +
  geom_sf(data = mtlnhoods, alpha = 0.5) + 
  geom_sf(data = mtltrees, colour = 'darkgreen', size = 0.01) +
  geom_sf(data = mtlnhoodfinal, colour = 'black', fill = NA, linewidth = 1) + 
  coord_sf(xlim = c(7600454, 7636840), ylim = c(1225208, 1268951), expand = FALSE) + 
  ggtitle('C) Neighbourhood Scale')

# street map --------------------------------------------------------------
nhoodex <- st_intersection(road_bound_trees, mtlnhoodfinal %>% filter(hood == "Rivière-Des-Prairies-Pointe-Aux-Trembles"))

streets <- ggplot() +
  geom_sf(data = mun_road_clean %>% st_intersection(., mtlnhoods %>% filter(hood == "Rivière-Des-Prairies-Pointe-Aux-Trembles")), alpha = 0.5) + 
  geom_sf(data = nhoodex, colour = 'black', fill = NA, linewidth = 1) +
  geom_sf(data = mtltrees %>% filter(hood == "Rivière-Des-Prairies-Pointe-Aux-Trembles"), colour = 'darkgreen', size = 0.5) +
  coord_sf(xlim = c(7623697 , 7633386 ), ylim = c(1256329 , 1268266 ), expand = FALSE) + 
  ggtitle('D) Street Scale')
  
  
  
# combine and save --------------------------------------------------------

  f <- main | ((city + nhoods) / (streets + plot_spacer()))


  ggsave(
    'graphics/study-system.png',
    f,
    width = 30,
    height = 10,
    dpi = 450
  )
  
  
}