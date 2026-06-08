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
hat(vtheta) = argmax_(vtheta) product_(i=1)^m p_"model" (#x^((i)); vtheta)
$
*Problem:* Multiplying many small numbers is numerically (for computers) not stable $->$ logarithm to the rescue:
$
argmax f(x) = argmax log f(x)
$
Therefore, we maximize the *log-likelihood:*
$
&= argmax_(vtheta) sum_(i = 1)^m log p_"model" (#x^((i)); vtheta) \
&= argmax_(vtheta) 1/m sum_(i = 1)^m log p_"model" (#x^((i)); vtheta) \
$

=== Relation to cross-entropy
Expectation over an empirical data distribution is:
$
EE_(#x tilde hat(p)_"data") [f(x)] = 1/m sum_(i = 1)^m f(#x^((i)))
$
Hence, the term $argmax_(vtheta) 1/m sum_(i = 1)^m log p_"model" (#x^((i)); vtheta)$ can be written as:
$
&= argmax_(vtheta) EE_(#x tilde hat(p)_"data") log p_"model" (#x ; #vtheta) \
&= hat(vtheta)_"ML" = argmin_vtheta H(hat(p)_"data", p_"model") \
&= hat(vtheta)_"ML" = argmin_vtheta D_"KL" (hat(p)_"data" || p_"model")
$

Maximum log-likelihood and minimizing the cross entropy works the same way:
$
hat(vtheta)_"ML" = argmax_vtheta sum_(i=1)^m log P(bold(y)^((i)) | #x^((i)) ; vtheta)
$

== Stochastic Gradient Descent
$
argmax_vtheta sum_(i = 1)^m log P(bold(y)^((i)) | #x^((i)) ; vtheta) \
= argmin_vtheta 1/m sum_(i = 1)^m -log P(bold(y)^((i)) | #x^((i)) ; vtheta)
$

$
hat(g) = 1/m' sum_(i = 1)^m' gradient_vtheta L(#x^((i)), bold(y)^((i)), vtheta)
$
where $m'$ is the *Minibatch size* (important hyperparameter), typically
between 1 and 1'000 (independent from dataset size!). Selected based on
available GPU memory.

SGD Algorithm:
+ Randomly sample minibatch BB of size $m'$
+ Estimate gradient $hat(g) = 1/m' sum_(i = 1)^m' gradient_vtheta L(#x^((i)), bold(y)^((i)), vtheta)$
+ Take small step in negative gradient direction $vtheta <- vtheta - epsilon hat(g)$

== Ingredients for a machine learning algorithm
*In Example of linear regression:*
- *Dataset:* $y in RR$ $#x in RR^n$
- *Cost function:* cross-entropy $J(bold(w), b) = - EE_(#x, y tilde hat(p)_"data") log p_"model" (y | #x)$
- *Probabilistic model:* Gaussian $p_"model" (y | #x) = cal(N) (y ; #x^T bold(w) + b, 1)$
- *Optimization algorithm:* $bold(w) = (#X^(("train")T) #X^(("train")))^(-1) #X^(("train")T) bold(y)^(("train"))$

== Challenges Motivating Deep Learning
Traditional algorithms and ML work well in many applications, but many *central
problems* were *not solved* (recognizing speech, understanding/processing text,
detecting objects in images). One key reason is the *curse of dimensionality*.

=== The Curse of Dimensionality
As the *number of variables* (dimensions) increases, the *number of
combinations* increases *exponentially*.

*Example:* 10 possible values per dimension, target: know 80% of possible values:
- 1d $->$ requires *8* values
- 2d $->$ requires *64* values
- 3d $->$ requires *512* values

$->$ The number of training samples must *increase exponentially* (and so does
data collection, memory consumption and processing power).

Collecting such amounts of data is *not feasible* $->$ for high-dimensional data
*most of the space is empty*. What should we predict for test points that are
*far from all training points*?

=== Why this breaks traditional ML
Generalization relies on *assumptions* about the data. Traditional ML assumes
the data is *locally constant* or *smooth*:
$
f^*(#x) approx f^*(#x + epsilon)
$
In *high-dimensional* data this assumption *fails*: in a mostly empty space
*all points are far away*, so there is no nearby example to generalize from.


== Manifolds
A manifold is a *connected region/set of points* embedded in a high dimensional space, but only spans a smaller number of dimensions (E.g. street on our world, 1D line in 3D space).
