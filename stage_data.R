library(dplyr)
library(tidyr)
load("C:/Repositories/TalkingData/data/data.rda")

full_events <- events %>%
  inner_join(gender_age_train) %>%
  inner_join(phone_brand_device_model)
rm(events, gender_age_train, phone_brand_device_model)
gc()


full_apps <- app_labels %>%
  inner_join(label_categories) %>%
  select(app_id, generalized) %>%
  distinct() %>%
  mutate(value = 1) %>%
  spread(generalized, value, fill = 0) %>%
  select(-Other)

full_apps$Other <- rowSums(select(full_apps, Custom:Vitality))

full_apps <- full_apps %>%
  mutate(Other = ifelse(Other == 0, 1, 0)) %>%
  right_join(select(app_events, event_id, app_id)) %>%
  rename(apps = app_id) %>%
  mutate(apps = 1) %>%
  group_by(event_id) %>%
  summarize_each(funs(sum)) 

for(i in names(full_apps)[!names(full_apps) %in% c("event_id", "apps")]){
  full_apps[, i] <- as.integer(full_apps[[i]] > 0)
}

rm(app_events, app_labels, label_categories)
gc()
  
full_data <- inner_join(full_events, full_apps) 
rm(full_events, full_apps)
gc()

long_left <- full_data$longitude > 70.67096
long_right <- full_data$longitude < 149.272235
lat_bottom <- full_data$latitude > 18.442542
lat_top <- full_data$latitude < 55.421728
full_data$Southeast_Asia <- long_left & long_right & lat_bottom & lat_top

full_data <- full_data %>%
  filter(Southeast_Asia)

map_data <- full_data %>%
  filter(!is.na(region)) 

map_summary <- map_data %>%
  group_by(region) %>%
  summarize(events = length(event_id),
            devices = length(unique(device_id))) %>%
  left_join(data.frame(region = unique(map_data$region)[order(unique(map_data$region))], 
                       longitude = c(116.4074, 104.0668, 114.1095, 121.4737),
                       latitude = c(39.9042, 30.5728, 22.3964, 31.2304),
                       radius = c(10, 7, 13, 15),
                       stringsAsFactors = FALSE))

city_names <- paste0("<b><a href='https://en.wikipedia.org/wiki/",
                     gsub(" ", "_", map_summary$region),
                     "'>",
                     map_summary$region,
                     "</a></b>")
number_events <- paste0(map_summary$events, " events on") 
number_devices <- paste0(map_summary$devices, " devices")
overview_content <- paste(sep = "<br/>", city_names, number_events,
                          number_devices)

save(full_data, map_summary, overview_content, file = "C:/Repositories/TalkingData/data/prepped_data.rda")
file.copy("C:/Repositories/TalkingData/data/prepped_data.rda",
          "C:/Repositories/TalkingData_Explorer/data/prepped_data.rda",
          overwrite = TRUE)

