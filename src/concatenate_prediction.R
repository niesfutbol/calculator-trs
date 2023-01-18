library("tidyverse")

prediction_paths <- c(
  "predictions_39_2022_21.csv",
  "predictions_61_2022_20.csv",
  "predictions_78_2022_16.csv",
  "predictions_88_2022_17.csv",
  "predictions_94_2022_17.csv",
  "predictions_135_2022_19.csv",
  "predictions_140_2022_18.csv"
)

predictions <- read_csv(prediction_paths, show_col_types = FALSE)

cleaned_predictions <- predictions %>%
  filter(home > 0.5 | away > 0.5 | draw > 0.5) %>%
  arrange(date, league) %>%
  write_csv("/workdir/results/nies_20-01-2022.csv")
