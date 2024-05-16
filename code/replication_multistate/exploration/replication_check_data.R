# Becuase the data filtering is slightly different between the two data sets, 
# I want to carefully control how this changes the variables in the new dataset
# before fitting the models. 

logs_dt[, .N]
all_logs[, .N]

table(logs_dt$session_count)
table(all_logs$item_count)

table(logs_dt$session_id)
table(all_logs$session_id)

logs_dt[, uniqueN(game_id)]
all_logs[, uniqueN(game_id)]

logs_dt[, uniqueN(msm_id)]
all_logs[, uniqueN(msm_id)]

table(logs_dt$State)
table(all_logs$State)
# Some more rows in state 3

table(logs_dt$error_seq)
table(all_logs$error_seq)

table(logs_dt$error_seq_within_disc)
table(all_logs$error_seq_cat)

table(logs_dt$error_seq_within_disc_shift)
table(all_logs$error_seq_cat_shift)
# Some more observations in >3

sum(table(logs_dt$quit_type)[3:4])
all_logs[non_deliberate == 1, .N]
# Here lies the biggest difference. In Nick's data, observations that were 
# speedy errors but not reuslted in a quit were marked as so. 

table(logs_dt$Error_type)
table(all_logs$Error_type)

logs_dt[non_deliberate == 0, table(Error_type)]
all_logs[non_deliberate == 0, table(Error_type)]
# More fast errors included in data 

# ! Run this before shifting the error_type variable 
logs_dt$acc <- ifelse(logs_dt$correct_answered == 0, "incorrect", "correct")
all_logs$acc <- ifelse(all_logs$correct_answered == 0, "incorrect", "correct")
logs_dt$non_deliberate <- ifelse(logs_dt$quit_type == "Speedy Error Quit" | logs_dt$quit_type == "Wrong Sel. Quit", 1, 0)
table(logs_dt$non_deliberate, logs_dt$Error_type, logs_dt$acc)
table(all_logs$non_deliberate, all_logs$Error_type, all_logs$acc)
# Something might be going on here

table(logs_dt$weekend_evening)
table(all_logs$weekend_evening)

mean(logs_dt$diff_s)
mean(all_logs$diff_s)
median(logs_dt$diff_s)
median(all_logs$diff_s)


