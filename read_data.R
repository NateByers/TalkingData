library(dplyr)
library(tidyr)
directory <- "D:/Repositories/TalkingData/"
source(paste0(directory, "makeRegions.R"))
source(paste0(directory, "generalizeCategories.R"))
app_events <- read.csv(paste0(directory, "data/app_events.csv"),
                       stringsAsFactors = FALSE) %>%
  filter(is_installed == 1, is_active == 1)
app_labels <- read.csv(paste0(directory, "data/app_labels.csv"),
                       stringsAsFactors = FALSE) 
events <- read.csv(paste0(directory, "data/events.csv"),
                   stringsAsFactors = FALSE)  %>%
  makeRegions(directory) %>%
  mutate(date = as.Date(timestamp),
         hour = as.numeric(substr(timestamp, 12, 13)),
         morning = hour > 5 & hour < 12,
         midday = hour >= 12 & hour < 18,
         evening = hour >= 18 & hour < 21,
         night = hour >= 21 | hour <= 5) 
events$time <- NA 
for(i in c("morning", "midday", "evening", "night")){
  events[events[, i], "time"] <- i
  events <- events[, names(events)[names(events) != i]]
}
gender_age_test <- read.csv(paste0(directory, "data/gender_age_test.csv"),
                            stringsAsFactors = FALSE) 
gender_age_train <- read.csv(paste0(directory, "data/gender_age_train.csv"),
                             stringsAsFactors = FALSE) 
label_categories <- read.csv(paste0(directory, "data/label_categories.csv"),
                             stringsAsFactors = FALSE) %>%
  filter(grepl("\\S", category)) %>%
  filter(category != "unknown") %>%
  generalizeCategories()
sample_submission <- read.csv(paste0(directory, "data/sample_submission.csv"),
                              stringsAsFactors = FALSE) 

phone_brand_device_model <- read.csv(paste0(directory, "data/phone_brand_device_model.csv"),
                                     encoding = "UTF-8", stringsAsFactors = FALSE) 
names(phone_brand_device_model)[1] <- "device_id"
for(i in c("phone_brand", "device_model")){
  phone_brand_device_model[[i]] <- enc2utf8(phone_brand_device_model[[i]])
}

rows <- sapply(list(app_events, app_labels, events, gender_age_train,
                    phone_brand_device_model), function(x) dim(x)[1])

table_dimensions <- data.frame(Table = c("app_events", "app_labels", "events", 
                                         "gender_age_train",
                                         "phone_brand_device_model"),
                               Records = format(rows, big.mark=",", trim=TRUE))

app_labels <- semi_join(app_labels, label_categories)
app_events <- semi_join(app_events, app_labels)
events <- semi_join(events, app_events)
phone_brand_device_model <- semi_join(phone_brand_device_model, events)
gender_age_train <- semi_join(gender_age_train, events)
gender_age_test <- semi_join(gender_age_test, events)


save(app_events, app_labels, events, gender_age_train, gender_age_test,
     label_categories, phone_brand_device_model, table_dimensions,
     file = paste0(directory, "data/data.rda"))
