<a href="http://nies.soccer/"><img src="https://github.com/nepito/world_cup_semis/blob/develop/img/logo.jpeg" align="right" width="256" /></a>

# Calculator Total Shot Rate
[![codecov](https://codecov.io/github/niesfutbol/pressure_index/graph/badge.svg?token=SPGA1DM17D)](https://codecov.io/github/niesfutbol/pressure_index)
![licencia](https://img.shields.io/github/license/niesfutbol/calculator-trs)
![languages](https://img.shields.io/github/languages/top/niesfutbol/calculator-trs)
![commits](https://img.shields.io/github/commit-activity/y/niesfutbol/calculator-trs)

## Total Shots Rate

### Liga MX 2020
- `xGoal_inside` = 0.096171 ***
- `xGoal_outside` = 0.045958 ***
- `xPenalty` = 0.785234

### Eurocopa 2020
- `xGoal_inside` = 0.096 ***
- `xGoal_outside` = 0.073 ***

### Copa América 2021
- `xGoal_inside` = 0.074 ***
- `xGoal_outside` = 0.108 ***

### La Liga 2020
- `xGoal_inside` = 0.125454 ***
- `xGoal_outside` = 0.044485 ***
- `xPenalty` = 0.816

### La Liga 2020
- `xGoal_inside` = 0.109849 ***
- `xGoal_outside` = 0.036571 ***
- `xPenalty` = 0.816

### Premier League 2020
- `xGoal_inside` = 0.101172 ***
- `xGoal_outside` = 0.051113 ***
- `xPenalty` = 0.816

### Premier League 2021
- `xGoal_inside` = 0.096065 ***
- `xGoal_outside` = 0.053973 ***
- `xPenalty` = 0.816

### Bundesliga 2020
- `xGoal_inside` = 0.110081 ***
- `xGoal_outside` = 0.037332 **
- `xPenalty` = 0.774774

### Bundesliga 2021
- `xGoal_inside` = 0.104047 ***
- `xGoal_outside` = 0.049906 **
- `xPenalty` = 0.774774

### Serie A 2020
- `xGoal_inside` = 0.106269 ***
- `xGoal_outside` = 0.048015 ***
- `xPenalty` = 0.846666

### Serie A 2021
- `xGoal_inside` = 0.095796 ***
- `xGoal_outside` = 0.050902 ***
- `xPenalty` = 0.846666

### Serie A 2022
- `xGoal_inside` = 0.096118 ***
- `xGoal_outside` = 0.059871 ***
- `xPenalty` = 0.777778

### Serie A 2023
- `xGoal_inside` = 0.096118 ***
- `xGoal_outside` = 0.059871 ***
- `xPenalty` = 0.777778

### Ligue 1 2020
- `xGoal_inside` = 0.108780 ***
- `xGoal_outside` = 0.065102 ***
- `xPenalty` = 0.826087

### Ligue 1 2021
- `xGoal_inside` = 0.106016 ***
- `xGoal_outside` = 0.053995 ***
- `xPenalty` = 0.826087

### Eredivisie 2020
- `xGoal_inside` = 0.097606 ***
- `xGoal_outside` = 0.059503 ***
- `xPenalty` = 0.815126

### Eredivisie 2021
- `xGoal_inside`  = 0.097820 ***
- `xGoal_outside` = 0.052652 ***
- `xPenalty`      = 0.785714

### Eredivisie 2022
- `xGoal_inside`  = 0.091485 ***
- `xGoal_outside` = 0.063886 ***
- `xPenalty`      = 0.815384

### Primeira Liga 2020
- `xGoal_inside` = 0.102894 ***
- `xGoal_outside` = 0.056361 ***
- `xPenalty` = 0.718182

### Primeira Liga 2021
- `xGoal_inside` = 0.102119 ***
- `xGoal_outside` = 0.046297 ***
- `xPenalty` = 0.718182

---
# How to use
## Xpected Goal

``` bash
docker container run -itv $PWD/nies_data:/workdir/results nepolin/calculator-trs bash
Rscript src/calculate_xGoal.R --input-file=results/statistics_39_2022.csv
```

## To update

``` bash
docker container run -v $PWD/nies_data:/workdir/results nepolin/calculator-trs make update
```

## To add new season
1. Add phony `update` and `upadate_{league}_{season}`
1. Update xGoal parameters in `R/xTable.R` using `src/calculate_xGoal.R --input-file=results/league_{league}_{season}.csv`
1. Obtain the file `results/names_{league}_{season}.csv` using `football/src/get_name_teams_from_league.py`
1. Obtain the file `results/season_{league}_{season}.csv` using `football/src/matches_of_seasons.py`
