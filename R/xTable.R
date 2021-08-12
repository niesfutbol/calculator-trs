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

calculate_diff_goals <- function(home_xGol, away_xGol){
  n_sample <- 2000
  diff_goals <- rpois(n_sample, home_xGol) - rpois(n_sample, away_xGol)
  return(diff_goals)
}
