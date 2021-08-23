library(tidyverse)
library(xGoal)
source("R/xGoal.R")
#away_prob <- (dpois(0:6, league$away_xGol[1]))
#home_prob <- (dpois(0:6, league$home_xGol[1]))
#for (i in 1:5) {print(home_prob[i] * away_prob[1:7])}
statistics_path <- "results/league_262_2021.csv"
league <- read_csv(statistics_path)

teams <- Teams$new()
teams$read(statistics_path)
teams$get_id_teams()
teams$set_team_from_id("2288")
team_2288 <- teams$team
bootstrapped_xgoal <- teams$bootstrapping_xgoal()
density <- Calculator_Density$new()
probability_goal <- density$probability_goal(bootstrapped_xgoal)

heat_map <- Heat_Map$new()