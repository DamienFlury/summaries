= Lambda Calculus
== Alpha-Conversion

$lambda x.M = lambda y.[x := y]M "if" (y "nfin" lambda x.M)$
=== Example
$(lambda x .x) = (lambda y.y)$

```hs
a = (\x -> x)
a = (\y -> y) -- α-Reduction
```

== Beta-Reduction
$(lambda x.M) N = [x := N] M$

=== Example
$(lambda x.x) a = a \
(lambda x.x y) a = a y)$

```hs
a = (\x -> x) 5
a = 5 -- β-Reduction
```

== Eta-Reduction
$(lambda x.f x) = f$

```hs
add5 xs = map (\x -> x + 5) xs
add5' = map(\x -> x + 5) -- η-Reduction
```