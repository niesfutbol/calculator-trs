run_diff_pts_diff_xgoal <- function() {
  league_season <- "135_2022"
  directory <- "/workdir/tests/data"
  src_file <- "/workdir/src/diff_pts_diff_xgoal.R"
  command <- glue::glue("Rscript {src_file} -l {league_season} -d {directory}")
  system(command)
}

describe("Run diff_pts_diff_xgoal", {
  it("run", {
    output_file <- "/workdir/tests/data/Inter_135_2022.jpg"
    testtools::delete_output_file(output_file)
    run_diff_pts_diff_xgoal()
    expected_hash <- "d83f8f78939c833d7828e1fbb16eaa8a"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_equal(obtained_hash, expected_hash)
  })
})
