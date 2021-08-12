source("../../R/xTable.R")

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
})
