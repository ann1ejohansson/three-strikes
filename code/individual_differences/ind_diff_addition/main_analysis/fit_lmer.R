## Script for fitting multilevel models ##
source("~/research-collaboration/quitting_ind_differences/dependencies.R")
setwd("~/research-collaboration/quitting_ind_differences/main_analysis/addition")

# Load data - Addition 
dat <- readRDS(paste0(path_to_data, "/addition_train_forLMER.Rdata"))
# dat_c <- dat
# dat <- dat[user_id %in% sample(dat[, unique(user_id)], 500)]
# dat <- dat_c

# Random Intercept Model
ran_int <- glmer(quit ~ 1 + error_seq + (1 | user_id),
                 data = dat,
                 family = "binomial",
                 control = glmerControl(optimizer="bobyqa")) #nloptwrap or bobyqa
saveRDS(ran_int, file = "~/research-collaboration/quitting_ind_differences/ind_diff_addition/models/train/ran_int.RData")
rm(ran_int)
gc()

# Random Slope Model
ran_int_slope <- glmer(quit ~ 1 + error_seq + (1 + error_seq | user_id),
                       data = dat,
                       family = "binomial",
                       control = glmerControl(optimizer="bobyqa")) #nloptwrap or bobyqa
saveRDS(ran_int_slope, file = "~/research-collaboration/quitting_ind_differences/ind_diff_addition/models/train/ran_int_slope.RData")
rm(ran_int_slope)
gc()

# Random Slope Model with Covariates
ran_int_slope_cov <- glmer(quit ~ 1 + error_seq + rat_center + grade + (1 + error_seq | user_id),
                       data = dat,
                       family = "binomial",
                       control=glmerControl(optimizer="bobyqa"))
saveRDS(ran_int_slope_cov, file ="~/research-collaboration/quitting_ind_differences/ind_diff_addition/models/train/ran_int_slope_cov.RData")
