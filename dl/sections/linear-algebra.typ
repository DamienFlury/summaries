#let A = math.bold("A")
#let diag = math.op("diag")

= Linear Algebra
== Broadcasting
Add vector $bold(b)$ to every column of matrix $A$:
$ C = A + bold(b), quad C_{i,j} = A_{i,j} + b_j $

== Matrix multiplication
For vectors:
$ x^T y = ||x||_2 ||y||_2 cos(theta) $

Hadamard product: Element-wise multiplication:
$bold(A) dot.o bold(B)$

== Norms
- *$L^p$ norm*: $||bold(x)||_p = (sum_i |x_i|^p)^(1/p)$
- *$L^infinity$ norm*: maximum element of vector, $||bold(x)||_infinity = max_i |x_i|$
- *Frobenius norm*: $L^2$ norm for matrices, $||A||_F = sqrt(sum_(i,j) A_(i,j)^2)$

== Diagonal Matrices
A Diagonal matrix is all zero except for its
diagonal. The diagonal we call vector $bold(v)$:
$
  bold(v) = vec(1, 1, 1) \
  diag(bold(v)) = mat(1, 0, 0; 0, 1, 0; 0, 1, 1) \
$
Multiplying a diagonal matrix with a vector is
computationally efficient:
$
  diag(bold(v)) bold(x) = bold(v) dot.o bold(x)
$

=== Inverting diagonal matrices
$
  diag(bold(v))^(-1) = diag(mat(1/v_1, dots.c, 1/v_n)^T)
$

== Orthogonal matrices
$
  #A^T #A = #A #A^T = bold(I) \
  #A^(-1) = #A^T
$

== Eigenvectors
A *real symmetric matrix* with *n rows and columns* has *n real eigenvalues* and *n orthogonal eigenvectors*.

Eigenvectors can be concatenated into a n orthogonal matrix:
$
  bold(V) = mat(bold(v)^((1)), dots.c, bold(v)^((n)))
$

The eigenvalues can be concatenated into a vector:
$
  bold(lambda) = mat(lambda_1, dots.c, lambda_n)^T
$

Then the matrix $bold(A)$ can be rewritten as:
$
  bold(A) = bold(V) diag(bold(lambda)) bold(V)^(-1)
$

== Optimization using Eigendecomposition
The optimization problem of maximizing or minimizing $f(bold(x)) = bold(x)^T bold(A) bold(x)$ subject to $||bold(x)||_2 = 1$ can be solved using eigendecomposition:
$
  bold(A) bold(x) &= lambda bold(x) \
  bold(x)^T bold(A) bold(x) &= bold(x)^T lambda bold(x) = lambda bold(x)^T bold(x) = lambda
$
- *Maximum*: eigenvector belonging to the *maximum eigenvalue*.
- *Minimum*: eigenvector belonging to the *minimum eigenvalue*.

