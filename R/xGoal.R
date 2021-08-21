return_one <- function() {
  return(1)
}

Teams <- R6::R6Class("Teams",
  public = list(
    league = NULL,
    read = function(path_league) {
      raw_league <- readr::read_csv(path_league)
      self$league <- xGoal::xgoal_team_place(raw_league)
    },
    get_id_teams = function() {
      ids <- unique(self$league$team_id)
      return(ids)
    },
    set_team_from_id = function(id) {

    }
  ),
  private = list()
)
