height_hood <- function(hood, city_build_height, tifname){
  
  st_join(hood, city_build_height) %>%
    rename(height = tifname) %>%
    filter(height > 0) %>% 
    group_by(hood_id) %>%
    summarize(city = first(city),
              hood = first(hood),
              mean = mean(height),
              median = median(height),
              sd = sd(height))
  
}