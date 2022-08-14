clean_pollution <- function(df, v) {
  
    # need to extract dates from the system:index column
    df$start_date <- anytime::anydate(substr(df$`system:index`, 1, 8))
    df$end_date <- anytime::anydate(as.numeric(gsub("[^_]*_(\\d+).*", "\\1", df$`system:index`)))

    # need to extract image id from system.index without long series of 0s at the end
    df$id <- sub("_[^_]+$", "", df$`system:index`) 
    
    # select columns of interest (exclude azimuth and zenith angles)
    df <- subset(df, select = c("id", "start_date", "end_date", "city", paste0(v, "_list"), paste0(v, "_mean")))
    
    # convert list to true list of numbers
    col <- paste0(v, "_list")
    df_b <- df[, (col) := gsub("[][]", "", .SD), by = seq_len(nrow(df)), .SDcols = col]
    df_c <- df_b[, (col) := lapply(strsplit(as.character(.SD), ","), as.numeric), by = seq_len(nrow(df_b)), .SDcols = col]

}

#lapply(strsplit(as.character(uv_clean$absorbing_aerosol_index_list), ","), as.numeric)