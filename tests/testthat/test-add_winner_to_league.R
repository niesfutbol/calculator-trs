run_add_winner_to_league <- function(output_file, mode) {
  directory <- "/workdir/tests/data"
  src_file <- "/workdir/src/add_winner_to_league.R"
  testtools::delete_output_file(output_file)
  command <- glue::glue("Rscript {src_file} -l 39_2022 -d {directory} -m {mode}")
  system(command)
}

describe("We can run the original file", {
  output_file <- "/workdir/tests/data/strength_league_39_2022.csv"
  it("mode default value in the cli", {
    run_add_winner_to_league(output_file, "mean")
    expected_hash <- "0c90348e765b5980d603926cd6b72f34"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_equal(obtained_hash, expected_hash)
  })
  it("mode streak value in the cli", {
    run_add_winner_to_league(output_file, "streak")
    expected_hash <- "0c90348e765b5980d603926cd6b72f34"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_false(obtained_hash == expected_hash)
  })
})
