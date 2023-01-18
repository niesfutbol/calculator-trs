#!/usr/bin/env Rscript
#
#

library(tidyverse)
library(comprehenr)
source("R/xTable.R")

opciones <- cli_calculate_xpoints()
league_season <- opciones[["league-season"]]
statistics_path <- glue::glue("results/league_{league_season}.csv")
league <- read_csv(statistics_path)

resumen <- league %>%
  xpoint_team_place() %>%
  summarize_xpoints_played_match() %>%
  arrange(desc(xpuntos))

puntos <- league %>%
  point_team_place() %>%
  summarize_points_played_match()

xTable <- resumen %>% inner_join(puntos)
xTable$xpuntos <- round(xTable$xpuntos, 2)
xTable %>% write_csv(glue::glue("results/xTable_{league_season}.csv"))
