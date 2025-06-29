= Aufgaben eines Betriebssysteme
Ein Betriebssystem ist eine Abstraktion von der Hardware und von darunterliegenden Protokollen und Softwareservices.
Dadurch bietet es eine Portabilität.

Es bietet ein Resourcenmanagement und eine Isolation der Anwendungen voneinander. Dies wirkt sich auf die Rechenzeit,
Hauptspeicherverwaltung, sekundären Speicher, Bandbreite, etc. aus.

Die meisten Betriebssysteme bieten eine Benutzerverwaltung und Sicherheitsmechanismen.

== Grenzen der Portierbarkeit
Der Entwickler muss sicherstellen, dass die Applikation auf verschiedenen Bildschirmen funktioniert (z.B. auch Maus/Touchscreen). Moderne Betriebssysteme bieten dafür Mechanismen an, der Entwickler muss sie jedoch korrekt anwenden.

== Grenzen der Portierbarkeit
Applikationen konkurrieren um Bildschirm und Tastatur. Daher kommt auch das Popup-Problem (Applikationen stehlen durch Popups den Fokus).

== Prozessor Privilege Levels
Moderne OS haben mindestens zwei Privilege Levels: den Kernel-Mode und den User-Mode, in welchem nur bestimmte Instruktionen
ausgeführt werden dürfen. Das OS läuft im Kernel-Mode und kann bestimmen, welche Software in welchem Mode läuft. Bei den Privilege Levels spricht man von einem Hardware-Mechanismus. Beim Wechseln vom Mode wird eine Instruktion für den Kontextwechsel ausgeführt.

== Grundaufbau eines Betriebssystems
Betriebssysteme werden typischerweise in einen Kern- und einen Nicht-Kernbereich aufgeteilt.


#figure(
  image("../assets/privilege-levels.png", width: 80%),
  caption: [Privilege Levels],
) <fig-privilege-levels>

== Microkernel
In einem Microkernel ist die Kernelfunktionalität auf ein Minimum reduziert, das allermeiste läuft im User-Mode, sogar Gerätetreiber. Nur kritische Teile des Kernels laufen im Kernel-Mode.

Dies hat den Vorteil von erhöhter Stabilität und Analysierbarkeit aber resultiert auch in Performance-Einbussen.

In der Praxis sind auch Microkernel nicht völlig minimal.

== Monolithische Kernel
Die meisten OS-Kernel sind monolithisch. Sie erhalten viel Funktionalität, die theoretisch auch im User-Mode laufen könnte.
Dies bietet den Vorteil, dass weniger zwischen den Modes gewechselt werden muss $=>$ Bessere Performance.

Dies hat aber den Nachteil, dass vor Programmierfehlern wenig geschützt wird und kleine Fehler auch über Modulgrenzen propagieren können und nicht-nachvollziehbare Auswirkungen haben (z.B. wilde Pointer).

Gerätetreiber und sogar Teile des Desktop-Systems laufen im Kernel-Mode.

== Unikernel
Als Unikernel versteht man ein einzelnes Programm als Kernel. Es gibt keine Trennung zwischen Kernel- und User-Mode. Dies bietet echte Minimalität und ist extrem Kompakt, ist aber single Purpose und der Applikationsentwickler muss sich direkt mit
der Hardware auseinandersetzen.

== Wechseln des Privilege Levels zum Kernel Mode
Durch `syscall`-Anweisungen wird der Prozessor in den Kernel-Mode geschaltet. Der Instuction-Pointer (IP) wird dann auf
OS-Code gesetzt (auf den System Call Handler). Somit bleibt Kernel-Mode-Code immer im Kernel-Mode.

Da es nur einen `syscall`-Befehl gibt, muss jede OS-Kernel-Funktionalität mit einem Code versehen werden. Dieser Code wird in einem Register übergeben.

== API vs ABI
/ API: Application Programming Interface (Abstrakte Schnittstelle, für diverse Betriebssysteme gleich)
/ ABI: Application Binary Interface (Calling Conventions, ...)

=== ABI-Kompatibilität Linux-Kernel
Innerhalb einer Kernel-Version wird die gleiche ABI garantiert, aber nicht zwischen Kernel-Versionen. Linux-Kernel sind _nicht_ binär-kompatibel zueinander. Applikationen müssen somit jeweils für einen Kernel kompiliert werden.

Daher sollten Applikationen nicht direkt Syscalls aufrufen, sondern C-Wrapper-Funktionen $->$ ABI-Kompatibilität.

== Umgebungsvariablen
- Werden vom erzeugenden Prozess festgelegt (e.g. shell)
- C: `environ` (Variable)
  - Sollte nicht direkt verwendet werden $->$ `getenv`, `putenv`, `setenv`, `unsetenv`
- Value kann auch ein `=` enthalten

=== C-API
==== Abfragen
```c
char * getenv(const char * key)
```
- gibt Adresse des ersten Zeichens des entsprechenden Values zurück
- Falls Umgebungsvariable mit dem key nicht vorhanden: gibt 0 zurück

==== Setzen
```c
int setenv(const char * key, const char * value, int overwrite)
```
- _Kopiert_ key und value

==== Entfernen
```c
int unsetenv(const char * key)
```

==== Hinzufügen
```c
int putenv(char * kvp)
```
- Fügt den Pointer kvp dem Array der Umgebungsvariablen hinzu
- Der String wird _nicht_ kopiert! Nur die Adresse wird kopiert.
- Ersetzt Key-Value-Pair, falls Key bereits vorhanden

=== Weitere Konfigurationsmöglichkeiten
- Programme sehen häufig anstelle einiger Umgebungsvariablen optionale Programmargumente vor (Bsp. Docker)
- Grössere Konfigurationsinformationen sollten bevorzugt über Dateien übermittelt werden:
  - Nötig wegen Beschränkungen der Zeilenlänge
  - Datenname als Umgebungsvariable/Programmargument übergeben
- Einige OS kennen noch andere Mechanismen: e.g. Windows Registry, ähnlich einer Datenbank (Key-Value-Pairs mit beliebig vielen untergeordneten Key-Value-Pairs)
