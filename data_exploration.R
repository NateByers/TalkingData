library(dplyr)
load("C:/Repositories/TalkingData/data/data.rda")
rm(gender_age_test, sample_submission)

full_events <- events %>%
  left_join(gender_age_train) %>%
  left_join(phone_brand_device_model)
rm(events, gender_age_train, phone_brand_device_model)
gc()

full_apps <- app_events %>%
  left_join(app_labels) %>%
  left_join(label_categories)
rm(app_events, app_labels, label_categories)
gc()
  
