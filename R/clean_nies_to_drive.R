library(optparse)

select_columns_to_drive <- function(filtered_predictions) {
  filtered_predictions %>%
    select(date, league, home_team, away_team, won, name, nies_cuota)
}

did_who_win <- function(filtered_predictions) {
  filtered_predictions %>%
    mutate(won = ifelse(home > 0.5, "Home", ifelse(away > 0.5, "Away", "Draw")))
}

what_name_of_who_won <- function(filtered_predictions) {
  filtered_predictions %>%
    mutate(name = ifelse(home > 0.5, home_team, ifelse(away > 0.5, away_team, "Draw")))
}


calculate_nies_fee <- function(filtered_predictions) {
  filtered_predictions %>%
    mutate(nies_cuota = ifelse(home > 0.5, 1 / home, ifelse(away > 0.5, 1 / away, 1 / draw)))
}

read_predictions_of_week <- function(options) {
  expected_option <- "nies-predictions"
  rlang::arg_match0(expected_option, names(opciones))
  return(read_csv(options[[expected_option]], show_col_types = FALSE))
}

write_cleaned_predictions_of_week_for_drive <- function(filtered_predictions, options) {
  expected_option <- "cleaned-nies"
  rlang::arg_match0(expected_option, names(opciones))
  filtered_predictions %>%
    write_csv(options[[expected_option]])
}
