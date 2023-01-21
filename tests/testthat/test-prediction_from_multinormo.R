run_add_winner_to_league <- function(output_file, mode) {
  directory <- "/workdir/tests/data"
  src_file <- "/workdir/src/prediction_from_multinom.R"
  testtools::delete_output_file(output_file)
  command <- glue::glue("Rscript {src_file} -l 78_2022 -r 16 -d {directory} -m {mode}")
  system(command)
}

describe("We can run the original file", {
  output_file <- "/workdir/tests/data/predictions_78_2022_16.csv"
  it("mode default value in the cli", {
    run_add_winner_to_league(output_file, "mean")
    expected_hash <- "c1c759f78d285c7ceb2e7385626903e6"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_equal(obtained_hash, expected_hash)
  })
  it("mode value = streak in the cli", {
    run_add_winner_to_league(output_file, "streak")
    expected_hash <- "c1c759f78d285c7ceb2e7385626903e6"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_false(obtained_hash == expected_hash)
  })
})
