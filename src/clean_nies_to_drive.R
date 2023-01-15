library(tidyverse)
source("/workdir/R/clean_nies_to_drive.R")

opciones <- cli_clean_nies_to_drive()

jornada <- read_csv(opciones[["nies-prediction"]], show_col_types = FALSE)

jornada_limpia <- jornada %>%
  mutate(won = ifelse(home > 0.5, "Home", ifelse(away > 0.5, "Away", "Draw"))) %>%
  mutate(name = ifelse(home > 0.5, home_team, ifelse(away > 0.5, away_team, "Draw"))) %>%
  mutate(nies_cuota = ifelse(home > 0.5, 1/home, ifelse(away > 0.5, 1/away, 1/draw))) %>%
  select_columns_to_drive() %>%
  write_csv(opciones[["cleaned-nies"]])