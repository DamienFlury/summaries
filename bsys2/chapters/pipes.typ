= Pipes
== Duplizieren eines File Descriptors
```c
int dup (int source_fd); // Alloziert neuen File-Descriptor
int dup2 (int source_fd, int destination_fd); // Überschreibt `destination_fd`
```
Beispiel:
```c
int fd = open ("log.txt", ...);
int id = fork();
if (id == 0) {
  // Duplicate fd for log.txt as stdout
  dup2 (fd, 1);
} else {
  close (fd);
}
```

== Abstrakte Dateien
Konsole ist keine Datei, dennoch ist der stdout-Stream oft die Ausgabe auf der Konsole.

Eine Datei muss nur irgendwie `open`. `close`, `read` und/oder `write` unterstützen.

== Pipes
Eine Pipe ist "eine Datei" im Hauptspeicher, die über _zwei_ File-Deskriptoren veerwendet wird: _read end_ und _write end_.
Daten, die in _write end_ geschrieben werden, können genau einmal aus _read end_ in FIFO gelesen werden.
Pipes unterstützen somit kein `lseek`. Sie ermöglichen Kommunikation über Prozess-Grenzen.

```c
int pipe (int fd [2]);
```
Erzeugt eine Pipe und zwei File-Deskriptoren.

=== Lesen aus einer Pipe
Mit `read`. Falls keine Daten in der Pipe sind, blockiert `read` bis Daten hineingeschrieben werden.
Falls keine Daten in der Pipe sind und es kein geöffnetes Write-End mehr gibt, gibt `read` 0 zurück (EOF).
Der lesende Prozess muss sein Write-End schliessen, damit der schreibende Prozess über Schliessen seines
Write-Ends das Ende der Kommunikation mitteilen kann.

Das Pipe-Symbol in der Shell (|) verknüpft einfach stdout mit stdin.

Pipes sind unidirektional, es ist nicht spezifiziert, was beim Schreiben ins
_read end_ oder umgekehrt passiert.

=== Named Pipes
```c
int mkfifo (const char * path, mode_t mode);
```
Erzeugt eine Pipe mit Namen und Pfad im Dateisystem.
