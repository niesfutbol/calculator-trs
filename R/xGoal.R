return_one <- function() {
  return(1)
}

Teams <- R6::R6Class("Teams",
  public = list(
    league = NULL,
    read = function(path_league) {
      self$league <- read_csv(path_league)
    }
  ),
  private = list()
)