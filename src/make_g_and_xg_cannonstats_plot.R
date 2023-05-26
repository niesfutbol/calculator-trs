library("ggplot2")
library(tidyverse)
library(comprehenr)
download_logo_team <- function(id_team) {
  url <- glue::glue("https://media.api-sports.io/football/teams/{id_team}.png")
  download.file(url, destfile = glue::glue("logo_{id_team}.png"))
}
#to_vec(for(id in weighted_g_and_xg$team_id) download_logo_team(id))
nies <- png::readPNG("/workdir/tests/data/logo_nies.png", native = TRUE)

weighted_g_and_xg <- read_csv("results/weighted_g_and_xg.csv", show_col_types = FALSE)
logos <- to_vec(for(id in weighted_g_and_xg$team_id) png::readPNG(glue::glue("logo_{id}.png", native = TRUE)))

calculate_left <- function(x) {
  m <-  0.79923
  b <- -0.53846
  return(m*x+b-0.025)
}

calculate_right <- function(x) {
  m <-  0.79923
  b <- -0.53846
  return(m*x+b+0.025)
}

calculate_top <- function(x) {
  m <- -0.76923
  b <-  1.53846
  return(m*x+b+0.025)
}

calculate_bottom <- function(x) {
  m <- -0.76923
  b <-  1.53846
  return(m*x+b-0.025)
}
add_logo_team <- function(row) {
  l <- calculate_left(row$weighted_attack)
  r <- calculate_right(row$weighted_attack)
  t <- calculate_top(row$weighted_deffense)
  b <- calculate_bottom(row$weighted_deffense)
  path_logo <- glue::glue("logo_{row$team_id}.png")
  patchwork::inset_element(p = png::readPNG(path_logo, native = TRUE), left = l, bottom = b, right = r, top = t)
}
p <- ggplot(weighted_g_and_xg, aes(x = weighted_attack, y = weighted_deffense)) +
    theme_classic() +
    xlab("Goles y xGoles a favor") +
    ylab("Goles y xGoles en contra") +
    scale_y_reverse() +
    xlim(0.7, 2) +
    ylim(2, 0.7) +
    add_logo_team(weighted_g_and_xg[1,]) +
    add_logo_team(weighted_g_and_xg[2,]) +
    add_logo_team(weighted_g_and_xg[3,]) +
    add_logo_team(weighted_g_and_xg[4,]) +
    add_logo_team(weighted_g_and_xg[5,]) +
    add_logo_team(weighted_g_and_xg[6,]) +
    add_logo_team(weighted_g_and_xg[7,]) +
    add_logo_team(weighted_g_and_xg[8,]) +
    add_logo_team(weighted_g_and_xg[9,]) +
    add_logo_team(weighted_g_and_xg[10,]) +
    add_logo_team(weighted_g_and_xg[11,]) +
    add_logo_team(weighted_g_and_xg[12,]) +
    add_logo_team(weighted_g_and_xg[13,]) +
    add_logo_team(weighted_g_and_xg[14,]) +
    add_logo_team(weighted_g_and_xg[15,]) +
    add_logo_team(weighted_g_and_xg[16,]) +
    add_logo_team(weighted_g_and_xg[17,]) +
    add_logo_team(weighted_g_and_xg[18,]) +
    add_logo_team(weighted_g_and_xg[19,]) +
    add_logo_team(weighted_g_and_xg[20,]) +
    patchwork::inset_element(p = nies, left = 0.705, bottom = 0.01, right = 0.995, top = 0.2)

output <- glue::glue("g_xg_cannon.jpg")
ggsave(output)