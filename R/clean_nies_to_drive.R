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

cli_clean_nies_to_drive <- function() {
  listaOpciones <- list(
    make_option(
      c("-i", "--nies-prediction"),
      default = "/workdir/results/nies_13-01-2022.csv",
      help = "Input file path of csv with predictions of the week",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-o", "--cleaned-nies"),
      default = "/workdir/results/cleaned_nies.csv",
      help = "Output file path of csv with cleaned predictions of the week",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}

read_predictions_of_week <- function(options) {
  return(read_csv(options[["nies-prediction"]], show_col_types = FALSE))
}

write_cleaned_predictions_of_week_for_drive <- function(filtered_predictions, options) {
  filtered_predictions %>%
    write_csv(options[["cleaned-nies"]])
}
