## Load data
source("~/research-collaboration/quitting_ind_differences/dependencies.R")

dataset <- "testing"

if(dataset == "training") {
  dat <- readRDS(paste0(path_to_data, "/addition_train_clean.RData"))
} else {
  dat <- readRDS(paste0(path_to_data, "/addition_test_clean.RData"))
}

dat <- as.data.table(dat)

## Data cleaning
min_quits <- 10
min_sessions <- 50

N_start <- dat[, uniqueN(user_id)]
n_per_user <- dat[, .(n = .N,
                      n_sessions = uniqueN(session_count),
                      n_quits = sum(quit)), by = user_id]
hist(n_per_user$n_quits, breaks = 2000, xlim = c(0, 200))

n_per_user[n_quits >= min_quits, uniqueN(user_id)]
n_per_user[n_sessions >= min_sessions, uniqueN(user_id)]
n_per_user[n_sessions >= min_sessions & n_quits >= min_quits, uniqueN(user_id)]

dat <- dat[user_id %in% n_per_user[n_sessions >= min_sessions & n_quits >= min_quits, unique(user_id)]]

# This also removed users who always quit
dat[, mean(quit, na.rm = T), by = user_id][V1 == 1, user_id]

# n_per_user_new <- dat[, .(n = .N,
#                       n_sessions = uniqueN(session_count),
#                       n_quits = sum(quit)), by = user_id]
#
# hist(n_per_user_new$n_quits, breaks = 1000)
# hist(n_per_user_new$n_sessions, breaks = 800)

# Remove users in grades 1 and 2 (too little data)
# dat <- dat[grade > 2]

# Factor difficulty variable
dat$difficulty <- factor(dat$difficulty)
levels(dat$difficulty) <- list(`1` = "1",
                               `0` = "0",
                               `2` = "2")

# Center rating variable
# ratings <- readRDS("~/research-collaboration/quitting_ind_differences/data_clean/player_ratings_addition_new.Rdata")
# ratings <- ratings[user_id %in% dat[,unique(user_id)], ]
# colnames(ratings)[2] <- "rat_new"
# dat <- merge(dat, ratings, by = "user_id")

dat$rat_center <- scale(dat$rat)

N_end <- dat[, uniqueN(user_id)]

cat("New N:", N_end,
    "\n", N_start - N_end, "users were removed.")

if(dataset == "training") {
  saveRDS(dat, file = paste0(path_to_data, "/addition_train_forLMER.Rdata"))
} else {
  saveRDS(dat, file = paste0(path_to_data, "/addition_test_forLMER.Rdata"))
}


