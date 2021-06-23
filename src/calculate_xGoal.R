library("tidyverse")
league <- read_csv("tests/data/statistics_262_2019.csv")
league_home <- league %>%
  select("home", "home_shots_outsidebox", "home_shots_insidebox") %>%
  mutate(is_home = TRUE)
league_away <- league %>%
  select("away", "away_shots_outsidebox", "away_shots_insidebox") %>%
  mutate(is_home = FALSE)
colnames(league_away) <- c("gol", "outsidebox", "insidebox", "is_home")
colnames(league_home) <- c("gol", "outsidebox", "insidebox", "is_home")
cleaned_league <- bind_rows(league_home, league_away)
modelo <- glm(gol ~ 0 + outsidebox + insidebox, data = cleaned_league, poisson(link = "identity"))
resumen_modelo <- summary(modelo)
xGol_inside <- al$coefficients[2,1]
xGol_outside <- al$coefficients[1,1]