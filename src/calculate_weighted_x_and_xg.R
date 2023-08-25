library(tidyverse)
library(comprehenr)
library(xGoal)
source("R/xGoal.R")
id_league <- "262"
statistics_path <- glue::glue("results/league_{id_league}_2022.csv")
league <- read_csv(statistics_path, show_col_types = FALSE)

teams <- Teams$new()
teams$read(statistics_path)
teams$get_id_teams()
path_names <- glue::glue("results/names_{id_league}_2022.csv")
teams$set_names(path_names)

weighted_attack <- c()
weighted_deffense <- c()
for (team_id in teams$get_id_teams()) {
  teams$set_team_from_id(team_id)
  weighted_attack <- append(weighted_attack, teams$get_weighted_g_and_xg()[1])
  weighted_deffense <- append(weighted_deffense, teams$get_weighted_g_and_xg()[2])
}
weighted_g_and_xg <- tibble::tibble(
  "team_id" = as.integer(teams$get_id_teams()),
  "weighted_attack" = weighted_attack,
  "weighted_deffense" = weighted_deffense
) |>
left_join(teams$names, by = c("team_id" = "ids")) |>
  write_csv(glue::glue("results/weighted_g_and_xg_{id_league}.csv"))
