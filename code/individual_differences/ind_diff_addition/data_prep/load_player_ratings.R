load("~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_addition1.Rdata")
player_ratings2 <- readRDS("~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_addition2.Rdata")

length(unique(c(player_ratings$user_id, player_ratings2$user_id)))

player_ratings <- data.table(player_ratings)
colnames(player_ratings2)[2] <- "rat"
player_ratings2 <- data.table(player_ratings2)


player_ratings <- player_ratings[!user_id %in% player_ratings2[, unique(user_id)]][, .(user_id, rat)]
player_ratings <- rbind(player_ratings, player_ratings2)


saveRDS(player_ratings, "~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_addition.Rdata")
