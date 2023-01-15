test_that("We can run the original file", {
  input_file  <- "/workdir/tests/data/nies_13-01-2022.csv"
  output_file <- "/workdir/tests/data/cleaned_nies.csv"
  src_file    <- "/workdir/src/clean_nies_to_drive.R"
  testtools::delete_output_file(output_file)
  command <- glue::glue("Rscript {src_file} -i {input_file} -o {output_file}")
  system(command)
  expected_hash <- "a5bce86a571db25679065a7fc58336ac"
  obtained_hash <- as.vector(tools::md5sum(output_file))
  expect_equal(obtained_hash, expected_hash)
})
