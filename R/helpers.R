
#' safe glmmTMB fitting and parameter extraction
safe_glmmTMB_fit <- function(formula, data, family) {
  tryCatch({
    glmmTMB::glmmTMB(formula = formula, data = data, family = family)
  }, error = function(e) {
    warning("glmmTMB fit failed: ", conditionMessage(e))
    NULL
  })
}

#' Extract intercept (on link scale) safely
extract_intercept <- function(model) {
  if(is.null(model)) return(NA_real_)
  tryCatch({
    as.numeric(fixef(model)$cond[1])
  }, error = function(e) NA_real_)
}

#' Extract dispersion/precision parameter (on natural scale) heuristically for many glmmTMB families
#' 
#'  - Negative binomial (nbinom2): phi or theta (size) often in fixef(model)$disp on log scale -> exp()
#'  - Beta: precision phi often in fixef(model)$disp on log scale -> exp()
#'  
extract_dispersion <- function(model) {
  if(is.null(model)) return(NA_real_)
  # try fixef dispersion
  try({
    if(!is.null(fixef(model)$disp)) {
      val <- as.numeric(fixef(model)$disp[1])
      return(exp(val))
    }
  }, silent = TRUE)
  # try summary coefficients for "disp"
  try({
    s <- summary(model)
    if(!is.null(s$coefficients$disp)) {
      val <- as.numeric(s$coefficients$disp[1, "Estimate"])
      return(exp(val))
    }
  }, silent = TRUE)
  # fallback: try reading model$fit$par for names containing "theta|phi|disp"
  try({
    if(!is.null(model$fit$par)) {
      pnames <- names(model$fit$par)
      idx <- grep("phi|theta|disp", pnames, ignore.case = TRUE)
      if(length(idx) >= 1) {
        return(exp(as.numeric(model$fit$par[idx[1]])))
      }
    }
  }, silent = TRUE)
  NA_real_
}


#' Single-simulation function
#' 
#' @return A named list with estimates for poisson, nbinom and beta-backtransformed
#' @export
run_one_sim <- function(sim_i, lambda, n_obs) {
  # sim_i included to allow reproducible splits if desired
  y <- rpois(n_obs, lambda)
  
  # sample true moments (observed sample moments)
  mean_y <- mean(y)
  var_y  <- if(n_obs > 1) var(y) else 0
  
  # -------- Poisson model --------
  dat_p <- data.frame(y = y)
  m_p <- safe_glmmTMB_fit(y ~ 1, data = dat_p, family = poisson(link = "log"))
  intercept_p <- extract_intercept(m_p)
  mu_p_hat <- if(!is.na(intercept_p)) exp(intercept_p) else NA_real_
  # Poisson model-implied variance = mean (no dispersion)
  var_p_hat <- if(!is.na(mu_p_hat)) mu_p_hat else NA_real_
  
  # -------- Negative-binomial model (nbinom2) --------
  m_nb <- safe_glmmTMB_fit(y ~ 1, data = dat_p, family = nbinom2(link = "log"))
  intercept_nb <- extract_intercept(m_nb)
  mu_nb_hat <- if(!is.na(intercept_nb)) exp(intercept_nb) else NA_real_
  # extract theta/dispersion: for nbinom2 variance = mu + mu^2 / theta
  theta_hat <- extract_dispersion(m_nb)  # many glmmTMB store theta as exp(disp)
  var_nb_hat <- if(!is.na(mu_nb_hat) && !is.na(theta_hat)) mu_nb_hat + (mu_nb_hat^2) / theta_hat else NA_real_
  
  # -------- Beta model on scaled data --------
  max_y <- max(y)
  if(max_y == 0) {
    # degenerate: all zeros; set scaled to tiny positives so Beta can fit (but results will be dubious)
    y_scaled <- rep(eps_trunc, length(y))
    max_y_for_back <- 1
  } else {
    y_scaled <- y / max_y
    # ensure values inside (0,1)
    y_scaled[y_scaled <= 0] <- eps_trunc
    y_scaled[y_scaled >= 1] <- 1 - eps_trunc
    max_y_for_back <- max_y
  }
  dat_b <- data.frame(y_scaled = y_scaled)
  # beta_family with logit link
  m_b <- safe_glmmTMB_fit(y_scaled ~ 1, data = dat_b, family = beta_family(link = "logit"))
  intercept_b <- extract_intercept(m_b)
  mu_b_scaled_hat <- if(!is.na(intercept_b)) plogis(intercept_b) else NA_real_
  phi_b_hat <- extract_dispersion(m_b)   # precision parameter: Var(Y) = mu*(1-mu)/(1+phi)
  var_b_scaled_hat <- if(!is.na(mu_b_scaled_hat) && !is.na(phi_b_hat)) {
    mu_b_scaled_hat * (1 - mu_b_scaled_hat) / (1 + phi_b_hat)
  } else NA_real_
  # backtransform to original count scale
  mean_b_back <- if(!is.na(mu_b_scaled_hat)) mu_b_scaled_hat * max_y_for_back else NA_real_
  var_b_back  <- if(!is.na(var_b_scaled_hat)) var_b_scaled_hat * (max_y_for_back^2) else NA_real_
  
  list(
    mean_true = mean_y,
    var_true  = var_y,
    
    # Poisson
    mu_p_hat = mu_p_hat,
    var_p_hat = var_p_hat,
    
    # Negative binomial
    mu_nb_hat = mu_nb_hat,
    var_nb_hat = var_nb_hat,
    theta_hat = theta_hat,
    
    # Beta-backtransformed
    mu_b_back = mean_b_back,
    var_b_back = var_b_back,
    phi_b_hat = phi_b_hat
  )
}

#' helper summaries
#' 
#' @export
summarise_bias_rmse <- function(est, truth) {
  ok <- !is.na(est) & !is.na(truth)
  if(sum(ok) == 0) return(tibble(n_ok = 0, bias = NA_real_, rmse = NA_real_))
  est2 <- est[ok]; tr2 <- truth[ok]
  tibble(
    n_ok = sum(ok),
    bias = mean(est2 - tr2),
    rmse = sqrt(mean((est2 - tr2)^2))
  )
}