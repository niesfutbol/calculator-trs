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
calculate_breaks <- function(weighted) {
  pretty(c(min(weighted), max(weighted)))
}
brk <- calculate_breaks(weighted_g_and_xg$weighted_deffense)
brk_x <- calculate_breaks(weighted_g_and_xg$weighted_attack)
p <- ggplot(weighted_g_and_xg, aes(x = weighted_attack, y = weighted_deffense)) +
    theme_classic() +
    xlab("Goles y xGoles a favor") +
    ylab("Goles y xGoles en contra") +
    scale_y_reverse(
      expand = c(0,0),
      limits = range(brk),
      breaks = brk
    ) +
    scale_x_continuous(
      expand = c(0,0),
      limits = range(brk_x),
      breaks = brk_x
    ) +
    patchwork::inset_element(p = nies, left = 0.705, bottom = 0.01, right = 0.995, top = 0.2)
for (i in 1:20) {
  p <- p + add_logo_team(weighted_g_and_xg[i,])
}

output <- glue::glue("g_xg_cannon.jpg")
ggsave(output)