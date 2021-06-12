setwd("/workdir")
library(geci.rjags)

in_file <- "tests/data/noisy_data.csv"
results <- read.csv(in_file)
bayesian_fit <- make_fit(results)
testthat::test_that("ajuste lineal", {
  predicted_intercept <- as.numeric(bayesian_fit[2])
  testthat::expect_equal(predicted_intercept,
    5.0,
    tolerance = 0.05
  )
  predicted_slope <- as.numeric(bayesian_fit[4])
  testthat::expect_equal(predicted_slope,
    2.0,
    tolerance = 0.05
  )
})
