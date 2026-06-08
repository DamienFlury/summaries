#import "../lib/lib.typ": *

= Machine Learning Basics
== Linear Regression
A linear regression can be expressed with:
$
  #y_hat = #w^T #x
$
where $#w, #x$ have the dimension of feature length. If there is only one
feature to evaluate, the result is $#y_hat = a x$, which fits the mental model of
conventional linear regression. If we evaluate all data points $#X$ with all features, we get:
$
#y_hat = #X #w
$

== Performance measure (loss)
We need some kind of loss function, for example *MSE*:
$
  "MSE"_"test" & = 1/m sum_i (hat(bold(y))^(("test")) - bold(y)^(("test")))^2_i \
               & = 1/m norm(hat(bold(y))^(("test")) - bold(y)^(("test")))^2_2
$

== Bias Term
To achieve $#y_hat = #w^T #x + b$, we often add a columns of 1's to $#X$:
$
#X = mat(x_11, 1; x_12, 1; x_13, 1)
$

The bias is mathematically defined as $"bias"(hat(theta)_m) = EE(hat(theta)_m)
- theta$. An estimator is *unbiased* if $EE(hat(theta)_m) = theta$ $->$ on
average, the estimator finds the correct value.

An estimator is *asymptotically unbiased* if:
$
lim_(m -> infinity) EE(hat(theta)_m = theta)
$

== Capacity, Overfitting and Underfitting
=== The assumptions
- Examples are *independent* from each other.
- Training and test set are *identically distributed*.
$-> E["MSE"_"train"] = E["MSE"_"test"]$ 

The test error rate will typically never be 0, even if we knew the underlying
distribution $p_"data"$ (measurement errors, missing relation between $x$ and
$y$, ...). The resulting test error of a perfect classifier is the *Bayes error
  rate/irreducible error*.

== The No Free Lunch Theorem
#quote[No machine learning algorithm is universally any better than any other.]

== Hyperparameters and Validation Sets
*Definition:* Hyperparameters are parameters [...] that are *not learned* by the algorithm.

We *cannot* select them from:
- *Training set:* *No*, would choose the highest capacity
- *Test set:* *No*, we cannot touch the test set.
$->$ We need a separate *validation set*.

== Bernoulli Distribution
$
P(x = 1) = theta \
P(x = 0) = 1 - theta
$
In Bernoulli distributions the expectation is $E[x] = theta$


== Gaussian Distribution
The standard error is $"SE"(hat(mu)_m) = sigma/sqrt(m)$.
*Important:*
- *Smaller variance -> smaller standard error.*
- *More samples -> smaller standard error.*

== Consistency
Consistency is the *combination of Bias and Variance*. A consistent estimator
produces exactly $theta$ with infinitely many samples $->$ Asymptotically
unbiased, standard error decreases to 0 with infinitely many steps.
$
lim_(m -> infinity) hat(theta)_m ->^p theta
$
$->$ *Good estimators* should be *consistent*. The goal for ML & DL is to find
*consistent estimators* for all learnable parameters.

== Bias-Variance Trade-Off
$
"MSE" = EE[(hat(theta)_m - theta)^2]
$
The MSE can be divided into:
$
"Bias"(hat(theta)_m)^2 + "Var"(hat(theta)_m)
$

== Maximum Likelihood Estimation
$
hat(bold(theta)) = op("arg max", limits: #true)_bold(theta) product_(i=1)^m p_"model" (#x^((i)); bold(theta))
$
*Problem:* Multiplying many small numbers is numerically (for computers) not stable $->$ logarithm to the rescue:
$
op("arg max", limits: #true) f(x) = op("arg max") log f(x)
$
Therefore, we maximize the *log-likelihood:*
$
op("arg max", limits: #true)_bold(theta) sum_(i = 1)^m log p_"model" (#x^((i)); bold(theta))
$

