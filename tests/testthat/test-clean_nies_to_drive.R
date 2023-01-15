test_that("We can run the original file", {
  output_file <- "/workdir/results/cleaned_nies.csv"
  testtools::delete_output_file(output_file)
  source("/workdir/src/clean_nies_to_drive.R")
  expected_hash <- "a5bce86a571db25679065a7fc58336ac"
  obtained_hash <- as.vector(tools::md5sum(output_file))
  expect_equal(obtained_hash, expected_hash)
})
