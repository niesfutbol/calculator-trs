library("tidyverse")
source("/workdir/R/concatenate_prediction.R")
source("/workdir/R/cli_options.R")

names_options_cli <- c("threshold")
opciones <- get_options_from_names(names_options_cli)
threshold <- opciones[["threshold"]]

prediction_paths <- c(
  obtain_prediction_of_each_league("39"),
  obtain_prediction_of_each_league("61"),
  obtain_prediction_of_each_league("78"),
  obtain_prediction_of_each_league("88"),
  obtain_prediction_of_each_league("94"),
  obtain_prediction_of_each_league("135"),
  obtain_prediction_of_each_league("140")
)

predictions <- read_csv(prediction_paths, show_col_types = FALSE)
cleaned_predictions <- predictions %>%
  filter(home > threshold | away > threshold | draw > threshold) %>%
  arrange(date, league) %>%
  write_csv("/workdir/results/nies_20-01-2022.csv")
