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

Statische Bibliotheken sind einfacher. Der Nachteil ist, dass Programme bei
Änderungen in Bibliotheken neu erstellt werden müssen und dass die
Funktionalität fix ist, d.h. Plugins sind nicht moglich.

== Dynamische Bibliotheken
Bei dynamischen Bibliotheken wird das Linken erst zur Ladezeit/Laufzeit des Programs durchgeführt.
Dies bedeutet höheren Aufwand für Programmierer, Compiler, Linker und OS.

Programme können um Funktionalität ergänzt werden, die beim Schreiben nicht vorgesehen war. Dazu definiert das Programm eine allgemeine Schnittstelle (Funktionsnamen, Signaturen). Jede Plugin-Bibliothek implementiert diese Schnittstelle.

=== POSIX: Shared Objects (SO) API
```c void * dlopen(char * filename, int mode)```
Die Funktion öffnet eine dynamische Bibliothek und gibt einen Handle darauf zurück.
Der `mode` gibt an:
- `RTLD_NOW`: Alle Symbole werden beim Laden gebunden
- `RTLD_LAZY`: Symbole werden bei Bedarf gebunden
- `RTLD_GLOBAL`: Synmbole können beim Binden anderer Objekt-Dateien verwendet werden
- `RTLD_NOW`: Symbole werden nicht für andere Objekt-Dateien verwendet

```c dlsym (void * handle, char * name)```
Gibt die Adresse des Symbols `name` aus dem Handle. Dabei werden keine Typinformationen übertragen (`void *`).

```c int dlclose (void * handle)```
Schliesst das Objekt, gibt 0 zurück wenn erfolgreich.

```c char * dlerror()```
Gibt bei Fehler eine Fehlermeldung als null-terminierten String zurück

==== Benennungsschema
- Linker-Name: `lib<name>.so`
- SO-Name: `<linkername>.<versionsnummer>`
- Real-Name: `<so-name>.<unterversionsnummer>`

Das tool `ldconfig` setzt die Namen korrekt auf:
- Bibliotheksdatei in `/usr/lib/` + Real-Name
- `/usr/lib/` + SO-Name ist Soft-Link auf die Bibliotheksdatei
- `/usr/lib` + Linker-Name ist Soft-Link auf `/usr/lib/` + SO-Name

Somit können verschiedene Programme verschiedene Unterversionen ansteuern oder eine Grossversion.

=== Verwendung von Bibliotheken
==== Statische Bibliothek
`clang main.c -o main -L. -lmylib`
- Option `-L`: fügt "." zum Suchpfad hinzu
- `-lmylib` bezieht sich auf libmylib.a

==== Dynamische Bibliothek, mit Programm geladen
`clang main.c -o main -lmylib`
- `-lmylib` bezieht sich auf libmylib.so

==== Dynamische Bibliothek, mit `dlopen` geladen
Um dynamische Bibliotheken importieren zu können, brauchen wir libdl.so (stellt `dlopen`, etc. zur Verfügung):
`clang main.c  -o main -ldl`


Eine dynamische Library wird in den Dynamic Library Page Frame geladen -> Kann
von verschiedenen Prozessen verwendet werden, shared memory. Mehrere Prozesse
mappen auf denselben Frame im RAM.

Dazu wird Position-Independent Code (PIC) benötigt:
Adressen werden mit Offset vom IP berechnet.
Dazu muss der Prozessor relative Instruktionen anbieten.
`x86_32` hat (im Gegensatz zu `x86_64`) nur relative Calls, aber keine relative
Moves. Relative Moves können über relative Calls emuliert werden.
$->$ Global Offset Table (GOT)

Die Procedure Linkage Table (PLT) implementiert Lazy Binding. Sie enthält pro
gebundene Funktion einen Eintrag. PLT-Eintrag enthält einen Sprungbefehl in
GOT-Eintrag.


