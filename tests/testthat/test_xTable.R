library(comprehenr)
library(tidyverse)
setwd("/workdir")
source("R/xTable.R")

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
    x_goal <- list(inside = 1, outside = 1, penalty = 0)
    expected_goal <- calculate_xgoal(xGol = x_goal, shots_outsidebox = 1, shots_insidebox = 1, total_penalties = 3)
    obtained_goal <- 2
    expect_equal(expected_goal, obtained_goal)
  })
  it("The function calculate_xgoal is in R", {
    x_goal <- list(inside = 2, outside = 3, penalty = 2)
    expected_goal <- calculate_xgoal(xGol = x_goal, shots_outsidebox = 0, shots_insidebox = 2, total_penalties = 3)
    obtained_goal <- 10
    expect_equal(expected_goal, obtained_goal)
  })
})

describe("The function calculate_xpoints", {
  it("The local win", {
    limit_sup <- 3
    limit_inf <- 2
    simulations_points <- to_vec(for (i in 1:2000) calculate_xpoints(2, 1))
    obtained_points <- mean(simulations_points)
    expect_true(limit_inf < obtained_points)
    expect_true(limit_sup > obtained_points)
  })
  it("Draw", {
    limit_sup <- 2
    limit_inf <- 1
    simulations_points <- to_vec(for (i in 1:2000) calculate_xpoints(3, 3))
    obtained_points <- mean(simulations_points)
    expect_true(limit_inf < obtained_points)
    expect_true(limit_sup > obtained_points)
  })
})

describe("The function xgoal_from_league_season", {
  it("xGoal for La Liga 2021", {
    expected_goal <- xgoal_from_league_season("140_2020")
    obtained_goal <- list(inside = 0.117440, outside = 0.043654, penalty = 0.744681)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for MX 2020", {
    expected_goal <- list(inside = 0.096171, outside = 0.045958, penalty = 0.785234)
    obtained_goal <- xgoal_from_league_season("262_2021")
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for Premier League 2020", {
    expected_goal <- xgoal_from_league_season("39_2021")
    obtained_goal <- list(inside = 0.107191, outside = 0.052831, penalty = 0.809524)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for Bundesliga 2020", {
    expected_goal <- xgoal_from_league_season("78_2020")
    obtained_goal <- list(inside = 0.110081, outside = 0.037332, penalty = 0.774774)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for Serie A 2020", {
    expected_goal <- xgoal_from_league_season("135_2021")
    obtained_goal <- list(inside = 0.104484, outside = 0.054466, penalty = 0.846666)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal for Ligue 1 2020", {
    expected_goal <- xgoal_from_league_season("61_2020")
    obtained_goal <- list(inside = 0.108780, outside = 0.065102)
    expect_equal(expected_goal, obtained_goal)
  })
  it("xGoal from unexistent league", {
    expect_error(xgoal_from_league_season("foo_boo"))
  })
})

describe("The function xgoal_team_place", {
  league <- tibble(
    match_id = c(22, 33),
    home_xGol = c(2, 3),
    home_id = c(1, 2),
    away_xGol = c(5, 6),
    away_id = c(3, 4)
  )
  it("xGoal for Bundesliga 2020", {
    expected_table_xgoal <- tibble(
      match_id = c(22, 33, 22, 33),
      local = c("home", "home", "away", "away"),
      xGol = c(2, 3, 5, 6),
      team_id = as.character(c(1, 2, 3, 4))
    )
    obtained_table_xgoal <- xgoal_team_place(league)
    expect_equal(expected_table_xgoal, obtained_table_xgoal)
  })
})

describe("The function xpoint_team_place", {
  league <- tibble(
    home_xPoints = c(2, 3),
    home_id = c(1, 2),
    away_xPoints = c(5, 6),
    away_id = c(3, 4)
  )
  it("xGoal for Bundesliga 2020", {
    expected_table_xgoal <- tibble(
      local = c("home", "home", "away", "away"),
      xPoints = c(2, 3, 5, 6),
      team_id = as.character(c(1, 2, 3, 4))
    )
    obtained_table_xgoal <- xpoint_team_place(league)
    expect_equal(expected_table_xgoal, obtained_table_xgoal)
  })
})

describe("The function point_team_place", {
  league <- tibble(
    home_Points = c(2, 3),
    home_id = c(1, 2),
    away_Points = c(5, 6),
    away_id = c(3, 4)
  )
  it("xGoal for Bundesliga 2020", {
    expected_table_xgoal <- tibble(
      local = c("home", "home", "away", "away"),
      Points = c(2, 3, 5, 6),
      team_id = as.character(c(1, 2, 3, 4))
    )
    obtained_table_xgoal <- point_team_place(league)
    expect_equal(expected_table_xgoal, obtained_table_xgoal)
  })
})

describe("The function summarize_points_played_match", {
  it(" correct answer", {
    table_Points <- tibble(
      local = c("home", "home", "away", "away"),
      Points = c(1, 3, 1, 0),
      team_id = as.character(c(1, 2, 1, 2))
    )
    expected_summary <- tibble(
      team_id = as.character(c(1, 2)),
      puntos = c(2, 3),
      jj = c(2, 2)
    )
    obtained_summary <- summarize_points_played_match(table_Points)
    expect_equal(expected_summary, obtained_summary)
  })
})

describe("The function summarize_points_played_match", {
  it(" correct answer", {
    table_Points <- tibble(
      local = c("home", "home", "away", "away"),
      xPoints = c(1, 3, 1, 0),
      team_id = as.character(c(1, 2, 1, 2))
    )
    expected_summary <- tibble(
      team_id = as.character(c(1, 2)),
      xpuntos = c(2, 3),
      jj = c(2, 2)
    )
    obtained_summary <- summarize_xpoints_played_match(table_Points)
    expect_equal(expected_summary, obtained_summary)
  })
})



describe("The funtion previous_season", {
  it("First example", {
    expected_season <- "68_2020"
    obtained_season <- previous_season("68_2021")
    expect_equal(expected_season, obtained_season)
  })
  it("Second example", {
    expected_season <- "135_2020"
    obtained_season <- previous_season("135_2021")
    expect_equal(expected_season, obtained_season)
  })
  it("Other example", {
    expected_season <- "78_2025"
    obtained_season <- previous_season("78_2026")
    expect_equal(expected_season, obtained_season)
  })
})

league_attack_defense <- tibble(
  home_id = c(1, 2, 3),
  home_xGol = c(0.2, 0.3, 0.4),
  away_id = c(2, 1, 1),
  away_xGol = c(0.3, 0.2, 0.2)
)

describe("get_strength_atack()", {
  expected_strength_atack <- 0.2
  obtained_strength_atack <- get_strength_atack(league_attack_defense, id = 1)
  expect_equal(obtained_strength_atack, expected_strength_atack, tolerance = 1e-3)
  obtained_strength_atack <- get_strength_atack(league_attack_defense, id = 2)
  expected_strength_atack <- 0.3
  expect_equal(obtained_strength_atack, expected_strength_atack, tolerance = 1e-3)
})

describe("get_strength_defense()", {
  expected_strength_defense <- 1 / 3
  obtained_strength_defense <- get_strength_defense(league_attack_defense, id = 1)
  expect_equal(obtained_strength_defense, expected_strength_defense, tolerance = 1e-3)
  obtained_strength_defense <- get_strength_defense(league_attack_defense, id = 2)
  expected_strength_defense <- 0.2
  expect_equal(obtained_strength_defense, expected_strength_defense, tolerance = 1e-3)
})

league_attack_defense_streak <- tibble(
  home_id = c(1, 1, 1, 1, 5, 2, 3, 4),
  away_id = c(5, 2, 3, 4, 1, 1, 1, 1),
  home_xGol = c(0.1, 0.3, 0.3, 0.3, 0.5, 0.2, 0.3, 0.4),
  away_xGol = c(0.5, 0.2, 0.3, 0.4, 0.1, 0.2, 0.2, 0.2)
)

describe("get_strength_streak_attack()", {
  obtained_attack <- get_strength_atack(league_attack_defense_streak, id = 1)
  obtained_streak_attack <- get_strength_streak_attack(league_attack_defense_streak, 1)
  expect_true(obtained_attack < obtained_streak_attack)
  expect_equal(obtained_streak_attack, 0.2313, tolerance = 1e-3)
})

describe("get_strength_streak_defense()", {
  obtained_defense <- get_strength_defense(league_attack_defense_streak, id = 1)
  obtained_streak_defense <- get_strength_streak_defense(league_attack_defense_streak, 1)
  expect_true(obtained_defense > obtained_streak_defense)
  expect_equal(obtained_streak_defense, 0.3253, tolerance = 1e-3)
})

describe("GET_STRENGTH_DEFENSE()", {
  obtained_defense <- GET_STRENGTH_DEFENSE[["mean"]](league_attack_defense_streak, id = 1)
  expect_equal(obtained_defense, 0.350, tolerance = 1e-3)
  obtained_streak_defense <- GET_STRENGTH_DEFENSE[["streak"]](league_attack_defense_streak, 1)
  expect_equal(obtained_streak_defense, 0.3253, tolerance = 1e-3)
})

describe("GET_STRENGTH_ATTACK()", {
  obtained_attack <- GET_STRENGTH_ATTACK[["mean"]](league_attack_defense_streak, id = 1)
  expect_equal(obtained_attack, 0.2123, tolerance = 1e-3)
  obtained_streak_attack <- GET_STRENGTH_ATTACK[["streak"]](league_attack_defense_streak, 1)
  expect_equal(obtained_streak_attack, 0.2313, tolerance = 1e-3)
})

describe("concatenate_strength_attack_defense", {
  path_league <- "tests/data/league_39_2022.csv"
  league <- read_csv(path_league, show_col_types = FALSE)
  path_names <- "tests/data/names_39_2022.csv"
  names <- read_csv(path_names, show_col_types = FALSE)
  it(" mode = mean", {
    obtained_strength <- concatenate_strength_attack_defense(names, league)
    expect_equal(sum(obtained_strength$attack), 23.2651, tolerance = 1e-3)
    expect_equal(sum(obtained_strength$deffense), 23.17, tolerance = 1e-3)
  })
  it(" mode = streak", {
    obtained_strength <- concatenate_strength_attack_defense(names, league, mode = "streak")
    expect_equal(sum(obtained_strength$attack), 23.0252, tolerance = 1e-3)
    expect_equal(sum(obtained_strength$deffense), 23.017, tolerance = 1e-3)
  })
})

league_points <- tibble(
  home_id = c(1, 1, 1, 1, 5, 2, 3, 4),
  away_id = c(5, 2, 3, 4, 1, 1, 1, 1),
  home_xPoints = c(0.1, 0.3, 0.3, 0.3, 0.5, 0.2, 0.3, 0.4),
  away_xPoints = c(0.5, 0.2, 0.3, 0.4, 0.1, 0.2, 0.2, 0.2),
  home_Points = c(1, 1, 0.3, 0.3, 0.5, 0, 0.3, 0.4),
  away_Points = c(1, 1, 0.3, 0.4, 0.1, 3, 0.2, 0.2),
  date = c("a", "b", "c", "d", "f", "g", "h", "i")
)
describe("extract_{xpoint/point}_from_league", {
  it("data league_points and `extract_xpoint_from_league()`", {
    obtained <- extract_xpoint_from_league(league_points, 2)
    expected <- c(0.2, 0.2)
    expect_equal(obtained, expected)
  })
  it("data league_points and `extract_point_from_league()`", {
    obtained <- extract_point_from_league(league_points, 2)
    expected <- c(0, 1)
    expect_equal(obtained, expected)
  })
  it("data league_points and `extract_date_from_league()`", {
    obtained <- extract_date_from_league(league_points, 2)
    expected <- c("g", "b")
    expect_equal(obtained, expected)
  })
})
