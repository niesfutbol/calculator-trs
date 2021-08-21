source("../../R/xGoal.R")
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
  it("Read a league file", {
    path_league <- "../data/league_262_2021.csv"
    teams$read(path_league)
    expected_league <- read_csv(path_league)
    obtained_league <- teams$league
    expect_equal(expected_league, obtained_league)
  })
})
