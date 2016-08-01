library(data.table)
library(dplyr)
source("makeRegions.R")

app_events <- fread("data/app_events.csv") %>%
  as.data.frame()
app_labels <- fread("data/app_labels.csv") %>%
  as.data.frame()
events <- fread("data/events.csv") %>%
  as.data.frame() %>%
  makeRegions()
  
gender_age_test <- fread("data/gender_age_test.csv") %>%
  as.data.frame()
gender_age_train <- fread("data/gender_age_train.csv") %>%
  as.data.frame()
label_categories <- fread("data/label_categories.csv") %>%
  as.data.frame()
phone_brand_device_model <- fread("data/phone_brand_device_model.csv",
                                  encoding = "UTF-8") %>%
  as.data.frame()
sample_submission <- fread("data/sample_submission.csv") %>%
  as.data.frame()



