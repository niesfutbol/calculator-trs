library("ggplot2")
library("tidyverse")
library("xGoal")
source("/workdir/R/cli_options.R")

names_options_cli <- c("league", "directory")
opciones <- get_options_from_names(names_options_cli)
league_season <- opciones[["league-season"]]
directory <- opciones[["directory"]]
league <- read_league_from_options_cli(opciones)
names <- read_names_from_options_cli(opciones)
season <- read_season_from_options_cli(opciones) %>%
  select(c(id_match, date, league))

the_league <- League$new(league, season, names)

id_team <- 505
the_league$set_id_team(id_team)

liga <- the_league$league_name
nombre <- the_league$team_name
print(nombre)

output <- glue::glue("borrame_{id_team}.csv")
puntos <- the_league$team
#puntos$point_6 <- RcppRoll::roll_mean(puntos$point, n = 4, align = "right", fill = NA)
puntos$xpoint_6 <- RcppRoll::roll_mean(puntos$xpoint, n = 4, align = "right", fill = NA)
puntos <- puntos %>% mutate(diff_points = point_agg - xpoint_6)
puntos %>% write_csv(output)

media <- mean(puntos$diff_points, na.rm = TRUE)
sd <- sd(puntos$diff_points, na.rm = TRUE)
print(media)


# Download and read sample image (readJPEG doesn't work with urls)
url <- glue::glue("https://media.api-sports.io/football/teams/{id_team}.png")
download.file(url, destfile = "logo.png")
img <- png::readPNG("logo.png", native = TRUE)
nies <- png::readPNG("/workdir/tests/data/logo_nies.png", native = TRUE)
p <- ggplot(puntos, aes(x = date, y = diff_points)) +
  theme_classic() +
  geom_line(color = "steelblue") +
  geom_point() +
  xlab("") +
  ylab("") +
  geom_hline(yintercept = media, linetype = "dashed", color = "black") +
  geom_hline(yintercept = media + sd, linetype = "dashed", color = "green") +
  geom_hline(yintercept = media - sd, linetype = "dashed", color = "red") +
  patchwork::inset_element(p = img, left = 0.005, bottom = 0.8, right = 0.205, top = 1) +
  patchwork::inset_element(p = nies, left = 0.80, bottom = 0.005, right = 1, top = 0.105)

output <- glue::glue("{directory}/{nombre}_{league_season}.jpg")
ggsave(output)
