#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#set text(lang: "DE", region: "CH", font: "EB Garamond", size: 9pt)
#set par(justify: true)
#set heading(numbering: "1.1")

#let theorem = thmbox("theorem", "Satz", fill: rgb("#eeffee"))
#let proof = thmproof("proof", "Beweis")
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Beispiel").with(numbering: none)
#let info = thmbox("info", "Info", fill: rgb("#aaeeff"))

#let highlight(x) = text(fill: orange, $#x$) 
#let conceal(x) = text(fill: gray, $#x$)

#let reduction(body) = box(inset: (x: 1em, y: 1em), fill: rgb("#eeffff"), radius: 0.4em, width: 100%)[
  *Reduktion:* Folgende Elemente müssen reduziert werden:
  #body
]

#let given_question(given, question) = block(inset: (1em))[*Gegeben:* #given \ *Fragestellung:* #question]

#set page("a4", numbering: "1", margin: 20pt, columns: 2)
#counter(page).update(1)

#outline(indent: auto)

= Logik
== Prädikate
- Aussagen über mathematische Objekte, wahr oder falsch
- Funktionen mit booleschen Rückgabewerten:
$P$, $Q(n)$, $R(x, y, z)$

== Verknüpfungen
- und: $P and Q$
- oder: $P or Q$
- nicht: $not P$
- Implikation $P => Q = not P or Q$

== Distributivgesetze
- $P and (Q or R) <=> (P and Q) or (P and R)$
- $P or (Q and R) <=> (P or Q) and (P or R)$

== De Morgan
- $not (P and Q) <=> not P or not Q$
- $P => Q <=> (not Q => not P)$

== Quantoren
- $forall i in {1, ..., n} (P_i)$ = (Für alle $i$ ist $P_i$ wahr)
- $exists i in {1, ..., n} (P_i)$ = (Es gibt ein $i$ derart, dass $P_i$ wahr ist)

=== Morgan 2.0
"Nicht für alle" = "Es gibt einen Fall, für den nicht"
$ not forall i in {1, ..., n}(P_i) <=> not (P_1 and dots.c and P_n) <=> not P_1 or dots.c or not P_n <=> exists i in {1, ..., n}(not P_i) $

= Alphabet und Wort
- Alphabet: $Sigma$
- Wort: Ein $n$-Tuplel in $Sigma^n = Sigma times dots.c times Sigma$
- Menge aller Wörter: $Sigma^* = {epsilon} union Sigma union Sigma^2 union dots.c = union.big_(k=0)^infinity Sigma^k$

== Wortlänge
- $|epsilon| = 0$
- $|01010|_0 = 3$
- $|(1201)^7| = 7 dot |1201| = 28, |w^n| = n dot |w|$

= Reguläre Sprachen

#set text(lang: "de")

#let screenshot(text) = {
  box(fill: luma(220), width: 100%, inset: 2em)[#align(center)[*Screenshot* #if(text != none) {[\ #text]} else {}]]
}

== Deterministische endliche Automaten (DEA)
#definition[
Ein DEA ist ein Quintupel $(Q, Sigma, delta, q_0, F)$, wobei:
+ $Q$, Beliebige endliche Menge von *Zuständen*
+ $Sigma$, *Alphabet* (Endliche Menge)
+ $delta: Q times Sigma -> Q$, *Übergangsfunktion*
+ $q_0 in Q$, *Startzustand*
+ $F subset Q$, Menge der *Akzeptierzustände*
]

#definition[Sei $a$ ein endlicher Automat, dann ist $L(A)$ die Sprache
$ L(A) = {w in Sigma^* | "w überführt A in einen Akzeptierzustand"} $]

=== Beispiele für DEAs:
- Durch drei teilbare Zahlen
- Wörter mit einer geraden Anzahl $a$
- Bedingungen an einzelne Zeichen, wie: Wörter, die mit einem $a$ beginnen und genau ein $b$ enthalten.

=== Myhill-Nerode Automat
Wir müssen für beliebige Wörter herausfinden, mit welchem weiteren Input der Automat in einen Akzeptierzustand übergeht. Das leere Wort $epsilon$ ist speziell, wir benötigen die Sprache $L$ selbst, um zum Akzeptierzustand zu kommen. Beispiel:

$ Sigma &= {0, 1} \
L &= {w in Sigma^* | |w|_0 "gerade"} $

#table(columns: (auto, 1fr, auto), table.header([w], [L(w)], [Q]),
[$epsilon$], [$L(epsilon) = L$], [$q_0$],
[$0$], [$L(0) = {w in Sigma^* | |w|_0 "ungerade"}$], [$q_1$],
[$1$], [$L(1) = {w in Sigma^* | |w|_0 "gerade"} = L$], [$q_0$])

=== Algorithmus für den Minimalautomaten
Wir füllen jeweils nur die untere Hälfte der Tabelle aus:
+ Tabelle erstellen mit allen Zuständen in den Zeilen und Spalten
+ Äquivalente Zustände (die Diagonale) mit $equiv$ markieren
+ Akzeptierzustände von normalen Zuständen unterscheiden mit $times$.
+ Falls man von einem Zustandspaar $(a, b)$ mit einem Übergang bei einem Paar mit $times$ landet, kann man das Paar $(a, b)$ auch mit $times$ markieren.

#image("./assets/minimaler-automat.png")

=== Pumping Lemma
#theorem[Ist $L$ eine reguläre Sprache, dann gibt es eine Zahl $N$, die Pumping Length, so dass jedes Wort $w in L$ mit $|w| >= N$ in drei Teile $w=x y z$ zerlegt werden kann, so dass:
$ |y|> 0 \
|x y| <= N \
x y^k z in L, forall k >= 0 $
]
Zum beweisen, dass eine Sprache nicht regulär ist, nimmt man an, dass sie regulär ist und führt das Pumping Lemma durch. Gibt es einen Widerspruch, ist die Sprache nicht regulär (Widerspruchsbeweis).

#let colMath(x, color) = text(fill: color)[$#x$]

#example[$L = {0^n 1^n | n >= 0}$][
  + Annahme: $L$ ist regulär
  + $exists N in NN$, Pumping Length
  + w = $0^N 1^N$
  + Unterteilung $w = colMath(x, #green) colMath(y, #red) colMath(z, #blue)$
  #figure(image("./assets/pumping-lemma.png"), caption: [Pumping Lemma])
  + Pumpen: nur die Anzahl der 0 wird erhöht, Anzahl 1 bleibt
  + $colMath(x, #green) colMath(y, #red)^k colMath(z, #blue) in.not L "für" k != 1$, im Widerspruch zum Pumping-Lemma
]

== Nicht deterministische Automaten (NEA)
Ein DEA sieht immer nur ein Zeichen weit, kann sich nicht an ältere Zeichen erinnnern und kann Entscheidungen später nicht mehr revidieren. Zum Beispiel ist unklar, wie eine Bedingung wie "wenn ein Wort mit einer 0 aufhört, muss es auch mit einer 0 beginnen" implementiert werden müsste.

Jeder NEA lässt sich in einen DEA umwandeln, NEAs erkennen somit dieselbe Sprache wie DEAs.

NEAs erlauben auch verschiedene Zustandsänderungen durch dieselben Symbole oder gar keine Zustandsänderungen ($|delta(q, a)| eq.not 1$) und Zustandsänderungen durch das leere Wort ($delta(q, epsilon) != emptyset$)). Wenn ein NEA $epsilon$-Änderungen erlaubt, nennt man ihn auch $"NEA"_epsilon$.

== Mengenoperationen
#image("./assets/mengenoperationen.png")

= Reguläre Operationen und Ausdrücke
== Alternative
$L = L_1 union L_2 = L(A_1) union L(A_2)$
#image("./assets/alternative.png")

== Verkettung
$L = L_1 L_2 = L(A_1) L(A_2)$
#image("./assets/verkettung.png")

== \*-Operation
$ L^* &= {epsilon} union L union L^2 union dots.c\
&= union.big_(k = 0)^infinity L^k $

#image("./assets/star-operation.png")

== Reguläre Ausdrücke
- Metazeichen `() [] * ? | . \`
- `[abc] = a|b|c`, `[^abc] = nicht [abc]` (das ^-Symbol bedeutet innerhalb `[]` "nicht")

=== Erweiterungen
- `{n, m}`: zwischen _n_ und _m_
- `+`: mindestens eines (`{1,}`)
- `?`: optional (`{0, 1}`)
- `\d` Ziffern, `\s` whitespace, `\w` Wortzeichen (inkl. Ziffern), `[:space:], [:lower:], [:xdigit:]`

= Kontextfreie Sprachen
== Grammatik für Klammerausdrücke
$ A &-> epsilon \ 
&-> A A \
&-> (A) $
Oder (Kurzschreibweise):
$ A -> epsilon | A A | (A) $

=== Beispiel für Ableitung von Klammerausdruck
Wort $(()())$ soll abgeleitet werden:
$ A -> (A) -> (A A) -> ((A)A) -> ((A)(A)) -> ((epsilon)(A)) -> ((epsilon)(epsilon)) -> (()())  $

== Parse Tree
#definition[Zwei Ableitungen eines Wortes $w$ einer kontextfreien Sprache $L(G)$ heissen äquivalent, wenn sie den gleichen Ableitungsbaum haben. Hat eine Sprache Wörter mit verschiedenen Ableitungen, heisst sie mehrdeutig (engl. ambiguous)]

Ein Beispiel einer Grammatik, die nicht eindeutige Ableitungen hat, ist:
$ G = ({S}, {0, 1}, {S -> 0 S 1 | 1 S 0 | S S | epsilon}, S) $

Ein Ausruck $001011$ produziert verschiedene Parsetrees (siehe @ambiguous-grammar).

#figure(placement: auto, grid(columns: (1fr, 1fr), gutter: 1cm, image("./assets/derivation-1.png"), image("./assets/derivation-2.png")), caption: [Nicht eindeutig ableitbare Grammatik])<ambiguous-grammar>

Von besonderer praktischer Bedeutung sind jedoch Grammatiken, die immer eindeutig ableitbar sind. Ein Beispiel solch einer Grammatik ist die `expression-term-factor`-Grammatik für einfache arithmetische Ausdrücke.

== Reguläre Operationen
$L_1, L_2$ kontextfreie Sprachen mit Grammatiken $G_i = (V_i, Sigma, R_i, S_i)$. Grammatik für reguläre Operationen:
- Neue Startvariable $S_0$
- $V = V_1 union V_2 union {S_0}$
- Geeignet erweiterte Regeln $R$
$=> G = (V, Sigma, R, S_0)$

=== Alternative
Regeln für $L_1 union L_2$:

$R = R_1 union R_2 union {S_0 -> S_1, S_0 -> S_2}$

Im Wesentlichen bleiben die einzelnen Regeln dieselben, es müssen nun einfach alle Regeln der Sprachen $L_1, L_2$ untereinander geschrieben werden. Wichtig ist jedoch, dass wir einen neuen Startzustand konstruieren, den wir mit Regeln in $S_1, S_2$ überführen.

=== Verkettung
Regeln für $L_1 L_2$:

$R = R_1 union R_2 union {S_0 -> S_1 S_2}$

=== \*-Operation
Regeln für $L_1^*$:

$R = R_1 union {S_0 -> S_0 S_1, S_0 -> epsilon}$

Diese Regel besagt einfach, dass $S_1$ beliebig oft wiederholt werden kann.

#theorem[Die Klasse der kontextfreien Sprachen ist abgeschlossen unter regulären Operationen.]

== Reguläre Sprachen sind kontextfrei
=== Bausteine
- Einzelne Buchstaben:
  - $A -> a$
  - $B -> b$
  - $...$
  - $Z -> z$
- Leeres Wort
  - empty $-> epsilon$

=== regex $->$ CFG
#example[Grammatik zum regulären Ausdruck `(ab)*|c`:

$ "Alternative: " &S -> U | C \
"*-Operation: " &U -> U P | epsilon \
"Verkettung:" &P -> A B \
"a: " &A -> a \
"b: " &B -> b \
"c: " &C -> c $]

== Arithmetische Ausdrücke
$ "expression" &-> "expression" + "term" \ 
& -> "term" \
"term" &-> "term" * "factor" \
&-> "factor " \ 
"factor" &-> ("expression") \
&-> upright(N) \ 
upright(N) &-> "NZ" \
&-> upright(Z) \
Z &-> 0|1|2|3|4|5|6|7|8|9 $

== Chomsky Normalform
=== Anforderungen an eine Grammatik
+ Keine Unit-Rules $A -> B$
+ Keine Regeln $A -> epsilon$ ausser wenn nötig $S -> epsilon$ (Startvariable $S$)
+ Keine Regeln mit mehr als 2 Variablen auf der rechten Seite
$=>$ Rechte Seite enthält genau zwei Variablen oder genau ein Terminalsymbol

=== Transformation in CNF

+ Neue Startvariable $S_0 -> S$
+ $epsilon$-Regeln
+ Unit-Rules
+ Verkettungen auflösen


#example[
  $ S &-> A S A | a B \ 
  A &-> B | S \ 
  B &-> b | epsilon $

  *Neue Startvariable:*
  $ highlight(S_0 &-> S) \
  S &-> A S A | a B \ 
  A &-> B | S \ 
  B &-> b | epsilon $

  *#sym.epsilon eliminieren:*
  $ S_0 &-> S \
  S &-> A S A | a B | highlight(a) \ 
  A &-> B | S | highlight(epsilon) \ 
  B &-> b $
  
  $ S_0 &-> S \
  S &-> A S A | highlight(S A) | highlight(A S) | conceal(S) | a B | a \ 
  A &-> B | S \ 
  B &-> b $

  *Unit-Rules:*
  $ S_0 &-> S \
  S &-> A S A | S A | A S | a B | a \ 
  A &-> highlight(b) | S \
  B &-> b $

  $ S_0 &-> highlight(A S A) | highlight(S A) | highlight(A S) | highlight(a B) | highlight(a) \
  S &-> A S A | S A | A S | a B | a \ 
  A &-> highlight(A S A) | highlight(S A) | highlight(A S) | highlight(a B) | highlight(a) | b \
  B &-> b $

  *Verkettungen, Terminalsymbole:*
  $ S_0 &-> A highlight(A_1) | S A | A S | a B | a \
  S &-> A highlight(A_1) | S A | A S | a B | a \ 
  A &-> A highlight(A_1) | S A | A S | a B | a | b \
  B &-> b \
  highlight(A_1 &-> S A) $

  $ S_0 &-> A A_1 | S A | A S | highlight(U) B | a \
  S &-> A A_1 | S A | A S | highlight(U) B | a \ 
  A &-> A A_1 | S A | A S | highlight(U) B | a | b \
  B &-> b \
  A_1 &-> S A \
  highlight(U &-> a) $
]

#definition[Chomsky-Normalform][Eine CFG ist in Chomsky-Normalform (CNF), wenn $S$ auf der rechten Seite nicht vorkommt und jede Regel von der Form $A -> B C$ oder $A -> a$ ist, zusätzlich ist die Regel $S -> epsilon$ erlaubt.]

=== Anwendungen der Chomsky-Normalform
*Gegeben:* Grammatik $G$ in Chomsky-Normalform
#theorem[Ableitung eines Wortes $w in L(G)$ ist immer in $2|w| - 1$ Regelanwendungen möglich.]
#proof[
  - $|w| - 1$ Regeln der Form $A -> B C$ um aus $S$ ein Wort aus $w$ Variablen zu erzeugen
  - $|w|$ Regeln der Form $A -> a$, um das Wort $w$ zu erzeugen
]

=== Deterministisches Parsen
*Aufgabe: $S =>^* w$* \
Kann das Wort $w in Sigma^*$ von der Grammatik $G = (V, Sigma, R, S)$ erzeugt werden?

*Verallgemeinerte Aufgabe: $A =>^* w$* \
Kann das Wort $w in Sigma^*$ aus der Variablen $A$ in der Grammatik $G = (V, Sigma, R, s)$ abgeleitet werden?

*Deterministische Antwort:* \
Gesucht ist ein Programm mit der Signatur
```java
boolean ableitbar(Variable a, String w);
```
welches entscheiden kann, ob ein Wort $w$ aus der Variablen $V$ ableitbar ist.

=== CYK-Ideen
+ Grammatik $G = (V, Sigma, R, S)$
+ Variable $A in V$
+ Wort $w in Sigma^*$

*Frage:* Ist $w$ aus $A$ ableitbar? In Zeichen $A =>^* w$

- Spezialfall $w = epsilon$: $A =>^* epsilon <=> A -> epsilon in R$
- Spezialfall $|w| = 1$: $A =>^* w <=> A -> w in R$
- Fall $|w| > 1$:
$ A =>^* w => exists cases(A -> B C in R, w = w_1 w_2\, w_i in Sigma^*) "mit" cases(B =>^* w_1, C =>^* w_2) $

=== CYK-Algorithmus

#[
  #show raw.line: it => {
  show regex("\\$.*\\$"): it => {
    eval(it.text)
  }
  it.body.text
} 
```
boolean ableitbar(Variable A, String w) {
  if (w.length() == 0) {
    return $A -> epsilon in R$;
  }
  if (w.length() == 1) {
    return $A -> w in R$;
  }
  foreach Unterteilung $w = w_1 w_2$ {
    foreach $A -> B C in R$ {
      if (ableitbar(B, $w_1$) 
        && ableitbar(C, $w_2$)) {
          return true;
        }
    }
  }
  return false;
}
```
]

== Stack-Automaten
#figure(image("./assets/stack-transitions.png"), caption: [Stackübergänge])

$ a, b -> c $
- $a$: vom Input
- $b$: vom Stack entfernen (Bedingung)
- $c$: auf den Stack

#example[${0^n 1^n | n >= 0}$ \
#figure(image("./assets/stackautomat.png"), caption: [Stackautomat])
]

#definition[Stackautomat][
  $ P = (Q, Sigma, Gamma, delta, q_0, F) $
  + $Q$: Zustände
  + $Sigma$: Eingabe-Alphabet
  + $Gamma$: Stack-Alphabet
  + $delta$: $Q times Sigma_epsilon times Gamma_epsilon -> P(Q times Gamma_epsilon)$, Regeln
  + $q_0 in Q$: Startzustand
  + $F subset Q$: Akzeptierzustände

  Die Regeln hängen ab vom aktuellen Zustand, vom aktuellen Inputzeichen und vom Zeichen, das zuoberst auf dem Stack liegt.

  $delta$: Funktion mit drei Inputs (aktueller Zustand, Input-Zeichen, oberstes Zeichen auf dem Stack) und gibt ein Tupel zurück mit neuem Zustand und neuem obersten Zeichen auf dem Stack.

  *Beachte:*
  - Immer nicht-deterministisch
  - $Gamma != Sigma$ möglich (z.B. \$-Symbol auf den Stack)
]

=== Visualisierung eines Stacks
#example[
  
Grammatik:
$ S &-> 0 S 1\
&-> epsilon $

Input: 0 0 0 1 1 1

+ \$-Symbol auf den Stack (um später zu prüfen, ob der Stack leer ist)
+ Variable $S$ auf den Stack
+ Input 0 matcht nicht $->$ Variable $S -> 0 S 1$ (1 auf den Stack, dann $S$, dann 0)
+ 0 matcht $->$ 0 vom Stack entfernen und weiter
+ 0 matcht nicht $S -> 0 S 1$

#figure(grid(gutter: 5pt, columns: (1fr, 1fr, 1fr, 1fr, 1fr), image("./assets/stack0.png"), image("./assets/stack1.png"), image("./assets/stack2.png"), image("./assets/stack3.png"),
image("./assets/stack4.png"), [1], [2], [3], [4], [5]
), caption: [Stack-Visualisierung])

*Zustandsdiagramm:*
#figure(grid(columns: (1fr, 1fr), image("./assets/state-start.png"), image("./assets/state-finish.png")), caption: [Zustandsdiagramm erstellen])
]


=== Grammatik #sym.arrow Stackautomat
#figure(image("./assets/grammar-to-pda.png"), caption: [CNF zu Stackautomat])

=== Backus-Naur-Form (BNF)
Grammatik: 
$ S &-> epsilon \ 
&-> 0 S 1 $

BNF: \
`<string> ::= '' | 0 <string> 1`

#example[Expression-Term-Factor][
  ```
  <expression> ::= <expression> + <term> | <term>
  <term> ::= <term> * <factor> | <factor>
  <factor> ::= ( <expression> ) | <number>
  <number> ::= <number> <digit> | <digit>
  <digit> ::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  ```
]

== PDA zu CFG
*Variablen* \
Wörter beschreiben Pfade durch den Automaten:

Variable $A_(p q)$ = Wörter, die von $p$ nach $q$ führen mit leerem Stack

*Regeln* \
Regeln beschreiben, wie sich Wege zerlegen lassen.
$ A_(p q) -> A_(p r) A_(r q) $

=== Stackautomat standardisieren
+ Nur ein Akzeptierzustand
  - $forall q in F$: Übergang in neuen Akzeptierzustand $q_a$
+ Stack leeren:
  - Markierungszeichen zu Beginn auf den Stack
  - Am Schluss: $epsilon, . -> epsilon$ und dann $epsilon, \$ -> epsilon$ von $q_a$ nach $q'_a$
+ Jeder Übergang legt entweder ein Zeichen auf den Stack oder entfernt eines
#image("./assets/stack-standard.png")

=== Regeln
$A_(p q)$ wird, falls sich der Stack dazwischen nicht leert, zu folgendem:

#figure(grid(columns: (2fr, 1fr),
image("./assets/empty-stack-rule.png"),
image("./assets/empty-stack-rule-applied.png")
), caption: [Regel, falls der Stack dazwischen nie leer wird])

$ A_(p q) -> a A_(r s) b $

#figure(grid(columns: (2fr, 1fr), image("./assets/stack-rule-2.png"),
image("./assets/stack-rule-2-applied.png")
), caption: [Falls der Stack zwischendurch leer wird])

$ A_(p q) -> A_(p r) A_(r q) $

=== Grammatik ablesen
Ausgangspunkt: Standardisierte Grammatik mit Startzustand $q_0$ und $F = {q_a}$.
+ Startvariable $A_(q_0, q_a)$
+ Regeln: #figure(grid(columns: (1fr ,1fr, 1fr), image("./assets/app_to_empty.png"),
image("./assets/apq_to_aarsb.png"), image("./assets/apq_to_aprarq.png"), $A_(p p) -> epsilon$, $A_(p q) -> a A_(r s) b$, $A_(p q) -> A_(p r) A_(r q)$
))

#example[PDA zu CFG][
  #grid(columns: (1fr, 1fr), image("./assets/pda-to-cfg-example.png"), [
    *Grammatik*
    $ A_(q_0 q_a) &-> epsilon A_(q_1 q_3) epsilon \
    A_(q_1 q_3) &-> 0 A_(q_1 q_3) 1 \
    &-> epsilon A_(q_2 q_2) epsilon \
    A_(q_2 q_2) &-> epsilon $

    *Vereinfachung*
    $ S_0  &-> S \
    S &-> 0 S 1 \
    &-> epsilon $

    $->$ Grammatik für $L = {0^n 1^n | n >= 0}$
  ])
  
]

= Nicht kontextfreie Sprachen
== Pumping-Lemma für kontextfreie Sprachen
#figure(grid(columns: (1fr, 1fr),
image("./assets/pumping-lemma-cfg-herleitung.png"),
image("./assets/pumping-lemma-cfg-herleitung-2.png")
), caption: [Herleitung Pumping Lemma für CFGs])

#definition[Pumping Lemma für CFL][
  Ist $L$ eine CFL, dann gibt es eine Zahl $N$, die Pumping Length, derart, dass jedes Wort $w in L$ mit $|w| >= N$ zerlegt werden kann in fünf Teile $w = u v x y z$ derart, dass:
  + $|v y| > 0$
  + $|v x y| <= N$
  + $u v^k x y^k z in L, forall k in NN$
]

Mit dem Pumping-Lemma kann man beweisen, dass eine Sprache _nicht_ kontextfrei ist.

#example[${a^n b^n c^n | n >= 0}$ \
+ AnnahmeL $L$ kontextfrei
+ Pumping Length $N$
+ Wort: $w = a^N b^N c^N$
+ Zerlegungen (mehrere): #image("./assets/pumping-lemma-cfl.png")
+ Beim Pumpen nimmt die Anzahl der a und b zu, nicht aber die Anzahl der c $=> u v^k x y^k z in.not L, forall k != 1$
+ Widerspruch: $L$ nicht kontextfrei
]

 

= Turing-Maschinen
#definition[Eine Turing-Maschine ist ein 7-Tupel $M = (Q, Sigma, Gamma, delta, q_0, q_"accept", q_"reject")$, wobei:
+ $Q$ heisst die Menge der Zustände
+ $Sigma$ heisst das Inputalphabet, es enthählt das Blank-Zeichen *nicht* #footnote[Wäre das Blank-Zeichen in $Sigma$, könnte man das leere Band nicht vom Input unterscheiden.]
+ $Gamma$ ist das Bandalphabet, es enthält das Blank-Zeichen und $Sigma subset Gamma$
+ $delta: Q times Gamma -> Q times Gamma times {L, R}$ ist die Übergangsfunktion]

== Spielregeln
+ Der Speicher ist unbegrenzt
+ In jeder Zelle steht genau ein Zeichen
+ Es ist immer nur eine Speicherzelle einsehbar
+ Der Inhalt der aktuellen Zelle kann beliebig verändert werden
+ Bewegung immer nur eine Zelle nach links oder rechts
+ Kein weiterer Speicher (nur die Zustände eines endlichen Automaten)

== Zustandsdiagramm
#image("./assets/state-diagram-turing-machine.png", width: 50%)

== Von einer TM erkannte Sprache
$ L(M) = {w in Sigma^* | M "akzeptiert" w} $

#definition[Ein Entscheider ist eine Turing-Mashchine, die auf jedem Input $w in Sigma^*$ anhält.
Eine Sprache heisst entscheidbar, wenn ein Entscheider sie erkennt.]

Eine Turing-entscheidbare Sprache ist auch Turing-erkennbar. Die Eigenschaft "Turing-entscheidbar" unterscheidet sich von der Eigenschaft "Turing-erkennbar" nur dadurch, dass bei einer entscheidbaren Sprache die Turing-Maschine auf jedem beliebigen Input anhalten muss, während bei einer nur erkennbaren Sprache einzelne Input-Wörter auch dazu führen können, dass die Turing-Maschine endlos weiterrechnet.

== Turing Maschinen und moderne Computer
#grid(columns: (1fr, 1fr), [
  *Turing Maschine*
  + Zustände Q
  + Band, unendlich grosser Speicher
  + Schreib-/Lesekopf
  + Anhalten, $q_"accept"$ und $q_"reject"$
  + Problemspezifisch
], [
  *Moderner Computer*
  + Zustände der CPU: Statusbits, Registerwerte
  + Virtueller Speicher: praktisch unbegrenzt
  + Adress-Register, Programm-Zähler
  + `exit(EXIT_SUCCESS)`, `exit(EXIT_FAILURE)`
  + Kann beliebige Programme ausführen
])

== Aufzähler
#definition[Aufzähler][Ein Aufzähler ist eine TM, die alle akzeptierbaren Wörter mit einem Drucker ausdruckt.]
#definition[Rekursiv aufzählbare Sprache][Eine Sprache $L$ heisst rekursiv aufzählbar, wenn es einen Aufzähler gibt, der sie aufzählt.]

Aufzählbare Sprache #sym.arrow.l.r.double Turing-erkennbare Sprache.

== Berechnungsgeschichte
#image("./assets/berechnungsgeschichte.png", width:80%)
#image("./assets/transition.png", width: 80%)

== Vergleich von Maschinen
#definition[Eine TM $M_1$ ist "leistungsfähiger" als eine TM $M_2$, wenn $M_1$ die Maschine $M_2$ simulieren kann
$ M_2 <=_S M_1 $

$M_2$ ist simulierbar auf $M_1$.]

Beispiele:
- $"TM" scripts(<=)_S "Minecraft"$
- $"8-Bit CPU" scripts(<=)_S "Minecraft" scripts(<=)_S "TM"$

== Unendlichkeit
Die Mengen $NN$ und $RR$ sind nicht gleich mächtig, da es keine bijektive Abbildung $NN -> RR$ gibt.
#definition[Mengen $A$ und $B$ heissen _gleich mächtig_, $A tilde.eq B$, wenn es eine Bijektion $A -> B$ gibt.]

#definition[Eine Menge $A$ heisst _unendlich_, wenn sie gleich mächtig wie eine echte Teilmenge ist.]

#definition[$A$ heisst _abzählbar unendlich_, wenn $A tilde.eq NN$, d.h. $A$ gleich mächtig wie $N$ ist.]

#theorem[Die Potenzmenge $P(A)$ einer abzählbar unendlichen Menge $A$ ist immer _überabzählbar unendlich_.]

#theorem[Die Vereinigung von endlich vielen abzählbaren Mengen ist abzählbar. Das kartesische Produkt $A times B$ zweier abzählbaren Mengen $A, B$ ist abzählbar.]

*Anwendungen:*
- Abzählbar unendlich: $Sigma^*$, Menge aller DEAs/NEAs/PDAs/CFGs
- Überabzählbar unendlich: Menge aller Sprachen $P(Sigma^*)$


= Entscheidbarkeit
Eine Sprache heisst entscheidbar, wenn es einen Entscheider gibt, der prüfen kann, ob ein Wort $w$ in der Sprache liegt.
#example[Sei $A$ ein DEA. Dann kann man folgenden Algorithmus $M_A$ mit Input $w$ bauen:
+ Simuliere $A$ auf $w$
+ Falls $A$ in Akzeptierzustand: $q_"accept"$
+ Andernfalls: $q_"reject"$

Daraus folgt $L(A) = L(M_A)$, oder $M_A$ ist ein Entscheider für die Sprache $L(A)$.]
#theorem[Reguläre Sprachen sind entscheidbar.]

#example[Sei $G$ eine CFG. Dann kann man folgenden Algorithmus $M_G$ mit Input $w$ bauen:
+ Wandle $G$ in Chomsky-Normalform $G'$ um
+ Wende den CYK-Algorithmus auf $G'$ und Wort $w$ an
+ Wenn der CYK-Algorithmus das Wort $w$ akzeptiert: $q_"accept"$
+ Andernfalls: $q_"reject"$
]

== Berechenbare Zahlen
#definition[Berechenbare Zahl][Eine Zahl $w$ heisst berechenbar, wenn es eine Turingmaschine $M$ gibt, die auf leerem Band startet und auf dem Band nacheinander die Stellen der Zahl ausgibt.

Eine Zahl $w$ ist somit berechenbar, wenn es eine Turing-Maschine gibt, die sie berechnet.]

#example[
  $pi, e, sqrt(2), gamma, phi = (sqrt(5) - 1)/2$
]

=== Wieviele berechenbare Zahlen gibt es?
_Sind alle reellen Zahlen berechenbar?_
+ Es gibt höchstens so viele berechenbare Zahlen wie Turing-Maschinen
+ Die Menge der Turing-Maschinen ist abzählbar unendlich
+ Die Menge der reellen Zahlen $RR$ ist überabzählbar unendlich
+ $=>$ fast alle reelle Zahlen sind nicht berechenbar

== Hilberts 10. Problem
Gibt es ganzzahlige Lösungen für Polynomgleichungen?

$ x^2 - y &= 0\
x^n + y^n &= z^n $

Eine TM, die verschiedene Möglichkeiten ausprobiert, ist hierfür nicht geeginet; falls es keine Lösung gibt, würde die TM nicht anhalten. $=>$ Es bräuchte einen Entscheider. Dieses Problem wurde jedoch 1970 von Yuri Matiyasevich als nicht entscheidbar bewiesen.

== Sprachprobleme
Ein normales Problem soll zunächst in eine Ja/Nein-Frage übersetzt werden.

#example[
Problem: Finden sie eine Lösung der quadratischen Gleichung:
$ x^2 - x - 1 = 0 $

Dies ist jedoch nicht wirklich als Sprache formuliert. Wir können folgende Formulierung postieren:

Sei $L$ die Sprache bestehend aus Wörtern der Form
$ w = upright(a)=a,upright(b)=b,upright(c)=c,upright(x)=x $
wobei $a,b,c,x$ Dezimaldarstellungen von Zahlen sind. Ein Wort gehört genau dann zur Sprache $w$, wenn $a x^2 + b x + c = 0$ gilt. Ist
$upright(a)=1, upright(b)=-1, upright(c)=-1, upright(x)=3 in L$?
]

#example[
  Gegeben ist eine natürliche Zahl $n$, berechne die ersten 10 Stellen der Dezimaldarstellung von $sqrt(n)$.

  Dies ist wieder kein normales Sprachproblem $->$ Als Entscheidungsproblem mit Ja/Nein-Antwort formulieren:

  Sind die ersten 10 Stellen der Dezimaldarstellung von $sqrt(2) = 1.414213562$?

  *Als Sprache formuliert:* Sei $L$ die Sprache bestehend aus Zeichenketten der Form $n,x$ wobei n die Dezimaldarstellung einer natürlichen Zahl ist und $x$ die ersten 10 Stellen einer Dezimalzahl. Gilt $2, 1.414213562 in L$?
]

=== $epsilon$-Akzeptanzproblem für endliche Automaten
*Problem:* Kan der endliche Automat $A$ das leere Wort akzeptieren?

*Als Sprachproblem:* Ist die Sprache $L = {angle.l A angle.r | epsilon in L(A)}$ entscheidbar?

*Entscheidungsalgorithmus:*
+ Wandle $A$ in einen DEA um
+ Ist der Startzustand ein Akzeptierzustand $q_0 in F$?

=== Gleichheitsproblem für DEAs
*Problem:* Akzeptieren die endlichen Automaten $A_1$ und $A_2$ die gleiche Sprache, $L(A_1) = L(A_2)$?

*Sprachproblem:* Ist die Sprache $L = {angle.l A_1, A_2 angle.r | L(A_1) = L(A_2)}$ entscheidbar?

*Entscheidungsalgorithmus:*
+ Wandle $A_1$ in einen minimalen Automaten $A'_1$ um
+ Wandle $A_2$ in einen minimalen Automaten $A'_2$ um
+ Ist $A'_1 = A'_2$?

=== Akzeptanzproblem für DEAs
*Problem:* Akzeptiert der endliche Automat $A$ das Wort $w$?

*Spachproblem:* Ist die Sprache $L = {angle.l A, w angle.r | w in L(A)}$ entscheidbar?

*Entscheidungsalgorithmus:*
+ Wandle A in einen DEA A' um
+ Simuliere A' mit Hilfe einer TM
+ Hält die Turing-Maschine im Zustand $q_"accept"$?

=== Akzeptanzproblem für CFGs
*Problem:* Kann das Wort $w$ aus der Grammatik $G$ produziert werden?

*Als Sprachproblem:* Ist die Sprache $L = {angle.l G, w angle.r | w in L(G)}$ entscheidbar?

*Entscheidungsalgorithmus:*
+ Kontrollieren, dass $angle.l G angle.r$ wirklich eine Grammatik beschreibt
+ Grammatik in Chomsky-Normalform bringen
+ Mit dem CYK-Algorithmus prüfen, ob $w$ aus $G$ produziert werden kann

== Defintion Entscheidbarkeit
#definition[Entscheider][
  Ein Entscheider ist eine Turing Maschine, die auf jedem beliebigen Input anhält.
]

#definition[Entscheidbar][Eine Sprache $L$ heisst entscheidbar, wenn es einen Entscheider $M$ gibt mit $L = L(M)$. Man sagt, $M$ entscheidet $L$.]

Jedes Problem kann in ein Sprachproblem übersetzt werden:
$ L_P = {w in Sigma^* | w "ist Lösung des Problems" P} $

#example[Leerheitsproblem][$ E_"DEA" = {angle.l A angle.r | A "ein DEA und" L(A) = emptyset } $]

#example[Gleichheitsproblem][$ italic("EQ")_"CFG" = {angle.l G_1, G_2 angle.r | G_i "CFGs und"  L(G_1) = L(G_2)} $]

#example[Akzeptanzproblem][$ A_"DEA" = {angle.l A, w angle.r | A "ein DEA, der" w "akzeptiert"} $]

#example[Halteproblem][$ italic("HALT")_"TM" = { angle.l M, w angle.r | M "hält auf Input" w} $]

== Nicht entscheidbare Probleme

#theorem[Alan Turing][$A_"TM"$ ist nicht entscheidbar.]
#proof[Konstruiere aus dem Entscheider $H$ für $A_"TM"$ eine Maschine $D$ mit Input $angle.l M angle.r$.
+ Lasse $H$ auf Input $angle.l M, angle.l M angle.r angle.r$ laufen
+ Falls $H$ akzeptiert: $q_"reject"$
+ Falls $H$ verwirft: $q_"accept"$

Wende jetzt $D$ auf $angle.l D angle.r$ an:\
$D(angle.l D angle.r) "akzeptiert" <=> D "verwirft" angle.l D angle.r$ \
$D(angle.l D angle.r) "verwirft" <=> D "akzeptiert" angle.l D angle.r$

Widerspruch!
]

#theorem[Halteproblem][Das spezielle Halteproblem $ italic("HALT")epsilon_"TM" \ = {angle.l M angle.r | M "ist eine Turingmaschine und" M "hält auf leerem Band"} $ ist nicht entscheidbar.]

#theorem[Allgemeines Halteproblem][Das allgemeine Halteproblem 
$ italic("HALT")_"TM" \ = {angle.l M, w angle.r | M "ist eine Turingmaschine und" M "hält auf Input" w} $
ist nicht entscheidbar.]

Weitere nicht entscheidbare Probleme:
- Leerheitsproblem $E_"TM"$

== Reduktion

Berechenbare Abbildung $f: Sigma^* -> Sigma^*$ so, dass
$ w in A <=> f(w) in B $
Notation: $f: A <= B$, "$A$ leichter entscheidbar als $B$"

Entscheidbarkeit: $B$ entscheidbar, $f : A <= B => A "entscheidbar"$

#proof[$H$ ein Entscheider für $B$, dann ist $H circle.small f$ ein Entscheider für $A$.]

Folgerung: $A$ nicht entscheidbar, $A <= B => B$ nicht entscheidbar.

=== Reduktionsbeispiele
In folgenden Beispielen ist $M$ eine Maschine, die ein Wort $w$ entweder akzeptiert oder verwirft. Wie wir bewiesen haben, ist es unmöglich, einen Entscheider für das Akzeptanzproblem $A_"TM"$ zu konstruieren.
#example[Reduktion für das spezielle Halteproblem][
  
  Programm $S$:
  + Führe $M$ auf $w$ aus
  + $M$ hält in $q_"accept"$: akzeptiere
  + $M$ hält in $q_"reject"$: Endlosschleife

  Wenn $H$ ein Entscheider für $italic("HALT")epsilon_"TM"$ wäre, könnte man daraus einen Entscheider für $A_"TM"$ konstruieren:
  + Konstruiere das Programm $S$
  + Wende $H$ auf $angle.l S angle.r$ an
]

#example[Reduktion für das Leerheitsproblem $A_"TM" <= E_"TM"$][
  Ist die Sprache $L(M)$ leer? $-> overline(E)_"TM"$ ist $L(M) eq.not emptyset$ 

  Programm $S$ mit Input $u$:
  + $M$ auf $w$ laufen lassen
  + $M$ akzeptiert $w$: $q_"accept"$
  + Andernfalls: $q_"reject"$

  $ M "akzeptiert" w <=> S "akzeptiert" L(S) = Sigma^* != emptyset $

  Wenn $H$ ein Entscheider für $E_"TM"$ wäre, könnte man daraus einen Entscheider für $A_"TM"$ konstruieren:
  + Konstruiere das Programm $S$
  + Wende $H$ auf $angle.l S angle.r$ an
]

#example[Regularitätsproblem $A_"TM" <= italic("REGULAR")_"TM"$][
  Ist die Sprache $L(M)$ regulär?

  Programm $S$ mit Input $u$:
  + $u in.not {0^n 1^n | n >= 0} -> q_"reject"$
  + $M$ auf $w$ laufen lassen
  + $M$ akzeptiert $w$: $q_"accept"$
  + $q_"reject"$

  $ &M "akzeptiert" w &&<=> S "akzepiert" {0^n 1^n | n>= 0}, "nicht regulär" \
  &M "akzeptiert" w "nicht" &&<=> S "akzeptiert" emptyset, "regulär" $

  Wäre $H$ ein Entscheider für $italic("REGULAR"_"TM")$, könnte man daraus einen Entscheider für $A_"TM"$ konstruieren:
  + Konstruiere das Programm $S$
  + Wende $H$ auf $angle.l S angle.r$ an
]

== Satz von Rice
Eigenschaften Turing-erkennbarer Sprachen
- $italic("REGULAR")$: $L(M)$ ist regulär
- $E$: $L(M)$ ist leer

#definition[Eine Eigenschaft $P$ Turing-erkennbarer Sprachen heisst nichttrivial, wenn es zwei Turingmaschinen $M_1$ und $M_2$ gibt, mit:
$ &L(M_1) "hat Eigenschaft" P \
&L(M_2) "hat Eigenschaft" P "nicht" $]

#theorem[Rice][Ist $P$ eine nichttriviale Eigenschaft Turing-erkennbarer Sprachen, dann ist
$ P_"TM" = {angle.l M angle.r | L(M) "hat Eigenschaft" P} $
nicht entscheidbar.]

= Komplexität
== P -- NP
=== Folgerungen aus P = NP
+ Für jedes Problem in NP gibt es einen polynomiellen Algorithmus
+ Es gibt keine "schwierigen" Probleme
+ Mit Moore's Law lässt sich jedes Problem "lösen"
+ Es gibt keine sichere Kryptographie

=== Folgerungen aus P #sym.eq.not NP
+ NP-vollständige Probleme haben nicht skalierende Lösungen
+ Moore's Law hilft nicht in NP \\ P

=== NP-vollständig
Eine entscheidbare Sprache B heisst NP-vollständig, wenn sich jede Sprache A in NP polynomiell auf B reduzieren lässt:
$ A scripts(<=)_P B, forall A in "NP" $

Wenn ein Problem NP-vollständig ist:
- Lösung braucht typischerweise exponentielle Zeit
- Korrektheit der Lösung ist leicht (in polynomieller Zeit) zu prüfen
- Andernfalls wären Tests schon exponentiell und somit in Software nicht sinnvoll

Falls P #sym.eq.not NP, dann können NP-vollständige Probleme nicht in polynomieller Zeit gelöst werden.

== Aufüllrätsel
Viele Ausfüllrätsel wie z.B. Sudoku sind exponentiell lösbar. Man versucht dabei einfach jede Möglichkeit und falls eine Möglichkeit nicht zu einer korrekten Lösung führt, machen wir ein Backtracking. Man spricht von einer Nicht-Deterministischen Turing-Maschine, bei welcher wir alle Möglichkeiten durchprobieren müssen. Eine solche Maschine kann aber polynomiell verifiziert werden, in dem man den Pfad durchgeht, welcher verwendet worden ist für die Lösung des Rätsels und prüft, ob dieser in $q_"accept"$ landet.

== Polynome Verifizierer


== Reduktion Sudoku #sym.arrow CONSTRAINTS #sym.arrow SAT
Sudoku-Regeln werden als logische "Constraints" formuliert. Dabei müssen alle Constraints erfüllt sein. Es gibt Software/Libraries wie python-constraint für diese Probleme.

*Allgemein*: Jedes Ausfüllrätsel lässt sich auf CONSTRAINTS = SAT reduzieren.

=== SAT
Eine logische Formel ist in SAT genau dann, wenn sie erfüllt werden kann. Constraints werden miteinander "verundet", diese Formel soll wahr ergeben.
$ "SAT" = {phi | phi "erfüllbar"} $

S eine Sprache in NP
#sym.arrow.double Es gibt eine nichtdeterministische TM $M$, die $A$ in polynomieller Zeit $O(t(n))$ entscheidet.
#sym.arrow.double $A$ kann polynomiell auf SAT reduziert werden: $A scripts(<=)_P "SAT"$

Beschreibe das Finden der Berechnungsgeschichte von $M$ als polynomielles Ausfüllrätsel.

== Karp-Katalog
=== SAT<sat>
Das SAT-Problem prüft im Allgemeinen, ob ein Ausdruck `true` wird. Dann ist er _satisfiable_. Es sind folgende Dinge gegeben:
- Aussagenlogische Formel

#reduction[
- Variablen (boolesche Werte)
- Aktion, die den Wahrheitszustands einer Variable verändert
- (falls vorhanden) Zwischenausdrücke von logischen Formeln
- Finaler Logischer Ausdruck zur Erfüllung des Ausgangproblems]

SAT eignet sich für Probleme, bei welchen Elemente (Variablen) nur zwei Zustände einnehmen können. Jedes Ausfüllrätsel ist mit SAT beschreibbar. Man kann Wahrheitstabellen bilden. Jedes Problem, das sich auf SAT reduzieren lässt, ist NP-vollständig.

=== k-CLIQUE
#given_question[
  Graph $G$ (bestimmte Anzahl und Anordnung von Knoten), Zahl $k$
][
  Gibt es $k$ Knoten, die alle miteinander verbunden sind? Diese Knoten bilden eine sogenannte k-CLIQUE.
]

#figure(image("./assets/k-clique.png"), caption: [k-Clique])

#reduction[
- Knoten (die miteinander via Kanten verbunden werden)
- Kanten
- k (Anzahl verbundener Knoten, bzw. Grösse der Clique)
- Clique (Was bildet die Clique?)]

Eignet sich für Probleme, bei denen möglichst viele Elemente eine Bedingung erfüllen müssen.

=== SET-PACKING
#given_question[
  Eine Familie $(S_i), i in I$ und eine Zahl $k in NN$
][
  Gibt es eine $k$-elementige Teilfamilie $(S_i), i in J$ mit $J subset I$ (also $|J| = k$) derart, dass die Menge der Teilfamilie paarweise disjunkt sind ($S_i sect S_j = emptyset$)?
]

#figure(image("./assets/np-complete-set-packing.png"), caption: [SET-PACKING])

#reduction[
  - Menge $I$ (Eigenschaft zum Vergleich von Elementen)
  - Familie $S_i$ (Elemente mit Eigenschaften aus der Menge $I$)
  - Teilmenge $J$ von $I$ (so dass |J| = k)
  - Teilfamilie, so dass die enthaltenen Mengen unterscheidbar sind
]

=== #smallcaps[Vertex-Cover]
#given_question[
  Graph $G$ und eine Zahl $k$.
][
  Gibt es eine Teilmenge von $k$ Vertizes so, dass jede Kante des Graphen ein Ende in dieser Teilmenge hat? Jeder Knoten ausserhalb des Graphen muss dementsprechend eine Kante zur Teilmenge besitzen.
]

#figure(image("./assets/np-complete-vertex-cover.png"), caption: smallcaps[Vertex-Cover])

#reduction[
  - Knoten des Graphen
  - Kanten (Verbindung zwischen den Knoten)
  - $k$ (Anzahl Knoten, so dass jeder andere Knoten in dieser Teilmenge eine Kante besitzt)
]

=== #smallcaps[Feedback-Node-Set]<feedback-node-set>

#given_question[
  Gerichteter Graph $G$ und eine Zahl $k$
][
  Gibt es eine endliche Teilmenge von $k$ Vertizes in $G$ so, dass jeder Zyklus#footnote[Ein Zyklus ist ein sich wiederholender Ablauf]<cycle> in $G$ einen Vertex in der Teilmenge enthält?
]

#info[Gerichtete Graphen sind eine Klasse von Graphen, die keine Symmetrie zwischen den Knotenpunkten gebildeten Kanten voraussetzen.]

#figure(image("./assets/np-complete-feedback-node-set.png"), caption: smallcaps[Feedback-Node-Set])

#reduction[
  - gerichteter Graph
  - Knoten
  - Kanten
  - Richtung
  - Zyklen
  - $k$ (Anzahl verbindende Knoten)
  - Node Set (ausgewählte Knoten)
]

=== #smallcaps[Feedback-Arc-Set]
#given_question[
  Gerichteter Graph $G$, Zahl $k$
][
  Gibt es eine Teilmenge von $k$ Kanten so, dass jeder Zyklus@cycle in $G$ eine Kante aus der Teilmenge enthält?
]

Im Vergleich zum #smallcaps[Feedback-Node-Set] wird im #smallcaps[Feedback-Arc-Set] meist beschrieben, dass ein Vorgang wähernd einer Verschiebung (auf einer Kante) gemacht wird.

#figure(image("./assets/np-complete-feedback-arc-set.png"), caption: smallcaps[Feedback-Arc-Set])

#reduction[
  - gerichteter Graph
  - Knoten
  - Kanten
  - Richtung
  - Zyklen
  - k (Anzahl verbindende Kanten)
  - Arc Set (ausgewählte Kanten)
]

=== #smallcaps[Hampath] (Hamiltonischer Pfad)
Das #smallcaps[Hampath]-Problem beschreibt die Suche nach einem geschlossenen Pfad in einem gerichteten Graphen, der genau einmal durch jeden Knoten geht.

#figure(image("./assets/np-complete-hampath.png"), caption: smallcaps[Hampath])

=== #smallcaps[UHampath]
Das #smallcaps[UHampath]-Problem beschreibt die Suche nach einem hamiltonischen Pfad in einem *ungerichteten Graphen* zu finden.

#info[Bei einem ungerichteten Graphen sind die Verbindungen zwischen den Knoten (Kanten) symmetrisch.]

#figure(image("./assets/np-complete-uhampath.png"), caption: smallcaps[UHampath])

=== #smallcaps[Set-Covering]
#given_question[
  endliche Familie endlicher Mengen $\(S_j\)_(1 <= j <= n)$ und eine Zahl $k$
][
  Gibt es eine Unterfamilie bestehend aus $k$ Mengen, die die gleiche Vereinigung hat? Kann man $k$ Teilmengen bilden, welche die Menge $S$ komplett abdecken?
]

Ziel ist es, alle Elemente abzudecken. Überschneidungen der Mengen sind möglich. 

#figure(image("./assets/np-complete-set-covering.png"), caption: smallcaps[Set-Covering])

#reduction[
  - Nummerierung von 1 bis $n$
  - Familie endlicher Mengen
  - Unterfamilie bestehend aus $k$ Mengen
  - Bedingung der beiden Vereinigungen
]

=== BIP
Das BIP-Problem (Binary Integer Programming) beschreibt, dass zu einer ganzzahligen Matrix $C$ und einem ganzzahligen Vektor $d$ ein binärer Vektor $x$ gefunden werden kann mit $C dot x = d$.

$ mat(1, 3, 0; 0, 2, 5) dot vec(1, 0, 1) = vec(1, 5) $

#reduction[
  - Matrix $C$
  - Vektor $d$
  - Resultat für die Suche nach dem Vektor $x$ zur Erfüllung der Gleichung $C dot x = d$
]

=== 3SAT
3SAT ist eine Variante vom SAT-Problem, wo die aussagenlogische Formel als konjunktive Normalform mit 3 Variablen pro Klausel gegeben ist. Beispiel:
$ (x_1 or x_2 or x_3) and (not x_1 or x_2 or not x_3) $
Mit Erfüllungsequivalenz darf jede SAT-Formel in eine 3SAT-Formel umgewandelt werden.

Die Reduktion ist identisch zu @sat SAT.

=== #smallcaps[Vertex-Coloring]
Beim $k$-Vertex-Coloring-Problem sind folgende Dinge gegeben:

#given_question[
Graph $G$, Anzahl $k$ Farben
][
  Kann man die Knoten so mit $k$-Farben einfärben, dass benachbarte Knoten verschiedene Farben haben?
]

*Fragestellung:* 

#figure(image("./assets/np-complete-k-vertex-coloring.png"), caption: smallcaps[k-Vertex-Coloring])

#reduction[
  - Vertizes
  - Kanten
  - Farben
  - $k$: Anzahl Farben
]

Die verbundenen Vertizes sollen alle verschiedene Farben haben:
- Die Farben stellen den (gesuchten) Unterschied zwischen den Vertizes dar (eine unterscheidbare Eigenschaft) 
- Die Kanten zwischen den Vertizes stellen die Regeln für die unterscheidbaren Objekte dar.

Das #smallcaps[Vertex-Coloring]-Problem eignet sich für Probleme, bei denen Elemente, die miteinander in Beziehung stehen, unterschieden werden müssen.

=== #smallcaps[Clique-Cover]
#given_question[
  Graph $G$, positive Zahl $k$
][
  Gibt es $k$ Cliquen so, dass jede Ecke in genau einer der Cliquen ist?
]

#figure(image("./assets/np-complete-clique-cover.png"), caption: smallcaps[Clique-Cover])

#reduction[
  - Vertizes
  - Kanten
  - $k$ (Anzahl Vertizes)
  - Clique (verbund von möglichst vielen Vertizes)
  - Covering (Bedingung)
]

=== #smallcaps[Exact-Cover]
#given_question[
  Eine Familie $\(S_j\)_(1 <= j <= n)$ von Teilmengen einer Menge $U$.
][
  Gibt es eine Unterfamilie von Mengen, die disjunkt sind, aber dieselbe Vereinigung haben? Die Unterfamilie $\(S_j_i\)_(1 <= i <= m)$ muss also $S_(j i) sect S_(j k) = 0$ und $union.big_(j=1)^n S_j = union.big_(i = 1)^m S_(j i)$ erfüllen.
]

Jedes Element in $U$ soll genau in einer der Teilmengen einer Familie $S$ vorkommen. Die gesuchte Menge bildet eine exakte Überdeckung. Es darf keine Überschneidungen geben, aber alle Elemente sollen abgedeckt werden.

#figure(image("./assets/np-complete-exact-cover.png"), caption: smallcaps[Exact-Cover])

#reduction[
  - Menge $U$
  - Familie $S_j subset U$
  - Unterfamilie $S_(j i)$ (so, dass die gleiche Vereinigung wie die Familie $S_j$ erzielt wird)
  - Bedingung $S_(j i) sect S_(j k) = 0$
  - Bedingung $union.big_(j=1)^n S_j = union.big_(i=1)^m S_(j i)$
]

=== #smallcaps[3D-Matching]
#given_question[
  Endliche Menge $T$ und Menge $U$ von Tripeln $T^3$.
][
  Gibt es eine Teilmenge $W$ von $U$ so, dass $|W| = |T|$ und keine zwei Elemente von $W$ in irgendeiner Koordinate übereinstimmen?
]

Für jeden Wert im Tripel $(x, y, z)$ gibt es eine bestimmte Bedeutung abhängig vom Kontext.
#figure(image("./assets/np-complete-3d-matching.png"), caption: smallcaps[3D-Matching])

#reduction[
  - Menge $T$ (normalerweise eine bestimmte Anzahl $n$ von Elementen)
  - Tripel aus $T^3$
  - Menge $U$ (bestehend aus Kombinationen der Tripel)
  - Teilmenge $W$ von $U$ so, dass $n = |W| = |T|$ (jedes Tripel muss in jedem Element für $x, y, z$ eindeutig sein)
]

#example[
  - $T = {0, 1}$
  - $U = {(0, 0, 0), (0, 0, 1), (0, 1, 0), (0, 1, 1), (1, 0, 0), (1, 0, 1), (1, 1, 0), (1, 1, 1)}$
  - $W = {(1, 0, 1), (0, 1, 0)}$ erfüllt die Bedingung
]

=== #smallcaps[Steiner-Tree]
#given_question[
  Ein Graph $G$, eine Teilmenge $R$ von Verizes, eine Gewichtsfunktion und eine positive Zahl $k$.
][
  Gibt es einen Baum mit Gewicht $<= k$, dessen Knoten in $R$ enthalten sind? Das Gewicht des Baumes ist die Summe der Gewichte über alle Kanten im Baum.
]

#figure(image("./assets/np-complete-steiner-tree.png"), caption: smallcaps[Steiner-Tree])

#reduction[
  - Vertizes
  - Kanten (im Fall X)
  - Gewichtsfunktion (zum Vergleich der Kanten und Wahl des Baumes)
  - Knoten in $R$ (bestimmte Auswahl von Vertizes aufgrund einer Bedingug)
  - maximales Gewicht $k$ (so, dass es sich noch "lohnt")
  - Baum (der die einzelnen Vertizes schliesslich verbinden soll)
]

=== #smallcaps[Hitting-Set]
#given_question[
  Menge von Teilmengen $S_i subset S$
][
  Gibt es eine Menge $H$, die jede Menge in genau einem Punkt trifft $(H subset union.big_(i in J) S_i)$, also $|H sect S_i| = 1$?
]

#example[
  - Gegeben: $A = {1, 2, bold(3)}, B = {1, 2, bold(4)}, C = {1, 2, bold(5)}$
  - Gesucht: $H = {3, 4, 5}$
]

#reduction[
  - $i$ (Bedingung/Merkmal zur eindeutigen Auswahl eines Elements)
  - Menge $S_i$ (Menge von Teilmengen)
  - Menge $H$ (Resultat mit Bedingung $|H sect S_i| = 1$)
]

=== #smallcaps[Subset-Sum]
#given_question[
  Menge $S$ von ganzen Zahlen
][
  Kann man eine Teilmenge finden, die als Summe einen bestimmten Wert $t$ hat?
]
#reduction[
  - Elemente, zwischen denen entschieden werden muss
  - Menge $S$ von Elementen
  - bestimmter Wert $t$
  - Teilmenge $T$, so dass die Werte der Elemente dem Wert $t$ entspricht: $sum_(x in T) x = t$
]

Der Name "Rucksack"-Problem rührt daher, dass man sich die Zahlen aus $S$ als "Grösse" von Gegenständen vorstellt, und wissen möchte, ob man einen Rucksack der Grösse $t$ exakt füllen kann mit einer Teilmenge von Gegenständen aus $S$.

=== #smallcaps[Sequencing]
#given_question[
  Ein Vektor von Laufzeiten von $p$ Jobs, ein Vektor von spätesten Ausführzeiten, ein Strafenvektor und eine positive ganze Zahl $k$.
][
  Gibt es eine Permutation der Zahlen $1, ..., p$, sodass die Gesamtstrafe für verspätete Ausführung bei der Ausführung der Jobs nicht grösser ist als $k$?
]

Vereinfachte Definition:\
#given_question[
  Eine Menge von Jobs, pro Job eine Ausführzeit, Deadline und eine Strafe sowie eine maximale Strafe $k$. Die Jobs müssen sequenziell abgearbeitet werden. Wird ein Job zu spät fertig, muss eine Strafe gezahlt werden.
][
  Gibt es eine Reihenfolge von Jobs so, dass die Strafe kleiner gleich $k$ ist?
]

#reduction[
  - Ausführungszeit von Job
  - Deadline
  - Strafe
  - Permutation/Reihenfolge
  - Zusammensetzung der Gesamtstrafe
]

=== #smallcaps[Partition]
#given_question[
  Eine Folge von $n$ ganzen Zahlen $c_1, c_2, ... c_n$
][
  Kann man die Indizes $1, 2, ..., n$ in zwei Teilmengen $I$ und $overline(I)$ teilen, so dass die Summe der zugehörigen Zahlen $c_i$ identisch ist ($sum_(i in I) c_i = sum_(i in overline(I)) c_i$)? Gibt es zwei disjunktive Teilmengen mit derselben Summe?
]

#reduction[
  - Indizes $i$ (konkretes Objekt zum Vergleich/zur Aufteilung)
  - Werte der Vergleichsobjekte $c_i$
  - Aufteilung in zwei Teilmengen $I$ und $overline(I)$ so, dass der Wert der entsprechenden Vergleichsobjekte identisch ist
]

#example[
  Eine Reihe von Wassergläsern ist unterschiedlich gefüllt. Es sollen 2 Behählter gleich voll mit den Gläsern gefüllt werden. Welche Gläser müssen in welche Behälter geleert werden?
]

=== #smallcaps[Max-Cut]
#given_question[
  Graph $G$ mit einer Gewichtsfunktion $w : E -> Z$ und eine ganze Zahl $W$.
][
  Gibt es eine Teilmenge $S$ der Vertizes, so dass das Gesamtgewicht der Kanten, die $S$ mit seinem Komplement verbinden, so gross wie $W$?
]

$ sum_({u,v} in E and u in S and v in.not S) w({u, v}) >= W $

Der Max-Cut eines Graphen ist eine Zerlegung seiner Knotenmenge in zwei Teilmengen, sodass das Gleichgewicht der Zwischen den beiden Teilen verlaufenden Kanten mindestens $W$ wird.

#smallcaps[Max-Cut] sucht die maximalen Investitionen, die man in den Sand setzen muss, indem man eine Menge von Verbindungen durchschneidet.

#figure(image("./assets/np-complete-max-cut.png"), caption: smallcaps[Max-Cut])

#reduction[
  - Vertizes
  - Kanten
  - Gewichtsfunktion der Kante (zum Vergleich der Kanten)
  - Wert $W$ (Ziel, das bei der Wahl der Teilmenge $S$ der Vertizes überstiegen werden sollte)
  - Gesamtgewicht
  - Teilmenge $S$ der Vertizes (Trennlinie zwischen zwei Gruppierungen)
]

= Turing-Vollständigkeit
== Die universelle Turing-Maschine
Gibt es eine TM, die jede beliebige TM simulieren kann?


Charles Babbage, Ada Lovelace: Analytical Engine

Alan Turing: Es gibt eine Turing-Maschine, die jede beliebige andere Turing-Maschine simulieren kann#footnote[Alan Turing (1936): On Computable Numbers, With an Application to the Entscheidungsproblem]:
- Eigenes Band für die Codierung der Übergangsfunktion $delta: Q times Gamma -> Q times Gamma times {L, R}$
- Eigenes Band für den aktuellen Zustand
- Arbeitsband
- Simulation dieser Maschine auf einer Standard-TM

== Programmiersprachen und Turing-Vollständigkeit
#definition[
  Eine Programmiersprache heisst Turing-vollständig, wenn in ihr jede beliebige Turing-Maschine siumuliert werden kann.
]
Frage:
Gibt es einen in $A$ geschriebenen Turing-Maschinen-Simulator?

== Turing-Vollständigkeit von Programmiersprachen
=== LOOP
Führe ein Programm $P$ genau $x_i$ mal aus:
```
LOOP x_i DO
  P
END
```

Daraus kann eine if-Kontrollstruktur erstellt werden:

```
IF x_i THEN
  P
END
```

wird folgendermassen realisiert:
```
y := 0
LOOP x_i DO y := 1 END
LOOP y DO P END
```

=== Turing-Vollständigkeit
Für Turing-Vollständigkeit wird neben `LOOP` noch eine `GOTO`-Struktur benötigt.
