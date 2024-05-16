#### FIT 2-STATE MARKOV MODELS ####

# Here, I am using item count as predictor variable 
# I compared these results with using row id as predictor and they give the same 
# transition estimate (file: fit_markov_model_OLD).  
# I use item count because this allows for a direct extraction of observed probabilities 
# with estimated probabilities per item count. 

# OBS model fitting is commented out! Undo the comment to run the desired model. 

#### LOAD DATA ####
source("~/research-collaboration/quitting_ind_differences/dependencies.R")
setwd("~/research-collaboration/quitting_ind_differences/ind_diff_analysis/models")

dataset <- "training"
if(dataset == "training") {
  dat <- readRDS(paste0(path_to_data, "/addition_train_clean.RData"))
  dat <- as.data.table(dat)
  path_to_models <- "~/research-collaboration/quitting_ind_differences/ind_diff_analysis/models/train"
} else {
  dat <- readRDS(paste0(path_to_data, "/addition_test_clean.RData"))
  dat <- as.data.table(dat)
  path_to_models <- "~/research-collaboration/quitting_ind_differences/ind_diff_analysis/models/test"
}

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
dat <- dat[!non_deliberate == 1]
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

#### BASELINE MODEL ####
# model_baseline <- msm(state ~ item_count,
#                       data = dat,
#                       subject = session_id,
#                       qmatrix = q,
#                       cl = 0.95)
# saveRDS(model_baseline, paste0(path_to_models, "/mm_baseline.Rdata"))
# rm(model_baseline)
# gc()

#### SEQ ERROR MODEL ####
# model_se <- msm(state ~ item_count,
#              data = dat,
#              subject = session_id,
#              qmatrix = q,
#              cl = 0.95,
#              covariates = ~ error_seq_cat_shift)
# saveRDS(model_se, paste0(path_to_models, "/mm_se.Rdata"))
# rm(model_se)
# gc()

#### INTERACTION MODEL ####
# model_int <- msm(state ~ item_count, 
#                  data = dat, 
#                  subject = session_id, 
#                  qmatrix = q,
#                  cl = 0.95, 
#                  covariates = ~ error_seq_cat_shift*difficulty)
# saveRDS(model_int, paste0(path_to_models, "/mm_int.Rdata"))
# rm(model_int)
# gc()

#### COVARIATE MODEL ####
# model_cov <- msm(state ~ item_count,
#                  data = dat,
#                  subject = session_id,
#                  qmatrix = q,
#                  cl = 0.95,
#                  covariates = ~ error_seq_cat_shift + RT + weekend_evening + grade_cat + difficulty)
# saveRDS(model_cov, paste0(path_to_models, "/mm_cov.Rdata"))
# rm(model_cov)
# gc()

#### COVARIATE & INTERACTION MODEL ####
# model_cov_int <- msm(state ~ item_count,
#                      data = dat,
#                      subject = session_id,
#                      qmatrix = q,
#                      cl = 0.95,
#                      covariates = ~ error_seq_cat_shift*difficulty + grade_cat + RT + weekend_evening)
# saveRDS(model_cov_int, paste0(path_to_models, "/mm_cov_int.Rdata"))
# rm(model_cov_int)
# gc()

#### GRADE MODEL ####
# model_grade <- msm(state ~ item_count,
#                    data = dat,
#                    subject = session_id,
#                    qmatrix = q,
#                    cl = 0.95,
#                    covariates = ~ error_seq_cat_shift*grade_cat + error_seq_cat_shift*difficulty +
#                      RT + weekend_evening)
# saveRDS(model_grade, paste0(path_to_models, "/mm_grade.Rdata"))
# rm(model_grade)
# gc()

#### RT INTERACTION MODEL ####
# model_rt_int <- msm(state ~ item_count,
#                  data = dat,
#                  subject = session_id,
#                  qmatrix = q,
#                  cl = 0.95,
#                  covariates = ~ error_seq_cat_shift*RT + weekend_evening + grade_cat + difficulty)
# saveRDS(model_rt_int, paste0(path_to_models, "/mm_rt_int.Rdata"))
# rm(model_rt_int)
# gc()




#### FULL MODEL ####
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
