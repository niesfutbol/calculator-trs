library("ggplot2")
library("RcppRoll")
library("tidyverse")
source("/workdir/R/xTable.R")
source("/workdir/R/diff_pts_diff_xgoal.R")

opciones <- cli_calculate_xpoints()
league_season <- opciones[["league-season"]]
directory <- opciones[["directory"]]
league <- read_league_from_options_cli(opciones)
names <- read_names_from_options_cli(opciones)
path_season <- glue::glue("{directory}/season_{league_season}.csv")
season <- read_season_from_options_cli(opciones) %>%
  select(c(id_match, date, league))

league <- league %>% left_join(season, by = c("match_id" = "id_match"))

id_team <- 505
nombre <- names %>%
  filter(ids == id_team) %>%
  .$names

liga <- get_league_name_from_season(season)
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

library("patchwork")

# Download and read sample image (readJPEG doesn't work with urls)
url <- glue::glue("https://media.api-sports.io/football/teams/{id_team}.png")
download.file(url, destfile = "logo.png")
img <- png::readPNG("logo.png", native = TRUE)
nies <- png::readPNG("/workdir/tests/data/nies.png", native = TRUE)
p <- ggplot(puntos, aes(x = date, y = diff_points)) +
  theme_classic() +
  geom_line(color = "steelblue") +
  geom_point() +
  xlab("") +
  ylab("") +
  geom_hline(yintercept = media, linetype = "dashed", color = "black") +
  geom_hline(yintercept = media + sd, linetype = "dashed", color = "green") +
  geom_hline(yintercept = media - sd, linetype = "dashed", color = "red") +
  inset_element(p = img, left = 0.005, bottom = 0.8, right = 0.205, top = 1) +
  inset_element(p = nies, left = 0.95, bottom = 0.015, right = 1, top = 0.065)

output <- glue::glue("{directory}/{nombre}_{league_season}.jpg")
ggsave(output)
