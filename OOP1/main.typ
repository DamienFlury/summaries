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

== Unäre Operatoren
```java x++``` #sym.arrow.l.r.double Gib x zurück; x = x + 1. \
```java ++x``` #sym.arrow.l.r.double x = x + 1; Gib x zurück.

== Datentypen
=== Double
Mantisse: 52 Bit
Exponent: 11 Bit
Vorzeichen: 1 Bit

=== Float
Mantisse: 23 Bit
Exponent: 8 Bit
Vorzeichen 1 Bit

=== Ordnung von Primitives
+ long, double (64 Bit)
+ int, float (32 Bit)
+ short (16 bit)
+ byte (8 bit)

=== Iterator
```java
Iterator<String> iter = stringList.iterator();
while(it.hasNext()) {
  String elem = it.next();

  it.remove();
}
```

=== Wrapper-Klassen
```java
Integer boxed = Integer.valueOf(5);
int unboxed = boxed.intValue();
```
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

== Enums
```java
public enum Weekday {
  MONDAY(true), TUESDAY(true), WEDNESDAY(true), THURSDAY(true), FRIDAY(true), SATURDAY(false), SUNDAY(false);

  private boolean isWeekday;

  public Weekday(boolean isWeekday) {
    this.isWeekday = isWeekday;
  }
}
```
Der `==`-Operator funktioniert für Enums by default.

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

== Exceptions
Bei einem Rethrow in einer try-Methode, werden alle nachfolgenden catches nicht behandelt.

```java `Exception(String message, Throwable cause)``` (cause kann Exception sein, damit kann man den Stack Trace selbst aufbauen)

=== Finally
Wird immer ausgeführt, auch wenn Exception nicht geprüft wurde oder nach einem Rethrow.
Wird auch ausgeführt nach einem early return.

Die zweite Exception im Finally-Block überschreibt erste Exception im catch Block.
```java
try {
  // ...
} catch(RuntimeException ex) {
  throw ex; // wird ignoriert
} finally {
  throw new Exception();
}
```

== Comparable-Interface

```java
class Person implements Comparable<Person> {
  private int age;
  public int compareTo(Person other) {
    return Integer.compare(age, other.age);
  }
}
```

== Comparator-Interface

```java
interface Comparator<T> {
  int compare(T a, T b);
}

Collections.sort(people, new MyComparator());
people.sort(this::compareByAge); // Methodenreferenz (Higher order function)
```

```java
  @FunctionalInterface
  interface Comparable<T> {
    int compare(T first, T second);
  }
```

=== Comparator-Bausteine
```java
people.sort(Comparator.comparing(Person::getAge));
people.sort(Comparator.comparing(
  Person::getLastName).reversed()); // reversed ist eine default methode auf dem Comparator-Interface
people.sort(Comparator
  .comparing(Person::getLastName)
  .thenComparing(Person::getFirstName));
```

== Stream-API
```java
list.forEach(System.out::println);
```

von Package `java.util.function`:
```java
filter(Predicate<T> p)
map(Function<T, U> f)
foreach(Consumer<T> c)
```

```java
var random = new Random();
Stream.generate(random::nextInt)
  .forEach(System.out::println);
```

```java
Map<Integer, List<Person>> peopleByAge = 
  people.stream()
  .collect(Collectors.groupingBy(Person::Age));
```