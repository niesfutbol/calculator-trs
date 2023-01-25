run_diff_pts_diff_xgoal <- function(output_file, mode) {
  src_file <- "/workdir/src/diff_pts_diff_xgoal.R"
  command <- glue::glue("Rscript {src_file}")
  system(command)
}

describe("Run diff_pts_diff_xgoal", {
  it("run", {
    run_diff_pts_diff_xgoal()
  })
})
