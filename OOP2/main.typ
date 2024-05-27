#import "@preview/ctheorems:1.1.2": *
#show: thmrules

#let info = thmbox("info", "Info", fill: rgb("#eeeeff")).with(numbering: none)

#set page(flipped: true, columns: 3)
#set text(lang: "de")
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