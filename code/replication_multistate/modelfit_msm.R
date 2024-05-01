# Libraries, etc. 
source("~/research-collaboration/quitting_ind_differences/dependencies.R")

# Load log data
path_to_data <- "~/research-collaboration/quitting_ind_differences/data/replication/"
# temp_logs <- readRDS(paste0(path_to_data, "replication_clean.Rdata"))
# temp_logs <- all_logs[user_id %in% sample(all_logs[, unique(user_id)], 100)] # Sample users for testing
temp_logs <- data.table(temp_logs)
setkeyv(temp_logs, cols = c("created", "user_id"))

# Load domain info data
load(paste0(path_to_data, "domain_info.Rdata"))
colnames(domain_info)[1] <- "domain_id"
colnames(domain_info)[2] <- "application"
domain_info <- data.table(domain_info)

# Load user data
load(paste0(path_to_data, "user_info.Rdata"))
user_info <- data.table(user_info)

# Some consolidation and filtering
# temp_logs[is.na(non_deliberate), non_deliberate := 0]
temp_logs <- temp_logs[grade > 2 & non_deliberate == 0]
temp_logs <- temp_logs[, grade_collapse := fct_collapse(factor(grade),
                                                        lower_grades = c("3", "4", "5"),
                                                        higher_grades = c("6", "7", "8"))]
temp_logs <- merge(temp_logs, domain_info[, .(domain_id, application)], by = "domain_id")
temp_logs <- merge(temp_logs, user_info[, .(user_id, gender)], by = "user_id")

# Setting a key to ensure proper ordering
temp_logs <- data.table(temp_logs)
setkeyv(temp_logs, c("user_id", "created"))

temp_logs$difficulty <- factor(temp_logs$difficulty)
temp_logs$error_seq_cat_shift <- factor(temp_logs$error_seq_cat_shift)
temp_logs$weekend_evening <- factor(temp_logs$weekend_evening)

# Specifying the order of the discretized variables explicitly to ensure correct reference category
levels(temp_logs$error_seq_cat_shift) <- list(`0` = "0",
                                                      `1`  = "1",
                                                      `2` = "2",
                                                      `3` = "3",
                                                      `>3` = ">3")
levels(temp_logs$weekend_evening) <- list(`1` = "1",
                                          `0` = "0")
levels(temp_logs$difficulty) <- list(`2` = "2",
                                     `1` = "1",
                                     `0` = "0")
levels(temp_logs$grade_collapse) <- list(`higher_grades` = "higher_grades",
                                         `lower_grades` = "lower_grades")
levels(temp_logs$gender) <- list(`m` = "m",
                                 `f` = "f")

###############################################
############# Fitting the model ###############
###############################################

# Transition matrix
Q <- matrix(data = c(1, 1, 1, 1, 1, 1, 0, 0, 0), 
            nrow = 3,
            ncol = 3,
            byrow = T)

rownames(Q) <- colnames(Q) <- c("Persisting",
                                "Soft-Quit",
                                "Hard-Quit")

### Constrained models ###
# All data
msm_constrained_all <- msm(State ~ diff_s,
                     subject = msm_id,
                     data = temp_logs,
                     qmatrix = Q,
                     obstype = 2,
                     death = 3,
                     gen.inits = TRUE)

# Rekentuin
msm_constrained_rt <- msm(State ~ diff_s,
                   subject = msm_id,
                   data = temp_logs[temp_logs$application == 1,],
                   qmatrix = Q,
                   obstype = 2,
                   death = 3,
                   gen.inits = TRUE)

# Taalzee
msm_constrained_tz <- msm(State ~ diff_s,
                     subject = msm_id,
                     data = temp_logs[temp_logs$application == 2,],
                     qmatrix = Q,
                     obstype = 2,
                     death = 3,
                     gen.inits = TRUE)

# Save to directory
saveRDS(msm_constrained_all, file = paste0(path_to_data, "/msm_constrained_all.Rdata"))
saveRDS(msm_constrained_rt, file = paste0(path_to_data, "/msm_constrained_rt.Rdata"))
saveRDS(msm_constrained_tz, file = paste0(path_to_data, "/msm_constrained_tz.Rdata"))

rm(msm_constrained_all, msm_constrained_rt, msm_constrained_tz)
gc()

### Covariate models ###

# All data
msm_covariate_all <- msm(State ~ diff_s,
                   subject = msm_id,
                   data = temp_logs,
                   qmatrix = Q,
                   obstype = 2,
                   death = 3,
                   gen.inits = TRUE,
                   covariates = ~ error_seq_cat_shift + Error_type + weekend_evening + difficulty + grade_collapse + gender)

# Saving hazard ratios
hr_msm_covariate_all <- hazard.msm(msm_covariate_all)
hr_msm_covariate_all

saveRDS(msm_covariate_all, file = paste0(path_to_data, "/msm_covariate_all.Rdata"))
saveRDS(hr_msm_covariate_all, file = paste0(path_to_data, "/hr_msm_covariate_all.Rdata"))

rm(msm_covariate_all)
gc()

# Rekentuin
msm_covariate_rt <- msm(State ~ diff_s,
                   subject = msm_id,
                   data = temp_logs[temp_logs$application == 1,],
                   qmatrix = Q,
                   obstype = 2,
                   death = 3,
                   gen.inits = TRUE,
                   covariates = ~ error_seq_cat_shift + Error_type + weekend_evening + difficulty + grade_collapse + gender)

# Saving hazard ratios
hr_msm_covariate_rt <- hazard.msm(msm_covariate_rt)
hr_msm_covariate_rt

# Save to directory
saveRDS(msm_covariate_rt, file = paste0(path_to_data, "/msm_covariate_rt.Rdata"))
saveRDS(hr_msm_covariate_rt, file = paste0(path_to_data, "/hr_msm_covariate_rt.Rdata"))

rm(msm_covariate_rt)
gc()

# Taalzee
msm_covariate_tz <- msm(State ~ diff_s,
                   subject = msm_id,
                   data = temp_logs[temp_logs$application == 2,],
                   qmatrix = Q,
                   obstype = 2,
                   death = 3,
                   gen.inits = TRUE,
                   covariates = ~ error_seq_cat_shift + Error_type + weekend_evening + difficulty + grade_collapse + gender)

# Saving hazard ratios
hr_msm_covariate_tz <- hazard.msm(msm_covariate_tz)
hr_msm_covariate_tz

# Save to directory
saveRDS(msm_covariate_tz, file = paste0(path_to_data, "/msm_covariate_tz.Rdata"))
saveRDS(hr_msm_covariate_tz, file = paste0(path_to_data, "/hr_msm_covariate_tz.Rdata"))


