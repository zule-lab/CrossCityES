calculate_percent <- function(can_cen) {

can_cen_p <- can_cen[, c(paste0(names(can_cen[,5:12]), "p")) := lapply(.SD, function(x) x / sum(.SD)), by=1:nrow(can_cen), .SDcols = c(5:12)]

# population percentages 
can_cen_pp <- can_cen_p[ , c(paste0(names(can_cen_p[,15:17]), "p")) := lapply(.SD, function(x) x/totpop), .SDcols = 15:17]

return(can_cen_pp)

}