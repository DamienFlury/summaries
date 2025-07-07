#set page("a4", columns: 2, flipped: true, margin: 20pt)
#set text(size: 10pt)
= Derivatives
$
&dif/(dif x) 1/x &= -1/x^2 \
$
$
&dif/(dif x) sqrt(x) &= 1/(2 sqrt(x)) \
$
$
&dif/(dif x) a^x &= ln(a) a^x \
$
$
&dif/(dif x) log_b (x) &= 1/(ln(b) x) \
$
$
dif/(dif x) tan(x) &= 1/(cos^2(x)) \ &= 1 + tan^2 (x) \
$
$
&dif/(dif x) arcsin(x) &= 1/sqrt(1-x^2) \
$
$
&dif/(dif x) arccos(x) &= -1/sqrt(1-x^2) \
$
$
&dif/(dif x) arctan(x) &= 1/(1 + x^2) \
$
$
gradient(bold(x)^T dot bold(x)) &= gradient |bold(x)|^2 \ &= 2 |bold(x)| bold(x)^T/(|bold(x)|) \ &= 2 bold(x)^T \
$
$
&gradient(|bold(v)|) = bold(v)^T/(|bold(v)|)
$
$
$


= Matrices
== Scalar/Matrix operations
$
(lambda + mu) bold(A) &= lambda bold(A) + mu bold(A) \
(lambda mu) bold(A) &= lambda (mu bold(A)) \
lambda (bold(B) + bold(C)) &= lambda bold(B) + lambda bold(C) \
lambda (bold(B)  bold(C)) &= (lambda bold(B)) bold(C) = bold(B) (lambda bold(C)) \
(bold(A) bold(B))^T = bold(B)^T bold(A)^T
$

== Tensors
Tensors can be added and multiplied by a scalar, just like matrices. The set of
all tensors of a particular rank and shape can be interpreted as a vector space.
The standard basis of this vector space is the set of all tensors whose components
are all zero except at one position, which it is one.

The standard basis for $RR^(128 times 256 times 3)$ consists of $128 dot 256
dot
3 = 98304$ basis vectors $bold(E)_(i j k)$, where $1 <= i <= 128, 1 <= j <=256,
1 <= k <= 3$, such that all components of $bold(E)_(i j k)$ are zero except at
position $i, j, k$ where the value is $1$.

== Kronecker delta
$
delta_(i j) = cases(0 "if" i != j, 1 "if" i = j)
$
Es gilt:
$
delta_(m 1) delta_(m 2) = 0 \
delta_(k l) - delta_(l k) = 0
$

With that symbol we can define the values of the components of a vector, matrix
and tensor in a standard basis:
$
(bold(e)_k)_i &= delta_(k i) = delta_(i k) \
(bold(E)_(k l))_(i j) &= delta_(k i) delta_(l j) \
(bold(E)_(r s t))_(i j k) &= delta_(r i) delta_(s j) delta_(t k)
$

== Index notation for matrix multiplication
$
(bold(A B))_(i j) = sum_k a_(i k) b_(k j)
$

= Functions of several variables
== Image
The set
$
f(D) &= { y in R|exists x in D : y = f(x)} \
&= {f(x) | x in D}
$
is called the _image_ of $f$.

== Graph
$
"graph" (f) &= {vec(x, y) | x in D and y = f(x)} \
&= {vec(x, f(x)) | x in D}
$
is called the _graph_ of $f$.

== Linearisation
$
L(x) = f(x_0) + J_f (x_0) (x - x_0) 
$
$
f(x, y, z) = vec(x^2 sin(y), y + cos(x-z)) = vec(0, 1)\
J_f = mat(2 x sin(y), x^2 cos(y), 0; -sin(x-z), 1, sin(x-z)) \
=> J_f (1, 0, 1) = mat(0, 1, 0;0, 1, 0) \
f(1.1, -0.1, 0.9) approx f(1,0,1) + J_f (1,0,1) (vec(1.1,-0.1,0.9) - vec(1, 0, 1))
$

= Probability Theory
== Cumulative distribution function (CDF)
$
F_Y (y) = PP(Y <= y)
$

A function $f: RR -> RR^+$, such that
$
integral_(-infinity)^infinity f(t) dif t = 1
$
is called _probability densitiy function (PDF)_. With any PDF we can associate a continuous cumulative distribution function (CDF)
$
F(alpha) = integral_(-infinity)^alpha f(t) dif t
$
and a probability measure $PP$ that associates the probability of the event $E subset RR$ to occur with the area of all points underneath the function $f(t)$ whose $t$-values reside in $E$:
$
PP(E) = integral_(t in E) f(t) dif t
$

$
F_Y (y) = PP (Y <= y) = PP(g(Y) <= g(y)) = PP(X <= g(y)) = F_X (g(y)) \
f_X (g(y)) dot g'(y) = f_Y (y)
$

== Maximum likelihood
$n$: Successful events
$
l(a, b) = (product_(x in S_"Day") p_(m,q) (b(x))) (product_(x in S_"Night") (1 - P_(m, q) (b(x)))) = p^n (1-p)^("total" - n)
$
