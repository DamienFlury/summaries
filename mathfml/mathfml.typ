= Derivatives
$
&dif/(dif x) 1/x &= -1/x^2 \
&dif/(dif x) sqrt(x) &= 1/(2 sqrt(x)) \
&dif/(dif x) a^x &= ln(a) a^x \
&dif/(dif x) log_b (x) &= 1/(ln(b) x) \
&dif/(dif x) tan(x) &= 1/(cos^2(x)) = 1 + tan^2 (x) \
&dif/(dif x) arcsin(x) &= 1/sqrt(1-x^2) \
&dif/(dif x) arccos(x) &= -1/sqrt(1-x^2) \
&dif/(dif x) arctan(x) &= 1/(1 + x^2) \
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
