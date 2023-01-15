library(optparse)

select_columns_to_drive <- function(filtered_predictions) {
  filtered_predictions %>%
  select(date, league, home_team, away_team, won, name, nies_cuota)
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
