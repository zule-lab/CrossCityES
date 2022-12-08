clean_da_bound <- function(da_raw, mun_bound){
  
  da_s <- da_raw %>%
    select(c("DAUID", "geometry")) %>%
    rename(da = "DAUID") %>%
    st_transform(crs = 3347)
  
  da_clean <- da_s[mun_bound,]
  
  return(da_clean)
}