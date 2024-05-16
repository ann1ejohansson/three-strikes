dat <- readRDS("~/research-collaboration/quitting_ind_differences/data/replication/replication_clean.Rdata")
dat <- data.table(dat)
setkeyv(dat, cols = c("created", "user_id"))

# What is the average playing time for a user at a given login moment?
playtime <- dat[, .(playtime = sum(diff_s)), by = msm_id]
avg_playtime_s <- mean(playtime$playtime)
avg_playtime_m <- mean(playtime$playtime)/60 
cat("The average playtime is approximately", round(avg_playtime_m, 0), "minutes")

# What is the average duration of one game?
gametime <- dat[, .(gametime = sum(diff_s),
                    N = .N/10), by = domain_id]
gametime <- gametime[, .(domain_id, gametime_s = gametime/N,
                         gametime_m = (gametime/N)/60)]
avg_gametime_m <- mean(gametime$gametime_m)
avg_gametime_m



# #! Try
# plot.msm, pmatrix.msm, print.msm, qmatrix.msm, summary.msm, sim.msm, lrtest.msm, msm.object, 

time_min <- avg_playtime_m


# plot.msm(msm_covariate_all, range = c(0, 20),
#          xlab = "Time (min)",
#          covariates = "mean")
times <- seq(1, 30)
df_tranprob <- numeric()
for(i in times) {
  pp <- pmatrix.msm(msm_covariate_all, t = i)[1,1] 
  psq <- pmatrix.msm(msm_covariate_all, t = i)[1,2] 
  phq <- pmatrix.msm(msm_covariate_all, t = i)[1,3] 
  sqp <- pmatrix.msm(msm_covariate_all, t = i)[2,1] 
  sqsq <- pmatrix.msm(msm_covariate_all, t = i)[2,2] 
  sqhq <- pmatrix.msm(msm_covariate_all, t = i)[2,3] 
  df_temp <- data.frame(time = i, 
                        tran = c("pp", "sqp", "psq",
                                 "sqsq", "phq", "sqhq"),
                        prob = c(pp, sqp, psq, 
                                 sqsq, phq, sqhq))
  df_tranprob <- rbind(df_tranprob, df_temp)
}

colors <- c("pp" = "#FDAE61", "sqp" = "#FEE08B", 
            "psq" ="#1B9E77", "sqsq" = "#ABDDA4", 
            "phq" = "#5E4FA2", "sqhq" = "#E7298A")
labels = c("pp" = "Persisting - Persisting", 
           "sqp" = "Soft-Quit - Persisting",
           "psq" = "Persisting - Soft-Quit",
           "sqsq" = "Soft-Quit - Soft-Quit", 
           "phq" = "Persisting - Hard-Quit",
           "sqhq" = "Soft-Quit - Hard-Quit")

# png(filename = paste0(path_to_plots, "/transitionprobs.png"),
#                       width = 1200, height = 700,
#                       res = 150)
ggplot(df_tranprob, aes(x = time, y = prob, group = tran)) +
  geom_line(aes(color = tran), linewidth = 1) +
  geom_vline(aes(xintercept = avg_playtime_m, linetype = "Average Playtime"), color = "black") +
  scale_color_manual(name = "Transition type", labels = labels, values = colors) +
  scale_linetype_manual(name = "", values = "dotted") +
  ggtitle(paste("Transition probabilities throughout", max(times), "minutes of gameplay")) +
  theme_minimal() 
# dev.off()





