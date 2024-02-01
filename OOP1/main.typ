#import "typst-boxes.typ": *


#set page(
  header: align(right)[OOP Zusammenfassung – Damien Flury],
  numbering: "– 1 –",
  columns: 5,
  flipped: true,
  margin: 20pt,
)

#set text(
  lang: "de",
  size: 8pt,
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

== Unäre Operatoren
```java x++``` #sym.arrow.l.r.double Gib x zurück; x = x + 1. \
```java ++x``` #sym.arrow.l.r.double x = x + 1; Gib x zurück.

== Datentypen
#image("./datatypes_overview.png", width: 100%)
=== Double
Mantisse: 52 Bit
Exponent: 11 Bit
Vorzeichen: 1 Bit

=== Float
Mantisse: 23 Bit
Exponent: 8 Bit
Vorzeichen 1 Bit

=== Ordnung von Primitives
Implizites Casting von unten nach oben:
+ double (64 Bit)
+ float (32 Bit)
+ long (64 Bit)
+ int (32 Bit)
+ short (16 Bit)
+ byte (8 Bit)

Long ist spezifischer als float:
```java
long l = 1;
float f = l; // ok
```

Spezialfall char (unsigned 16 Bit):
+ explizites Casting von/zu byte, short.
+ implizites Casting zu int, float (und grösser).

=== Iterator
```java
Iterator<String> iter = stringList.iterator();
while(it.hasNext()) {
  String elem = it.next();

  it.remove();
}
```

=== List
```java
list.removeAll(List.of("Bsys1", "CN1"));
```


=== Wrapper-Klassen
```java
Integer boxed = Integer.valueOf(5);
int unboxed = boxed.intValue();
// auch atomatisches Boxing:
Integer wrapper = 123; // Integer.valueOf(123);
int value = wrapper; // wrapper.intValue();
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

// oder:

String a = "Hello";
String b = new String(a);
a == b // false
```

Info: Compiler erkennt konstanten Ausdruck "OO" + "Prog" als "OOProg". Somit ist `"OO" + "Prog" == "OOProg"`.
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

== Arrays
```java
Arrays.equals(a, b); // Vergleicht die Inhalte der Arrays
Arrays.deepEquals(a, b); // Vergleicht verschachtelte Arrays
```
=== Mehrdimensionale Arrays
```java
int[][] matrix = new int[2][3];
```


== Methoden
=== Overloading
  _f_ spezifischer als _g_ #sym.arrow.l.r.double Alle möglichen Aufrufe von _f_ passen auch für _g_ (aber nicht umgekehrt).

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
Bei equals stets `getClass() != obj.getClass()` verwenden, anstelle `instanceof`, da `instanceof` die Vererbungshierarchie berücksichtigt.


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

=== Implementierung
```java
@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    if (!super.equals(o)) return false; // Wichtig bei Vererbung
    Person person = (Person) o;
    return Objects.equals(firstName, person.firstName) && Objects.equals(lastName, person.lastName);
}
```

=== Hash-Code
```java
@Override
public int hashCode() {
  return Objects.hash(firstName, lastName);
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

=== Performance-Übersicht
#image("./performance-overview.png", width: 100%)

=== Feature-Übersicht
#image("./feature-overview.png", width: 100%)

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

=== Übersicht
#image("./exceptions-overview.png", width: 100%)

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

=== Multicatch
```java
try {
  // ...
} catch(NoStringException | ShortStringException ex) {
  System.out.println("clip error: " + ex.getMessage());
}
```

=== Try-With-Resources
```java
try(var scanner = new Scanner(System.in)) {}
// äquivalent zu:
{
  Scanner scanner = new Scanner(System.in);
  try {

  } finally {
    if (scanner != null) {
      scanner.close();
    }
  }
}
```
== Liskov Substitution Principle
"Objekte einer Klasse soll man durch Objekte einer Subklasse ersetzen können, ohne die Programm-Korrektheit zu verletzen."

== Downcasting von `null`
Downcasting von `null` geschieht ohne Fehler:
```java
Vehicle v = null;
Car c = (Car)v; // c == null
```

== Packages
```java
package p1;
public class A {}

package p2;
import p1.A;
public class C {}
```
Exakte Imports haben Priorität, Wildcards nicht:
```java
package p1;
public class A {}

package p2;
public class A {}
```
Wildcard:
```java
package p1;
import p2.*;

class Test {
  A a1;
  p2.A a2;
}
```
Exakter Import:
```java
package p1;
import p2.A;

class Test {
  p1.A a1;
  A a2;
```

=== Static Imports
```java
import static java.lang.Math.*;
```

```java import java.lang.*``` ist implizit immer vorhanden.


== Interfaces
Gleiche Signatur, aber unterschiedliche Rückgabetypen geht nicht:
```java
interface RoadVehicle {
  String getModel();
}
interface WaterVehicle {
  int getModel();
}

class AmphibianMobile implements RoadVehicle, WaterVehicle {
  // Compilerfehler
  public int getModel() {
    return 1;
  }
}
```
Mit Subtypen funktioniert es aber:
```java
interface RoadVehicle {
  RoadVehicle clone();
}
interface WaterVehicle {
  WaterVehicle clone();
}
class AmphibianMobile implements RoadVehicle, WaterVehicle {
  @Override
  public AmphibianMobile clone() { // Covarianz
    return new AmphibianMobile();
  }
}
```
=== Mehrere Interfaces mit spezifischerem Interface (ok)
#image("./multiple-interfaces.png", width: 100%)
=== Mehrere Interfaces mit derselben Priorisierung (nicht ok, Klasse muss den Konflikt beheben)
#image("./multiple-interfaces-conflict.png", width: 100%)

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

class AgeComparator implements Comparator<Person> {
  public int compare(Person p1, Person p2) {
    return Integer.compare(p1.getAge(), p2.getAge());
  }
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
people.sort(Comparator
  .comparing(Person::getAge)
  .reversed()); // reversed ist eine default methode auf dem Comparator-Interface
people.sort(Comparator
  .comparing(Person::getLastName)
  .thenComparing(
    Person::getFirstName));
```

== Stream-API

=== Wichtige Stream-Methoden
- filter
- map
- flatMap
- mapToInt/mapToDouble/mapToLong
- sorted
- distinct
- limit
- skip

=== Terminaloperationen
- forEach
- forEachOrdered (erhält Reihenfolge, besonders wichtig bei Parallelisierung)
- count
- min, max
- average, sum
- findAny, findFirst
- allMatch, anyMatch, noneMatch
- reduce

=== Parallelisierung
```java
people.parallelStream()
  .filter(p -> p.getAge() > 16)
  .forEach(System.out::println);
```

=== Vordefinierte Funktionsschnittstellen
```java
interface Predicate<T> {
  boolean test(T input);
}
interface Function<T, R> {
  R apply(T input);
}
interface Consumer<T> {
  void accept(T input);
}
```
Von `java.util.function`.
```java
filter(Predicate<T> p)
map(Function<T, U> f)
forEach(Consumer<T> c)
```

=== Methodenreferenz-Syntax
```java
list.forEach(System.out::println);
```

```java
var random = new Random();
Stream.generate(random::nextInt)
  .forEach(System.out::println);
```

```java
Map<Integer, List<Person>> peopleByAge = 
  people.stream()
  .collect(Collectors
    .groupingBy(Person::Age));
```

=== Optional
```java
OptionalDouble averageAge = people.stream()
  .mapToInt(Person::getAge)
  .average();

if (averageAge.isPresent()) {
  System.out.println(averageAge
    .getAsDouble());
}
```
Methoden:
`empty()`, `of(double value)`, `ifPresent(Consumer)`, `orElse(double value)`

=== Groupings
```java
Map<Integer, List<Person>> peopleByAge = people.stream()
  .collect(Collectors
    .groupingBy(Person::getAge));
```