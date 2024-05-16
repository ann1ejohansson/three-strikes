dat <- readRDS(paste0(path_to_data, "/subtraction_clean.RData"))
dat <- as.data.table(dat)

N_start <- dat[, uniqueN(user_id)]
n_per_user <- dat[, .(n = .N,
                      n_sessions = uniqueN(session_count), 
                      n_quits = sum(quit)), by = user_id]
hist(n_per_user$n_quits, breaks = 2000, xlim = c(0, 200))

min_quits <- 10
min_sessions <- 50

n_per_user[n_quits >= min_quits, uniqueN(user_id)]
n_per_user[n_sessions >= min_sessions, uniqueN(user_id)]
n_per_user[n_sessions >= min_sessions & n_quits >= min_quits, uniqueN(user_id)]

dat <- dat[user_id %in% n_per_user[n_sessions >= min_sessions & n_quits >= min_quits, unique(user_id)]]

# This also removed users who always quit 
dat[, mean(quit, na.rm = T), by = user_id][V1 == 1, user_id]

N_end <- dat[, uniqueN(user_id)]

cat("New N:", N_end,
    "\n", N_start - N_end, "users were removed.")

# n_per_user_new <- dat[, .(n = .N,
#                       n_sessions = uniqueN(session_count), 
#                       n_quits = sum(quit)), by = user_id]
# 
# hist(n_per_user_new$n_quits, breaks = 1000)
# hist(n_per_user_new$n_sessions, breaks = 800)

# Remove users in grades 1 and 2 (too little data)
dat <- dat[grade > 2]

# Factor difficulty variable 
dat$difficulty <- factor(dat$difficulty)
levels(dat$difficulty) <- list(`1` = "1",
                               `0` = "0",
                               `2` = "2")

# Ability (user rating)
ratings <- readRDS("~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_subtraction.Rdata")
dat <- dat[, -c(19:20)]
dat <- merge(dat, ratings, by = "user_id")
dat[, rat_center := scale(user_rating)] # center variable

# Include only users who were present in the addition dataset (training and testing)
dat_add_train <- readRDS(paste0("~/research-collaboration/quitting_ind_differences/data_clean/addition_train_forLMER.Rdata"))
dat_add_test <- readRDS(paste0("~/research-collaboration/quitting_ind_differences/data_clean/addition_test_forLMER.Rdata"))

addition_users_train <- dat_add_train[, unique(user_id)]
addition_users_test <- dat_add_test[, unique(user_id)]

addition_users <- c(addition_users_test, addition_users_train)
dat <- dat[user_id %in% addition_users]
dat[, uniqueN(user_id)]

saveRDS(dat, file = paste0(path_to_data, "/subtraction_forLMER.Rdata"))
