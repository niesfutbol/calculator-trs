<a href="http://nies.soccer/"><img src="https://github.com/nepito/world_cup_semis/blob/develop/img/logo.jpeg" align="right" width="256" /></a>

# Calculator Total Shot Rate

## Total Shots Rate

## Xpected Goal

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

``` bash
docker container run -v $PWD/results:/workdir/results -e x_rapidapi_key=$RAPIDAPI_KEY nepolin/calculator-trs make update_2021
```
