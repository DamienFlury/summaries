#set math.equation(numbering: "(1)")

= Lambda Calculus
== Alpha-Conversion
A not free (bound) variables $x$ in a Lambda-Function can be replaced by a different variable $y$ if $y$ doesn't exist as a free variable in the expression (_nfin_ meaning "not free in"):
$ lambda x.M = lambda y.[x := y]M "if" (y "nfin" lambda x.M) $
=== Example
$(lambda x .x) = (lambda y.y)$

```hs
a = (\x -> x)
a = (\y -> y) -- α-Reduction
```

== Beta-Reduction
If a function is applied to an argument, that expression can be written as the body of the function with the input variable replaced by the argument:
$ (lambda x.M) N = [x := N] M $

=== Example
$(lambda x.x) a = a \
(lambda x.x y) a = a y)$

```hs
a = (\x -> x) 5
a = 5 -- β-Reduction
```

== Eta-Reduction
$ (lambda x.f x) = f $

```hs
add5 xs = map (\x -> x + 5) xs
add5' = map(\x -> x + 5) -- η-Reduction
```
