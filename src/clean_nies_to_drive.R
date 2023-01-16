library(tidyverse)
source("/workdir/R/clean_nies_to_drive.R")

opciones <- cli_clean_nies_to_drive()

jornada <- read_predictions_of_week(opciones)

jornada_limpia <- jornada %>%
  did_who_win() %>%
  what_name_of_who_won() %>%
  calculate_nies_fee() %>%
  select_columns_to_drive() %>%
  write_cleaned_predictions_of_week_for_drive(opciones)
