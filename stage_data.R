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

save(full_data, file = "C:/Repositories/TalkingData/data/prepped_data.rda")
file.copy("C:/Repositories/TalkingData/data/prepped_data.rda",
          "C:/Repositories/TalkingData_Explorer/data/prepped_data.rda")

