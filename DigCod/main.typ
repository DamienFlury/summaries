#set page(
  flipped: true,
  columns: 3,
)

= Das Stellenwertsystem
== Polynomschreibweise
$d_n = "Ziffer" in Z_n, R^n = "Wertigkeit"$

$N_n = d_n R^n + d_(n-1) R^(n-1) + ... + d_1 R^1 + d_0 R^0$

== Dezimalsystem
$R_10 = 10 "(Basis)"; Z_10 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}$

== Dualsystem
$R_2 = 2 "(Basis)"; Z_2 = {0, 1}$

=== Beispiel
$N_2 &= 110$
$N_2 &= 1 dot 2^2 + 1 dot 2^1 + 0 dot 2^0 = 4_d + 2_d = 6_d$

== Oktalsystem
$R_8 = 8 "(Basis)"; Z_8 = {0, 1, 2, 3, 4, 5, 6, 7}$

=== Beispiel
$N_8 = 110$
$N_8 = 1 dot 8^2 + 1 dot 8^1 + 0 dot 8^0 = 72_d$

== Kommazahlen
$RR_10 = 110.13$
$N_10 = 1 dot 10^2 + 1 dot 10^1 + 0 dot 10^0 + 1 dot 10^(-1) + 3 dot 10^(-2)$

$RR_2 = 101.110$
$N_2 = 1 dot 2^2 + 0 dot 2^1 + 1 dot 2^0 + 1 dot 2^(-1) + 1 dot 2^(-2) + 0 dot 2^(-3) = 5.75_d$

== Subtrahieren durch Addieren
Annahme: Bei 1000 gibt es einen *Überlauf*.

$753 + 247 = 0$, daraus folgt $753 equiv -247$

Somit ist $620 - 247 equiv 620 + 753 = 1373 equiv 373$.
