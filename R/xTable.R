library(tidyverse)

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
