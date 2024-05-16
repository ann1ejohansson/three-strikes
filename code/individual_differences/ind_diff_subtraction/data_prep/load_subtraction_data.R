## Loading and splitting the subtraction dataset 
library(data.table)
library(dplyr)

load("~/research-collaboration/data-ro/all-logs-subtraction_2020-2022.Rdata")
logs_1 <- all_logs
rm(all_logs)

load("~/research-collaboration/data-ro/all-logs-subtraction_2022.Rdata")
logs_2 <- all_logs
rm(all_logs)

all_logs <- rbind(logs_1, logs_2)
all_logs <- data.table(all_logs)
setkeyv(all_logs, cols = c("user_id", "created"))

player_ratings_subtraction <- all_logs %>%
  group_by(user_id) %>%
  filter(row_number()==n()) %>% 
  summarise(user_rating)
saveRDS(player_ratings_subtraction, "~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_subtraction.Rdata")

rm(logs_1, logs_2)
gc()

