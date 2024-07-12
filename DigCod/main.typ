#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let proof = thmproof("proof", "Beweis")
#let example = thmplain("example", "Beispiel").with(numbering: none)

#set text(lang: "de", region: "CH")
#set par(justify: true)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")
#let colred(x) = text(fill: red, $#x$) 

#align(center, [#text(size: 22pt, weight: "bold", [Digitale Codierungen]) \ Zusammenfassung \ Damien Flury \ \ Juni/Juli 2024])
#v(1cm)

#outline()

= Das Stellenwertsystem
== Begriffe
- Nibble: Binärzahl mit 4 Bit
- Oktett: Binärzahl mit 8 Bit (Byte)
== Polynomschreibweise
$d_n = "Ziffer" in Z_n, R^n = "Wertigkeit"$

$N_n = d_n R^n + d_(n-1) R^(n-1) + ... + d_1 R^1 + d_0 R^0$

#example[
  $123 = 1 dot 10^2 + 2 dot 10^1 + 3 dot 10^0$
]

Basis $<=>$ Wertigkeit

Potenz $<=>$ Position der Stelle

== Dezimalsystem
$R_10 = 10 "(Basis)"; Z_10 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}$

== Dualsystem
$R_2 = 2 "(Basis)"; Z_2 = {0, 1}$

=== Umerchnung ins Dualsystem
#[
#set math.cases(delim: "|")
$ arrow.t cases(25 / 2 &= 12 &"Rest 1", 12 / 2 &= 6 &"Rest 0", 6 / 2 &= 3 &"Rest 0", 3 /2 &= 1 &"Rest 1", 1 / 2 &= 0 &"Rest 1") $
$= 11001$
]

=== Umrechnung einer Dezimalzahl ins Dualsystem
#[
  #set math.cases(delim: "|")
  $ arrow.b cases(0.75 dot 2 &= 1.5 &"Stelle 1", 0.5 dot 2 &= 1 &"Stelle 1", 0 dot 2 &= 0 &"Stelle 0") $
  $= 0.11$
]


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

=== Additive Zahl berechnen
Gesucht: Additive Zahl von -247 (, also 753).
$
999 - 247 &= 752 "(Neunerkomplement)" \
752 + 1 &= 753 "(Zehnerkomplement)"
$

#example[$ 760 - 233 &= ? \
999 - 233 &= 766 \ 
760 + 767 &= 1527 &"Überlauf bei 1000" \ 
527 &= 760 - 233 $]

#example[Zweiersystem][
  $ 10110 - 01010 &= ? \
  11111 - 01010 &= 10101 \
  10110 + 10110 &= 101100 &"Überlauf" \
  10110 - 01010 &= 01100 $
]

#example[Negatives Resultat][
  $ 0101 &- 0110 \
  &-0110 => 1001 + 1 = 1010 \
  0101 &+ 1010 = 1111 $
  $-1$ ist also $1111$
]

== Dualzahlen

$-1$:\ 
$1 = 0001_2$. \
Einerkomplement: $1110_2$ \
Zweierkomplement: $1111_2 = -1$

== Multiplikation
=== Unsigned
Die unsigned Multiplikation ist eine Summe von Links-Shifts.

$a = 3, b = 5$
$
0011 dot 0101 \
&= 0101 + 1010 \
&= 1111 = 15_d
$
Oder durch Polynommultiplikation:
$ (2^1 + 2^0) dot (2^2 + 2^0) = 2 dot 4 + 2 dot 1 + 1 dot 4 + 1 dot 1 = 15 $

=== Signed
Die signed Multiplikation funktioniert analog zur unsigned Multiplikation, aber wenn einer der Operanden negativ ist, muss das Zweierkomplement davon gebildet werden:

#example[Signed][
 
$1101 * 0111$ ($(-3) dot 7 = -21$) 

$1101$ ist negativ, das Zweierkomplement ist $0011$.

$0011 * 0111 = 0111 + 01110 = 010101$. Das Zweierkomplement davon ist $101011$ (= -21).
]

== Indexschreibweise
$b = 1010$

$b_3 = 1, b_2 = 0, b_1 = 1, b_0 = 0$

$b_(3..1) = 101, b[3..1] = 101$

== Subtrahieren
=== Betrag mit Vorzeichen
$
5 - 1 \
5 = 0101 \
-1 = 1001 \
0101 - 0001 = 0100 = 4
$

=== Einerkomplement (b-1)
Von negativen Zahlen wird das Einerkomplement gebildet. Gibt es nach Addition einen Überlauf, muss noch +1 gerechnet werden.
$
5 - 1 \
5 = 0101 \
1 = 0001, -1 = 1110 \
0101 + 1110 = 10011 \
=> "Überlauf" => 0011 + 1 = 0100 = 4
$

=== Zweierkomplement (b-Komplement)
$
5 - 1 \
5 = 0101 \
1 = 0001, -1 = 1111 \
0101 + 1111 = 10100 => "Überlauf" => 0100 = 4
$

== Allgemeine Berechnung des b-Komplements
$
C_(b, n)(N) = b^n - N
$
- n = Anzahl Stellen
- b = Basis
- N = Zahl, von welcher das Komplement gebildet werden soll

Beispiel:
- $C_(8, 2)(6) = 8^2 - 6 = 58_10 = 72_8$
Im Dualsystem entspricht dies dem Zweierkomplement.


== Darstellung von negativen Zahlen
=== Vorzeichen und Betrag (Sign and Magnitude)
- Vorzeichenbit (Sign): 0 für positive, 1 für negative Zahlen
- Betrag (Magnitude): absoluter Wert der Zahl
#example[
  - Positive Zahl (+5): #underline[0]101
  - Negative Zahl (-5): #underline[1]101
]
$->$ Suboptimal: Wir haben zwei Nullen (+0 und -0)

- Einfach, intuitiv
- Zwei Darstellungen von Null
- Weniger effizient für mathematische Operationen (zwei Prozessschritte, Vorzeichen & Operation mit Beträgen)
- Anwendung: Vorallem im Bildungskontext

=== Einerkomplement (b - 1)
Es werden einfach alle Bits invertiert im Binärsystem
#example[$+5 = 0101 => -5 = 1010$]

Im allen Zahlensystem allgemein bildet man das Einerkomplement, indem man von der Basis 1 und die jeweilige Ziffer subtrahiert:
#example[Sei $b$ = 5, Zahl: $234_5$. Das Einerkomplement wird berechnet durch $b - 1 - z$, wobei $z$ die Ziffer ist.
$ (5 - 1 - 2) = 2 \
(5 - 1 - 3) = 1 \ 
(5 - 1 - 4) = 0 $
Das Einerkomplement von $234_5$ wäre also $210_5$.
]

- Suboptimal: Immernoch zwei Nullen (0 und -0)
- Berechnung effizienter, aber bei einem Überlauf bei Addition muss ein _End-Around-Carry_ angewendet werden, d.h. wir entfernen und addieren den Überlauf zur Zahl hinzu

=== Zweierkomplement (b)
Um das Zweierkomplement zu erstellen, addieren wir 1 zum Einerkomplement
- Nur noch eine 0
- Effizient für Rechnen

=== Excesscode
Der Exzess- oder Überschusscode verschiebt den Zahlenstrahl auf negative Zahlen. So ist z.B. bei Exzess-8 die $0000 = -8$. Die tatsächliche Zahl kann errechnet werden, indem man eine gegebene binäre Zahl minus den Exzess rechnet:
$ 0101 "in Exzess-8" \ 
0101_b = 5 -> 5 -  8 =-3 $
Somit entspricht 0101 in Exzess-8: -3.

Man schreibt $C_("ex", -q, n)(x)$, wobei:
- $-q$: Bias
- $n$: Länge der binären Schreibweise
- $x$: Zahl (normalerweise im Dezimalsystem)

Der Excesscode, der den Zahlenbereich in zwei gleich grosse Hälften aufteilt, hat einen besonderen Stellenwert. Dabei gehört die 0 zu den negativen Zahlen. Beispiel: Bei vierstelligen Codes würde der Excess-7-Code $C_("Ex", -7, 4)(x)$ die Zahlen von -7 bis 8 darstellen. Der Bias ergibt sich dann durch $2^(n-1) - 1$.

Um eine Zahl $a$ zu kodieren, wählt man die kleinste Zahl b im Wertebereich und bildet die Differenz $d = |a-b|$. Beispiel:
$
C_("ex",-4,3)(-1) = ? \
d = |-1 - (-4)| = 3 => 011
$

== Präfixe
#table(columns: 4, stroke: none, [$2^10$], [$1.024 dot 10^3$], [K Kilo], [Ki Kibi],
[$2^20$], [$1.049 dot 10^6$], [M Mega], [Mi Mebi],
[$2^30$], [$1.074 dot 10^9$], [G Giga], [Gi Gibi],
$2^40$, $1.100 dot 10^12$, [T Tera], [Ti Tebi],
$2^50$, $1.126 dot 10^15$, [P Peta], [Pi Pebi],
$2^60$, $1.153 dot 10^18$, [E Exa], [Ei Exbi])

#example[Wie viele Datensätze zu je 128 Byte passen in einen Speicherbereich der Grösse 4 KB?

$ 128 upright(B) = 2^7 upright(B), 4"KB" = 2^2 dot 2^10 upright(B) \
(2^2 dot 2^10 upright(B)) / (2^7 upright(B)) = 2^5 = 32 $]

== Fixkommazahlen
$C_("FK", k, n)(x)$, wobei
- k = Anzahl Nachkommastellen
- n = Länge der binären Schreibweise
Beispiel: 
$C_("FK", 4, 16)(453.1234) = 0001'1100'0101'0001$

=== Absoluter Fehler
$E_"abs" = |x_"korrekt" - x_"gerundet"|$

=== Relativer Fehler
$E_"rel" = (|x_"korrekt" - x_"gerundet"|) / x_"korrekt"$

== Gleitkommazahlen
Bei Gleitkommazahlen wird zusätzlich zum Bitmuster z auch die Stelle k mitgeführt, an der das Komma steht.
- z = Signifikand, Mantisse
- k = Exponent
- $C_("GK", k, n)(z) = z dot 2^k$

Beispiel: $6.25$.

$6 = 0110, 0.25 = 0.01$

Fixkommarepräsentation: $0110.01$

Gleitkommazahlrepräsentation: $1.1001 dot 2^2$

Für die Mantisse wird die Excess-Darstellung verwendet, d.h. bei 8-Bit-Mantisse der $C_("Ex", -127, 8)$. Der Exponent $2$ wird so zu $10000001$.

Als 32-Bit-Gleitkommazahl: $0'10000001'100100000000000000000000$

#table(
  columns: (auto, auto, auto),
  align: horizon,
  [0], [10000001], [100100000000000000000000],
  [Vorzeichen], [Exponent], [Mantisse],
  stroke: none
)

=== Standard IEEE 754
- Single: 24 Bit Präzision, 8 Bit Exponent
- Double: 53 Bit Präzision, 11 Bit Exponent
- Quadruple: 113 Bit Präzision, 15 Bit Exponent

=== Addition
+ Wenn Vorzeichen unterschiedlich: Subtraktion
+ Hidden Bits ergänzen
+ Wenn Exponenten unterschiedlich: Signifikand der kleineren Zahl um entsprechend viele Bits nach rechts verschieben
+ Addition durchführen
+ Falls Carry = 1: Ergebnis normalisieren:
  - Exponent um 1 erhöhen
  - Signifikand um 1 nach rechts schieben

#figure(image("images/float-addition.png"), caption: [Floating-Point-Addition])

= Interpretation eines Codewortes
Ein Codewort $1001$ kann auf verschiedene Arten interpretiert werden:
- Als Tupel (1, 0, 0, 1)
- Als Zahl $1001_2 = 9_10$. Es gelten die üblichen Operationen der Ganzzahlrechnung.
- Als Vektor $mat(1, 0, 0, 1)^T$. Es gelten die üblichen Operationen der Vektorrechnung.
- Als Polynom: $g(u) = u^3 + 1$. Es gelten die üblichen Operationen der Polynomrechnung.

Die obigen Darstellungsformen sind äquivalent und beschreiben alle dasselbe Codewort. Alle Berechnungen erfolgen in $ZZ_2$.

== Interpretation als Vektor

Vektorraum $ZZ_2^3$:

$ vec(1, 1, 0) + vec(0, 0, 1) + vec(0, 0, 1) equiv vec(1, 1, 0) mod 2 $

Vektoren werden in der Codierung zur Fehlererkennung und -behebung verwendet.

== Interpretation als Polynom

Codewort $100101$ als Polynom:
$ 1u^5 + 0u^4 + 0u^3 + 1u^2 + 0u^1 + 1u^0 = u^5 + u^2 + u^0 $

Multiplikation zweier Polynome in $ZZ_2$:

$ (u^5 + u^2 + u^0)(u^2 + u^0) mod 2 \
= (u^7 + u^5 + u^4 + 2u^2 + u^0) mod 2 \
= u^7 + u^5 + u^4 + 1 $

Das resultierende Codewort ist $1011#h(2pt)0001$.

= Gruppe, Ring und Körper
Verknüpfung $->$ Gruppe $->$ Ring $->$ Körper
== Verknüpfung
Menge $m$ und Operation $w$: $(M, w)$

Bsp: $(NN, +)$

=== Neutrales Element
#example[$ &(NN, +) &-> 0 \
&(NN, dot) &-> 1 $]

=== Inverses Element
$a circle a' = n$
#example[$ (ZZ, +): 7 + (-7) = 0 \
(RR, dot): 4 dot 1/4 = 1 $]

== Gruppe
Verknüpfung $(G, w)$ mit
- Bezügl. $w$ abgeschlossen
- $w$ assoziativ
- Neutrales Element existiert
- Inverses Element existiert

Zusatz: Wenn Kommutativ $->$ abelsche Gruppe (Bsp. $(ZZ, +)$)

== Ring
Zwei Operationen $R(M, w_1, w_2)$, wobei $(M, w_1)$ abelsche Gruppe.

== Körper
Ein Ring ist ein Körper, wenn:
#enum(numbering: "a)",
[Jedes Element des Rings (ausser der 0) ein multiplikatives Inverses hat],
[Die Multiplikation kommutativ ist: $a b = b a$ (Abel'sche Gruppe)],
[Das Distributivgesetz gilt: $a(1 - b) = a - a b$],
[Wenn er eine 1 hat (multiplikatives neutrales Element)])

Wir definieren Mengen wie:
- $ZZ_2 = {0, 1}$
- $ZZ_5 = {0, 1, 2, 3, 4}$
- $ZZ_M = {0, 1, 2, ..., M - 1}$

Wir bewegen uns haupsächlich in $ZZ_2 = {0, 1}$ und definieren folgende Operationen:
- Addition $+$,
- Subtraktion $-$,
- Multiplikation $dot$,
- Ganzzahldivision mit Rest (Restklassen)
- Um die Abgeschlossenheit sicherzustellen, verwenden wir Operationen zusammen mit Modulo M. Beispiel:

$ ZZ_5 = {1, 2, 3, 4, 5} \
3 dot 4 = 12, 12 in.not ZZ_5 \
12 mod 5 = 2, 2 in ZZ_5 $

Modulo von negativen Zahlen: $-1 equiv 1 mod 2, -4 equiv 1 mod 5$

Codewörter können als Elemente eines endlichen Ganzzahlkörpers betrachtet werden. In der Informatik bewegen wir uns in $ZZ_2$. Die Anzahl der darstellbaren Codewörter wird durch die Codewortlänge bestimmt.
- Byte: $8 "Bit"$
- Word: $16, 32, 64 "Bit"$
- TCP-Paket: $1024 "Bit"$

Im endlichen Ganzzahlkörper gibt es immer eine grösste und eine kleinste Zahl. Die Darstellung dieser Zahl kann durch Speicher oder Definition der Wortgrösse begrenzt werden #sym.arrow Keine Unendlichkeit.


== Zyklische Gruppe
#definition[In der Gruppentheorie ist eine zyklische Gruppe eine Gruppe, die von einem einzelnen Element erzeugt wird. Sie besteht nur aus Potenzen des Erzeugers.]

Veranschaulichung:
$ M &= {0 degree, 90 degree, 180 degree, 270 degree} \
"Verknüpfung" &= "Drehung" #h(2em) mod 360 degree = a \
0 degree dot a^4 &equiv 0 degree mod 360 degree $
#figure(image("images/zyklische-gruppe.png"), caption: [Zyklische Gruppe])

Polynom $f(x) = x^3 + x + 1$, hat nach Fundamentalsatz der Algebra 3 Nullstellen. Die Frage ist nun, ob das Polynom in $ZZ_2$ eine Lösung hat.

=== Idee von Galois
Polynom $f(x) = x^3 + x + 1$ hat keine Nullstelle in $ZZ_2$. Also nehmen wir als (imaginäres) _erzeugendes Element_ $a$:
$ f(a) = a^3 + a + 1 = 0 $

Eine zyklische Gruppe (gemäss Évariste Galois (1811 - 1832)):
- Wird von einem einzigen Element erzeugt
- Besteht nur aus Potenzen des Erzeugers
- Das erzeugende Element $a$ wird als Lösung eingesetzt: $f(a) = a^3 + a + 1$
#example[
$
a &= a \
a^2 &= a^2 \
a^3 &= a + 1 && "Umstellung" f(a) "in" ZZ_2 \
a^4 &= a(a + 1) = a^2 + a \
a^5 &= a(a^2 + a) = a^3 + a^2 = a^2 + a + 1 \
a^6 &= a(a^2 + a + 1) = a^2 + 2a + 1 = a^2 + 1 \
a^7 &= a(a^2 + 1) = 1 \
a^8 &= a && "Zyklus beginnt von vorne"
$<galois>]

Neue Menge ist gemäss @galois: $ ZZ'_2 = {0, 1, a, a^2, a + 1, a^2 + a, a^2 + a + 1, a^2 + 1} $

Diese Menge können wir codieren:
$ {000, 001, 010, 100, 011, 110, 111, 101} $

= Boolsche Algebra
Es gibt genau 16 binäre Funktionen ($2^4$).
#[
#set text(size: 10pt)
#set table(
  stroke: (x, y) => (
    bottom: if y == 1 { 01pt } else { 0pt },
    right: if x == 1 or x == 9 { 1pt } else { 0pt }
  ),
)
#table(columns: 18, align: center, table.header([], [], [], [AND], [], [], [], [], [XOR], [OR], [NOR], [EQUIV], [], $y => x$, [], $x => y$, [NAND], [], $x$, $y$, $0$, $x y$, $x overline(y)$, $x$, $overline(x) y$, $y$, $x overline(y) or overline(x) y$, $x or y$, $overline(x or y)$, $x y or overline(x) and overline(y)$, $overline(y)$, $x or overline(y)$, $overline(x)$, $overline(x) or y$, $overline(x y)$, $1$), $0$, $0$, $0$, $0$, $0$, $0$, $0$, $0$, $0$, $0$, $1$, $1$, $1$, $1$, $1$, $1$, $1$, $1$,
$0$, $1$, $0$, $0$, $0$, $0$, $1$, $1$, $1$, $1$, $0$, $0$, $0$, $0$, $1$, $1$, $1$, $1$,
$1$, $0$, $0$, $0$, $1$, $1$, $0$, $0$, $1$, $1$, $0$, $0$, $1$, $1$, $0$, $0$, $1$, $1$,
$1$, $1$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $1$)
]

NAND wird auch bezeichnet als: $x | y = overline(x and y) = overline(x y)$.

$x xor y = (not x and y) or (x and not y) = (x | not y) | (not x | y)$

== Minterme und Maxterme
*Minterme* haben als Ergebnis immer 1.

*Maxterme* haben als Ergebnis immer 0.

== Addition
XOR bildet die Addition zweier Bits, AND den Übertrag.
=== Halbaddierer
- Kann 2 einstellige Binärzahlen addieren
- Hat 2 Eingänge $(x, y)$ und 2 Ausgänge


=== Volladdierer
- Hat 3 Eingänge $(x, y, C)$

#figure(grid(
  columns: 2,
image("images/halfadder.png"),
image("images/fulladder.png")  
), caption: [Half adder und full adder])

== Kanonische Disjunktive Normalform (KDNF)
Bei der KDNF kommen in jedem Minterm *alle Variablen* vor:

$ (A and B) or (A and C) \
<=> (A and B and (C or not C)) or (A and C and (B or not B)) \
<=> (A and B and C) or (A and B and not C) or (A and B and C) or (A and not B and C) \
<=> (A and B and C) or (A and B and not C) or (A and not B and C) $

= Wahrscheinlichkeit
== Begriffe
- Ereignismenge $Omega$: Menge aller möglichen Ausgänge (Ergebnisse) eines Zufallsvorgangs
- Ergebnis $omega$: Ein einzelnes Element $omega in Omega$
#example[Werfen eines Würfels][$Omega = {1, 2, 3, 4, 5, 6}$]
#example[Zweifaches Werfen einer Münze][$Omega = {Z Z, Z K, K Z, K K}$]
#example[Werfen einer Münze so lange, bis Kopf erscheint][$Omega = {K, Z K, Z Z K, Z Z Z K, dots}$]
- Anzahl aller Ergebnisse $|Omega|$
- Wahrscheinlichkeit des Komplementärergebnisses: $P(overline(A)) = 1 - P(A)$
- Wahrscheinlichkeit des unmöglichen Ereignisses: $P(theta) = 0$
- Wertebereich der Wahrscheinlichkeit: $0 <= P(A) <= 1$

== Laplace
$P(A) = ("Anzahl der günstigen Ergebnisse" A)/("Anzahl aller Ergebnisse" Omega) = (|A|)/(|Omega|)$

== Verbundwahrscheinlichkeit
$ p(a, b) = p(a) dot p(b|a) $

== Kombinatorik
=== Übersicht
#[
  #set math.equation(numbering: none)
  #table(columns: (auto, auto, 1fr, 1fr), align: center + horizon, table.cell(colspan: 2, rowspan: 2, [$n$-Optionen  auswählen]), table.cell(colspan: 2, [Beachtung der Reihenfolge]), [MIT], [OHNE],
  table.cell(rowspan: 2, [Zurücklegen]), [MIT], $ A = n^k $, $ A = binom(n + k - 1, k) $, [OHNE], $ A = n (n-1) ... (n - k + 1) \ A = n!/(n - k)! $, $ A = n!/(k! (n - k)!) = binom(n, k) $)
]
=== Geordnete Proben (ohne Wiederholung)
Die Anzahl der $k$-Tupel aus einer $n$-Menge:
$ n dot (n - 1) dot (n - 2) dot dots dot (n - k + 1)\
= n!/(n - k)! \
= product_n^(n - k + 1) n $<nck>

=== Permutation
Die Zahl der Permutationen einer $n$-Menge ist $n!$.
Dies ist ein Spezialfall von @nck mit $n = k$.

=== Ungeordnete Proben
Die Anzahl der k-elementigen Teilmengen aus einer n-elementigen Menge ist (Binomialkoeffizient):
$ binom(n, k) = (product_n^(n - k + 1) n)/k! = n!/(k! (n-k)!) $


=== Binomialverteilung
$ P_x = binom(n, x) dot p^x dot q^(n - x) $
#example[Bitstream][
  #table(columns: 5, [],table.cell(fill: black, []),[],[],[])

  Wie gross ist die Wahrscheinlichkeit, dass *genau* 1 Bit gestört ist?

  Die Wahrscheinlichkeit für eine Störung ist $p = 0.1$. Somit ist die Wahrscheinlichkeit für ein korrektes Bit $q = 0.9$.

  $ P_1 = binom(5, 1) dot p^1 dot q^4 $

  Wahrscheinlichkeit für zwei Fehler:
  $ P_2 = binom(5, 2) dot p^2 dot q ^3 $
]
= Informationstheorie
#[
  #set table(fill: (x, y) => if x == 0 or y == 0 { rgb("e1faff") })
#table(columns: 3, [Nachricht], [redundant], [nicht-redundant],
[irrelevant], table.cell(colspan: 2, [Zeichenvorrat bei Quelle und Senke verschieden]),
[relevant], [vorhersagbar], text(blue)[Information])
]

== Entscheidungsgehalt
$ H_0 = log_2(N) #h(1em) ["bit"], N = "Anzahl Elemente" $

== Informationsgehalt
Der Informationsgehalt eines Zeichens ist die Anzahl Elementarentscheidungen zur Bestimmung dieses Zeichens.
$ I(x_k) = log_2(1/p(x_k)) #h(1em) ["bit"] $

=== Tatsächliche Codewortlänge L
$ L(x_k) = ceil(I(x_k)) #h(1em) ["Bit"] $
Vorsicht: Wenn die Codewortlänge bekannt ist (z.B. nach Durchführung der Huffman-Codierung), muss die effektive Codewortlänge verwendet werden anstelle dieser Formel. Diese Formel gilt nur für die Quelle, nicht für die Codierung dieser.

== Entropie
Unter der Entropie versteht man den mittleren Informationsgehalt einer Quelle. Also wie viele Elementarentscheidungen die Quelle/Senke im Mittel pro Zeichen treffen muss. Anderes Wort ist auch die "Ungewissheit" einer Quelle, d.h. wie unsicher ist das Erraten eines Codes.

$ H(X) = sum_(k=1)^N p(x_k) I(x_k) = sum_(k=1)^N p(x_k) log_2(1/p(x_k)) #h(1em) ["bit/Zeichen"] $

Die Entropie ist maximal, wenn alle Zeichen dieselbe Wahrscheinlichkeit besitzen. Wenn jedoch nur ein Zeichen vorkommt, d.h. ein Zeichen hat die Wahrscheinlichkeit 1, dann ist die Entropie $= 0$.

=== Mittlere Codewortlänge
$ L = H_c (X) = sum_(i=1)^N p(x_i) L(x_i) = sum_(i=1)^N p(x_i) ceil(I(x_i)) #h(1em) ["bit/Zeichen"] $

=== Quelle mit Gedächtnis
$ H(X, Y) = sum_(i=1)^N sum_(k=1)^N p(x_i) dot p(y_k|x_i) dot log_2(1/(p(x_i) dot p(y_k|x_i))) = H(X) + H(Y|X) $
Redundanz:
$ R_Q = H_0 - H_(o G)(X) <= H_0 - H_(m G)(x) = H_0 - H(Y|X) $

=== Wann wird die Entropie einer Quelle/Senke maximal?
Die Entropie ist maximal, wenn alle Wahrscheinlichkeiten gleich sind.
$ X &= {x_1, x_2} \
p(x_1) &= p \
p(x_2) &= 1 - p \
=> H(X) &= p dot log_2(1/p) + (1 - p) dot log_2(1/(1 - p)) $
#image("images/max_entropy_graph.png")

=== Shannon'sches Codierungstheorem
$ H(X) <= L <= H(X) + 1 $
Wobei $L = "Mittlere Codewortlänge"$

== Redundanz einer Quelle
Absolut:
$ R_Q_"absolut" = H_0 - H(X) #h(1em) ["bit/Zeichen"] $
Relativ:
$ R_Q_"relativ" = R_Q_"absolut" / H_0 = 1 - H(X) / H_0 #h(1em) [dot 100 %] $

Redundanz der Quelle:
$ R_Q = H_0 - H(X) $
Redundanz des Codes:
$ R_c = L - H(X) $


== Präfixeigenschaft
Kodierung nach Binärtree, wobei Zeichen nur bei den Leafs sind, ist kommafrei (siehe @binary-code).

#figure(image("images/binary-tree-encoding.png", width: 4cm), caption: [Kommafreie Codierung nach Binary Tree])<binary-code>

== Quelle mit Gedächtnis
#figure(image("images/quelle-mit-gedächtnis.png"), caption: [Quelle mit Gedächtnis])
Folgende Tabelle kann man ablesen:

#table(columns: (auto, auto, auto, auto),
  table.header([], [A], [B], [C]),
  [A], [0], [4/5], [1/5],
  [B], [1/2], [1/2], [0],
  [C], [1/2], [2/5], [1/10]
)


Nun hat man folgende drei Gleichungen:
$ p(A) &= 1/2 dot p(B) + 1/2 dot p(C) \
p(B) &= 4/5 dot p(A) + 1/2 dot p(B) + 2/5 dot p(C) \
p(C) &= 1/5 dot p(A) + 1/10 dot p(C) $

Diese sind jedoch linear abhängig. Somit nimmt man zwei von den obigen drei Gleichungen und die Gleichung

$ p(A) + p(B) + p(C) = 1 $

um ein lösbares lineares Gleichungssystem zu erhalten.

= Kompressionsmethoden
== Lauflängenkomprimierung
Ähnliches Prinzip wie "AAAbbceee" = "3A2bc3e", aber mit Bits. Hierzu muss jeweils nur klar sein welcher Bit als Erstes kommt, 1 oder 0. Beispiel:

$ &1111'1100'0001'1001 \
 = &[6 dot 1 ,5 dot 0, 2 dot 1, 2 dot 0, 1] \
 = &6, 5, 2, 2, 1 \
 = &110'101'010'010'001 $

Start mit einer #colred(1) $-> colred(1)'110'101'010'010'001$

== Lempel-Ziv-Verfaren
Eine Datenstruktur besteht aus:
- Einem Textfenster, dem *search buffer*
  - Schon kodierte Symbole
  - Wird dynamisch aufgebaut
- Nach vorne gerichteten Puffer, dem *look-ahead buffer*

#example[
  #table(
    columns: 3,
    table.header([*Search Buffer/Textfenster*], [*Look-ahead buffer*], [*Coding (Position, Länge, Zeichen)*]),
    [], [#text(orange)[s]ir_sid_eastman], [(0, 0, "s")],
    [s], [#text(orange)[i]r_sid_eastman], [(0, 0, "i")],
    [si], [#text(orange)[r]\_sid_eastman], [(0, 0, "r")],
    [sir], [#text(orange)[\_]sid_eastman], [(0, 0, "\_")],
    [#text(green)[si]r\_], [#text(green)[si]d_eastmam], [(4, 2, "d") #text(size: 0.8em, gray)[4 Stellen zurück, 2 Zeichen lang]],
    [sir_sid], [\_eastman], []
  )
]

=== Lempel-Ziv-Welch (LZW)
Startet im Normalfall mit dem Wörterbuch:
#table(
  columns: 2,
  table.header([*Index*], [*Eintrag*]),
  ..for i in range(10) {
    ([#i], [#i])
  }
)

Wir codieren die Zeichenfolge "36363":
#table(columns: 3, table.header([*Buffer*], [*Erkannte Zeichenfolge (Index)*], [*Neuer Eintrag*],
[#underline[*3*\6]363], [3 (3)], [10: 3],
[3#underline[#text(weight: "bold")[6]3]63], [6 (6)], [11: 63],
[36#underline[#text(weight: "bold")[36]3]], [36 (10)], [12: 363],
[3636#underline[*3*]], [3 (3)], [-]))

Codiert wird "3 6 10 3"

=== Lempel-Ziv für Binärzahlen
#figure(image("images/lempel-ziv-binary.png"), caption: [Lempel-Ziv-Algorithmus für Binärzahlen])

== Kombination Lempel-Ziv und Huffman
Es ist möglich, zunächst die Nachricht mit Lempel-Ziv zu komprimieren und dann mit der Huffman-Codierung das entstandene Wörterbuch weiter zu komprimieren.

= Kryptologie
Assymetrische Verschlüsselung ist nicht performant. Deshalb verwendet man oft nur zu Beginn einer Kommunikation asymmetrische Verschlüsselung, damit ein sicherer Kanal entsteht. Ein gemeinsamer Schlüssel für symmetrische Verschlüsselung wird dann über die asymmetrische Verschlüsselung sicher übertragen.

== RSA
Durch $mod b$ wird ein Ereignisraum von $0$ bis $b - 1$ möglich. Somit kann man eine Zahl $c$ ausserhalb dieses Ereignisraums finden, die in dieser Rechenvorschrift eine Inverse Zahl zu a ist.

$ &m^e mod N #h(4em) &&"Verschlüsseln" \
&(m^e)^d mod N &&"Entschlüsseln" \
&= m^(e d) mod N $

Dabei muss folgendes gelten:
$ e dot d equiv 1 mod N $

Für zwei teilerfremde Zahlen $a, b$ existiert eine Zahl $c$, so das gilt:
$ a dot c equiv 1 mod b $
.

=== Eulerfunktion
$phi(n) = "Anzahl der relativ primen (teilerfremden) Zahlen zu" n$

#theorem[$ a^y mod (p dot q) = a^(y mod phi(p dot q)) mod (p dot q) $]

#proof[$ a^y mod (p dot q) &=^! a^(y mod phi(p dot q)) mod (p dot q) \
&= a^(y - n dot phi(p dot q)) mod (p dot q) \
&= a^y dot a^(-n dot phi(p dot q)) mod (p dot q) \
&= (a^y mod (p dot q)) dot underbrace((a^(phi(p dot q)) mod (p dot q)), =1)^(-n) \
&= a^y mod (p dot q) $]

#example[RSA][Seien Primzahlen $p = 47, q = 59$ gegeben. Daraus folgt: $p dot q = 2773$ und $phi(n) = (p - 1) dot (q - 1) = 2668$.

Wir wählen den Wert $e = 17$, relativ prim zu $phi(n)$, wobei $ 1 < e < phi(n)$. Und dann berechnen wir den zu $e$ inversen Wert $d = 157$.

Privater Schlüssel: $(d, n)$, Öffentlicher Schlüssel: $(e, n)$

$ m = 12 &-> c = m^e mod n = 336  #h(20pt) &"Encrypt"\
c = 336 &-> m = c^d mod n = 12 &"Decrypt" $]

=== Euklidischer Algorithmus
#table(columns: 8, table.header[x][y][q][r][u][s][v][t], [], [], [x div y], [x mod y], $u_(k + 1) = s_k$, $s_(k + 1) = u_k − q_k dot s_k $, $v_(k + 1) = t_k$, $t_(k+1) = v_k − q_k dot t_k$)

= Kanalmodell
#image("images/rain-picknick-source.jpeg")
$ p(y_1) &= p(x_1) dot p + p(x_2) dot (1 - q) \
p(y_2) &= p(x_1) dot (1 - p) + p(x_2) dot q $

$ p(Y|X) = mat(p, 1-p; 1-q, q) $

In diesem Beispiel wäre 
$ p(Y|X) = mat(0.9, 0.1;0.3, 0.7) $

Fehlerfrei:
$ p(Y|X) = mat(1, 0; 0, 1) $

$ p(P = 1, R = 1) = p(R = 1) dot p(P = 1|R = 1) = 0.35 dot 0.3 = 0.105 $

=== 3x3-Matrix
Eine 3x3-Matrix ist also folgendermassen aufgebaut:
$ mat(p(y_1|x_1), p(y_1|x_2), p(y_1|x_3);
p(y_2|x_1), p(y_2|x_2), p(y_2|x_3);
p(y_3|x_1), p(y_3|x_2), p(y_3|x_3)) $
$ vec(p(y_1),p(y_2), p(y_3)) = vec(p(x_1) dot p(y_1|x_1) + p(x_2) dot p(y_1|x_2) + p(x_3) dot p(y_1|x_3), p(x_1) dot p(y_2|x_1) + p(x_2) dot p(y_2|x_2) + p(x_3) dot p(y_2|x_3), p(x_1) dot p(y_3|x_1) + p(x_2) dot p(y_3|x_2) + p(x_3) dot p(y_3|x_3)) $

 
=== Symmetrischer Kanal
Fehlerwahrscheinlichkeit des Kanals ist unabhängig von der Auftrittswahrscheinlichkeit der Zeichen der Quelle.
$ mat(0.95, colred(0.025), colred(0.025); colred(0.025), 0.95, colred(0.025); colred(0.025), colred(0.025), 0.95) $

=== Verbundentropie
$ H(X,Y) &= - sum_i^n sum_j^n p(x_i, y_j) dot log_2(p(x_i, y_j)) $

=== Äquivokation (Verlust)
$ H(X|Y) &= - sum_i^n sum_j^n p(x_i, y_j) dot log_2(p(x_i|y_j)) \
&= - sum_i^n sum_j^n p(y_j) dot p(x_i|y_j) dot log_2(p(x_i|y_j)) $
- Ähnliche Formel wie die Verbundentropie (Rückschlussentropie)
- Ungewissheit über das gesendete Zeichen bei bekanntem Empfangszeichen
- Merke: Ist der Kanal fehlerfrei, so ist die Äquivokation gleich 0

=== Irrelevanz (Rauschen)
$ H(Y|X) &= - sum_i^n sum_j^n p(x_i, y_j) dot log_2(p(y_j|x_i)) \
&= - sum_i^n sum_j^n p(x_i) dot p(y_j|x_i) dot log_2(p(y_j|x_i)) $
- AUch Streuentropie genannt
- Ungewissheit der empfangenen Zeichen bei vorgegebenen Sendezeichen

=== Transinformation
$ T &= H(X) - H(X|Y) \
T &= H(Y) - H(Y|X) $

*Fazit*:
- Ein nicht gestörter Kanal (Einheitsmatrix) überträgt den mittleren Informationsfluss ohne weiteren Verlust, d.h. die Transinformation wird nur durch die Quelle beeinflusst
- Verändert sich die Entropie der Quelle, so verändert sich auch die Transinformation
- Nimmt die Fehlerwahrscheinlichkeit zu, nimmt die Transinformation ab
- Sind alle Positionen der Kanalmatrix gleich besetzt, so wird die Transinformation $T = 0$ und $H(Y) = H(Y|X) = 1$ und zwar unabhängig von der Entropie am Kanaleingang
- Die Transinformation gibt den maximalen und somit fehlerfreien Informationsfluss über einen gestörten Kanal an.

=== Maximum-Likelihood-Verfahren
Gegeben sei eine Kanalmatrix $P(Y|X)$. Man wählt in jeder Spalte die höchstwahrscheinliche Zahl:
$ P(Y|X) = mat(colred(0.5), 0.4, 0.1;
0.2, 0.1, colred(0.7); 
0.3, colred(0.5), 0.2) $
Der Entscheider ist hier somit:
$ y_1 -> x_1 \
y_2 -> x_3 \
y_3 -> x_2 $

Die Spalten gelten für die $Y$'s, die Zeilen für die $X$'s in der Kanalmatrix.

== Fehlerkorrektur
Idee: Wir fügen Redundanz hinzu, damit sich der Coderaum in gültige und ungültige Codewörter aufteilt (Siehe @error-cube).

#figure(image("images/coderaum.png", width: 50%), caption: [Coderaum. Weisse Punkte sind gültige Codewörter, dunkle Punkte sind ungültig. Hier ist nur Fehlererkennung möglich, keine Fehlerkorrektur.])<error-cube>
Die Distanz zwischen zwei gültigen Codewörtern nennt man Distanz $d$.

Hammingdistanz $h$: Die kleinste Distanz zwischen zwei gültigen Codewörtern (#sym.arrow Flachdrücken des Coderaums).
$ h = min_(i, j)(d(x_i, x_j)) $

#figure(image("images/coderaum-mehr-redundanz.png", width: 50%), caption: [Coderaum mit Fehlerkorrektur möglich, Hammingdistanz 3.])<hammingdistanz>

Anzahl der sicher erkennbaren Fehler $e^* = h - 1$. Im Beispiel @hammingdistanz ist die Hammingdistanz $h = 3$. Die Anzahl erkennbaren Fehler ist somit $e^* = 3 - 1 = 2$.

Anzahl sicher korrigierbaren Fehler $e = floor((h - 1) / 2)$

Bei Hamming-Blockcode ist $h = 3$.

=== Korrigierkugel
#figure(image("images/korrigierkugeln.png", width: 50%), caption: [Korrigierbare Korrigierkugeln dürfen sich nicht berühren.])
Eine Korrigierkugel hat das Zentrum bei einem gültigen Punkt und umfasst alle korrigierbaren Fehler in ihrem Radius. Der Radius ist somit die Anzahl sicher korrigierbarer Fehler $e$. Bei einer Skizze kann man dann noch die Hammingdistanz $h$ und die erkennbaren Fehler $e^*$ einzeichnen.

#example[Quersummencode][
  #table(columns: 3, align: center, table.cell(colspan: 2, $m = 2$), $k = 1$, $x_1$, $x_2$, $x_3$,
$0$, $0$, $0$, $0$, $1$, $1$, $1$, $0$, $1$, $1$, $1$, $0$, table.hline(stroke: 2pt), $0$, $0$, $1$, $0$, $1$, $0$, $1$, $0$, $0$, $1$, $1$, $1$)
]

Ein solcher Code hat die Hammingdistanz $d = 2$, da der Abstand zwischen zwei korrekten Kombinationen *zwei Bits Unterschied* hat.

=== Paritätsbit-Code
#[
  #table(columns: 2, stroke: none, $0100 #h(4pt) 1111$, table.vline(stroke: .5pt), $1$, $0101 #h(4pt) 0011$, $0$, $0101 #h(4pt) 0100$, $1$, table.hline(stroke: .5pt), $0100 #h(4pt) 1000$, $0$)

  Es können mehrere Fehler gefunden und korrigiert werden.
]

=== Hammingcode
k-Kontrollstellen:
$ n &= 2^k - 1 \ 
n &= m + k $

Die Notation des Hammingcode ist immer ein Tupel $(n, m)$, z.b. $n = 7, m = 4 -> (7, 4)$

#image("images/hamming-code-1.png")
#image("images/hamming-code-1-vectors.png")

Es wird pro Kontrollbit ein Vektor mit jeweils zwei Stellen gebildet. Hammingdistanz ist drei, somit können zwei Fehler erkannt und ein Fehler korrigiert werden. Daraus bildet sich nun folgengde *Generatormatrix*:
$ mat(1, 1, 1, 0, 1, 0, 0; 0, 1, 1, 1, 0, 1, 0; 1, 1, 0, 1, 0, 0, 1; augment: #4) \
arrow(P_1) arrow(P_2) arrow(P_3) arrow(P_4) arrow(P_5) arrow(P_6) arrow(P_7) $
Hieraus folgt die Codebedingung: $sum_i x_i dot arrow(P_i) equiv arrow(0) mod 2$

#example[
  Dieselbe Matrix, erhaltenes Codewort: $1010011$.
  $ 1 dot vec(1, 0, 1) + 1 dot vec(1, 1, 0) + 1 dot vec(0, 1, 0) + 1 dot vec(0, 0, 1) equiv vec(0, 0, 0) mod 2 $
]

#image("images/syndrom-hammingcode.png")

$->$ Das entstandene Fehlersyndrom ist derselbe Vektor wie der Spaltenvektor an der Stelle des Fehlers!

*Fehlersyndrom:*
#image("images/fehlersyndrom-hammingcode.png")

=== Ermitteln der Kontrollstellen durch rückgekoppeltes Schieberegister
#image("images/rueckgekoppeltes-schieberegister.png")

=== Abramson- bzw. CRC-Code

Diese werden gebildet durch die Multiplikation eines primitiven Polynoms mit dem Term $(1 + x)$:

Abramson-Code: $g(x) = p(x) dot (1 + x)$

CRC-Codes haben immer die Hammingdistanz $h = 4$ (Multiplikation $->$ eins mehr als zyklische Hammingcodes). Sie haben immer die Länge $n = 15$ (Andernfalls ist die Formel bei CRC $n = 2^(k - 1) - 1$).

#example[
$ &g(x) = (1 + x + x^3) dot (1 + x) \
&g(x) = 1 + x^2 + x^3 + x^4 $
]

Wenn die Frage nach einem CRC-Code ist, reicht es, dieses Polynom anzugeben.

Anzahl Kontrollstellen ist dieselbe, wie der Grad des Polynoms, in diesem Beispiel 4.

== Codiergungsdichte
Sei:
- $n$ die Dimension des Codes (Anzahl aller CW $2^n$)
- $m$ die Dimension der Nachrichten (Anzahl aller gültigen CW $2^m$)
- $k$ die Dimension der Kontrollstellen mit $n = m + k$

Codeabschätzung (Dann ist der Code *nicht* dichtgepackt):
$ 2^m dot sum_(w=0)^e binom(n, w) <= 2^n $



== Fehlersyndrom
$ arrow(Z) = sum_i f_i dot arrow(P_i) $

== Zyklischer Hamming-Code
Ermittlung der Kontrollstellen durch Mehrfachaddition (alternativ zu Polynomdivision):
#image("images/hammingcode-multiple-addition.png")

- $X(u)$: Codewort
- $G(u)$: Generatorpolynom

#example[$X(u) = 1000101$, $G(u) = 1011$.
Durch Mehrfachaddition kann berechnet werden, ob $X(u)$ ein gültiges Codewort ist (siehe @remainderless-division).
#figure(image("images/remainderless-division.png", width: 50%), caption: [Polynomdivision ohne Rest])<remainderless-division>]

Wenn man ein gültiges Codewort hat, kann man jeweils einen Fehler einbauen für jede Position und dann wieder durch Polynomdivision die Generatormatrix herleiten (siehe @generator-matrix). Der übrigbleibende Rest entspricht immer dem *Fehlersyndrom*!

=== Ermitteln der Kontrollstellen durch Mehrfachaddition
Wenn wir z.B. wissen, dass wir ein 4-stelliges Codewort (m = 4) kodieren und $k = 3$, und das Generatorpolynom 1010 beträgt, können wir verschiedene Additionen vornehmen, um die korrekten Codeworte zu erhalten:
#table(stroke: none, align: (right, left), columns: 2, [0001], table.vline(), [],
[1], [010], table.hline(),
[0], text(orange)[010],)
$->$ 0001010 ist ein gültiges Codewort.
#table(stroke: none, align: (right, left), columns: 2, [1000], table.vline(), [],
[1010], [], table.hline(),
[0010], [],
[10], [10], table.hline(),
[00], text(orange)[100]
)
$->$ 1000100 ist ein gültiges Codewort


#figure(image("images/generatormatrix.png"), caption: [Herleitung der Generatormatrix])<generator-matrix>

== Faltungscodes
Ein Faltungscode wird als Tupel $(a, e, s)$ angegeben wobei:
- a: Anzahl Ausgänge
- e: Anzahl Eingänge
- s: Anzahl Speicherplätze

Beispiel für einen Faltungscode (3, 1, 2) mit:
- $g_1(x) = 1 + x$
- $g_2(x) = 1 + x^2$
- $g_3(x) = 1 + x + x^2$
#figure(image("images/polynom.png"), caption: [Faltungscode])

=== Zustandsdiagramm
#image("images/state-diagram.png")

Netzdiagramm:
#image("images/net-diagram.png")
Ergibt die Kodierung: 111 010 100 011 111 101 011 $->$ Bitrate: $1/3$ (1 bit wird in 3 bit übersetzt)

Decodierung des $(3, 1, 2)$ Faltungscodes:

#image("images/decoding-faltungscode.png")

#image("images/decoding-faltungscode-complete.png")

#image("images/generatorpolynomial-table.png")
