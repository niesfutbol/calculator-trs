library(tidyverse)
source("/workdir/R/clean_nies_to_drive.R")
source("/workdir/R/cli_options.R")

names_options_cli <- c("predictions", "cleaned-nies")
opciones <- get_options_from_names(names_options_cli)

jornada_limpia <- read_predictions_of_week(opciones) %>%
  did_who_win() %>%
  what_name_of_who_won() %>%
  calculate_nies_fee() %>%
  select_columns_to_drive() %>%
  write_cleaned_predictions_of_week_for_drive(opciones)
