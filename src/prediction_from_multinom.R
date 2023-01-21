library("tidyverse")
library("jsonlite")
library("nnet")
source("/workdir/R/xTable.R")

opciones <- cli_prediction_from_multinom()
league_season <- opciones[["league-season"]]
previous_league_season <- previous_season(league_season)
directory <- opciones[["directory"]]
path_strength_league <- glue::glue("{directory}/strength_league_{previous_league_season}.csv")
strength_league <- read_csv(path_strength_league, show_col_types = FALSE)

model <- multinom(
  won ~ home_attack + home_defense + away_attack + away_defense,
  data = strength_league
)


get_names <- function(id) {
  name <- names %>%
    filter(ids == id) %>%
    .$names
  return(name)
}


path_names <- glue::glue("{directory}/names_{league_season}.csv")
names <- read_csv(path_names, show_col_types = FALSE)
path_strength_league <- glue::glue("{directory}/strength_league_{league_season}.csv")
strength_league <- read_csv(path_strength_league, show_col_types = FALSE)
path_league <- glue::glue("{directory}/league_{league_season}.csv")
league <- read_csv(path_league, show_col_types = FALSE)
path_season <- glue::glue("{directory}/season_{league_season}.csv")
season <- read_csv(path_season, show_col_types = FALSE)
round_str <- opciones[["round"]]
n_round <- glue::glue("Regular Season - {round_str}")
round <- season %>%
  filter(round == n_round)

home_id <- round$home_id
away_id <- round$away_id
home_attack <- comprehenr::to_vec(for (id in home_id) get_strength_atack(league, id))
home_defense <- comprehenr::to_vec(for (id in home_id) get_strength_defense(league, id))
away_attack <- comprehenr::to_vec(for (id in away_id) get_strength_atack(league, id))
away_defense <- comprehenr::to_vec(for (id in away_id) get_strength_defense(league, id))
to_predict <- tibble(away_attack, away_defense, home_defense, home_attack)
pred <- predict(model, to_predict, type = "prob")
(predictions <- tibble("home" = pred[, 3], "draw" = pred[, 2], "away" = pred[, 1]) %>%
  cbind(home_id, away_id) %>%
  mutate(home_team = mapply(function(x) get_names(x), home_id)) %>%
  mutate(away_team = mapply(function(x) get_names(x), away_id)) %>%
  select(c(6, 1, 2, 3, 7)))
predictions_round <- cbind(predictions, round)
output_file <- glue::glue("{directory}/predictions_{league_season}_{round_str}.csv")
write_csv(predictions_round, output_file)
