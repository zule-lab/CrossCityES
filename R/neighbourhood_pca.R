neighbourhood_pca <- function(x, firstcol, secondcol){
  
  
  
  x_pca <- x %>% select(-c({{firstcol}}, {{secondcol}})) %>% mutate_all(as.numeric)
  
  
  #PCA
  pca <- PCA(x_pca, scale.unit=TRUE, ncp=14, graph=T)
  
  
  #both points and FA axes
  pca_plot <- fviz_pca_biplot(pca, label = "var", col.var = "gray22", col.ind = x$city, pointsize = 3,
                              addEllipses = TRUE, ellipse.level = 0.4, invisible = "quali", axes.linetype = "solid") + 
    scale_color_manual(values=met.brewer("Archambault", 7)) + 
    scale_fill_manual(values=met.brewer("Archambault", 7)) +
    scale_shape_manual(values=c(17, 17, 17, 17, 17, 17, 17), name = "city", guide = "none") + 
    theme_minimal() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    labs(title = "")
  
  return(pca_plot)
  
  
}
