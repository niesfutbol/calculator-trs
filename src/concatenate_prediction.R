library("tidyverse")
library("lubridate")
source("/workdir/R/concatenate_prediction.R")
source("/workdir/R/cli_options.R")

names_options_cli <- c("threshold")
opciones <- get_options_from_names(names_options_cli)
threshold <- opciones[["threshold"]]

prediction_paths <- obtains_the_last_predictions_of_the_all_leagues()
output_file <- glue::glue("/workdir/results/nies_{today()}.csv")
predictions <- read_csv(prediction_paths, show_col_types = FALSE)
cleaned_predictions <- predictions %>%
  filter(home > threshold | away > threshold | draw > threshold) %>%
  arrange(date, league) %>%
  write_csv(output_file)
