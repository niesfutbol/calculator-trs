run_presition_of_multinom <- function(output_file) {
  directory <- "/workdir/tests/data"
  src_file <- "/workdir/src/presition_of_multinom.R"
  testtools::delete_output_file(output_file)
  command <- glue::glue("Rscript {src_file} -l 78_2022 -d {directory}")
  system(command)
}

describe("We can run the original file", {
  output_file <- "/workdir/tests/data/precition_78_2022.csv"
  it("mode default value in the cli", {
    run_presition_of_multinom(output_file)
    expected_hash <- "4c873c181e8011e9ed5aae40d60f9373"
    obtained_hash <- as.vector(tools::md5sum(output_file))
    expect_equal(obtained_hash, expected_hash)
  })
})
