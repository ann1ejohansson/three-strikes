source("~/research-collaboration/quitting_ind_differences/dependencies.R")

# model <- readRDS("~/research-collaboration/quitting_ind_differences/replication_multistate/models/msm_constrained_all.Rdata")
# model <- readRDS("~/research-collaboration/quitting_ind_differences/replication_multistate/models/msm_covariate_all.Rdata")

# prevalence.msm is a function from the msm package which extracts observed and predicted prevelance of states in the data. 
# here, I create a dataframe of observed and predicted prevalances for both the constrained and covariate models to compare their fit to the data. 
# options(digits = 3)
# df_constrained <- prevalence.msm(model, times = seq(1, 30, by = 5)) # this takes long to run (>2 hours)
# df_covariate <- prevalence.msm(model, times = seq(1, 30, by = 5)) 

# saveRDS(df_constrained, "~/research-collaboration/quitting_ind_differences/supplementary/replication_modelfit_constrained.Rdata")
# saveRDS(df_covariate, "~/research-collaboration/quitting_ind_differences/supplementary/replication_modelfit_covariate.Rdata")

df_constrained <- readRDS("~/research-collaboration/quitting_ind_differences/supplementary/replication_modelfit_constrained.Rdata")
df_covariate <- readRDS("~/research-collaboration/quitting_ind_differences/supplementary/replication_modelfit_covariate.Rdata")


df <- data.frame(model = rep(c("Constrained", "Covariate"), each = 36),
                 time = rep(seq(1, 30, by = 5), 12),
                 data = rep(c("Observed", "Expected"), each = 6*3, times = 2),
                 state = rep(c("Persisting", "Soft-Quit", "Hard-Quit"), each = 6, times = 4),
                 num = c(as.numeric(df_constrained$Observed[,1]),
                         as.numeric(df_constrained$Observed[,2]),
                         as.numeric(df_constrained$Observed[,3]),
                         as.numeric(df_constrained$Expected[,1]),
                         as.numeric(df_constrained$Expected[,2]),
                         as.numeric(df_constrained$Expected[,3]),
                         as.numeric(df_covariate$Observed[,1]),
                         as.numeric(df_covariate$Observed[,2]),
                         as.numeric(df_covariate$Observed[,3]),
                         as.numeric(df_covariate$Expected[,1]),
                         as.numeric(df_covariate$Expected[,2]),
                         as.numeric(df_covariate$Expected[,3])
                         ),
                 percent = c(as.numeric(df_constrained$`Observed percentages`[,1]),
                             as.numeric(df_constrained$`Observed percentages`[,2]),
                             as.numeric(df_constrained$`Observed percentages`[,3]),
                             as.numeric(df_constrained$`Expected percentages`[,1]),
                             as.numeric(df_constrained$`Expected percentages`[,2]),
                             as.numeric(df_constrained$`Expected percentages`[,3]),
                             as.numeric(df_covariate$`Observed percentages`[,1]),
                             as.numeric(df_covariate$`Observed percentages`[,2]),
                             as.numeric(df_covariate$`Observed percentages`[,3]),
                             as.numeric(df_covariate$`Expected percentages`[,1]),
                             as.numeric(df_covariate$`Expected percentages`[,2]),
                             as.numeric(df_covariate$`Expected percentages`[,3])
                             )
                 )
df$prob = df$percent/100

plot_modelfit <- ggplot(df, aes(x = time, y = prob, linetype = data, color = state)) +
  geom_line() +
  labs(y = "Probability", x = "Time Interval (min)") +
  scale_color_manual(values = colors[c(3, 1, 2)]) +
  facet_wrap(~model, nrow = 1) +
  plot_theme

plot_modelfit
path_to_plots <- "~/research-collaboration/quitting_ind_differences/supplementary"
export_pdf(plot_modelfit)
