describe("obtain_the_last_round_file", {
  it("returns 34", {
    files <- c("predictions_78_2022_16.csv", "predictions_78_2022_14.csv", "predictions_78_2022_34.csv")
    expected <- "predictions_78_2022_34.csv"
    obtained <- obtain_the_last_round_file(files)
    expect_equal(obtained, expected)
  })
})
