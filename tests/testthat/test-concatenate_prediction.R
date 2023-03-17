source("/workdir/R/concatenate_prediction.R")

describe("obtain_the_last_round_file", {
  it("returns 34", {
    files <- c("predictions_78_2022_16.csv", "predictions_78_2022_14.csv", "predictions_78_2022_34.csv")
    expected <- "predictions_78_2022_34.csv"
    obtained <- obtain_the_last_round_file(files)
    expect_equal(obtained, expected)
  })
  it("obtain_prediction_of_each_league", {
    obtained <- obtain_prediction_of_each_league(league = "88", path = "/workdir/tests/data")
    expected <- "/workdir/tests/data/predictions_88_2022_22.csv"
    expect_equal(obtained, expected)
  })
})
