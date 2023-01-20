library("tidyverse")
source("/workdir/R/xTable.R")

opciones <- cli_add_winner_to_league()
league_season <- opciones[["league-season"]]
directory <- opciones[["directory"]]
path_names <- glue::glue("{directory}/names_{league_season}.csv")
names <- read_csv(path_names, show_col_types = FALSE)
path_league <- glue::glue("{directory}/league_{league_season}.csv")
league <- read_csv(path_league, show_col_types = FALSE)

how_won <- function(home, away) {
  if (home > away) {
    return("home")
  }
  if (home < away) {
    return("away")
  }
  return("draw")
}



mode <- opciones[["mode"]]
strength <- concatenate_strength_attack_defense(names, league, mode)

data <- league %>%
  mutate(won = mapply(function(x, y) how_won(x, y), home, away)) %>%
  left_join(strength, by = c("home_id" = "ids")) %>%
  rename(home_attack = attack, home_defense = deffense) %>%
  left_join(strength, by = c("away_id" = "ids")) %>%
  rename(away_attack = attack, away_defense = deffense) %>%
  select(home, away, won, home_attack, home_defense, away_attack, away_defense)

path_output <- glue::glue("{directory}/strength_league_{league_season}.csv")
write_csv(data, path_output)
