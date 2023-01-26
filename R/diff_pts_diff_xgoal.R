read_league_from_options_cli <- function(opciones) {
  league_season <- opciones[["league-season"]]
  directory <- opciones[["directory"]]
  league_path <- glue::glue("{directory}/league_{league_season}.csv")
  return(read_csv(league_path, show_col_types = FALSE))
}

read_names_from_options_cli <- function(opciones) {
  league_season <- opciones[["league-season"]]
  directory <- opciones[["directory"]]
  path <- glue::glue("{directory}/names_{league_season}.csv")
  return(read_csv(path, show_col_types = FALSE))
}

read_season_from_options_cli <- function(opciones) {
  league_season <- opciones[["league-season"]]
  directory <- opciones[["directory"]]
  path <- glue::glue("{directory}/season_{league_season}.csv")
  return(read_csv(path, show_col_types = FALSE))
}
