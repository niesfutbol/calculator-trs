source("../../R/xGoal.R")
source("../../R/xTable.R")
library("tidyverse")

describe("Dummy tests", {
  it("Return one", {
    expected <- 1
    obtained <- return_one()
    expect_equal(expected, obtained)
  })
})

describe("The class Teams", {
  teams <- Teams$new()
  path_league <- "../data/league_262_2021.csv"
  raw_league <- read_csv(path_league)
  expected_league <- xgoal_team_place(raw_league)
  it("Read a league file", {
    teams$read(path_league)
  })
  it("The method get_id_teams", {
    obtained_ids <- teams$get_id_teams()
    expect_true("2288" %in% obtained_ids)
    expect_true("2290" %in% obtained_ids)
    expect_true("2298" %in% obtained_ids)
  })
  it("The method set_team_from_id", {
    expected_team <- expected_league %>% filter(team_id == "2288")
    teams$set_team_from_id("2288")
    obtained_team <- teams$team
    expect_equal(expected_team, obtained_team)
    expected_team <- expected_league %>% filter(team_id == "2290")
    teams$set_team_from_id("2290")
    obtained_team <- teams$team
    expect_equal(expected_team, obtained_team)
  })
  it("The method bootstrapping_xgoal", {
    obtained_bootstrapped_xgoal <- teams$bootstrapping_xgoal()
    is_lower_max_xgol <- mean(obtained_bootstrapped_xgoal) < max(teams$team$xGol)
    expect_true(is_lower_max_xgol)
    is_greater_min_xgol <- mean(obtained_bootstrapped_xgoal) > min(teams$team$xGol)
    expect_true(is_greater_min_xgol)
    expect_true(length(obtained_bootstrapped_xgoal) == 2000)
  })
})

describe("The class Calculator_Density", {
  density <- Calculator_Density$new()
  it("The method probability_goal", {
    density <- density$probability_goal()
  })
})
