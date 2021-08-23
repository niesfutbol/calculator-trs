library(comprehenr)
return_one <- function() {
  return(1)
}

Teams <- R6::R6Class("Teams",
  public = list(
    team = NULL,
    read = function(path_league) {
      raw_league <- readr::read_csv(path_league)
      private$league <- xGoal::xgoal_team_place(raw_league)
    },
    get_id_teams = function() {
      ids <- unique(private$league$team_id)
      return(ids)
    },
    set_team_from_id = function(id) {
      self$team <- private$league %>% filter(team_id == id)
    },
    bootstrapping_xgoal = function() {
      B <- 2000
      sample_xgol <- sample(self$team$xGol, B, replace = TRUE)
      bootstrapped_xgoal <- rpois(B, sample_xgol)
      return(bootstrapped_xgoal)
    }
  ),
  private = list(
    league = NULL
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
    matrix_heat_map = function(prob_home, prob_away) {
      all_elemts <- to_vec(for (row in prob_home) for (column in prob_away) row * column)
      heat_map <- matrix(all_elemts, nrow = 6)
      return(heat_map)
    }
  ),
  private = list()
)
