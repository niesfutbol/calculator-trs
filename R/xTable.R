return_one <- function() {
  return(1)
}

calculate_points <- function(home_xGol, away_xGol){
  diff_goals <- home_xGol - away_xGol
  points <- sum(diff_goals > 0)*3 + sum(diff_goals == 0)
  return(points)
}
