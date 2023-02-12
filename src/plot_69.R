library("tidyverse")
library("xGoal")
matches <- read_csv("tests/data/season_2022.csv", show_col_types = FALSE)
seasons <- matches %>% select(c(id_match, date, league))
leagues <- read_csv("tests/data/league_2022.csv", show_col_types = FALSE)
names <- read_csv("tests/data/names_2022.csv", show_col_types = FALSE)
the_league <- League$new(leagues, seasons, names)
teams <- names$ids
all_teams <- tibble()
for (team in teams) {
  the_league$set_id_team(team)
  the_team <- the_league$team %>% mutate(team_id = team)
  all_teams <- rbind(all_teams, the_team)
}
all_teams <- all_teams %>% filter(!is.na(point_agg))
cleaned_matches <- matches %>%
  separate_wider_delim(round, " - ", names = c(NA, "round")) %>%
  mutate(round = as.numeric(round)) %>%
  filter(round > 4)
all_teams
all_matches <- tibble()
for (match in cleaned_matches$id_match) {
  info_from_match <- get_info_from_match(all_teams, match, matches)
  all_matches <- rbind(all_matches, info_from_match)
}
reg <- lm(formula = diff_point ~ diff_xgoal, data = all_matches)
coeff <- coefficients(reg)
intercept <- coeff[1]
slope <- coeff[2]
nies <- png::readPNG("/workdir/tests/data/logo_nies.png", native = TRUE)
p <- all_matches %>%
  left_join(leagues, by = join_by(match_id, home_id, away_id)) %>%
  ggplot(aes(x = diff_xgoal, y = diff_point)) +
  theme_classic() +
  geom_point(aes(colour = factor(home_Points))) +
  xlab("Diferencia xGol") +
  ylab("Diferencia puntos") +
  geom_abline(
    intercept = intercept,
    slope = slope,
    color = "black",
    linetype = "solid",
    size = 0.7
  ) +
  geom_abline(
    intercept = intercept + 4,
    slope = slope,
    color = "black",
    linetype = "dotted",
    size = 0.5
  ) +
  geom_abline(
    intercept = intercept - 4,
    slope = slope,
    color = "black",
    linetype = "dotted",
    size = 0.5
  ) +
  labs(color = "Puntos del equipo local") +
  theme(legend.position = "top")
p1 <- p + geom_text(x = 4, y = 5.5, label = "Zona 2", angle = 30) +
  geom_text(x = 4, y = 11, label = "Zona 1") +
  geom_text(x = 4, y = 1.5, label = "Zona 3", angle = 30) +
  geom_text(x = 4, y = -4, label = "Zona 4") +
  geom_segment(aes(x = -2.8504, y = -1.5, xend = -2.8504, yend = -3.5),
    arrow = arrow(length = unit(0.5, "cm"))
  ) +
  patchwork::inset_element(p = nies, left = 0.005, bottom = 0.9, right = 0.205, top = 1)

ggsave("afortunado_en_el_amor.jpg", dpi = 320)
