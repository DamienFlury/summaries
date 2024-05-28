#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#let info = thmbox("info", "Info", fill: rgb("#eeeeff")).with(numbering: none)

#set page(flipped: true, columns: 3, margin: 20pt)
#set text(lang: "de", size: 7pt)
#set par(justify: true)
#show raw: set text(font: "Fira Code")
#set heading(numbering: "1.1")

#let definition(text) = box()[_Definition:_ #text]

= Algorithmus
#definition[*Endliches*, *deterministisches* und *allgemeines* Verfahren unter Verwendung *ausführbarer*, *elementarer* Schritte.]

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