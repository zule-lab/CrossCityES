convert_area <- function(can_build, ...){
  # set units as km^2
  units(can_build) <- make_units(km^2)
  units(...) <- make_units(km^2)
  
  return(can_build)
}