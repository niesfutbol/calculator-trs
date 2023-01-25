library(tidyverse)
library(optparse)

calculate_points <- function(home_xGol, away_xGol) {
  diff_goals <- home_xGol - away_xGol
  points <- sum(diff_goals > 0) * 3 + sum(diff_goals == 0)
  return(points)
}

add_home_shots_outsidebox <- function(datos) {
  salida <- datos %>% mutate("home_shots_outsidebox" = home_total_shots - home_shots_insidebox)
  return(salida)
}

add_away_shots_outsidebox <- function(datos) {
  salida <- datos %>% mutate("away_shots_outsidebox" = away_total_shots - away_shots_insidebox)
  return(salida)
}

calculate_diff_goals <- function(home_xGol, away_xGol) {
  n_sample <- 2000
  diff_goals <- rpois(n_sample, home_xGol) - rpois(n_sample, away_xGol)
  return(diff_goals)
}

xGoal_all_league <- list(
  "262_2021" = list(inside = 0.096171, outside = 0.045958, penalty = 0.785234),
  "253_2021" = list(inside = 0.089624, outside = 0.069169, penalty = 0.8),
  "140_2020" = list(inside = 0.117440, outside = 0.043654, penalty = 0.744681),
  "140_2021" = list(inside = 0.117440, outside = 0.043654, penalty = 0.744681),
  "140_2022" = list(inside = 0.117440, outside = 0.043654, penalty = 0.750000),
  "78_2020"  = list(inside = 0.110081, outside = 0.037332, penalty = 0.774774),
  "78_2021"  = list(inside = 0.110081, outside = 0.037332, penalty = 0.774774),
  "78_2022"  = list(inside = 0.110081, outside = 0.037332, penalty = 0.833333),
  "39_2021"  = list(inside = 0.107191, outside = 0.052831, penalty = 0.809524),
  "39_2022"  = list(inside = 0.104380, outside = 0.044810, penalty = 0.815534),
  "61_2020"  = list(inside = 0.108780, outside = 0.065102),
  "61_2021"  = list(inside = 0.107191, outside = 0.052831, penalty = 0.878049),
  "61_2022"  = list(inside = 0.107191, outside = 0.052831, penalty = 0.878049),
  "88_2021"  = list(inside = 0.097606, outside = 0.059503, penalty = 0.815126),
  "88_2020"  = list(inside = 0.097606, outside = 0.059503, penalty = 0.815126),
  "88_2022"  = list(inside = 0.097606, outside = 0.059503, penalty = 0.785714),
  "94_2021"  = list(inside = 0.102894, outside = 0.056361, penalty = 0.718182),
  "94_2022"  = list(inside = 0.086937, outside = 0.057643, penalty = 0.794393),
  "135_2021" = list(inside = 0.104484, outside = 0.054466, penalty = 0.846666),
  "135_2022" = list(inside = 0.091034, outside = 0.058765, penalty = 0.774647)
)

xgoal_from_league_season <- function(league_season) {
  xGoal <- xGoal_all_league[[league_season]]
  check_league_season(league_season)
  return(xGoal)
}

check_league_season <- function(league_season) {
  leagues <- names(xGoal_all_league)
  rlang::arg_match0(league_season, leagues)
}
calculate_xgoal <- function(xGol, shots_outsidebox, shots_insidebox, total_penalties) {
  xgoal <- shots_outsidebox * xGol$outside + shots_insidebox * xGol$inside + total_penalties * xGol$penalty
  return(xgoal)
}

calculate_xpoints <- function(home_xGol, away_xGol) {
  diff_goals <- calculate_diff_goals(home_xGol, away_xGol)
  xpoints <- sum(diff_goals > 0) * 3 / 2000 + sum(diff_goals == 0) / 2000
  return(xpoints)
}


cli_calculate_xpoints <- function() {
  listaOpciones <- list(
    make_option(
      c("-l", "--league-season"),
      default = "262_2021",
      help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-d", "--directory"),
      default = "results",
      help = "Directory where are the files `statistics_{league}_{season}.csv`",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}

cli_add_winner_to_league <- function() {
  listaOpciones <- list(
    make_option(
      c("-l", "--league-season"),
      default = "262_2021",
      help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-d", "--directory"),
      default = "results",
      help = "Directory where are the files `statistics_{league}_{season}.csv`",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-m", "--mode"),
      default = "mean",
      help = "Mode to calculate stregth",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}

cli_prediction_from_multinom <- function() {
  listaOpciones <- list(
    make_option(
      c("-l", "--league-season"),
      default = "262_2021",
      help = "League and season like 78_2020: \n
        Bundesliga id is 78 \n
        Premier id is 39 \n",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-r", "--round"),
      default = "1",
      help = "Round",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-m", "--mode"),
      default = "mean",
      help = "Mode to calculate stregth",
      metavar = "character",
      type = "character"
    ),
    make_option(
      c("-d", "--directory"),
      default = "results",
      help = "Directory where are the files `statistics_{league}_{season}.csv`",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}

cli_calculate_xgoals <- function() {
  listaOpciones <- list(
    make_option(
      c("-i", "--input-file"),
      default = "results/statistics_88_2021.csv",
      help = "Datos de la estadística de la liga",
      metavar = "character",
      type = "character"
    )
  )
  opt_parser <- OptionParser(option_list = listaOpciones)
  opciones <- parse_args(opt_parser)
  return(opciones)
}
#' @export
xgoal_team_place <- function(league) {
  league %>%
    dplyr::select(home_xGol, away_xGol, home_id, away_id, match_id) %>%
    unite(col = "home", c(home_xGol, home_id), sep = "--") %>%
    unite(col = "away", c(away_xGol, away_id), sep = "--") %>%
    gather(key = "local", value = "xGol-d", -match_id) %>%
    separate(col = "xGol-d", into = c("xGol", "team_id"), sep = "--") %>%
    mutate(xGol = as.numeric(xGol))
}

xpoint_team_place <- function(league) {
  league %>%
    select(home_xPoints, away_xPoints, home_id, away_id) %>%
    unite(col = "home", c(home_xPoints, home_id), sep = "--") %>%
    unite(col = "away", c(away_xPoints, away_id), sep = "--") %>%
    gather(key = "local", value = "xPoint-d") %>%
    separate(col = "xPoint-d", into = c("xPoints", "team_id"), sep = "--") %>%
    mutate(xPoints = as.numeric(xPoints))
}

point_team_place <- function(league) {
  league %>%
    select(home_Points, away_Points, home_id, away_id) %>%
    unite(col = "home", c(home_Points, home_id), sep = "--") %>%
    unite(col = "away", c(away_Points, away_id), sep = "--") %>%
    gather(key = "local", value = "Point-d") %>%
    separate(col = "Point-d", into = c("Points", "team_id"), sep = "--") %>%
    mutate(Points = as.numeric(Points))
}

summarize_points_played_match <- function(league) {
  league %>%
    group_by(team_id) %>%
    summarize(
      puntos = sum(Points),
      jj = n()
    )
}

summarize_xpoints_played_match <- function(league) {
  league %>%
    group_by(team_id) %>%
    summarize(
      xpuntos = sum(xPoints),
      jj = n()
    )
}

home_xPoints_all_matches <- function(league) {
  number_of_matches <- nrow(league)
  home_xPoints <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_xpoints(league[match, ]$home_xGol, league[match, ]$away_xGol)
    }
  )
}

away_xPoints_all_matches <- function(league) {
  number_of_matches <- nrow(league)
  away_xPoints <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_xpoints(league[match, ]$away_xGol, league[match, ]$home_xGol)
    }
  )
}

home_Points_all_matches <- function(league) {
  number_of_matches <- nrow(league)
  home_Points <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_points(league[match, ]$home, league[match, ]$away)
    }
  )
}

away_Points_all_matches <- function(league) {
  number_of_matches <- nrow(league)
  away_Points <- to_vec(
    for (match in 1:number_of_matches) {
      calculate_points(league[match, ]$away, league[match, ]$home)
    }
  )
}

add_xpoints_and_points <- function(league) {
  number_of_matches <- nrow(league)
  home_xPoints <- home_xPoints_all_matches(league)
  away_xPoints <- away_xPoints_all_matches(league)
  home_Points <- home_Points_all_matches(league)
  away_Points <- away_Points_all_matches(league)
  league <- cbind(league, tibble(home_xPoints, away_xPoints, home_Points, away_Points))
}

previous_season <- function(id_season) {
  id <- str_split(id_season, "_")[[1]][1]
  previous_season <- as.character(as.numeric(str_split(id_season, "_")[[1]][2]) - 1)
  id_previous_season <- paste(id, previous_season, sep = "_")
  return(id_previous_season)
}

get_strength_atack <- function(league, id) {
  attack <- extract_xgoal_attack_from_league(league, id)
  return(mean(attack))
}

get_strength_defense <- function(league, id) {
  attack <- extract_xgoal_defense_from_league(league, id)
  return(mean(attack))
}

extract_xgoal_attack_from_league <- function(league, id) {
  attack <- c(league %>% filter(home_id == id) %>% .$home_xGol, league %>% filter(away_id == id) %>% .$away_xGol)
}

extract_point_from_league <- function(league, id) {
  attack <- c(league %>% filter(home_id == id) %>% .$home_Points, league %>% filter(away_id == id) %>% .$away_Points)
}

extract_xpoint_from_league <- function(league, id) {
  attack <- c(league %>% filter(home_id == id) %>% .$home_xPoints, league %>% filter(away_id == id) %>% .$away_xPoints)
}

extract_date_from_league <- function(league, id) {
  attack <- c(league %>% filter(home_id == id) %>% .$date, league %>% filter(away_id == id) %>% .$date)
}

extract_xgoal_defense_from_league <- function(league, id) {
  attack <- c(league %>% filter(home_id == id) %>% .$away_xGol, league %>% filter(away_id == id) %>% .$home_xGol)
}

get_strength_streak_attack <- function(league, id) {
  home_xGol <- league %>%
    filter(home_id == id) %>%
    .$home_xGol
  away_xGol <- league %>%
    filter(away_id == id) %>%
    .$away_xGol
  expected_attack <- c(home_xGol, away_xGol)
  expected_streak_attack <- .last_xGol(home_xGol, away_xGol)
  .half_mean(expected_attack, expected_streak_attack)
}

get_strength_streak_defense <- function(league, id) {
  away_xGol <- league %>%
    filter(home_id == id) %>%
    .$away_xGol
  home_xGol <- league %>%
    filter(away_id == id) %>%
    .$home_xGol
  expected_defense <- c(home_xGol, away_xGol)
  expected_streak_defense <- .last_xGol(home_xGol, away_xGol)
  .half_mean(expected_defense, expected_streak_defense)
}

.half_mean <- function(expected_defense, streak_defense) {
  half_mean <- mean(expected_defense) / 2 + mean(streak_defense) / 2
  return(half_mean)
}

.last_xGol <- function(home_xGol, away_xGol) {
  c(home_xGol %>% tail(3), away_xGol %>% tail(3))
}

GET_STRENGTH_DEFENSE <- list(
  "streak" = get_strength_streak_defense,
  "mean" = get_strength_defense
)

GET_STRENGTH_ATTACK <- list(
  "streak" = get_strength_streak_attack,
  "mean" = get_strength_atack
)

calculate_attack_strength_for_each_team <- function(ids, league, mode = "mean") {
  comprehenr::to_vec(for (id in ids) GET_STRENGTH_ATTACK[[mode]](league, id))
}

calculate_defense_strength_for_each_team <- function(ids, league, mode = "mean") {
  comprehenr::to_vec(for (id in ids) GET_STRENGTH_DEFENSE[[mode]](league, id))
}

concatenate_strength_attack_defense <- function(names, league, mode = "mean") {
  ids <- names[["ids"]]
  attack <- calculate_attack_strength_for_each_team(ids, league, mode)
  defense <- calculate_defense_strength_for_each_team(ids, league, mode)
  strength <- tibble(ids = ids, attack = attack, deffense = defense)
}
