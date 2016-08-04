makeRegions <- function(events_data, folder){
  regions <- read.csv(paste0(folder, "data/regions.csv"), stringsAsFactors = FALSE)
  apply(regions, 1, function(row){
    box_left <- events_data$longitude > row[["long_left"]]
    box_right <- events_data$longitude < row[["long_right"]]
    box_top <- events_data$latitude < row[["lat_top"]]
    box_bottom <- events_data$latitude > row[["lat_bottom"]]
    events_data[[row[["region"]]]] <<- box_left & box_right & box_top & box_bottom
  })
  
  events_data$region <- NA
  for(i in regions$region){
      events_data[events_data[, i], "region"] <- i
      events_data <- events_data[, names(events_data)[names(events_data) != i]]
  }
  
  events_data
}
                        