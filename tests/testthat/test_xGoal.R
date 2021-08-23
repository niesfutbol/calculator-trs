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
    expected_density <- c(rep(1 / 5, 5), 0)
    bootstrapped_xgoal <- rep(seq(0, 4), 400)
    obtained_density <- density$probability_goal(bootstrapped_xgoal)
    expect_equal(expected_density, obtained_density)
    expected_density <- c(rep(c(1 / 4, 0), 2), rep(1 / 4, 2))
    bootstrapped_xgoal <- rep(seq(0, 6, 2), 500)
    obtained_density <- density$probability_goal(bootstrapped_xgoal)
    expect_equal(expected_density, obtained_density)
  })
})

describe("The class Heat_Map", {
  heat_map <- Heat_Map$new()
  it("The method matrix_heat_map works right", {
    probability_goal <- rep(1 / 6, 6)
    expected_matrix_heat_map <- matrix(rep(probability_goal^2, 6), nrow = 6)
    obtained_matrix_heat_map <- heat_map$matrix_heat_map(probability_goal, probability_goal)
    expect_equal(expected_matrix_heat_map, obtained_matrix_heat_map)
    probability_goal <- c(rep(0.2, 5), 0)
    expected_matrix_heat_map <- matrix(c(rep(probability_goal^2, 5), rep(0, 6)), nrow = 6)
    obtained_matrix_heat_map <- heat_map$matrix_heat_map(probability_goal, probability_goal)
    expect_equal(expected_matrix_heat_map, obtained_matrix_heat_map)
    probability_goal <- c(rep(0.5, 2), rep(0, 4))
    expected_matrix_heat_map <- matrix(c(rep(probability_goal^2, 2), rep(0, 24)), nrow = 6)
    obtained_matrix_heat_map <- heat_map$matrix_heat_map(probability_goal, probability_goal)
    expect_equal(expected_matrix_heat_map, obtained_matrix_heat_map)
  })
  it("The builder make a Teams and a Calculator_Density", {
    is_there_object_Teams <- ("Teams" %in% class(heat_map$teams))
    expect_true(is_there_object_Teams)
    is_there_object_Calculator_Density <- ("Calculator_Density" %in% class(heat_map$density))
    expect_true(is_there_object_Calculator_Density)
  })
  it("The method read works right", {
    path_league <- "../data/league_262_2021.csv"
    heat_map$read(path_league)
  })
  it("The method heat_map_goal_match works with id teams", {
    goal_match <- heat_map$heat_map_goal_match("2288", "2288")
    expect_equal(1, sum(goal_match))
    expect_equal(36, length(goal_match))
  })
})
