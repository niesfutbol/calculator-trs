library(comprehenr)
library(tidyverse)

obtain_the_last_round_file <- function(predictions_files) {
  files <- str_split(predictions_files, "_")
  rounds <- to_vec(for (file in files) file[4])
  id_of_last_round <- which(rounds == max(rounds))
  return(predictions_files[id_of_last_round])
}

obtain_prediction_of_each_league <- function(league, path = "/workdir/results") {
  predictions_files <- list.files(path, pattern = glue::glue("^predictions_{league}"))
  full_path <- paste(path, obtain_the_last_round_file(predictions_files), sep = "/")
  return(full_path)
}
