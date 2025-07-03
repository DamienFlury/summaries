= Prozesse
== Monoprogrammierung
Das OS muss seine Dienste jedem Programm _einzeln_ zur Verfügung stellen. Ein
Programm läuft nur für sich und kennt nur sich selber und das OS. Das OS
isoliert die Programme voneinander. Dafür verwendet das OS jeweils einen
_Prozess_. Jedem Prozess ist ein virtueller Adressraum zugeordnet.

== Sektionen
Ein Prozess umfasst neben dem Abbild des Programms im Hauptspeicher (`text
section`) die globalen Variablen (`data section`), Speicher für den Heap und
Speicher für den Stack. In der `text section` springt der Instruction Pointer
(_IP_) herum.

#figure(
  image("../assets/process-sections.png", width: 80%),
  caption: [Prozess-Sektionen],
) <fig-process-sections>

== Prozess $!=$ Programm
Ein Programm ist passiv, es beschreibt Abläufe, während ein Prozess aktiv die
Abläufe ausführt. Ein Programm kann mehrfach ausgeführt werden in verschiedenen
Prozessen. In POSIX kann ein Prozess mehrere Programme _nacheinander_
ausführen.

== Process Control Block (PCB)
Der PCB beinhaltet alle Daten, die das OS benötigt für den spezifischen Prozess. Jeder Prozess hat somit einen eigenen PCB. Darin steht die Eigene PID, die PID des Parents und andere wichtige IDs. Ausserdem wird der Zustand/Kontext des Prozessors darin gespeichert, es beinhält Scheduling-Informationen, Daten zur Synchronisation & Kommunikation zwischen Prozessen, Dateisystem-relevante und Security-Informationen.

== Interrupts
Bei einem Interrupt wird der Kontext des aktuellen Prozesses im dazugehörigen PCB gespeichert werden ("context save"). Gespeichert werden:
- Register
- Flags
- Instruction Pointer
- MMU-Konfiguration (Page-Table-Pointer)
Danach wird der Interrupt-Handler aufgerufen. Danach wird der Kontext des
Prozesses aus seinem PCB wiederhergestellt ("context restore")

== Prozess-Hierarchie
In POSIX hat jeder Prozess ausser Prozess 1 genau einen Parent-Prozess. Die
erzeugte Baumstruktur kann z.B. mit dem Tool `pstree` angezeigt werden.

== Fork
```c pid_t fork (void)```
Erzeugt eine exakte Kopie (Child $C$) des Prozesses (Parent $P$), aber:
- $C$ hat eine eigene Prozess-ID
- $C$ hat als Parent-Prozess-ID die PID von $P$
Die Funktion führt in beiden Prozessen den Code an _derselben Stelle_ fort, am
Rücksprung aus `fork`.
- In $P$ bei Erfolg: Gibt PID von C zurück (> 0)
- In $P$ bei Misserfolg: Gibt -1 zurück und Fehlercode in `errno`
- In $C$: Gibt 0 zurück

Beispiel:
```c
pid_t new_pid = fork();

if (new_pid > 0) {
  // Parent code
} else if (new_pid == 0) {
  // Child code
}
```

`void exit (int code)` bietet das "Gegenstück" zu fork.


Beispiel Worker-Prozess:
```c
void spawn_worker () {
  if (fork() == 0) {
    // do stuff...
    exit(0);
  }
}
```

== Wait
```c pid_t wait (int *status)```
Wait unterbricht aufrufenden Prozess, bis einer seiner Child-Prozesse beendet wurde.
Der Status wird durch Macros abgefragt:
- `WIFEXITED (*status)`: $!= 0$ ("true"), wenn Child ordnungsgemäss beendet wurde
- `WEXITSTATUS (*status)`: Exit-Code von Child
`wait` gibt $-1$ zurück, wenn ein Fehler auftritt, Fehlercode in `errno`:
- `ECHILD`: Kein Child, um darauf zu warten
- `EINTR`: Wurde von einem Signal unterbrochen (Interrupt)

```c pid_t waitpid (pid_t pid, int *status, int options)```
wartet auf bestimmten Child-Prozess:
- $"pid" > 0$: Wartet nur auf Child-Prozess mit dieser `pid`
- $"pid" = -1$: Wartet auf irgendeinen Child-Prozess (= `wait`)
- $"pid" = 0$ und $"pid" < -1$ erwarten das Warten auf Prozesse einer bestimmten Prozessgruppe

Beispiel: Mehrere Worker-Prozesse

```c
for (int i = 0; i < n; ++i)
{
    spawn_worker (...);
}

// ... do something in parent process

do
{
    pid = wait(0);
}
while (pid > 0 || errno != ECHILD);
```

== Exec-Funktionen
6 exec-Funktionen:
- Programmargumente:
  - `execl*`-Funktionen: Als Liste: `execl(path, arg0, arg1, ...)`
  - `execv*`-Funktionen: Als Vektor: `execv(path, argv)`
- Die `exec*e`-Funktionen erlauben die Angabe eines Arrays für die Umgebungsvariablen, in den anderen bleiben die Umgebungsvariablen gleich
- Die `exec*p`-Funktionen suchen den Dateinamen über die Umgebungsvariable `PATH`, die anderen verwenden absolute/relative Pfade

== Zombie-Prozess
Der Parent-Prozess $P$ ist verantwortlich dafür, _auf jeden Fall_ `wait`
aufzurufen. Das OS muss die Statusinformationen von $C$ solange vorhalten, bis
$P$ `wait` aufruft. $C$ ist zwischen seinem Ende und dem Aufruf von `wait`
durch $P$ ein Zombie-Prozess.

== Oprhan-Prozess
Wenn der Parent-Prozess $P$ endet, ohne auf die Child-Prozesse $C$ zu warten,
werden alle Child-Prozesse zu Orphan-Prozessen. Sie werden alle an den Prozess
mit $"pid" = 1$ übertragen. Dieser Prozess ruft in einer Endlosschleife `wait` auf und beendet somit alle ihm übertragenen Orphan-Prozesse.


== Sleep
```c unsigned int sleep (unsigned int seconds)```
unterbricht die Ausführung bis die Anzahl der Sekunden _ungefähr_ verstrichen
ist. Sleep kann auch vom System unterbrochen werden (z.B durch Signale) und
gibt die Anzahl Sekunden zurück, die vom Schlaf noch verblieben sind.

== atexit
```c int atexit (void (*function)(void))```
Viele Resourcen werden vom OS automatisch nach Beendigung aufgeräumt, z.B.
Speicher oder offene Dateien. Das Programm kann eine oder mehrere Funktionen
mit `atexit` registrieren, die vor dem wirklichen Ende des Prozesses selber
Aufräumarbeiten durchführen kann.

== Lesen von PIDs

```c
pid_t getpid (void); // PID
pid_t getppid (void); // Parent-PID
```
Diese Funktionen geben die Prozess-ID des aufrugenden Prozesses (Parent-Prozess) zurück.
