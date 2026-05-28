= Probability Theory
== Conditional Theory
$
  P(upright(y) = y | upright(x) = x) = P(upright(y) = y, upright(x) = x)/P(upright(x) = x)
$

*Three chained together:*
$
  P(upright(a), upright(b), upright(c)) = P(upright(a) | upright(b), upright(c)) P(upright(b), upright(c)) \
  P(upright(b), upright(c)) = P(upright(b) | upright(c)) P(upright(c)) \
  P(upright(a), upright(b), upright(c)) = P(upright(a) | upright(b), upright(c)) P(upright(b) | upright(c)) P (upright(c))
$

== Bayes Theory
$
  P(upright(x) | upright(y)) = (P(upright(x)) P(upright(y) | upright(x))) / P(upright(y))
$

== Rule of total probability
$
  P(upright(y)) = sum_x P(upright(y) | x) P(x)
$

== Expectation
$
  E[upright(x)] = sum_x x P(x) \
  E[f(upright(x))] = sum_x f(x) P(x)
$

*Linearity of Expectation:*
$
  E[a upright(x) + b] = a E[upright(x)] + b
$

== Variance
The *variance* $sigma^2$ measures the variability around the expectation. $sigma$ is the *standard deviation* and is the square root of the variance.
$
  "Var"(f(x)) = EE[(f(x) - EE[f(x)])^2]
$

== Covariance
The covariance $sigma_(x y)$ is the linear relation between two random variables $x$ and $y$.
