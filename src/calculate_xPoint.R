library(tidyverse)
calculate_xgoal <- function(shots_outsidebox, shots_insidebox){
  xGol_inside <- 0.09720
  xGol_outside <- 0.06995
  xgoal <- shots_outsidebox * xGol_outside + shots_insidebox * xGol_inside
  return(xgoal)
}

calculate_diff_goals <- function(home_xGol, away_xGol){
  n_sample <- 2000
  diff_goals <- rpois(n_sample, home_xGol) - rpois(n_sample, away_xGol)
  return(diff_goals)
}

calculate_xpoints <- function(home_xGol, away_xGol){
  diff_goals <- calculate_diff_goals(home_xGol, away_xGol)
  xpoints <- sum(diff_goals > 0)*3/2000 + sum(diff_goals == 0)/2000
  return(xpoints)
}

league <- read_csv("tests/data/statistics_262_2020.csv")
league <- league %>%
  mutate("home_shots_outsidebox" = home_total_shots - home_shots_insidebox) %>%
  mutate("away_shots_outsidebox" = away_total_shots - away_shots_insidebox) %>%
  mutate("home_xGol" = calculate_xgoal(home_shots_outsidebox, home_shots_insidebox)) %>%
  mutate("away_xGol" = calculate_xgoal(away_shots_outsidebox, away_shots_insidebox)) %>%
  mutate("home_alpha" = dpois(home, home_xGol)) %>%
  mutate("away_alpha" = dpois(away, away_xGol))
home_xPoints <- to_vec(for(x in 1:40) calculate_xpoints(league[x,]$home_xGol, league[x,]$away_xGol))
away_xPoints <- to_vec(for(x in 1:40) calculate_xpoints(league[x,]$away_xGol, league[x,]$home_xGol))
league <- cbind(league, tibble(home_xPoints, away_xPoints))

suspicious_game <- league %>%
  filter(home_alpha < 0.05 | away_alpha < 0.05) %>%
  select(c("match_id", "home", "away", "home_xGol", "away_xGol", "home_xPoints", "away_xPoints"))

resumen <- league %>% 
  select(home_xPoints, away_xPoints, match_id, home_id, away_id) %>% 
  unite(col="home", c(home_xPoints, home_id), sep="--") %>%
  unite(col="away", c(away_xPoints, away_id), sep="--") %>%
  gather(key="local", value="xPoint-d", -match_id) %>%
  separate(col="xPoint-d", into=c('xPoints', 'id'), sep='--') %>%
  group_by(id) %>%
  mutate(xPoints = as.numeric(xPoints)) %>%
  summarize(
    puntos = sum(xPoints), 
    jj = n()) %>%
  arrange(desc(puntos))