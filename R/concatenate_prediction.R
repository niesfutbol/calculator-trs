library(comprehenr)
library(tidyverse)


obtains_the_last_predictions_of_the_all_leagues <- function(root_path = "/workdir/results") {
  leagues <- obtains_the_leagues_with_predictions(root_path)
  prediction_paths <- to_vec(for (league in leagues) obtain_prediction_of_each_league(league, root_path))
  return(prediction_paths)
}

obtains_the_leagues_with_predictions <- function(root_path = "/workdir/results") {
  predictions_files <- list.files(root_path, pattern = glue::glue("^predictions_"))
  files <- str_split(predictions_files, "_")
  leagues <- to_vec(for (file in files) file[2]) |> unique()
  return(leagues)
}

obtain_the_last_round_file <- function(predictions_files) {
  files <- str_split(predictions_files, "_")
  rounds <- to_vec(for (file in files) .obtain_round_from_last_part_of_split(file[4]))
  id_of_last_round <- which(rounds == max(rounds))
  return(predictions_files[id_of_last_round])
}

.obtain_round_from_last_part_of_split <- function(last_part_of_split) {
  round <- str_split(last_part_of_split, "\\.")[[1]][1]
  return(as.numeric(round))
}

obtain_prediction_of_each_league <- function(league, path = "/workdir/results") {
  predictions_files <- list.files(path, pattern = glue::glue("^predictions_{league}"))
  full_path <- paste(path, obtain_the_last_round_file(predictions_files), sep = "/")
  return(full_path)
}
