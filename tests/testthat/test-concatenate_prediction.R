source("/workdir/R/concatenate_prediction.R")

describe("obtain_the_last_round_file", {
  it("obtains the last predictions of the all leagues", {
    expected <- c(
      "/workdir/tests/data/predictions_78_2022_22.csv",
      "/workdir/tests/data/predictions_88_2022_22.csv",
      "/workdir/tests/data/predictions_94_2022_18.csv"
    )
    obtained <- obtains_the_last_predictions_of_the_all_leagues(root_path = "/workdir/tests/data")
    expect_equal(obtained, expected)
  })
  it("returns 34", {
    files <- c("predictions_78_2022_16.csv", "predictions_78_2022_7.csv", "predictions_78_2022_34.csv")
    expected <- "predictions_78_2022_34.csv"
    obtained <- obtain_the_last_round_file(files)
    expect_equal(obtained, expected)
  })
  it("obtain round from last part of split", {
    last_part_of_split <- "34.csv"
    expected <- 34
    obtained <- .obtain_round_from_last_part_of_split(last_part_of_split)
    expect_equal(obtained, expected)
  })
  it("obtain_prediction_of_each_league", {
    obtained <- obtain_prediction_of_each_league(league = "88", path = "/workdir/tests/data")
    expected <- "/workdir/tests/data/predictions_88_2022_22.csv"
    expect_equal(obtained, expected)
  })
  it("obtains theleagues with predictions", {
    expected <- c("78", "88", "94")
    obtained <- obtains_the_leagues_with_predictions(root_path = "/workdir/tests/data")
    expect_equal(obtained, expected)
  })
})
