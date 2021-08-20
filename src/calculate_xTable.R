#!/usr/bin/env Rscript
#
#

library(tidyverse)
library(comprehenr)
source("R/xTable.R")

opciones <- cli_calculate_xpoints();
league_season <- opciones[["league-season"]]
statistics_path <- glue::glue("results/league_{league_season}.csv")
league <- read_csv(statistics_path)

resumen <- league %>%
  select(home_xPoints, away_xPoints, home_id, away_id) %>%
  unite(col="home", c(home_xPoints, home_id), sep="--") %>%
  unite(col="away", c(away_xPoints, away_id), sep="--") %>%
  gather(key="local", value="xPoint-d") %>%
  separate(col="xPoint-d", into=c('xPoints', 'id'), sep='--') %>%
  group_by(id) %>%
  mutate(xPoints = as.numeric(xPoints)) %>%
  summarize(
    xPuntos = sum(xPoints),
    jj = n()) %>%
  arrange(desc(xPuntos))

puntos <- league %>%
  select(home_Points, away_Points, home_id, away_id) %>%
  unite(col="home", c(home_Points, home_id), sep="--") %>%
  unite(col="away", c(away_Points, away_id), sep="--") %>%
  gather(key="local", value="Point-d") %>%
  separate(col="Point-d", into=c('Points', 'id'), sep='--') %>%
  group_by(id) %>%
  mutate(Points = as.numeric(Points)) %>%
  summarize(
    puntos = sum(Points),
    jj = n()) %>%
  arrange(desc(puntos))

xTable <- resumen %>% inner_join(puntos)
xTable$xPuntos <- round(xTable$xPuntos,2)
xTable %>% write_csv(glue::glue("results/xTable_{league_season}.csv"))