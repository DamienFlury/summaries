= Dateisystem-API
== File Systems (FS)
File Systems haben zwei Bedeutungen: Einerseits auf der Seite des OS, der Teil,
welcher die Datenträger verwaltet. Auf der anderen Seite die Struktur des
Datenträgers selber.

== OS-Ebene
=== Logische Organisation
Dateien bestehen aus zwei Teilen: Den eigentlichen Daten (Inhalt und Struktur
ist dem Dateisystem egal) und den Metadaten (Sammlung von Attributen,
Informationen). Die Metadaten sind teilweise sichtbar für Nutzer (Dateiname,
Grösse, Verzeichnis, Datum des Erstellens), teilweise nicht (Ablageort auf
Datenträger, Verkettung von Blöcken).

=== Dateitypen
Dateiendungen sind von fast keiner Relevanz. Einige Programme deuten die
Dateiendung als Typ (z.B. Adobe Reader für .pdf). Häufig wird der Typ aber
durch Numbers/Strings innerhalb der Datei gekennzeichnet.

=== Schutz gegen falsche Datentypen
Die Applikation muss den Dateityp richtig bestimmen. Sie dürfen nie annehmen,
dass Daten gültig sind. Sie müssen Daten validieren und auf Grenzverletzungen
prüfen.

=== Begriffe
- Verzeichnis: Liste, die Dateien oder weitere Verzeichnisse enthalten kann
  - Als Datei realisiert, die diese Liste enthält
  - Hat einen Dateinamen
- Verzeichnishierarchie: Gesamtheit aller Verzeichnisse im System
  - Jedes Verzeichnis (ausser Root) hat genau ein Elternverzeichnis (Baum-Hierarchie)
- Wurzelverzeichnis: Oberstes Verzeichnis in Hierarchie
  - Keinen Namen, wird oft mit / bezeichnet

=== Besondere Verzeichnisse
Jeder Prozess hat ein _Arbeitsverzeichnis (working dir)_. Es bildet den
Bezugspunkt für relative Pfade und wird beim Prozessstart von aussen
festgelegt. Im Prozess wird es mit `getcwd` ermittelt und mit `chdir` (oder
`fchdir`) geändert.

=== Kanonische Pfade
Kanonische Pfade sind absolute Pfade ohne `.` und ohne `..`. Sie können mit
`realpath` ermittelt werden.

=== Längster Pfadname
Die maximale Länge der Pfadnamen ist je nach System unterschiedlich. Jedes POSIX-System definiert den Header `<limits.h>`:
- `NAME_MAX`: Maximale Länge eines Dateinamens (exklusive terminierender Null)
- `PATH_MAX`: Maximale Länge eines Pfads (inklusive terminierender Null)
- `_POSIX_NAME_MAX`: Minimaler Wert von `NAME_MAX` nach POSIX (14)
- `_POSIX_PATH_MAX`: Minimaler Wert von `PATH_MAX` nach POSIX (256)

=== Zugriffsrechte
Jede Datei/jedes Verzeichnis gehört genau einem Owner und genau einer Gruppe.
Je drei Bits für Owner, Gruppe und alle anderen Benutzer: rwx. Bei Directories
bedeutet `x` "search", d.h. das Verzeichnis darf durchsucht werden. $r = 4, w = 2, x = 1$.
Beispiel: `0740 oder rwxr-----`. Das 0 am Anfang steht für das optionale Sticky-Bit.

Die POSIX-API definiert Konstanten in `<sys/stat.h>`:
- `S_IRWXU = 0700 = rwx------`
- `S_IRGRP =  040 = ---r-----`

== POSIX-API
Die POSIX-API ist für den direkten Zugriff mit rohen Binärdaten. Die Funktionen
sind in `<unistd.h>` und `<fcntl.h>` verfügbar. Der Fehler-Code kann mit `errno` abgefragt werden.
- `char * strerror(int code)`: Gibt eine textuelle Beschreibung des Fehlers zurück.
- `void perror(const char *text)`: schreibt das Argument `text` gefolgt von
  einem Doppelpunkt und vom Ergebnis von `strerror` auf den Errorstream.

=== File-Descriptor
Die File-Descriptoren gelten immer nur _innerhalb eines Prozesses_.
Sie sind Indexe in eine Tabelle aller geöffneten Dateien eines Prozesses. Diese
Tabelle mappt dann wiederum diesen Index auf den Index in die systemweite
Tabelle aller geöffneten Dateien.

Diese systemweite Tabelle enthält Daten, um die physische Datei (mit richtigem
Treiber, Datenträger, etc.) zu identifizieren. Ausserdem ist sie
Zustandsbehaftet und merkt sich den aktuellen Offset.

Folgende File-Descriptoren sind speziell:
- 0: Immer standard in (`STDIN_FILENO`)
- 1: Immer standard out (`STDOUT_FILENO`)
- 2: Immer standard error (`STDERR_FILENO`)

Jeder Prozess erhält File-Descriptors in /proc/self/fd.

=== `read`
```c ssize_t read (int fd, void *buffer, size_t n)```
- Kopiert die nächsten $n$ Bytes am aktuellen Offset in den buffer.
- Blockiert
- Erhöht Offset
- Analog dazu: ```c ssize_t write (int fd, void *buffer, size_t n)```
- `pread (..., off_t offset)`, `pwrite(..., off_t offset)`: Read/Write _ohne_ Offsetänderung

=== `lseek`
```c off_t lseek (int fd, off_t offset, int origin)```
- Setzt den Offset von `fd`
- `origin` gibt an, wozu `offset` relativ ist:
  - `SEEK_SET`: Anfang der Datei
  - `SEEK_CUR`: Current Offset
  - `SEEK_END`: Ende der Datei

==== Weitere Anwendungen
- ```c lseek (fd, 0, SEEK_CUR)```: Gibt aktuellen Offset zurück
- ```c lseek (fd, 0, SEEK_END)```: Gibt Grösse der Datei zurück
- ```c lseek (fd, n, SEEK_END)```: Hängt bei nachfolgendem `write` $n$ Nullen
  an Datei


== C-API
Die C-API
liefert einen Zugriff via Streams, eine Abstraktion und übersetzt z.B. `\n` in
systemspezifische Zeilenenden und zurück. Das OS liefert alle Zugriffe an die
Treiber weiter.

Die Streams können gepuffert oder ungepuffert sein.

=== `FILE`
- Soll immer nur als Pointer `FILE *` verwendet werden
- Soll nicht kopiert werden
- Standard-Streams (Analog zu Standard-FDs):
  - ```c FILE *stdin```
  - ```c FILE *stdout```
  - ```c FILE *stderr```

=== Open
```c FILE * fopen (char const *path, char const *mode)```
- Pointer auf erzeugtes `FILE`-Objekt oder NULL bei Fehler

=== Close
```c int fclose (FILE *file)```
- Ruft `fflush` auf
- Schliesst Stream
- Entfernt `file` aus Speicher
- Gibt 0 zurück, falls OK, andernfalls `EOF`

=== Flush
```c int fflush (FILE *file)```
- Schreibt zu schreibenden Inhalt aus Hauptspeicher in die Datei
- Wird automatisch aufgerufen, wenn Puffer voll oder Datei geschlossen wird
- Gibt 0 zurück, falls OK, andernfalls `EOF`

=== Zusammenarbeit mit POSIX
- ```c FILE * fdopen (int fd, char const *mode)```
- ```c int fileno (FILE *stream)```
