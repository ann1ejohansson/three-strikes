#### LOAD DATA ####
source("~/research-collaboration/quitting_ind_differences/dependencies.R")
setwd("~/research-collaboration/quitting_ind_differences/ind_diff_stability/models")

dat <- readRDS(paste0(path_to_data, "/subtraction_clean.RData"))
dat <- as.data.table(dat)
path_to_models <- "~/research-collaboration/quitting_ind_differences/ind_diff_stability/models"


#### PREP DATA ####

#### Compute State Variable
# This has to be computed before any data cleaning on an item level. 
# State 1 = Persisting
# State 2 = Quitting
dat[, state := ifelse(quit == 1, 2, 1)]
# This is the simplest version of the state variable. We assume users always start a session in 
# a persisting state, enter a quit state when a soft-quit is made, and then return to a 
# persisting state when a new session is started. 
# See the script "mm_compute_state.R" for alternative assumptions. 

#### Remove non-deliberate gameplay
dat[is.na(non_deliberate), non_deliberate := 0]
dat <- dat[!non_deliberate == 1,]
# This causes some users to have just one observation. Removing these
dat <- dat[!user_id %in% dat[, .N, by = user_id][N == 1]$user_id]

#### Remove users in grades 1 & 2
dat <- dat[grade > 2]

#### Shift sequential error variable 
dat[, error_seq_cat_shift := shift(error_seq_cat, type = "lead"),
    by = .(user_id,
           date,
           session_count)]

#### Difficulty 
dat$difficulty <- factor(dat$difficulty)
# For comparison with medium diff level:
levels(dat$difficulty) <- list(`1` = "1",
                               `0` = "0",
                               `2` = "2")

#### Slow or fast RT
# Comparison point is slow rt.
dat[, RT := factor(ifelse(response_in_milliseconds - quantile(response_in_milliseconds)[3] < 0, 
                          "Fast", "Slow"),
                   levels = c("Slow", "Fast"))]

#### Schooltime or not
# weekend_evening: 0 (ref) = playing in schooltime; 1 = playing outside school hours 
dat[,weekend_evening := ifelse(weekdays(created, abbreviate = TRUE) %in% 
                                 c("Sun", "Sat") | strftime(created, format="%H:%M:%S") > "16.00", 0, 1),]
dat$weekend_evening <- as.factor(dat$weekend_evening)

#### Grade
# dat$grade_disc <- factor(dat$grade, levels = c(8:3)) # All grade levels separately
# dat[, grade_cat := ifelse(grade < 5, "Lower", "Higher")] # Low vs. high grade 
# 3 levels: 3-4; 5-6; 7-8
dat[, grade_cat := factor(ifelse(grade <= 4, "3-4", ifelse(grade > 6, "7-8", "5-6")),
                          levels = c("7-8", "5-6", "3-4"))]

#### PREP MODEL PARAM ####
# Order rows
setDT(dat, key = c("user_id", "session_count"))

# Check session count variable (resulting dt should be empty)
dat[, .N, by = .(session_count, user_id)][N > 10, .(user_id, session_count)]

# Session ID
setDT(dat, key = c("user_id", "session_count", "created"))
temp <- paste(dat$user_id, dat$session_count, sep = "-")
dat$user_id_session <- temp
dat[, session_id := rleid(user_id_session)]

# Remove sessions lasting 1 item
dat <- dat[!session_id %in% dat[, .N, by = session_id][N==1, session_id]]

# 2 sessions have state 2 recorded twice. Removing these. 
dat <- dat[!session_id %in% dat[, sum(state == 2), by = session_id][V1>1, session_id]]
rm(temp); gc()

# Define transition matrix
q <- matrix(c(-1, 1, 0, -1), nrow = 2, ncol = 2, byrow = T)

#### FIT FULL MODEL ####
model_full <- msm(state ~ item_count,
                  data = dat,
                  subject = session_id,
                  qmatrix = q,
                  cl = 0.95,
                  covariates = ~ error_seq_cat_shift*grade_cat + error_seq_cat_shift*difficulty +
                    error_seq_cat_shift*RT + error_seq_cat_shift*weekend_evening)
saveRDS(model_full, paste0(path_to_models, "/mm_full.Rdata"))
rm(model_full)
gc()