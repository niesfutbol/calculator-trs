#!/usr/bin/env Rscript
#
#

library(tidyverse)
library(comprehenr)
source("R/xTable.R")

opciones <- cli_calculate_xpoints()
league_season <- opciones[["league-season"]]
directory <- opciones[["directory"]]
statistics_path <- glue::glue("{directory}/league_{league_season}.csv")
league <- read_csv(statistics_path, show_col_types = FALSE)

resumen <- league %>%
  xpoint_team_place() %>%
  summarize_xpoints_played_match() %>%
  arrange(desc(xpuntos))

puntos <- league %>%
  point_team_place() %>%
  summarize_points_played_match()

xTable <- resumen %>% inner_join(puntos, by = c("team_id", "jj"))
path_names <- glue::glue("{directory}/names_{league_season}.csv")
names <- read_csv(path_names, show_col_types = FALSE, col_types = "cc")
xTable$xpuntos <- round(xTable$xpuntos, 2)
xTable %>%
  left_join(names, by = c("team_id" = "ids")) %>%
  write_csv(glue::glue("results/xTable_{league_season}.csv"))
