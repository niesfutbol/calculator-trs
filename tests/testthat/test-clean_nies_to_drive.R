library(tidyverse)
source("/workdir/R/clean_nies_to_drive.R")
run_clean_nies_to_drive <- function() {
  input_file <- "/workdir/tests/data/nies_13-01-2022.csv"
  output_file <- "/workdir/tests/data/cleaned_nies.csv"
  src_file <- "/workdir/src/clean_nies_to_drive.R"
  testtools::delete_output_file(output_file)
  command <- glue::glue("Rscript {src_file} -i {input_file} -o {output_file}")
  system(command)
}

test_that("We can run the original file", {
  output_file <- "/workdir/tests/data/cleaned_nies.csv"
  run_clean_nies_to_drive()
  expected_hash <- "a5bce86a571db25679065a7fc58336ac"
  obtained_hash <- as.vector(tools::md5sum(output_file))
  expect_equal(obtained_hash, expected_hash)
})

data_to_test <- tibble(
  home_team = "home_team",
  away_team = "away_team",
  home = c(0.6, 0.3, 0.1),
  draw = c(0.3, 0.1, 0.6),
  away = c(0.1, 0.6, 0.3)
)

test_that("Mutate who did win", {
  expected <- tibble(
    home_team = "home_team",
    away_team = "away_team",
    home = c(0.6, 0.3, 0.1),
    draw = c(0.3, 0.1, 0.6),
    away = c(0.1, 0.6, 0.3),
    won = c("Home", "Away", "Draw")
  )
  obtained <- did_who_win(data_to_test)
  expect_equal(obtained, expected)
})

test_that("What's the name of the one who won?", {
  expected <- tibble(
    home_team = "home_team",
    away_team = "away_team",
    home = c(0.6, 0.3, 0.1),
    draw = c(0.3, 0.1, 0.6),
    away = c(0.1, 0.6, 0.3),
    name = c("home_team", "away_team", "Draw")
  )
  obtained <- what_name_of_who_won(data_to_test)
  expect_equal(obtained, expected)
})

test_that("Calculate the nies fee", {
  expected <- tibble(
    home_team = "home_team",
    away_team = "away_team",
    home = c(0.6, 0.3, 0.1),
    draw = c(0.3, 0.1, 0.6),
    away = c(0.1, 0.6, 0.3),
    nies_cuota = 1 / 0.6
  )
  obtained <- calculate_nies_fee(data_to_test)
  expect_equal(obtained, expected)
})
