library("ggplot2")
library(tidyverse)
library(comprehenr)
download_logo_team <- function(id_team) {
  url <- glue::glue("https://media.api-sports.io/football/teams/{id_team}.png")
  download.file(url, destfile = glue::glue("logo_{id_team}.png"))
}
# to_vec(for(id in weighted_g_and_xg$team_id) download_logo_team(id))
nies <- png::readPNG("/workdir/tests/data/logo_nies.png", native = TRUE)

need_download <- FALSE
to_vec(for (id in weighted_g_and_xg$team_id) if (need_download) download_logo_team(id))


weighted_g_and_xg <- read_csv("results/weighted_g_and_xg.csv", show_col_types = FALSE)
logos <- to_vec(for (id in weighted_g_and_xg$team_id) png::readPNG(glue::glue("logo_{id}.png", native = TRUE)))

calculate_left <- function(x, brk) {
  recta <- lm(c(0, 1) ~ range(brk))
  m <- recta$coefficients[[2]]
  b <- recta$coefficients[[1]]
  return(m * x + b - 0.025)
}

calculate_right <- function(x, brk) {
  recta <- lm(c(0, 1) ~ range(brk))
  m <- recta$coefficients[[2]]
  b <- recta$coefficients[[1]]
  return(m * x + b + 0.025)
}

calculate_top <- function(x, brk) {
  recta <- lm(c(1, 0) ~ range(brk))
  m <- recta$coefficients[[2]]
  b <- recta$coefficients[[1]]
  return(m * x + b + 0.025)
}

calculate_bottom <- function(x, brk) {
  recta <- lm(c(1, 0) ~ range(brk))
  m <- recta$coefficients[[2]]
  b <- recta$coefficients[[1]]
  return(m * x + b - 0.025)
}
add_logo_team <- function(row, brk_x, brk_y) {
  l <- calculate_left(row$weighted_attack, brk_x)
  r <- calculate_right(row$weighted_attack, brk_x)
  t <- calculate_top(row$weighted_deffense, brk_y)
  b <- calculate_bottom(row$weighted_deffense, brk_y)
  path_logo <- glue::glue("logo_{row$team_id}.png")
  patchwork::inset_element(p = png::readPNG(path_logo, native = TRUE), left = l, bottom = b, right = r, top = t)
}
calculate_breaks <- function(weighted) {
  pretty(c(min(weighted), max(weighted)))
}
brk_y <- calculate_breaks(weighted_g_and_xg$weighted_deffense)
brk_x <- calculate_breaks(weighted_g_and_xg$weighted_attack)
p <- ggplot(weighted_g_and_xg, aes(x = weighted_attack, y = weighted_deffense)) +
  theme_classic() +
  xlab("Goles y xGoles a favor") +
  ylab("Goles y xGoles en contra") +
  scale_y_reverse(
    expand = c(0, 0),
    limits = range(brk_y),
    breaks = brk_y
  ) +
  scale_x_continuous(
    expand = c(0, 0),
    limits = range(brk_x),
    breaks = brk_x
  ) +
  patchwork::inset_element(p = nies, left = 0.705, bottom = 0.01, right = 0.995, top = 0.2)
for (i in 1:20) {
  p <- p + add_logo_team(weighted_g_and_xg[i, ], brk_x, brk_y)
}

output <- glue::glue("g_xg_cannon.jpg")
ggsave(output)
