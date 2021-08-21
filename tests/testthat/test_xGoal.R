source("../../R/xGoal.R")

describe("Dummy tests", {
  it("Return one", {
    expected <- 1
    obtained <- return_one()
    expect_equal(expected, obtained)
  })
})

describe("The class Teams", {
  it("The builder exist", {
    teams <- Teams$new()
  })
})
