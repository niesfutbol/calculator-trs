library("tidyverse")
library("nnet")
source("/workdir/R/xTable.R")
source("/workdir/R/cli_options.R")

names_options_cli <- c("league", "directory")
opciones <- get_options_from_names(names_options_cli)
league_season <- opciones[["league-season"]]
previous_league_season <- previous_season(league_season)
directory <- opciones[["directory"]]
path_strength_league <- glue::glue("{directory}/strength_league_{previous_league_season}.csv")
strength_league <- read_csv(path_strength_league, show_col_types = FALSE)

model <- multinom(
  won ~ home_attack + home_defense + away_attack + away_defense,
  data = strength_league
)

path_strength_league <- glue::glue("{directory}/strength_league_{league_season}.csv")
tests_strength_league <- read_csv(path_strength_league, show_col_types = FALSE)
upth <- 0.99
threshold <- 0.50

predictions <- cbind(predict(model, tests_strength_league, type = "prob"), tests_strength_league) %>%
  select(c(3, 2, 1, won)) %>%
  mutate(pred_won = ifelse(home > threshold & home < upth, "home", ifelse(away > threshold & away < upth, "away", ifelse(draw > threshold & away < upth, "draw", 0)))) %>%
  mutate(pred = won == pred_won)
mean(predictions %>% filter(pred_won != 0) %>% .$pred)


(predictions %>%
  filter(pred_won != 0) %>%
  group_by(won) %>%
  summarize(
    correct = mean(pred),
    N = n()
  ) %>%
  write_csv(glue::glue("{directory}/precition_{league_season}.csv")))
