= Numerical Computation
== General Methodology in Deep Learning
- $m$ training data points $x^((1)), ..., x^((m))$
- Empirical data distribution: $hat(p)(x) = 1/m sum_(i=1)^m delta(x - x^((i)))$
- Neural Network predicts distribution: $p_"model"(x; theta)$
  - Where $theta$ are the learnable parameters
- Training: Make $p_"model"(x)$ as similar as possible to $hat(p)(x)$
$->$ Minimize *KL-divergence* (or equivalently the *cross entropy*). \
$->$ Learning is an optimization problem

== Quantization
A PC only has a *finite number of bits* available, therefore we get rounding errors.
The accumulation of said rounding errors can be problematic.

*Underflow:* The rounding of small numbers to zero. Not a direct problem, but further
computation can be problematic, like $1/x$ or $log(x)$ as $x -> 0$

*Overflow:* The rounding of large numbers to $infinity$. No further computation
possible.

== Stabilizing Softmax
For example, softmax needs to be stabilized, as very high x result in $exp(x)$ infinity or very negative x result in $exp(x)$ 0:
$
  "softmax"(bold(x))_i = exp(x_i)/(sum_(j = 1)^n exp(x_j))
$

If we *add a constant* value *k* to all inputs, we do not change the output:
$
  exp(x_1 + k)/(exp(x_1 + k) + exp(x_2 + k)) = (exp(x_1) exp(k))/(exp(x_1) exp(k) + exp(x_2) exp(k))
$

Softmax is stabilized by subtracting the maximum input from all elements:
$
  bold(z) = bold(x) - max_i x_i
$

== Poor Conditioning
Small change of the input has a large effect on the output.

== Gradient-Based Optimization
In ML we try to minimize the cross-entropy $H$ between the empirical distribution and the parametric model distribution. Minimizing the cross-entropy is equivalent to minimizing the KL-divergence.
$
  min_theta H(hat(p)_"data", p_"model"(theta))
$
Oder anders:
$
  f(x) = H(hat(p)_"data", p_"model"(x)) \
  x^* = arg min f(x)
$

== Algorithm of Gradient Descent
+ Initialize to some point $x_0$
+ Calculate derivative $f'(x_0)$
+ Take small step $epsilon$ in the negative direction of the derivative
  - $x_1 = x_0 - epsilon f'(x_0)$
  - $f(x_1) approx f(x_0) - epsilon f'(x_0)$
+ Iterate until $f'(x_0) = 0$

*In multidimensional space:*
$
  bold(x)' = bold(x) - epsilon gradient_bold(x) f(bold(x))
$

