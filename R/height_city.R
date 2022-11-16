height_city <- function(city_build_height, tifname){
  city_build_height %>%
    rename(height = tifname) %>%
    st_set_geometry(NULL) %>%
    filter(height > 0) %>% 
    summarize(mean = mean(height),
              median = median(height),
              sd = sd(height))
}