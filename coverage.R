library(covr)
library(testthat)
cobertura <- file_coverage(
    c(
        "R/clean_nies_to_drive.R",
        "R/xGoal.R",
        "R/xTable.R"
    ),
    c(
        "tests/testthat/test-clean_nies_to_drive.R",
        "tests/testthat/test_xGoal.R",
        "tests/testthat/test_xTable.R"
    )
)
covr::codecov(covertura=cobertura, token='ef6a60a1-4873-4590-9475-ba68538791c0')