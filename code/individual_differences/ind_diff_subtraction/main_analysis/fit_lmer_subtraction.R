source("~/research-collaboration/quitting_ind_differences/dependencies.R")
setwd("~/research-collaboration/quitting_ind_differences/ind_diff_subtraction")

# Load data - subtraction 
dat <- readRDS(paste0(path_to_data, "/subtraction_forLMER.Rdata"))


# Random Slope Model with Covariates
ran_int_slope_cov <- glmer(quit ~ 1 + error_seq + grade + rat_center + (1 + error_seq | user_id),
                       data = dat,
                       family = "binomial",
                       control=glmerControl(optimizer="bobyqa"))
saveRDS(ran_int_slope_cov, file = "~/research-collaboration/quitting_ind_differences/ind_diff_subtraction/models/lmer_sub.RData")
