library("tidyverse")
source("/workdir/R/xTable.R")

opciones <- cli_calculate_xpoints()
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



attack <- comprehenr::to_vec(for (id in names[["ids"]]) get_strength_atack(league, id))
deffense <- comprehenr::to_vec(for (id in names[["ids"]]) get_strength_defense(league, id))
strength <- tibble(ids = names[["ids"]], attack = attack, deffense = deffense)

data <- league %>%
  mutate(won = mapply(function(x, y) how_won(x, y), home, away)) %>%
  left_join(strength, by = c("home_id" = "ids")) %>%
  rename(home_attack = attack, home_defense = deffense) %>%
  left_join(strength, by = c("away_id" = "ids")) %>%
  rename(away_attack = attack, away_defense = deffense) %>%
  select(home, away, won, home_attack, home_defense, away_attack, away_defense)

path_output <- glue::glue("{directory}/strength_league_{league_season}.csv")
write_csv(data, path_output)
