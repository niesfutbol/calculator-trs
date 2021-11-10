library("tidyverse")
library("nnet")

league_season <- "61_2020"
path_strength_league <- glue::glue("results/strength_league_{league_season}.csv")
strength_league <- read_csv(path_strength_league)

model <- multinom(
  won ~ home_attack + home_deffense + away_attack + away_deffense,
  data=strength_league
)


get_names <- function(id) {
  name <- names %>%
    filter(ids == id) %>%
    .$names
  return(name)
}


league_season <- "61_2021"
path_names <- glue::glue("tests/data/names_{league_season}.csv")
names <- read_csv(path_names)
path_strength_league <- glue::glue("results/strength_league_{league_season}.csv")
strength_league <- read_csv(path_strength_league)
path_league <- glue::glue("results/league_{league_season}.csv")
league <- read_csv(path_league)
path_season <- glue::glue("tests/data/season_{league_season}.csv")
season <- read_csv(path_season)
round <- season %>%
  filter(round == "Regular Season - 14")

home_id <- round$home_id
away_id <- round$away_id
home_attack <- comprehenr::to_vec(for (id in home_id) get_strength_atack(league, id))
home_deffense <- comprehenr::to_vec(for (id in home_id) get_strength_deffense(league, id))
away_attack <- comprehenr::to_vec(for (id in away_id) get_strength_atack(league, id))
away_deffense <- comprehenr::to_vec(for (id in away_id) get_strength_deffense(league, id))
to_predict <- tibble(away_attack, away_deffense, home_deffense, home_attack)
pred <- predict(model, to_predict, type="prob")
predictions <- tibble("home" = pred[,3], "draw" = pred[,2], "away" = pred[,1]) %>%
  cbind(home_id, away_id) %>%
  mutate(home_team = mapply(function(x) get_names(x), home_id)) %>%
  mutate(away_team = mapply(function(x) get_names(x), away_id)) %>%
  select(c(6,1,2,3,7))
