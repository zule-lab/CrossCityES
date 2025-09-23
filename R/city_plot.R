city_plot <- function(x, supp.labs){
  
  x <- x %>%
    mutate(value = as.numeric(value)) %>%
    arrange(value) %>%   # First sort by val. 
    # this sort the dataframe but NOT the factor levels
    ggplot(., aes(x = city, y = value, fill = city)) + 
    geom_col() + 
    facet_wrap(vars(variable), scales = "free_y", labeller = labeller(variable = {supp.labs})) + 
    theme_classic() + 
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank()) + 
    scale_fill_met_d(name = 'Demuth') +
    ylab("") + 
    xlab("")
  
  return(x)
  
  
}
