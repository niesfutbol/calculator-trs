library(tidyverse)
library(xGoal)
source("R/xGoal.R")
statistics_path <- "results/league_262_2021.csv"
league <- read_csv(statistics_path)

teams <- Teams$new()
teams$read(statistics_path)
teams$get_id_teams()
teams$set_team_from_id("2288")
path_names <- "tests/data/names_ids_262_2021.csv"
teams$set_names(path_names)
team_2288 <- teams$team
bootstrapped_xgoal <- teams$bootstrapping_xgoal()
density <- Calculator_Density$new()
probability_goal <- density$probability_goal(bootstrapped_xgoal)

heat_map <- Heat_Map$new()
heat_map$read(statistics_path)
heat_map$set_names(path_names)
probable_score <- heat_map$get_probable_score("2287", "2289")
heat_map$plot(probable_score)
heat_map$save("heat_map.png")
probability_win_draw_win(probable_score)
