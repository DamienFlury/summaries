#import "typst-boxes.typ": *


#set page(
  header: align(right)[OOP Zusammenfassung – Damien Flury],
  numbering: "– 1 –",
  columns: 3,
  flipped: true,
  margin: 20pt
)

#let warn(body) = {
  slantedColorbox(
    title: "Warnung",
    color: "red",
    radius: 0pt,
    width: auto
  )[#body]
}

#set text(
  lang: "de"
)

= OOP 1 Zusammenfassung

== Syntax und Semantik
*Syntax*: Grammatik \
*Semantik*: Bedeutung der Sprachelemente (Was macht eine While-Schlaufe?)
== Unäre Operatoren
```java x++``` #sym.arrow.l.r.double Gib x zurück; x = x + 1. \
```java ++x``` #sym.arrow.l.r.double x = x + 1; Gib x zurück.
== Strings
=== String Pooling
Eine reine Compiler-Optimisation. Gleiche Strings können als einziges Objekt alloziiert werden.
Beispiel:
```java
String a = "Hello";
String b = "Hello";
a == b // true

// aber:

String a = "Hello";
String b = "H";
b += "ello";

a == b // false
```
=== Textblocks (Multiline Strings)

```java
String a = """
Multiline
String with "(unescaped) double quotes inside".""";
```

== Methoden
=== Overloading
#slantedColorbox(
  title: "Merke",
  color: "blue",
  radius: 0pt,
  width: auto
)[
  _f_ spezifischer als _g_ #sym.arrow.l.r.double Alle möglichen Aufrufe von _f_ passen auch für _g_ (aber nicht umgekehrt).
]
Bei Overlaoding gibt es *keine* Priorisierung von links nach rechts (oder umgekehrt):
```java
print(int a, double b) {}
print(double a, int b) {}

print(1, 1) // ambiguous method call
```

=== Dynamische vs Statische Bindung
Alle nicht privaten Methoden verwenden Dynamic Dispatch. \
Static Dispatch wird verwendet bei:
- Konstruktoren
- Privaten Methoden
- Statischen Methoden

=== Covarianz
Der Rückgabe-Typ einer überschriebenen Methode kann Subtyp sein:

```java
class Vehicle {
  Vehicle getClone() {}
}
class Car extends Vehicle {
  @Override
  Car getClone() {}
}
```

== Wichtige Spezialfälle der Gleichheit

```java
double a = Double.POSITIVE_INFINITY;
a + 1 == a + 2; // true
```
```java
double a = Double.NaN;
a != a; // true
```
```java
null == null; // true
```

== Hiding
```java
class Vehicle {
  String description = "Any vehicle";
}
class Car extends Vehicle {
  String description = "This is a car";
}
```

Statische Bindung:
- Zugriff auf das Feld der eigenen Klasse mit `description` oder `this.description`
- Zugriff auf das Feld der Basisklasse mit `super.description` oder `((Vehicle)this).description`
- Zugriff auf das Feld irgendeiner Klasse in der Vererbungshierarchie mit `((SuperSuperClass)this).description` (Es existiert kein `super.super`).

== Final
=== Finale Methode
```java
class Vehicle {
  public final void stop() {}
}
class Car extends Vehicle {
  public void stop() {} // Compiler-Error: Cannot override the final method...
}
```

=== Finale Klasse
```java
final class Vehicle {}
class Car extends Vehicle {} // Compiler-Error: Cannot inherit from final class...
```

== Equals-Overriding
#warn[Bei equals stets `getClass() != obj.getClass()` verwenden, anstelle `instanceof`, da `instanceof` die Vererbungshierarchie berücksichtigt.]


=== Regeln
- Reflexivität:
  - `x.equals(x)` #sym.arrow.r `true`
- Symmetrie:
  - `x.equals(y) == y.equals(x)`
- Transitivität:
  - `x.equals(y) && y.equals(z)` #sym.arrow.r `x.equals(z)`
- Konsistenz:
  - Determinismus: Immer dasselbe Resultat für dieselben Argumente.
- Null
  - `x.equals(null)` #sym.arrow.r `false`

=== Hash-Code
```java
@Override
public int hashCode() {
  return Objects.hash(firstName, lastName, age);
}
```

== Collections
#table(
  columns: (auto, auto),
  [*Methode*], [*Effizienz*],
  [`get()`, `set()`], [Sehr schnell],
  [`add()`], [Sehr schnell (amortisiert)],
  [`remove(int)`], [Langsam (meist umkopieren)],
  [`contains()`], [Langsam (durchsuchen)]
)

=== Amortisierung von `add()`
Jedes neue Array, welches erstellt wird, wird um 1.5 grösser, muss aber nicht bei jedem `add()` vergrössert werden. 

*Amortisierte Kostenanalyse*: Einfügen im Worst Case langsam, im Durchschnitt aber sehr schnell.

Max. Anzahl Umkopieren bei n+1 Einfügen: 
$$$
n + n (2/3) + n (2/3)^2 + n (2/3)^3 + ... = 3n
$$$

Die amortisierte Kostenanalyse beträgt somit <= 3 pro Einfügen.