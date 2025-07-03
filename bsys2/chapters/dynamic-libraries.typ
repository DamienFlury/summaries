= Dynamische Bibliotheken
Dynamische Bibliotheken werden mit dem _Loader_ geladen. Auf Linux funktioniert
dies über `exec*`-Funktionen. Sie sucht die Datei, prüft Rechte und öffnet die
Datei.
Der Request wird an jeden registrierten "Binary Handler" übergeben.

== ELF (Executable and Linking Format)
ELF ist ein Binärformat, welches Kompilate spezifiziert. Es besteht eigentlich
aus zwei Formaten (Views): Linking View (für Object-Files), Execution View (für Programme).
Dynamische Bibliotheken verwenden _beide_ Views.

=== Struktur
Ein ELF besteht aus den Bereichen Header, Program Header Table (nur Execution View), Segmente (nur Execution View), Section Header Table (nur Linking View), Sektionen (nur Linking View).

Die View des Loaders sind die Segmente. Sie definieren die Portionen, die in den Hauptspeicher geladen werden. 

=== Header
Der Header (52/64 Bytes) beschreibt:
- Typ: Relozierbar (Speicher darf verschoben werden), Ausführbar, Shared Object (dynamische Bibliothek)
- 32- oder 64-Bit
- Encoding
- Maschine (e.g. i386, Motorola 68k)
- Entrypoint: Startadresse
- Relative Adresse, Anzahl und Grösse der Einträge der Program Header Table
- Relative Adresse, Anzahl und Grösse der Einträge der Section Header Table

=== Program Header Table
Jeder Eintrag (je 32/56 Bytes) beschreibt ein Segment: Segment-Typ und Flags,
Offset und Grösse in der Datei, Virtuelle Adresse und Grösse im Speicher.

=== Segmente
Die Segmente werden vom Loader zur Laufzeit verwendet. Der Loader lädt
bestimmte Segmente in den Speicher und kann weitere Segmente für andere
Informationen verwenden.

=== Sektionen
Jeder Eintrag einer Section Header Table (40 oder 64 Byte) beschreibt eine Sektion.
- Name: Referenz auf String-Tabelle (@string-table)
- Typ und Flags
- Offset und Grösse in der Datei
- Spezifische Informationen je nach Sektionstyp

=== String-Tabelle<string-table>
Die String-Tabelle ist ein Bereich in der Datei, der nacheinander
null-terminierte Strings enthält. Enthält typischerweise Namen von Symbolen.
Die String-Table enthält keine String-Literale aus Programmen, die sind
typischerweise in `.rodata`.

== Statische Bibliotheken
Archive von Objekt-Dateien (Datei, die Objekt-Dateien enthält). Sie werden mit
dem Tool `ar` erzeugt. Per Konvention folgen Bibliotheksnamen dem Muster
`lib<name>.a`. Referenziert wird nur `<name>`: `clang -lmylib` (referenziert
`libmylib.a`).

#figure(
  image("../assets/static-libraries.png", width: 80%),
  caption: [Statische Bibliotheken],
) <fig-static-libraries>


