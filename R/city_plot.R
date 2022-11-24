city_plot <- function(x){
  
  x <- x %>%
    mutate_at(vars(-("city")), as.numeric) %>%
    pivot_longer(cols = -city) %>%
    arrange(value) %>%    # First sort by val. This sort the dataframe but NOT the factor levels
    ggplot(., aes(x = city, y = value, fill = city)) + 
    geom_col() + 
    scale_fill_manual(values=met.brewer("Veronese", 7)) + 
    facet_wrap(vars(name), scales = "free_y") + 
    theme_classic() + 
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) + 
    ylab("") + 
    xlab("")
  
  return(x)
  
  
}