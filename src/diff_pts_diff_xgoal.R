library("ggplot2")
library("RcppRoll")
library("tidyverse")
source("/workdir/R/xTable.R")

opciones <- cli_calculate_xpoints()
league_season <- opciones[["league-season"]]
directory <- opciones[["directory"]]
league_path <- glue::glue("{directory}/league_{league_season}.csv")
league <- read_csv(league_path, show_col_types = FALSE)
path_names <- glue::glue("{directory}/names_{league_season}.csv")
names <- read_csv(path_names, show_col_types = FALSE)
path_season <- glue::glue("{directory}/season_{league_season}.csv")
season <- read_csv(path_season, show_col_types = FALSE, col_types = "cc") %>%
  select(c(id_match, date))

league <- league %>% left_join(season, by = c("match_id" = "id_match"))

id_team <- 505
nombre <- names %>% filter(ids ==id_team) %>% .$names
print(nombre)
point <- extract_point_from_league(league, id_team)
xpoint <- extract_xpoint_from_league(league, id_team)
date <- extract_date_from_league(league, id_team)

output <- glue::glue("borrame_{id_team}.csv")
puntos <- tibble(date, xpoint, point) %>% arrange(date)
puntos$point_6 <- roll_mean(puntos$point, n = 4, align = "right", fill = NA)
puntos$xpoint_6 <- roll_mean(puntos$xpoint, n = 4, align = "right", fill = NA)
puntos <- puntos %>% mutate(diff_points = point_6 - xpoint_6)
puntos %>% write_csv(output)

media <- mean(puntos$diff_points, na.rm = TRUE)
sd <- sd(puntos$diff_points, na.rm = TRUE)
print(media)

p <- ggplot(puntos, aes(x=date, y=diff_points)) +
  geom_line( color="steelblue") +
  geom_point() +
  xlab("") +
  geom_hline(yintercept=media, linetype="dashed", color = "black") +
  geom_hline(yintercept=media + sd, linetype="dashed", color = "green") +
  geom_hline(yintercept=media - sd, linetype="dashed", color = "red") +
  labs(title = nombre, subtitle = league_season)
output <- glue::glue("{directory}/{nombre}_{league_season}.jpg")
ggsave(output)