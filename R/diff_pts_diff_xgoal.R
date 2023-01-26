read_league_from_options_cli <- function(opciones) {
  league_season <- opciones[["league-season"]]
  directory <- opciones[["directory"]]
  league_path <- glue::glue("{directory}/league_{league_season}.csv")
  return(read_csv(league_path, show_col_types = FALSE))
}