source("../../R/xTable.R")
library(comprehenr)

describe("The function calculate_points", {
  it("return one point with draw", {
    expected_points <- 1
    obtained_points <- calculate_points(1, 1)
    expect_equal(expected_points, obtained_points)
  })
  it("return three points with local win", {
    expected_points <- 3
    obtained_points <- calculate_points(1, 0)
    expect_equal(expected_points, obtained_points)
  })
  it("return zero points with visit win", {
    expected_points <- 0
    obtained_points <- calculate_points(0, 1)
    expect_equal(expected_points, obtained_points)
  })
})

describe("The function add_home/away_shots_outsidebox", {
  test_data <- tibble(home_total_shots = c(2, 3), home_shots_insidebox = c(1, 1))
  it("add_home_shots_outsidebox", {
    expected <- tibble(home_total_shots = c(2, 3), home_shots_insidebox = c(1, 1), home_shots_outsidebox = c(1, 2))
    obtained <- add_home_shots_outsidebox(test_data)
    expect_equal(expected, obtained)
  })
  test_data <- tibble(away_total_shots = c(2, 3), away_shots_insidebox = c(1, 1))
  it("add_away_shots_outsidebox", {
    expected <- tibble(away_total_shots = c(2, 3), away_shots_insidebox = c(1, 1), away_shots_outsidebox = c(1, 2))
    obtained <- add_away_shots_outsidebox(test_data)
    expect_equal(expected, obtained)
  })
})

describe("The function calculate_diff_goals", {
  it("Length equal to 2000", {
    expected_length <- 2000
    obtained_diff_goal <- calculate_diff_goals(2, 0)
    obtained_length <- length(obtained_diff_goal)
    expect_equal(expected_length, obtained_length)
  })
  assert_mean_difference_goals <- function(home_xgoal, away_xgoal) {
    expected_mean_difference <- home_xgoal - away_xgoal
    obtained_diff_goal <- to_vec(for (i in 1:2000) mean(calculate_diff_goals(home_xgoal, away_xgoal)))
    obtained_mean_difference <- mean(obtained_diff_goal)
    expect_equal(expected_mean_difference, obtained_mean_difference, tolerance = 1e-3)
  }
  it("Mean difference aprox. 2", {
    home_xgoal <- 2
    away_xgoal <- 0
    assert_mean_difference_goals(home_xgoal, away_xgoal)
  })
  it("Mean difference aprox. 3", {
    home_xgoal <- 5
    away_xgoal <- 2
    assert_mean_difference_goals(home_xgoal, away_xgoal)
  })
})

describe("The function calculate_xgoal", {
  it("The function calculate_xgoal is in R", {
    x_goal <- list(inside = 1, outside = 1)
    expected_goal <- calculate_xgoal(xGol = x_goal, shots_outsidebox = 1, shots_insidebox = 1)
    obtained_goal <- 2
    expect_equal(expected_goal, obtained_goal)
  })
  it("The function calculate_xgoal is in R", {
    x_goal <- list(inside = 2, outside = 3)
    expected_goal <- calculate_xgoal(xGol = x_goal, shots_outsidebox = 0, shots_insidebox = 2)
    obtained_goal <- 4
    expect_equal(expected_goal, obtained_goal)
  })
})

describe("The function calculate_xpoints", {
  it("The function calculate_xpoints is in R", {
    calculate_points()
  })
})

describe("The function xgoal_from_league_season", {
  it("xGoal for La Liga 2021", {
    expected_goal <- xgoal_from_league_season("140_2020")
    obtained_goal <- list(inside = 0.125454, outside = 0.044485)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for MX 2020", {
    expected_goal <- xgoal_from_league_season("262_2021")
    obtained_goal <- list(inside = 0.101, outside = 0.043)
    expect_equal(expected_goal, obtained_goal)
  })
})
