source("../../R/xGoal.R")

describe("Dummy tests", {
  it("Return one", {
    expected <- 1
    obtained <- return_one()
    expect_equal(expected, obtained)
  })
})
