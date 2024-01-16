library(comprehenr)
library(ggplot2)
library(ggpubr)
source("R/xTable.R")

Teams <- R6::R6Class("Teams",
  public = list(
    team = NULL,
    names = NULL,
    team_g_xg = NULL,
    league_for_soccerbars = NULL,
    read = function(path_league) {
      raw_league <- readr::read_csv(path_league, show_col_types = FALSE)
      private$full_league <- raw_league
      xgoal_league <- xgoal_team_place(raw_league)
      goal_league <- goal_team_place(raw_league)
      private$league <- xgoal_league |> left_join(goal_league, by = c("match_id", "local", "team_id"))
    },
    get_id_teams = function() {
      ids <- unique(private$league$team_id)
      return(ids)
    },
    set_team_from_id = function(id) {
      self$team <- private$league %>% dplyr::filter(team_id == id)
      private$calculate_g_and_xg(id)
      private$calculate_league_for_soccerbars(id)
    },
    bootstrapping_xgoal = function() {
      B <- 2000
      sample_xgol <- sample(self$team$xGol, B, replace = TRUE)
      bootstrapped_xgoal <- rpois(B, sample_xgol)
      return(bootstrapped_xgoal)
    },
    set_names = function(path_names) {
      self$names <- read_csv(path_names, show_col_types = FALSE)
    },
    get_name_from_id = function(id) {
      name <- self$names %>%
        filter(ids == id) %>%
        .$names
      return(name)
    },
    get_weighted_g_and_xg = function() {
      return(c(mean(self$team_g_xg$wgol_f), mean(self$team_g_xg$wgol_a)))
    }
  ),
  private = list(
    league = NULL,
    full_league = NULL,
    calculate_g_and_xg = function(id) {
      self$team_g_xg <- tibble::tibble(
        "attack" = extract_xgoal_attack_from_league(private$full_league, id),
        "deffense" = extract_xgoal_defense_from_league(private$full_league, id),
        "gol_f" = extract_goal_attack_from_league(private$full_league, id),
        "gol_a" = extract_goal_defense_from_league(private$full_league, id),
      ) |>
        mutate(
          wgol_f = 0.7 * attack + 0.3 * gol_f,
          wgol_a = 0.7 * deffense + 0.3 * gol_a
        )
    },
    calculate_league_for_soccerbars = function(id) {
      self$league_for_soccerbars <- private$full_league |>
        filter(match_id %in% self$team$match_id) |>
        select(c(1, 2, 3, 4)) |>
        mutate(away_game = ifelse(home_id == id, FALSE, TRUE))
    }
  )
)

Calculator_Density <- R6::R6Class("Calculator_Density",
  public = list(
    probability_goal = function(xGol) {
      density <- to_vec(for (gol in seq(0, 10)) sum(xGol == gol) / 2000)
      density <- private$clean_density(density)
      return(density)
    }
  ),
  private = list(
    clean_density = function(density) {
      density[6] <- 1 - sum(density[1:5])
      return(density[1:6])
    }
  )
)

Heat_Map <- R6::R6Class("Heat_Map",
  public = list(
    teams = Teams$new(),
    density = Calculator_Density$new(),
    home_team = NULL,
    away_team = NULL,
    matrix_heat_map = function(prob_home, prob_away) {
      all_elemts <- to_vec(for (row in prob_home) for (column in prob_away) row * column)
      heat_map <- matrix(all_elemts, nrow = 6)
      return(heat_map)
    },
    get_probable_score = function(home_id, away_id) {
      private$set_home_away_name(home_id, away_id)
      private$home_probability_goal <- private$get_probability_goal_from_id(home_id)
      private$away_probability_goal <- private$get_probability_goal_from_id(away_id)
      problable_score <- self$matrix_heat_map(private$home_probability_goal, private$away_probability_goal)
    },
    read = function(path_league) {
      self$teams$read(path_league)
    },
    plot = function(probable_score) {
      scores <- expand.grid(away = as.character(seq(0, 5)), home = as.character(seq(0, 5)))
      scores$probabilities <- as.vector(probable_score)
      private$heat_map <- ggplot(scores, aes(home, away, fill = probabilities)) +
        geom_tile() +
        geom_text(aes(label = round(probabilities, 3))) +
        labs(x = "", y = "") +
        scale_fill_gradient(low = "white", high = "red")
      home_prob <- tibble(home = as.character(seq(0, 5)), prob = private$home_probability_goal)
      private$home_barplot <- ggplot(data = home_prob, aes(x = home, y = prob)) +
        geom_bar(stat = "identity", fill = "#EF9A9A") +
        lims(y = c(0, 1)) +
        labs(x = "", y = "") +
        theme_classic() +
        ggtitle(self$home_team)
      away_prob <- tibble(away = as.character(seq(0, 5)), prob = private$away_probability_goal)
      private$away_barplot <- ggplot(data = away_prob, aes(x = away, y = prob)) +
        geom_bar(stat = "identity", fill = "#FF8A65") +
        rotate() +
        scale_y_reverse() +
        lims(y = c(1, 0)) +
        labs(x = "", y = "") +
        theme_classic() +
        ggtitle(self$away_team)
      ggarrange(NULL, private$home_barplot, private$away_barplot, private$heat_map,
        ncol = 2, nrow = 2, align = "hv",
        widths = c(1, 2), heights = c(1, 2),
        common.legend = TRUE
      )
    },
    save = function(name) {
      ggsave(name)
    },
    set_names = function(path_names) {
      self$teams$set_names(path_names)
    }
  ),
  private = list(
    heat_map = NULL,
    home_probability_goal = NULL,
    away_probability_goal = NULL,
    home_barplot = NULL,
    away_barplot = NULL,
    get_probability_goal_from_id = function(id) {
      self$teams$set_team_from_id(id)
      bootstrapped_xgoal <- self$teams$bootstrapping_xgoal()
      probability_goal <- self$density$probability_goal(bootstrapped_xgoal)
      return(probability_goal)
    },
    set_home_away_name = function(home_id, away_id) {
      self$home_team <- self$teams$get_name_from_id(home_id)
      self$away_team <- self$teams$get_name_from_id(away_id)
    }
  )
)

probability_win_draw_win <- function(probable_score) {
  probability <- rep(0, 3)
  probability[2] <- sum(diag(probable_score))
  probability[1] <- sum(probable_score[upper.tri(probable_score)])
  probability[3] <- 1 - sum(probability[1:2])
  return(probability)
}
