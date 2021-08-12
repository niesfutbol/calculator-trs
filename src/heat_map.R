away_prob <- (dpois(0:6, league$away_xGol[1]))
home_prob <- (dpois(0:6, league$home_xGol[1]))
for (i in 1:5) {print(home_prob[i] * away_prob[1:7])}