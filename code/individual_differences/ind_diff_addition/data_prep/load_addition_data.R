## Loading and splitting the addition dataset 

load("~/research-collaboration/data-ro/all-logs-addition.Rdata")
logs_1 <- all_logs
rm(all_logs)

load("~/research-collaboration/data-ro/all-logs-addition_2022.Rdata")
logs_2 <- all_logs
rm(all_logs)

logs_2 <- data.table(logs_2)

addition_player_ratings2 <- logs_2 %>%
  group_by(user_id) %>%
  filter(row_number()==n()) %>% 
  summarise(user_rating)
saveRDS(addition_player_ratings2, "~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_addition2.Rdata")

all_logs <- rbind(logs_1, logs_2[, -c("user_rating", "gender")])
all_logs <- data.table(all_logs)
setkeyv(all_logs, cols = c("user_id", "created"))

rm(logs_1, logs_2, addition_player_ratings2)
gc()

set.seed(1234)
user_ids_train <- sample(all_logs[, unique(user_id)], round(all_logs[, uniqueN(user_id)]/2))
user_ids_test <- all_logs[!(user_id %in% user_ids_train), unique(user_id)] 

saveRDS(user_ids_train, "~/research-collaboration/quitting_ind_differences/data_clean/user_ids_train.Rdata")
saveRDS(user_ids_test, "~/research-collaboration/quitting_ind_differences/data_clean/user_ids_test.Rdata")

if(split == "training") {
  all_logs <- all_logs[user_id %in% user_ids_train]
  } else {
    all_logs <- all_logs[!(user_id %in% user_ids_train), ] 
    }

rm(user_ids_train, user_ids_test)
