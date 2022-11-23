height_city <- function(city_build_height, tifname, cityname){
  city_build_height %>%
    rename(height = tifname) %>%
    mutate(city = cityname) %>%
    st_set_geometry(NULL) %>%
    filter(height > 0) %>% 
    summarize(city = cityname, 
              mean = mean(height),
              median = median(height),
              sd = sd(height))
}