= Machine Learning Basics
== Linear Regression
A linear regression can be expressed with:
$
  hat(y) = bold(w)^T bold(x)
$
where $bold(w), bold(x)$ have the dimension of feature length. If there is only one
feature to evaluate, the result is $hat(y) = a x$, which fits the mental model of
conventional linear regression. If we evaluate all data points $bold(X)$ with all features, we get:
$
  hat(y) = bold(X) bold(w)
$

== Performance measure (loss)
We need some kind of loss function, for example *MSE*:
$
  "MSE"_"test" & = 1/m sum_i (hat(bold(y))^(("test")) - bold(y)^(("test")))^2_i \
               & = 1/m norm(hat(bold(y))^(("test")) - bold(y)^(("test")))^2_2
$

== Capacity, Overfitting and Underfitting
The test error rate will typically never be 0, even if we knew the underlying
distribution $p_"data"$ (measurement errors, missing relation between $x$ and
$y$, ...). The resulting test error of a perfect classifier is the *Bayes error
  rate/irreducible error*.

== The No Free Lunch Theorem
#quote[No machine learning algorithm is universally any better than any other.]
