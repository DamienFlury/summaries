#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#let info = thmbox("info", "Info", fill: rgb("#eeeeff")).with(numbering: none)

#set page(flipped: true, margin: 10pt, columns: 3)

#set text(lang: "de", size: 7pt)
#set par(justify: true)
#show raw: set text(font: "Monaspace Neon")
#set heading(numbering: "1.1")

#let definition(text) = box()[_Definition:_ #text]

#set image(width: 60%)


= Input und Output
#figure(image("images/class-hierarchy-io.png"), caption: [Klassenhierarchie von Input und Output])

== Input
=== File-Reader
```java
try (var reader = new FileReader("quotes.txt")) {
  int value = reader.read();
  while (value >= 0) {
    char c = (char) value;
    // use character
    value = reader.read();
  }
}
```

```java
new FileReader(f);
// ist äquivalent zu
new InputStreamReader(new FileInputStream(f));
```

=== Zeilenweises Lesen
```java
try (var reader = new BufferedReader(new FileReader("quotes.txt")) {
  String line = reader.readLine();
  while (line != null) {
    System.out.println(line);
    line = reader.readLine();
  }
}
  ```

#info[`FileReader` liest einzelne Zeichen, `BufferedReader` liest ganze Zeilen.]

== Output
=== File-Writer
```java
try (var writer = new FileWriter("test.txt", true)) {
  writer.write("Hello!");
  writer.write("\n");
}
```

== Zusammenfassung
- Byte-Stream: Byteweises Lesen von Dateien
- FileInputStream, FileOutputStream
- Character-Stream: Zeichenweises Lesen von Dateien (UTF-8)
- FileReader, FileWriter

= Serialisierung
Das `Serializable`-Interface implementieren (Marker-Interface). Ohne Marker-Interface wird eine `NotSerializableException` geworfen.
Jedes Feld, das serialisiert werden soll, muss ebenfalls `Serializable` implementieren (Transitive Serialisierung).
```java
class Person implements Serializable {
  private static final long serialVersionUID = 1L;
  private String firstName;
  private String lastName;
  // …
}
```

Das kann dann vom ObjectOutputStream verwendet werden, um Data Binär zu serialisieren:
```java
try (var stream = new ObjectOutputStream(new FileOutputStream("serial.bin"))) {
  stream.writeObject(person);
}
```
Um ein Objekt aus einem Bytestrom zu deserialisieren, wird der ObjectInputStream verwendet:
```java
try (var stream = new ObjectInputStream(
  new FileInputStream("serial.bin"))) {
  Person p = (Person) stream.readObject();
  // …
}
```

== Serialisierung mit Jackson
```java
Employee e = new Employee(1, "Frieder Loch");
String jsonString = mapper.writeValueAsString(e);
var writer = new PrintWriter(FILE_PATH);
writer.println(jsonString);
writer.close();
```
Output:
```json
{"id":1,"name":"Frieder Loch"}
```

=== Beeinflussung der Serialisierung
```java
public class WeatherData {
  @JsonProperty("temp_celsius")
  private double tempCelsius;
} 
```

```java
@JsonPropertyOrder({"name", "id"})
public class Employee{
  public int id;
  public String name;
}
```

`@JsonIgnore`, `@JsonInclude(Include.NON_NULL)` (nur nicht-null-Werte), `@JsonFormat(pattern = "dd-MM-yyyy")`

```java
@JsonRootName(value="user")
public class Customer {
  public int id;
  public String name;
}
// ...
var mapper = new ObjectMapper().enable(
  SerializationFeature.WRAP_ROOT_VALUE
);
```
Output:
```json
{
"user": {
"id": 1,
"name": "Frieder Loch"
}
}
```

=== JsonGenerator
```java
var generator = new JsonFactory().createGenerator(
  new FileOutputStream("employee.json"), JsonEncoding.UTF8);
jsonGenerator.writeStartObject();
jsonGenerator.writeFieldName("identity");
jsonGenerator.writeStartObject();
jsonGenerator.writeStringField("name", company.name);
jsonGenerator.writeEndObject();
```

=== Deserialisierung
```java
String json = "{\"name\":\"Max\", \"alter\":30}";
ObjectMapper mapper = new ObjectMapper();
Benutzer benutzer = mapper.readValue(json, Benutzer.class); // throws JsonMappingException
```

Deserializer:
```java
public class CompanyJsonDeserializer extends JsonDeserializer {
  @Override
  public Company deserialize(JsonParser jP, DeserializationContext dC) throws IOException {
    var tree = jP.readValueAs(JsonNode.class);
    var identity = tree.get("identity");
    var url = new URL(tree.get("website").asText());
    var nameString = identity.get("name").asText();
    var uuid = UUID.fromString((identity.get("id").asText()));
    return new Company(nameString, url, uuid);
  }
}
```

\@JacksonInject:
```java
public class Book {
  public String name;
  @JacksonInject
  public LocalDateTime lastUpdate;
}
InjectableValues inject = new InjectableValues.Std()
.addValue(LocalDateTime.class, LocalDateTime.now());
Book[] books = new ObjectMapper().reader(inject)
.forType(new TypeReference<Book[]>(){}).readValue(jsonString);
```

= Generics
== Iterator
```java
for (Iterator<String> it = list.iterator(); it.hasNext(); ) {
  String s = it.next();
  System.out.println(s);
}
```

=== Iterable und Iterator
#grid(columns: 2, gutter: 2em, 
  ```java
interface Iterable<T> {
  Iterator<T> iterator();
}
```,
  ```java
interface Iterator<T> {
  boolean hasNext();
  T next();
}
```
)

Klassen, die `Iterable` implementieren, können in einer enhanced `for`-Schleife verwendet werden:

== Generische Methoden
```java
public static <T> Stack<T> multiPush(T value, int times) {
  var result = new Stack<T>();
  for(var i = 0; i < times; i++) {
    result.push(value);
  }
  return result;
}
```
Typ wird am Kontext erkannt:
```java
Stack<String> stack1 = multiPush("Hallo", 3);
Stack<Double> stack2 = multiPush(3.141, 3);
```
Generics mit Type-Bounds verwenden immer `extends`, kein `implements`.

Vorsicht:
```java
private static <T extends Comparable<T>> T majority(T x, T y, T z) {
  // ...
}
// ...
Number n = majority(1, 2.4232, 3); // Compilerfehler
Main.<Number>majority(1, 2.4232, 3); // Eigentlich OK, aber Number hat keine Comparable-Implementierung
```

Die JVM hat keine Typinformationen zur Laufzeit #sym.arrow Non-Reifiable Types, Type-Erasure.

== Wildcards
```java
public static void printAnimals(List<? extends Animal> animals) {
  for (Animal animal : animals) {
    System.out.println(animal.getName());
  }
}
public static void main(String[] args) {
  List<Animal> animalList = new ArrayList<>();
  printAnimals(animalList);
  List<Cat> catList = new ArrayList<>();
  printAnimals(catList);
}
```

== Variance
#[
#let no = text(red, sym.times.big)
#let yes = text(green, sym.checkmark)
#table(columns: 5, stroke: none, table.header([], [*Typ*], [*Kompatible Typ-Argumente*], [*Lesen*], [*Schreiben*]), [*Invarianz*], [`C<T>`], [T], yes, yes, [*Kovarianz*], [`C<? extends T>`], [T und Subtypen], yes, no, [*Kontravarianz*], [`C<? super T>`], [T und Basistypen], no, yes, [*Bivarianz*], [`C<?>`], [Alle], no, no)
]

== Generics vs ArrayList
```java
ArrayList<String> stringsArray = new ArrayList<>();
ArrayList<Object> objectsArray = stringsArray; // Compilerfehler

String[] stringsArray = new String[10];
Object[] objectsArray = stringsArray; // OK
objectsArray[0] = Integer.valueOf(2); // Exception
```

Kompiliert nicht mit Subtypen:
```java
Object[] objectsArray = new Object[10];
String[] stringsArray = objectsArray; // Compilerfehler
```

=== Kovarianz
```java
Stack<? extends Graphic> stack = new Stack<Rectangle>();
stack.push(new Graphic()); // nicht erlaubt
stack.push(new Rectangle()); // auch nicht erlaubt
```
#sym.arrow Kovariante generische Typen sind *readonly*.
=== Kontravarianz
```java
public static void addToCollection(List<? super Integer> list, Integer i) {
  list.add(i);
}

List<Object> objects = new ArrayList<>();
addToCollection(objects, 1); // OK
```

Lesen aus Collection mit Kontravarianz ist nicht möglich:
```java
Stack<? super Graphic> stack = new Stack<Object>();
stack.add(new Object()); // Nicht OK, Object ist kein Graphic
stack.add(new Circle()); // OK
Graphic g = stack.pop(); // Compilerfehler
```

=== PECS
> Producer Extends, Consumer Super
```java
<T> void move(Stack<? extends T> from, Stack<? super T> to) {
  while (!from.isEmpty()) {
    to.push(from.pop());
  }
}
```

=== Bivarianz
Schreiben nicht möglich, Lesen mit Einschränkungen:
```java
static void appendNewObject(List<?> list) {
  list.add(new Object()); // Compilerfehler
}
```

```java
public static void printList(List<?> list) {
  for (Object elem: list) {
    System.out.print(elem + " "); // OK
  }
  System.out.println();
}
```

= Annotations und Reflection
Beispiele für Annotations:
- `@Override`
- `@Deprecated`
- `@SuppressWarnings(value = "unchecked")`
- `@FunctionalInterface`

== Implementation von Annotations
```java
@Target(ElementType.METHOD) // oder TYPE, FIELD, PARAMETER, CONSTRUCTOR
@Retention(RetentionPolicy.RUNTIME) // oder SOURCE, CLASS
public @interface Profile { }
```

== Reflection
```java
Class c = "foo".getClass();
Class c = Boolean.class;
```

Wichtige Methoden von `Class`:
- ```java public Method[] getDeclaredMethods() throws SecurityException```
- ```java public Constructor<?>[] getDeclaredConstructors() throws SecurityException```
- ```java public Field[] getDeclaredFields() throws SecurityException```

=== Methoden
- ```java public String getName()```
- ```java public Object invoke(Object obj, Object... args)``` 

=== Auswahl annotierter Methoden
```java
for (var m : methods) {
  if(m.isAnnotationPresent(Profile.class)) {
    PerformanceAnalyzer.profileMethod(testFunctions, m, new Object[] {array});
  }
}
```

=== Aufruf und Profiling der Methoden
```java
public class PerformanceAnalyzer {
  public static void profileMethod(Object object, Method method, Object[] args) {
    long startTime = System.nanoTime();
    try {
      method.invoke(object, args);
    } catch (IllegalAccessException | InvocationTargetException e) {
      e.printStackTrace();
    }
    long endTime = System.nanoTime();
    long elapsedTime = endTime - startTime;
    System.out.println(method.getName() + " took " + elapsedTime + " nanoseconds to execute.");
  }
}
```

= Arrays und Listen
== Sortieren
=== Platz finden und Platz schaffen
Beispiel (Highscore-Liste):
- Iteration vom Ende zu Beginn
- Neuer Score grösser als Score an `position - 1`?
- Ja: Kopiere `position - 1` an `position`
- Nein: Iteration abbrechen
- Eintrag an `position` speichern

#figure(image("images/leaderboard.png"), caption: [Leaderboard])

```java
public void add(GameEntry entry) {
  int newScore = entry.getScore();
  if(isHighscore(newScore)) {
    if(numEntries < board.length) {
      numEntries++;
    }
    int j = numEntries - 1;
    for(; j > 0 && board[j - 1].getScore() < newScore; j--) {
      board[j] = board[j - 1]
      j--;
    }
    board[j] = entry;
  }
}
```

=== Insertion Sort
```java
public static <T extends Comparable<T>> void insertionSort(T[] data) {
  for (int i = 1; i < data.length; i++) {
    T currentItem = data[i];
    int j = i;
    for(; (j > 0) && (data[j - 1].compareTo(currentItem) > 0); j--) {
      data[j] = data[j - 1];
    }
    data[j] = currentItem;
  }
}
```

== Linked List
=== Einfügen am Anfang
+ Neuen Knoten mit altem Kopf verketten
+ `head` auf neuen Knoten setzen

=== Einfügen am Ende
+ Neuen Knoten auf `null` zeigen lassen
+ Früheren Endknoten mit neuem Knoten verketten
+ `tail` auf neuen Knoten setzen

== Doubly Linked List
=== Einfügen eines Knotens am Anfang
```java
public void addFirst(T element) {
  DoublyLinkedNode<T> newNode = new DoublyLinkedNode<>(element, null, null);
  DoublyLinkedNode<T> f = header.getNext();
  header.setNext(newNode);
  newNode.setNext(f);
  size++;
}
```

=== Entfernen eines Knotens am Ende
```java
public T removeLast() {
  DoublyLinkedNode<T> oldPrevNode
  = trailer.getPrev();
  DoublyLinkedNode<T> prevPrevNode
  = oldPrevNode.getPrev();
  trailer.setPrev(prevPrevNode);
  prevPrevNode.setNext(trailer);
  oldPrevNode.setPrev(null);
  oldPrevNode.setNext(null);
  size--;
  return oldPrevNode.getElement();
}
```

= Algorithmenparadigmen
#definition[*Endliches*, *deterministisches* und *allgemeines* Verfahren unter Verwendung *ausführbarer*, *elementarer* Schritte.]

== Set-Covering Problem
_Beispiel:_ Alle Staaten mit möglichst wenigen Radiosendern abdecken.
#figure(image("images/set-covering.png"), caption: [Set-Covering Problem])

*Optimaler Algorithmus:*
- Teilmengen der Stationen aufzählen
- Minimale Anzahl Stationen wählen
- Problem: $2^n$ mögliche Kombinationen

*Greedy Algorithmus:*
- Immer Sender wählen, der die meisten neuen Staaten hinzufügt

```java
public static void calculateSolution(HashSet<String> statesNeeded, HashMap<String, HashSet<String>> stations) {
  var finalStations = new HashSet<String>();
  while (!statesNeeded.isEmpty()) {
    String bestStation = "";
    var statesCovered = new HashSet<String>();
    for (String station : stations.keySet()) {
      var covered = new HashSet<String>(statesNeeded);
      covered.retainAll(stations.get(station));
      if (covered.size() > statesCovered.size()) {
        bestStation = station;
        statesCovered = covered;
      }
    }
    statesNeeded.removeAll(statesCovered);
    finalStations.add(bestStation);
  }
  System.out.println(finalStations);
}
```

== Binary Search
```java
public static <T extends Comparable<T>> boolean searchBinary(List<T> data, T target, int low, int high) {
  if (low > high) {
    return false;
  } else {
    int pivot = low + ((high - low) / 2);
    if (target.equals(data.get(pivot))) {
      return true;
    } else if (target.compareTo(data.get(pivot)) < 0) {
      return searchBinary(data, target, low, pivot - 1);
    } else {
      return searchBinary(data, target, pivot + 1, high);
    }
  }
}
```

== Backtracking
- Ziel erreicht:
- Lösungspfad aktualisieren
- *True* zurückgeben
- Wenn (x, y) bereits Teil des Lösungspfades:
- *False* zurückgeben
- (x, y) als Teil des Lösungspfades markieren
- Vorwärts in X-Richtung suchen: #sym.arrow
- Keine Lösung: In Y-Richtung abwärts suchen: #sym.arrow.b
- Keine Lösung: Zurück in X-Richtung suchen: #sym.arrow.l
- Keine Lösung: Aufwärts in Y-Richtung suchen: #sym.arrow.t
- Immer noch keine Lösung: (x, y) aus Lösungspfad entfernen und *Backtracking*
- *False* zurückgeben

Vorgehensmodell:
```
fn backtrack(k: Konfiguration)
if [k ist Lösung] then
[gib k aus]
else
for each [direkte Erweiterung k' von k]
backtrack(k')
```

=== Sudoku
```java
public boolean solve(int row, int col) {
  // Lösung gefunden?
  if (row == 8 && col == 9) return true;
  if (col == 9) {
    row++;
    col = 0;
  }
  // Feld schon befüllt?
  if (sudokuArray[row][col] != 0) {
    // Wenn ja: Nächstes Feld
    return solve(row, col + 1);
  } else {
    for (int num = 1; num <= 9; num++) {
      // Ergänzung regelgerecht?
      if (checkRow(row, num) && checkCol(col, num) && checkBox(row, col, num)) {
        // Neue Teillösung erstellen und ergänzen
        sudokuArray[row][col] = num;
        if (solve(row, col + 1)) return true;
      }
    }
    // Backtracking
    sudokuArray[row][col] = 0;
    return false;
  }
}
```

=== Knight-Tour
```java
boolean knightTour(int[][] visited, int x, int y, int pos) {
  visited[x][y] = pos;

  if (pos >= N * N) {
    return true;
  }

  for (int k = 0; k < 8; k++) {
    int newX = x + row[k];
    int newY = y + col[k];

    if (isValid(newX, newY) && visited[newX][newY] == 0) {
      if (knightTour(visited, newX, newY, pos + 1)) {
        return true;
      }
    }
  }

  visited[x][y] = 0;
  return false;
}
```

== Dynamische Programmierung
```java
public static long fibonacci(int n) {
  long[] f = new long[n + 2];
  f[0] = 0;
  f[1] = 1;

  for(int i = 2; i <= n; i++) {
    f[i] = f[i - 1] + f[i -2];
  }

  return f[n];
}
```

= Algorithmenanalyse
== Theoretische Analyse
- Atomare Operationen
- In Pseudocode identifizierbar
- Annahme:
- Benötigen konstante Zeit
- Summe der primitiven Operationen bestimmt die Laufzeit

== Big-O Notation
$f(n) "ist" O(g(n))$, falls reelle, positive Konstante $c > 0$, Ganzzahlkonstante $n_0 >= 1$, so dass
$f(n) <= c dot g(n) "für" n >= n_0$

#figure(image("images/count-operations.png"), caption: [Primitive Operationen zählen])

= Sortieralgorithmen
== Selectionsort
Beim Selectionsort wird immer das grösste/kleinste Element gesucht und an der nächsten Stelle in einer zweiten Liste eingefügt. Alternativ kann auch geswappt werden.

#figure(image("images/selectionsort.png"), caption: [Selectionsort])

```java
public static void selectionsort(int[] array) {
  int n = array.length;
  for (int i = 0; i < n; i++) {
    int minimum = i;
    for (int j = i + 1; j < n; j++) {
      if (arr[j] < arr[minimum]) {
        minimum = j;
      }
    }
    swap(arr, i, minimum);
  }
}
```
Laufzeit: $O(n^2)$

== Insertionsort
```java
public static void insertionsort(Comparable[] a) {
  int n = a.length;
  for (int i = 1; i < n; i++) {
    for (int j = i; j > 0 && a[j] < a[j - 1]; j--) {
      swap(a, j, j - 1);
    }
  }
}
```

Laufzeit: $O(n^2)$

- Element entnehmen und an der richtigen Stelle in sortierter Liste einfügen
- Gut bei teilweise sortierten Arrays

== Bubblesort
Array von links nach rechts durchgehen
- Wenn Element grösser als rechter Nachbar: tauschen

#figure(image("images/bubblesort.png", width: 40%), caption: [Bubblesort])

```java
void bubblesort(int[] a) {
  for (int n = array.length; n > 1; n --) {
    for (int i = 0; i < n - 1; i++) {
      if (a[i] > a[i + 1]) {
        swap(a, i, i + 1);
      }
    }
  }
}
```

Laufzeit: $O(n^2)$

= Recursion
== Schlüssel suchen (iterativ)
+ Lege einen Haufen Schachteln zum Durchsehen an
+ Nimm eine Schachtel vom Haufen und sieh sie durch
+ Wenn du eine Schachtel findest, lege sie auf den Haufen, um sie später zu durchsuchen
+ Wenn du einen Schlüssel findest, bist du fertig
+ Gehe zu Schritt 2

```python
def look_for_key(main_box):
  pile = main_box.make_a_pile_to_look_through()
  while pile is not empty:
    box = pile.grab_a_box()
    for item in box:
      if item.is_a_box():
        pile.append(item)
      elif item.is_a_key():
        print("Found the key")
```

== Schlüssel suchen (rekursiv)
+ Sieh die Schachtel durch
+ Wenn Schachtel gefunden: Gehe zu Schritt 1
+ Wenn Schlüssel gefunden: Fertig

```python
def look_for_key(box):
  for item in box:
    if item.is_a_box():
      look_for_key(box)
    elif item.is_a_key():
      print("Found the key")
```

== Array umkehren
```java
int[] reverseArray(int[] a, int i, int j) {
  if (i < j) {
    int temp = a[j];
    a[j] = a[i];
    a[i] = temp;
    reverseArray(a, i + 1, j - 1);
  }
  return a;
}
```
Umwandlung in einen iterativen Algorithmus:
```java
int[] reverseArrayIteratively(int[] a, int i, int j) {
  while (i < j) {
    int temp = a[j];
    a[j] = a[i];
    a[i] = temp;
    i += 1;
    j += 1;
  }
  return a;
}
```

== Endrekursion
Summe (nicht end-rekursiv):
```java
int recsum(int x) {
  if (x == 0) {
    return 0;
  } else {
    return x + recsum(x - 1);
  }
}
```

Summe (end-rekursiv):
```java
int tailrecsum(int x, int total) {
  if (x == 0) {
    return total;
  } else {
    return tailrecsum(x - 1, total + 1);
  }
}
```
= Stack & Queue
== Array-basierter Stack
Push:
```java
void push(E element) {
  if (size() == data.length) {
    resize();
  }
  data[t++] = element;
}

void resize() {
  int oldSize = data.length;
  int newSize = oldSize * 2;
  E[] temp = (E[]) new Object[newSize];
  for (int i = 0; i < oldSize; i++) {
    temp[i] = data[i];
  }
  data = temp;
}
```

Pop:
```java
public E pop() {
  if (isEmpty()) {
    throw new IllegalStateException ("Stack is empty!");
  }
  E element = data[t];
  data[t--] = null;
  return element;
}
```

== Queue
- `enqueue(E)`: Element am Ende der Queue einfügen
- `E dequeue()`: Element vom Anfang der Queue entfernen und zurückgeben
- `E first()`: Liefert erstes Element, ohne es zu entfernen
- `int size()`: Anzahl gespeicherter Elemente
- `boolean isEmpty()`

=== Enqueue
- `storedElements = 0`
- `front = 0`

#figure(image("images/enqueue.png"), caption: [Enqueue])

$->$ `storedElements = 1` (`front` bleibt 0)

```java
void enqueue(E element) {
  if (storedElements == capacity) {
    throw new IllegalStateException();
  } else {
    int r = (front + storedElements) % capacity;
    data[r] = element;
    storedElements++;
  }
}
```

=== Dequeue
- `storedElements -= 1`
- `front = (front + 1) % capacity`

```java
E dequeue() {
  if (isEmpty()) {
    return null;
  } else {
    E elem = data[front];
    front = (front + 1) % capacity;
    storedElements--;
    return elem;
  }
}
```

== Ringbuffer
```java
synchronized void add(E element) throws Exception {
  int index = (tail + 1) % capacity;
  size++;

  if(size == capacity) {
    throw new Exception("Buffer Overflow");
  }

  data[index] = element;
  tail++;
}
```

```java
synchronized E get() throws Exception {
  if (size == 0) {
    throw new Exception("Empty Buffer");
  }

  int index = head % capacity;
  E element = data[index];

  head++;
  size--;
  return element;
}
```

= Trees
#figure(image("images/tree-overview.png"), caption: [Tree])
- Tiefe eines Knotens: Anzahl Vorgänger
- Höhe eines Baums: Maximale Tiefe der Knoten eines Subtree
- Subtree (Unterbaum): Baum aus einem Knoten und seinen Nachfolgern

Java Tree Interface:
```java
interface Tree<E> extends Iterable<E> {
  Node<E> root();
  Node<E> parent(Node<E> p);
  Iterable<Node<E>> children(Node<E> p);
  int numChildren(Node<E> p);
  boolean isInternal(Node<E> p); // Node
  boolean isExternal(Node<E> p); // Leaf
  boolean isRoot(Node<E> p);
}
```

Binary Tree in Java:
```java
interface BinaryTree<E> extends Tree<E> {
  Node<E> left(Node<E> p);
  Node<E> right(Node<E> p);
  Node<E> sibling(Node<E> p);
  Node<E> addRoot(E e);
  Node<E> addLeft(Node<E> p, E e);
  Node<E> addRight(Node<E> p, E e);
}
```

== Arten von Bäumen
=== Binärer Suchbaum
#figure(image("images/bst.png", width: 4cm), caption: [Binary Search Tree])
- Jeder Knoten trägt einen Schlüssel
- Alle Schlüssel im linken Teilbaum sind kleiner als die Wurzel des Teilbaums
- Alle Schlüssel im rechten Teilbaum sind grösser als die Wurzel des Teilbaums
- Die Unterbäume sind auch binäre Suchbäume



== Algorithmen
=== Tiefe
```java
int depth(Node<E> p) {
  if (isRoot(p)) {
    return 0;
  } else {
    return 1 + depth(parent(p));
  }
}
```
=== Höhe des Trees
```java
int height(Node<E> p) {
  int h = 0;
  for (Node<E> c : children(p)) {
    h = Math.max(h, 1 + height(c));
  }
  return h;
}
```

=== Sibling

== Traversierungen
=== Preorder (W - L - R)
#figure(image("images/preorder.png"), caption: [Preorder])
```java
algorithm preOrder(v) 
  visit(v)
  for each child w of v 
    preOrder(w)
```

=== Postorder (L - R - W)
#figure(image("images/postorder.png"), caption: [Postorder])
```java
algorithm postOrder(v)
  for each child w of v
    postOrder(w)
visit(v)
```

=== Breadth-First / Level-Order
Beispiel: Sudoku (Welcher Zug soll als nächstes gewählt werden).
#figure(image("images/breadth-first.png"))

```java
algorithm breadthFirst()
  // Q enthält ROot
  while Q not empty
v = Q.dequeue()
    visit(v)
for each child w in children(v)
Q.enqueue(w)
```

=== Inorder (L - W - R)
Beispiel: Arithmetische Ausdrücke
#figure(image("./images/inorder.png"), caption: [Inorder])

```java
algorithm inOrder(v)
  if hasLeft(v)
inOrder(left(v))
  visit(v)
if hasRight(v)
inOrder(right(v))
```

=== Übsersicht
#figure(image("./images/traversierung-overview.png"), caption: [Traversierungen (Übersicht)])

== Heapsort
Binärer Baum mit folgenden Eigenschaften:
- Baum ist vollständig (alle Blätter haben dieselbe Tiefe)
- Schlüssel jedes Knotens kleiner als oder gleich wie der Schlüssel seiner Kinder

#figure(image("./images/heap-as-array.png"), caption: [Heap als Array])

=== Ablauf
+ Nehme Root-Element aus dem Heap heraus und lege es in Array (Root ist immer das kleinste Element)
+ Letztes Element im Heap in Root ($->$ Heap-Eigenschaft wird verletzt)
+ Root-Element im Tree versenken (percolate)
+ Zurück zu Schritt 1.

Percolate-Algorithmus:
```java
void percolate(Comparable[] array, int startIndex, int last) {
  int i = startIndex;
  while (hasLeftChild(i, last)) {
    int left = getLeftChild(i);
    int right = getRightChild(i);
    int exchangeWith = 0;

    if (array[i].compareTo(array[left]) > 0) {
      exchangeWith = left;
    }
    if (right <= last && array[left].compareTo(array[right]) > 0) {
      exchangeWith = right;
    }
    if (exchangeWith == 0 || array[i].compareTo(array[exchangeWith]) <= 0) {
      break;
    }
    swap(array, i, exchangeWith);
    i = exchangeWith;
  }
}
```

Heap-Sort-Funktion:
```java
void heapSort(Comparable[] array) {
  int i;
  heapifyMe(array);
  for (i = array.length - 1; i > 0; i--) {
    swap(array, 0, i); // Erstes Element mit letztem tauschen
    percolate(array, 0, i - 1); // Heap wiederherstellen
  }
}
```

= Design Patterns
== Arten
- Erzeugungsmuster: Abstrahieren Instanziierung (Factory, Singleton)
- Strukturmuster: Zusammensetzung von Klassen & Objekten zu grösseren Strukturen (Adapter, Fassade)
- Verhaltensmuster: Algorithmen und Verteilung von Verantwortung zwischen Objekten (Iterator, Visitor)

=== Template-Method
- Rumpf (Skelett) eines Algorithmus definieren, Teilschritte in Subklasse spezifizieren
- Subklasse definiert nur Teilschritte, die Struktur des Algorithmus bleibt bestehen
- Entscheidung: Welche Teile sind unveränderlich, welche können angepasst werden?

#figure(image("./images/template-method.png"), caption: [Template-Method])

Das Template-Method-Pattern wird oft in Frameworks benutzt, im Sinne des Holywood-Prinzips: _Don't call us, we call you._

Euler-Tour:
- Generische Traversierung binärer Bäume
- Jeder Knoten wird drei mal besucht:
- Von links (preorder)
- Von unten (inorder)
- Von rechts (postorder)

```java
public abstract class EulerTour<E> {
  protected abstract void visitLeaf(Node<E> node);

  protected abstract void visitLeft(Node<E> node);

  protected abstract void visitBelow(Node<E> node);

  protected abstract void visitRight(Node<E> node);

  public void eulerPath(Node<E> node, Node<E> parent) {
    if (node == null) {
      return;
    }
    if (node.isLeaf()) {
      visitLeaf(node);
    } else {
      visitLeft(node);
      eulerPath(node.getLeft(), node);
      visitBelow(node);
      eulerPath(node.getRight(), node);
      visitRight(node);
    }
  }
}
```

=== Visitor-Pattern
#figure(image("./images/visitor-pattern.png"), caption: [Visitor-Pattern])

= Sets, Maps, Hashing
== Multiset
- Set mit erlaubten _Duplikaten_
- Was ist ein Duplikat?
- `equals()` (Standard) vs `==`

Add:
```java
public int add(E element, int occurrences) {
  if (occurrences < 0) {
    throw new IllegalArgumentException("Occurrences cannot be negative.");
  }
  int currentCount = elements.getOrDefault(element, 0);
  int newCount = currentCount + occurrences;
  elements.put(element, newCount);
  return newCount;
}
```

=== Divisionsrestverfahren
- $h(x) = x mod 10$: Nach Kriterien gute Hashfunktion, jedoch ist bei jeder Zahl nur die letzte Ziffer relevant
- $h(x) = x mod 2^2$: Die letzten beiden Ziffern in der Binärrepräsentation mappen immer auf dieselben Hashwerte
- $->$ Ungerade Zahlen (oder besser Primzahlen) verteilen sich besser
- Wird oft als Kompressionsfunktion nach dem Hash verwendet

=== Komponentensumme
+ Schlüssel in Komponenten unterteilen
+ Komponenten summieren
+ Overflow ignorieren
$->$ Problematisch, da z.B. bei Strings die Reihenfolge der Chars keine Rolle spielt

=== Polynom-Akkumulation
- Komponentensumme, mit gewichteten Komponenten:
- $p(z) = a_0 + a_1 z + a_2 z^2 + dots.c + a_(n - 1) z^(n - 1)$
- Gut für Strings
- Mit $z = 33$ maximal 6 Kollisionen bei 50'000 englischen Wörtern

=== Rezept für Benutzerdefinierte Typen
```java
@Override public int hashCode() {
  int result = 17;
  result =
  31 * result + (name != null ? name.hashCode() : 0);
  result = 31 * result + age;
  return result;
}
```

== Geschlossene Adressierung

- Behälter sind verkettete Listen
- Platz nicht begrenzt, keine Überläufer

Falls es zu einer Kollision kommt, wird in demselben Bucket der neue Wert als verlinkte Liste angehängt. Die Komplexitat beträgt $O(n/N)$, wobei:
- $n$: Einträge in der Tabelle
- $N$: Buckets

== Offene Adressierung
- Für überläufer in anderen Behältern Platz suchen
- Sondierungsfolge bestimmt Weg zum Speichern und Wiederauffinden der Überläufer

=== Sondieren
- Lineare Sondierung: Überläufer ins nächste freie Bucket schreiben
- $s(k, 1) = h(k) + 1$
- $s(k, 2) = h(k) + 2$
- Quadratische Sondierung
- $s(k, 1) = h(k) + 1^2$
- $s(k, 2) = h(k) + 2^2$
- $s(k, 3) = h(k) + 3^2$

_Löschen von Werten:_ Datensätze nicht physisch löschen, nur als gelöscht markieren
```java
public V remove(K key) {
  int hashIndex = Math.abs(key.hashCode() % capacity);
  int indexInHashMap = probeForDeletion(hashIndex, key);
  if (indexInHashMap == -1) {
    return null;
  }
  V answer = table[indexInHashMap].getValue();
  table[indexInHashMap] = DELETED;
  return answer;
}
```

=== Dynamisches Hashing
- Hashtabelle kann nur mit Aufwand vergrössert werden, um Kollisionen zu verringern
- Reorganisation bei vielen Kollisionen können nur durch Reservieren eines sehr grossen Speicherbereichs zu Beginn verhindert werden
- Wie könnte ein flexibleres Hashverfahren aussehen?


