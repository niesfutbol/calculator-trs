#' @import rjags
library(rjags)

#' @export
make_fit <- function(resultados) {
  linear_model <- "model{
    # Likelihood:
    for (i in 1:n_data) {
        y[i] ~ dnorm(mu[i], 0.01)
        mu[i] <- slope * x[i] + intercept
    }
    # Prior model for slope and intercept
    slope ~ dunif(0, 10)
    intercept ~ dunif(0, 10)
}"
  linear_jags <- jags.model(textConnection(linear_model),
    data = list(
      x = resultados$domain,
      y = resultados$noisy_range,
      n_data = nrow(resultados)
    ),
    inits = list(
      .RNG.name = "base::Wichmann-Hill",
      .RNG.seed = 10
    )
  )
  linear_sim <- coda.samples(
    model = linear_jags,
    variable.names = c("slope", "intercept"),
    n.iter = 1000
  )
  predicted_slope <- median(linear_sim[[1]][, "slope"])
  predicted_intercept <- median(linear_sim[[1]][, "intercept"])
  predicted_values <- rbind(
    c("predicted_intercept", "predicted_slope"),
    c(predicted_intercept, predicted_slope)
  )
  return(predicted_values)
}
