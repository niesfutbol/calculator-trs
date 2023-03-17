get_options_from_names <- function(names) {
  listaOpciones <- make_lista_opciones(names)
  opt_parser <- optparse::OptionParser(option_list = listaOpciones)
  opciones <- optparse::parse_args(opt_parser)
  return(opciones)
}

opcion_league <- optparse::make_option(
  c("-l", "--league-season"),
  default = "262_2021",
  help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
  metavar = "character",
  type = "character"
)

opcion_directory <- optparse::make_option(
  c("-d", "--directory"),
  default = "results",
  help = "Directory where are the files `statistics_{league}_{season}.csv`",
  metavar = "character",
  type = "character"
)

opcion_mode <- optparse::make_option(
  c("-m", "--mode"),
  default = "mean",
  help = "Mode to calculate stregth",
  metavar = "character",
  type = "character"
)

opcion_round <- optparse::make_option(
  c("-r", "--round"),
  default = "0",
  help = "Round",
  metavar = "character",
  type = "character"
)

opcion_predictions <- optparse::make_option(
  c("-i", "--nies-predictions"),
  default = "/workdir/results/nies_13-01-2022.csv",
  help = "Input file path of csv with predictions of the week",
  metavar = "character",
  type = "character"
)

opcion_cleaned_nies <- optparse::make_option(
  c("-o", "--cleaned-nies"),
  default = "/workdir/results/cleaned_nies.csv",
  help = "Output file path of csv with cleaned predictions of the week",
  metavar = "character",
  type = "character"
)

opcion_threshold <- optparse::make_option(
  c("-t", "--threshold"),
  default = 0.55,
  help = "The cut off for the probability in predictions",
  metavar = "double",
  type = "double"
)

OPTIONS <- list(
  "round" = opcion_round,
  "mode" = opcion_mode,
  "directory" = opcion_directory,
  "league" = opcion_league,
  "predictions" = opcion_predictions,
  "cleaned-nies" = opcion_cleaned_nies,
  "threshold" = opcion_threshold
)

make_lista_opciones <- function(names) {
  n_names <- length(names_options_cli)
  lista_opciones <- comprehenr::to_list(for (i in 1:n_names) OPTIONS[[names[i]]])
  return(lista_opciones)
}

cli_prediction_from_multinom <- function() {
  listaOpciones <- list(
    opcion_league,
    opcion_round,
    opcion_mode,
    opcion_directory
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}
