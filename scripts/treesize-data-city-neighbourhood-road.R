treesize_data_city_neighbourhood_road <- c(
  
  tar_target(
    all_tree_in, 
    all_tree %>% 
      drop_na(dbh) %>%
      mutate(dbh_in = dbh*2.54,
             basal_area = ((dbh_in)^2 * 0.005454))
  ),
  
  tar_target(
    treesize_city, 
    all_tree_in %>%
      group_by(city) %>% 
      summarize(mean_ba = mean(basal_area),
                sd_ba = sd(basal_area),
                mean_dbh = mean(dbh_in),
                sd_dbh = mean(dbh_in)) %>%
      mutate(mean_ba = set_units(mean_ba, "ft2"),
             sd_ba = set_units(sd_ba, "ft2"),
             mean_dbh = set_units(mean_dbh, "in"),
             sd_dbh = set_units(sd_dbh, "in"))
    
  ),
  
  tar_target(
    treesize_hood, 
    all_tree_in %>%
      group_by(city, hood_id) %>% 
      summarize(mean_ba = mean(basal_area), # NOTE: in square feet
                sd_ba = sd(basal_area),
                mean_dbh = mean(dbh_in),
                sd_dbh = sd(dbh_in)) %>%
      mutate(mean_ba = set_units(mean_ba, "ft2"),
             sd_ba = set_units(sd_ba, "ft2"),
             mean_dbh = set_units(mean_dbh, "in"),
             sd_dbh = set_units(sd_dbh, "in"))
    
  ),
  
  
  tar_target(
    treesize_road, 
    all_tree_in %>%
      group_by(city, hood_id, streetid) %>% 
      summarize(mean_ba = mean(basal_area), # NOTE: in square feet
                sd_ba = sd(basal_area),
                mean_dbh = mean(dbh_in),
                sd_dbh = sd(dbh_in)) %>%
      mutate(mean_ba = set_units(mean_ba, "ft2"),
             sd_ba = set_units(sd_ba, "ft2"),
             mean_dbh = set_units(mean_dbh, "in"),
             sd_dbh = set_units(sd_dbh, "in"))
    
  ),
  
  
  tar_target(
    skewness_vis_city,
    ggplot(all_tree_in, aes(x = dbh_in, group = city, col = city)) + 
      geom_density(alpha= 0.02, mapping = aes(y= ..count..)) +
      theme_classic() + xlim(c(0,100)) + xlab("DBH (in)")+ ylab("Density")+ 
      theme(legend.position = "top", axis.title = element_text(face= "bold", size= 18), axis.text.x = element_text(size= 18), axis.text.y = element_text(size= 18))
  ),
  
  
  tar_target(
    skewness_vis_hood,
    ggplot(all_tree_in, aes(x = dbh_in, group = hood_id, col = city)) + 
      geom_density(alpha= 0.02, mapping = aes(y= ..count..)) +
      theme_classic() + xlim(c(0,100)) + xlab("DBH (in)")+ ylab("Density")+ 
      theme(legend.position = "top", axis.title = element_text(face= "bold", size= 18), axis.text.x = element_text(size= 18), axis.text.y = element_text(size= 18))
  )
  
  
  
)
