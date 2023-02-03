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
  default = "1",
  help = "Round",
  metavar = "character",
  type = "character"
)

OPTIONS <- list(
  "round" = opcion_round,
  "mode" = opcion_mode,
  "directory" = opcion_directory,
  "league" = opcion_league
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
