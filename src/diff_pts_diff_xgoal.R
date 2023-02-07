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

matches <- read_season_from_options_cli(opciones) %>%
  select(c(id_match, home_id, away_id))

the_league <- League$new(league, season, names)

nies <- png::readPNG("/workdir/tests/data/logo_nies.png", native = TRUE)
get_limits <- function(league, id_home, id_away) {
  league$set_id_team(id_home)
  home_team <- the_league$team
  league$set_id_team(id_away)
  away_team <- the_league$team
  home_low_limit <- min(home_team$diff_points, na.rm = TRUE)
  away_low_limit <- min(away_team$diff_points, na.rm = TRUE)
  home_sup_limit <- max(home_team$diff_points, na.rm = TRUE)
  away_sup_limit <- max(away_team$diff_points, na.rm = TRUE)
  low_limit <- ifelse(home_low_limit < away_low_limit, floor(home_low_limit), floor(away_low_limit))
  sup_limit <- ifelse(home_sup_limit > away_sup_limit, ceiling(home_sup_limit), ceiling(away_sup_limit))
  return(c(low_limit, sup_limit))
}
plot_chart_cep <- function(puntos, logo_nies, logo_team, limits) {
  media <- mean(puntos$diff_points, na.rm = TRUE)
  sd <- sd(puntos$diff_points, na.rm = TRUE)
  print(media)
  p <- ggplot(puntos, aes(x = date, y = diff_points)) +
    theme_classic() +
    geom_line(color = "steelblue") +
    geom_point() +
    xlab("") +
    ylab("") +
    ylim(limits[1], limits[2]) +
    geom_hline(yintercept = media, linetype = "dashed", color = "black") +
    geom_hline(yintercept = media + sd, linetype = "dashed", color = "green") +
    geom_hline(yintercept = media - sd, linetype = "dashed", color = "red") +
    patchwork::inset_element(p = logo_team, left = 0.005, bottom = 0.8, right = 0.205, top = 1)
  return(p)
}
download_logo_team <- function(id_team) {
  url <- glue::glue("https://media.api-sports.io/football/teams/{id_team}.png")
  download.file(url, destfile = "logo.png")
  img <- png::readPNG("logo.png", native = TRUE)
  return(img)
}
doble_o_nada <- function(league, id_home, id_away) {
  home_logo <- download_logo_team(id_home)
  away_logo <- download_logo_team(id_away)
  limits <- get_limits(league, id_home, id_away)
  the_league$set_id_team(id_home)
  puntos <- the_league$team
  p1 <- plot_chart_cep(puntos, nies, home_logo, limits)
  the_league$set_id_team(id_away)
  puntos <- the_league$team
  p2 <- plot_chart_cep(puntos, nies, away_logo, limits)
  p3 <- p1 + p2 + nies +
    patchwork::plot_layout(nrow = 2, byrow = TRUE) +
    patchwork::plot_layout(heights = c(15, 0.5))
}
match_id <- 881997
home_id <- matches %>% filter(id_match == match_id) %>% .$home_id
away_id <- matches %>% filter(id_match == match_id) %>% .$away_id
p <- doble_o_nada(the_league, home_id, away_id)
the_league$set_id_team(home_id)
home_name <- the_league$team_name
the_league$set_id_team(away_id)
away_name <- the_league$team_name
output <- glue::glue("{directory}/{home_name}_vs_{away_name}.jpg")
ggsave(output)