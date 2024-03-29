source("/workdir/R/diff_pts_diff_xgoal.R")

run_diff_pts_diff_xgoal <- function() {
  league_season <- "135_2022"
  directory <- "/workdir/tests/data"
  src_file <- "/workdir/src/diff_pts_diff_xgoal.R"
  command <- glue::glue("Rscript {src_file} -l {league_season} -d {directory}")
  system(command)
}

describe("get_league_name_from_season", {
  it("Serie A", {
    path <- glue::glue("/workdir/tests/data/season_135_2022.csv")
    season <- read_csv(path, show_col_types = FALSE)
    expected <- "Italy - Serie A"
    obtained <- get_league_name_from_season(season)
    expect_equal(obtained, expected)
  })
  it("Bundesliga", {
    path <- glue::glue("/workdir/tests/data/season_78_2022.csv")
    season <- read_csv(path, show_col_types = FALSE)
    expected <- "Germany - Bundesliga"
    obtained <- get_league_name_from_season(season)
    expect_equal(obtained, expected)
  })
})
