neighbourhood_plot <- function(x){
  
  x <- x %>%
    mutate_at(vars(-c("city", "hood", "hood_id")), as.numeric) %>%
    pivot_longer(cols = -c(city, hood, hood_id)) %>%
    arrange(value) %>%    # First sort by val. This sort the dataframe but NOT the factor levels
    ggplot(., aes(x = city, y = value, col = city)) + 
    geom_boxplot() + 
    geom_point(size = 0.25) + 
    scale_colour_manual(values=met.brewer("Archambault", 7)) + 
    facet_wrap(vars(name), scales = "free_y") + 
    theme_classic() + 
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) + 
    ylab("") + 
    xlab("")
  
  return(x)
  
  
}