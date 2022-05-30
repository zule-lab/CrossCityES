convert_area <- function(can_build){
  # set units as km^2
  units(can_build$build_area) <- make_units(km^2)
  units(can_build$hood_area) <- make_units(km^2)
  
  return(can_build)
}