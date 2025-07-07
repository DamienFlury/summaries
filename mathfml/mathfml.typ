#set page("a4", columns: 3, flipped: true, margin: 20pt)
#set text(size: 10pt)
#set heading(numbering: "1.1.1")
#text(size: 24pt, [MathFML Cheatsheet])
#outline()
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
Therefore
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
is called _probability density function (PDF)_. With any PDF we can associate a continuous cumulative distribution function (CDF)
$
F(alpha) = integral_(-infinity)^alpha f(t) dif t
$
and a probability measure $PP$ that associates the probability of the event $E subset RR$ to occur with the area of all points underneath the function $f(t)$ whose $t$-values reside in $E$:
$
PP(E) = integral_(t in E) f(t) dif t
$

$
F_Y (y) &= PP (Y <= y) \ 
&= PP(g(Y) <= g(y)) \
&= PP(X <= g(y)) \ 
&= F_X (g(y)) \
$
$
f_X (g(y)) dot g'(y) = f_Y (y)
$

$
|f_Y (y)| &= |f_X (x) dif x| &"if g strictly monotonic" \
f_Y (y) &= f_X (x) dot (dif x)/(dif y)
$

== Example
Let 
$
X tilde "unif"(1, 3)
$
and
$
Y = root(3, (5 - X)/2)
$
Calculate the probability density function $f_Y (y)$.

=== Solution 1
$
f_X (x) = 1/2 dot chi_((1, 3)) (x) = cases(1/2 &"if" 1 < x < 3, 0 &"otherwise")
$

After term transformation we get
$
X = 5 - 2 Y^3 \
=> g(y) = 5 - 2 y^3 \
$
Note that $g'(y) = -6 y^2 < 0$, so $g$ is monotonically decreasing. It follows that $f_Y (y) = -f_X (g(y)) dot g'(y)$. Thus,
$
f_Y (y) &= -1/2 dot chi_((1, 3)) (5 - 2 y^3) dot (-6 y^2) \
&= 3 y^2 dot chi_((1, 3)) (5 - 2 y^3) \
f_Y (y) &= 3 y^2 dot chi_((1, root(3,2))) (y)
$

=== Solution 2:
$
F_X (x) = (x - 1) / 2 dot chi_((1, 3)) (x) + chi_([3, infinity)) (x)
$

By definition we have
$
F_Y (y) &= PP (Y(omega) < y) \
&= PP (root(3, (5 - X(omega))/2) < y) \
&= PP ((5 - X(omega))/2 < y^3) \
&= PP (5 - X(omega) < 2 y^3) \
&= PP (5 - 2 y^3 < X(omega)) \
&= 1 - PP (X(omega) < 5 - 2 y^3) \
&= 1 - F_X (5 - 2 y^3) \
&= 1 - (5 - 2 y^3 - 1) / 2 dot chi_((1, 3)) (5 - 2 y^3) + chi_((3, infinity)) (5 - 2 y^3) \
&= (y^3 - 1) dot chi_((1, root(3, 2))) (y) + chi_((root(3, 2), infinity)) (y)
$
Hence, the probability density function of $Y$ is
$
f_Y (y) = F_Y ' (y) = 3 y^2 dot chi_((1, root(3, 2))) (y)
$


== Maximum likelihood
$n$: Successful events
$
l(a, b) &= (product_(x in S_"Day") p_(m,q) (b(x))) (product_(x in S_"Night") (1 - P_(m, q) (b(x)))) \
&= p^n (1-p)^("total" - n)
$

== Normal Distribution
$
f(x) = 1/sqrt(2 pi sigma^2) e^(-(x - mu)^2/(2 sigma^2) )
$

