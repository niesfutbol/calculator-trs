cli_add_winner_to_league <- function() {
  listaOpciones <- list(
    make_option(
      c("-l", "--league-season"),
      default = "262_2021",
      help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-d", "--directory"),
      default = "results",
      help = "Directory where are the files `statistics_{league}_{season}.csv`",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-m", "--mode"),
      default = "mean",
      help = "Mode to calculate stregth",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}
