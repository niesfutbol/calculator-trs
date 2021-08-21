library(tidyverse)
library(optparse)

calculate_points <- function(home_xGol, away_xGol) {
  diff_goals <- home_xGol - away_xGol
  points <- sum(diff_goals > 0) * 3 + sum(diff_goals == 0)
  return(points)
}

add_home_shots_outsidebox <- function(datos) {
  salida <- datos %>% mutate("home_shots_outsidebox" = home_total_shots - home_shots_insidebox)
  return(salida)
}

add_away_shots_outsidebox <- function(datos) {
  salida <- datos %>% mutate("away_shots_outsidebox" = away_total_shots - away_shots_insidebox)
  return(salida)
}

calculate_diff_goals <- function(home_xGol, away_xGol) {
  n_sample <- 2000
  diff_goals <- rpois(n_sample, home_xGol) - rpois(n_sample, away_xGol)
  return(diff_goals)
}

xGoal_all_league <- list(
  "262_2021" = list(inside = 0.101, outside = 0.043),
  "140_2020" = list(inside = 0.125454, outside = 0.044485),
  "78_2020"  = list(inside = 0.116232, outside = 0.044561),
  "39_2020"  = list(inside = 0.107191, outside = 0.052831)
)

xgoal_from_league_season <- function(league_season) {
  xGoal <- xGoal_all_league[[league_season]]
  return(xGoal)
}

calculate_xgoal <- function(xGol, shots_outsidebox, shots_insidebox) {
  xgoal <- shots_outsidebox * xGol$outside + shots_insidebox * xGol$inside
  return(xgoal)
}

calculate_xpoints <- function(home_xGol, away_xGol) {
  diff_goals <- calculate_diff_goals(home_xGol, away_xGol)
  xpoints <- sum(diff_goals > 0) * 3 / 2000 + sum(diff_goals == 0) / 2000
  return(xpoints)
}


cli_calculate_xpoints <- function() {
  listaOpciones <- list(
    make_option(
      c("-l", "--league-season"),
      default = "262_2021",
      help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}

#' @export
xgoal_team_place <- function(league) {
  league %>%
    dplyr::select(home_xGol, away_xGol, home_id, away_id, match_id) %>%
    unite(col = "home", c(home_xGol, home_id), sep = "--") %>%
    unite(col = "away", c(away_xGol, away_id), sep = "--") %>%
    gather(key = "local", value = "xGol-d", -match_id) %>%
    separate(col = "xGol-d", into = c("xGol", "team_id"), sep = "--") %>%
    mutate(xGol = as.numeric(xGol))
}

xpoint_team_place <- function(league) {
  league %>%
    select(home_xPoints, away_xPoints, home_id, away_id) %>%
    unite(col = "home", c(home_xPoints, home_id), sep = "--") %>%
    unite(col = "away", c(away_xPoints, away_id), sep = "--") %>%
    gather(key = "local", value = "xPoint-d") %>%
    separate(col = "xPoint-d", into = c("xPoints", "team_id"), sep = "--") %>%
    mutate(xPoints = as.numeric(xPoints))
}

point_team_place <- function(league) {
  league %>%
    select(home_Points, away_Points, home_id, away_id) %>%
    unite(col = "home", c(home_Points, home_id), sep = "--") %>%
    unite(col = "away", c(away_Points, away_id), sep = "--") %>%
    gather(key = "local", value = "Point-d") %>%
    separate(col = "Point-d", into = c("Points", "team_id"), sep = "--") %>%
    mutate(Points = as.numeric(Points))
}

summarize_points_played_match <- function(league) {
  league %>%
    group_by(team_id) %>%
    summarize(
      puntos = sum(Points),
      jj = n()
    )
}

summarize_xpoints_played_match <- function(league) {
  league %>%
    group_by(team_id) %>%
    summarize(
      xpuntos = sum(xPoints),
      jj = n()
    )
}

home_xPoints_all_matches <- function(league) {
  home_xPoints <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_xpoints(league[match, ]$home_xGol, league[match, ]$away_xGol)
    }
  )
}

away_xPoints_all_matches <- function(league) {
  away_xPoints <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_xpoints(league[match, ]$away_xGol, league[match, ]$home_xGol)
    }
  )
}

home_Points_all_matches <- function(league) {
  home_Points <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_points(league[match, ]$home, league[match, ]$away)
    }
  )
}

away_Points_all_matches <- function(league) {
  away_Points <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_points(league[match, ]$away, league[match, ]$home)
    }
  )
}

add_xpoints_and_points <- function(league) {
  number_of_matches <- nrow(league)
  home_xPoints <- home_xPoints_all_matches(league)
  away_xPoints <- away_xPoints_all_matches(league)
  home_Points <- home_Points_all_matches(league)
  away_Points <- away_Points_all_matches(league)
  league <- cbind(league, tibble(home_xPoints, away_xPoints, home_Points, away_Points))
}
