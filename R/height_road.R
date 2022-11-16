height_road <- function(mun_road, city_build_height, tifname){
  
  mun_road %>% 
    filter(CMANAME == "Vancouver") %>%
    st_join(., city_build_height, join = st_nearest_feature) %>% 
    rename(height = tifname) %>%
    filter(height > 0) %>% 
    group_by(streetid) %>%
    summarize(city = first(CMANAME),
              street = first(street),
              streettype = first(streettype),
              mean = mean(height),
              median = median(height),
              sd = sd(height))
  
}