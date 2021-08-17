library(tidyverse)
library(comprehenr)
source("R/xTable.R")

calculate_xpoints <- function(home_xGol, away_xGol){
  diff_goals <- calculate_diff_goals(home_xGol, away_xGol)
  xpoints <- sum(diff_goals > 0)*3/2000 + sum(diff_goals == 0)/2000
  return(xpoints)
}
league_season <- "262_2021"
statistics_path <- glue("tests/data/statistics_{league_season}.csv")
xGol <- xgoal_from_league_season(league_season)
league <- read_csv(statistics_path)
league[is.na(league)] <- 0
league <- league %>%
  add_home_shots_outsidebox() %>%
  add_away_shots_outsidebox() %>%
  mutate("home_xGol" = calculate_xgoal(xGol, home_shots_outsidebox, home_shots_insidebox)) %>%
  mutate("away_xGol" = calculate_xgoal(xGol, away_shots_outsidebox, away_shots_insidebox)) %>%
  mutate("home_alpha" = dpois(home, home_xGol)) %>%
  mutate("away_alpha" = dpois(away, away_xGol))

number_of_matches <- nrow(league)
home_xPoints <- to_vec(for(x in 1:number_of_matches) calculate_xpoints(league[x,]$home_xGol, league[x,]$away_xGol))
away_xPoints <- to_vec(for(x in 1:number_of_matches) calculate_xpoints(league[x,]$away_xGol, league[x,]$home_xGol))
home_Points <- to_vec(for(x in 1:number_of_matches) calculate_points(league[x,]$home, league[x,]$away))
away_Points <- to_vec(for(x in 1:number_of_matches) calculate_points(league[x,]$away, league[x,]$home))
league <- cbind(league, tibble(home_xPoints, away_xPoints, home_Points, away_Points))

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
    xPuntos = sum(xPoints),
    jj = n()) %>%
  arrange(desc(xPuntos))

puntos <- league %>%
  select(home_Points, away_Points, match_id, home_id, away_id) %>%
  unite(col="home", c(home_Points, home_id), sep="--") %>%
  unite(col="away", c(away_Points, away_id), sep="--") %>%
  gather(key="local", value="Point-d", -match_id) %>%
  separate(col="Point-d", into=c('Points', 'id'), sep='--') %>%
  group_by(id) %>%
  mutate(Points = as.numeric(Points)) %>%
  summarize(
    puntos = sum(Points),
    jj = n()) %>%
  arrange(desc(puntos))

xTable <- resumen %>% inner_join(puntos)
xTable$xPuntos <- round(xTable$xPuntos,2)
xTable %>% write_csv(glue("results/xTable_{league_season}.csv"))