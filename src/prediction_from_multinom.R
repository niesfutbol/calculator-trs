library("tidyverse")
library("jsonlite")
library("nnet")
library("xGoal")
source("/workdir/R/cli_options.R")

names_options_cli <- c("league", "round", "mode", "directory")
opciones <- get_options_from_names(names_options_cli)
# opciones$"league-season" <- "135_2023"
# opciones$round <- 0
league_season <- opciones[["league-season"]]
previous_league_season <- previous_season(league_season)
directory <- opciones[["directory"]]
path_strength_league <- glue::glue("{directory}/strength_league_{previous_league_season}.csv")
strength_league <- read_csv(path_strength_league, show_col_types = FALSE)

model <- multinom(
  won ~ home_attack + home_defense + away_attack + away_defense,
  data = strength_league
)

path_names <- glue::glue("{directory}/names_{league_season}.csv")
names <- read_csv(path_names, show_col_types = FALSE)
path_league <- glue::glue("{directory}/league_{league_season}.csv")
league <- read_csv(path_league, show_col_types = FALSE)
path_season <- glue::glue("{directory}/season_{league_season}.csv")
season <- read_csv(path_season, show_col_types = FALSE)
round_str <- opciones[["round"]]
if (opciones[["round"]] == 0) {
  opciones$initial_date <- lubridate::today()
  opciones$final_date <- lubridate::today() + 14
}
round <- select_match_to_predict(season, opciones)

home_id <- round$home_id
away_id <- round$away_id
mode <- opciones[["mode"]]
home_attack <- calculate_attack_strength_for_each_team(home_id, league, mode)
home_defense <- calculate_defense_strength_for_each_team(home_id, league, mode)
away_attack <- calculate_attack_strength_for_each_team(away_id, league, mode)
away_defense <- calculate_defense_strength_for_each_team(away_id, league, mode)
to_predict <- tibble(away_attack, away_defense, home_defense, home_attack)
pred <- predict(model, to_predict, type = "prob")
(predictions <- tibble("home" = pred[, 3], "draw" = pred[, 2], "away" = pred[, 1]) %>%
  cbind(home_id, away_id) %>%
  left_join(names, by = c("home_id" = "ids")) |>
  left_join(names, by = c("away_id" = "ids"), suffix = c("_home", "_away")) |>
  rename(home_team = name_home, away_team = name_away) %>%
  select(c(6, 1, 2, 3, 7)))
predictions_round <- cbind(predictions, round)
output_file <- glue::glue("{directory}/predictions_{league_season}_{round_str}.csv")
write_csv(predictions_round, output_file)
