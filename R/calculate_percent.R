calculate_percent <- function(can_cen_dsa) {

can_cen_dsa_p <- can_cen_dsa[, c(paste0(names(can_cen_dsa[,5:13]), "p")) := lapply(.SD, function(x) x / sum(.SD)), by=1:nrow(can_cen_dsa), .SDcols = c(5:13)]

# population percentages 
can_cen_dsa_pp <- can_cen_dsa_p[ , c(paste0(names(can_cen_dsa_p[,16:19]), "p")) := lapply(.SD, function(x) x/totpop), .SDcols = 16:19]

return(can_cen_dsa_pp)

}