library(tidyverse)
source("R/xTable.R")

league <- read_csv("results/league_with_key_passes.csv")
cleaned_league <- league |>
  mutate("shots_outsidebox" = total_shots - shots_insidebox) |>
  mutate("shots_insidebox_kp" = shots_insidebox * key_passes/total_shots) |>
  mutate("shots_outsidebox_kp" = shots_outsidebox * key_passes/total_shots) |>
  mutate("shots_insidebox_nkp" = shots_insidebox * (total_shots-key_passes)/total_shots) |>
  mutate("shots_outsidebox_nkp" = shots_outsidebox * (total_shots-key_passes)/total_shots) |>
  mutate("shots_insidebox_kpnb" = shots_insidebox_kp * (total_shots-blocked_shots)/total_shots) |>
  mutate("shots_outsidebox_kpnb" = shots_outsidebox_kp * (total_shots-blocked_shots)/total_shots) |>
  mutate("shots_insidebox_nkpnb" = shots_insidebox_nkp * (total_shots-blocked_shots)/total_shots) |>
  mutate("shots_outsidebox_nkpnb" = shots_outsidebox_nkp * (total_shots-blocked_shots)/total_shots) |>
  mutate("shots_insidebox_kpb" = shots_insidebox_kp * (blocked_shots)/total_shots) |>
  mutate("shots_outsidebox_kpb" = shots_outsidebox_kp * (blocked_shots)/total_shots) |>
  mutate("shots_insidebox_nkpb" = shots_insidebox_nkp * (blocked_shots)/total_shots) |>
  mutate("shots_outsidebox_nkpb" = shots_outsidebox_nkp * (blocked_shots)/total_shots)

league_to_fit <- cleaned_league |>
  mutate(goal = goal - scored_penalties) |>
  select(
    c("goal", "shots_insidebox_kpnb", "shots_outsidebox_kpnb", "shots_insidebox_nkpnb", "shots_outsidebox_nkpnb","shots_insidebox_kpb", "shots_outsidebox_kpb", "shots_insidebox_nkpb", "shots_outsidebox_nkpb"))
league_to_fit[is.na(league_to_fit)] <- 0
intercept_only <- lm(goal ~ 0, data=league_to_fit)
all <- lm(goal ~ ., data=league_to_fit)
both <- step(intercept_only, direction='both', scope=formula(all), trace=0)
xG <- xGoal_all_league[["39_2021_kp"]]
league <- cleaned_league %>%
  mutate(xgoal = calculate_xgoal_kp(xG, shots_insidebox_kpnb, shots_outsidebox_nkpnb, total_penalties))