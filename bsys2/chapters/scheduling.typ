= Scheduling
== Zustände eines Threads
Auf einem Prozessor läuft zu einem Zeitpunkt immer höchstens ein Thread
(running). Alle Threads, die laufen könnten, aber es momentan nicht tun, sind
im Zustand _ready_.
Ein Thread, der auf ein Ereignis wartet (e.g. mit `pthread_join`) ist im Zustand _waiting_.

#figure(
  image("../assets/thread-states.png", width: 80%),
  caption: [Zustände eines Threads],
) <fig-thread-states>

Threads im _waiting_-Zustand müssen somit _nicht_ in einer Endlosschleife warten. Stattdessen
registriert das OS sie auf das entsprechende Ereignis. Wenn das Ereignis eintritt, ändert
das OS den Zustand auf _ready_ (Zustandsänderungen werden immmer vom OS vorgenommen).

== Ready-Queue
Nicht immer eine _Queue_, kann auch z.B. ein Red-Black-Tree sein (für Fairness). Neue Threads
kommen typischerweise direkt in die Ready-Queue.

== Powerdown-Modus
Wenn kein Thread laufbereit ist, schaltet das OS den Prozessor in den Standby-Zustand.
Der Prozessor wird durch den nächsten INterrupt wieder geweckt und fährt mit seiner
normalen Operation fort.
Dies führt zu einer erheblichen Energiesparung. Normalerweise ist der Prozessor die
grösste Zeit im Standby-Zustand. Busy-Waits sind deshalb nicht so gut, da sie das
Umschalten in den Busy-Wait verhindern.

== Arten von Threads
- I/O-Bound: Kommuniziert viel mit Geräten, rechnet wenig $->$ Wartet viel auf Events
- Processor-Bound: Rechnet fast ausschliesslich

== Arten der Nebenläufigkeit
- Cooperative: Jeder Thread entscheidet selbst, wann er den Prozessor abgibt
- Preemptive: Scheduler entscheidet, wann einem Thread der Prozessor entzogen wird

=== Preemptive
Der aktuelle Thread läuft weiter, bis er:
- Auf IO, einen anderen Thread, bzw. Ressource wartet/blockiert
- Freiwillig auf Prozessor verzichtet (yield)
- System-Timer-Interrupt
- Ein anderer Thread _ready_ wird, der auf ein Event gewartet hat und _bevorzugt werden soll_
- Ein neuer Prozess erzeugt wird und _bevorzugt werden soll_


== Parallele, Quasiparallele, nebenläufige Ausführung
- Parallel: Alle Threads laufen tatsächlich gleichzeitig: _n_ Threads, _n_ Prozessoren
- Quasiparallel $n$ Threads auf $< n$ Prozessoren _abwechselnd_
- Nebenläufig: Parallel oder Quasiparallel, Thread-basierte Programme meist nebenläufig

== Bursts
- Prozessor-Burst: Intervall, in dem ein Thread den Prozessor vom Eintritt in
  _running_ bis zum nächsten _waiting_ voll belegt.
- IO-Burst: Intervall, in dem ein Thread den Prozessor nicht benötigt; vom
  Eintritt in _waiting_ bis zum nächsten _running_

#figure(
  image("../assets/bursts.png", width: 80%),
  caption: [Jeder Thread kann als Abfolge von Bursts betrachtet werden.],
) <fig-bursts>

== Scheduling-Strategien
=== Anforderungen an einen Scheduler aus Anwendungssicht
- Durchlaufzeit (turnaround time): Zeit vom Starten des Threads bis zu seinem Ende
- Antwortzeit (response time): Zeit vom Empfang eines Requests bis die Antwort zur Verfügung steht
- Wartezeit (waiting time): Zeit, die ein Thread in der Ready-Queue verbringt
=== Anforderungen an einen Scheduler aus Systemperspektive
- Durchsatz (throughput): Anzahl Threads, die pro Intervall bearbeitet werden
- Prozessor-Verwendung (processor utilization): Prozentsatz der Verwendung des Prozessors gegenüber der Nichtverwendung

Zu hoher Durchsatz führt zu kleiner Prozessor-Verwendung.

- Latenz: Durchschnittliche Zeit zwischen Auftreten und vollständigem Verarbeiten eines Ereignisses
- Im schlimmsten Fall tritt das Ereignis dann auf, wenn der Thread gerade vom Prozessor entfernt wurde
- Um Antwortzeit zu verringern, muss jeder Thread öfter ausgeführt werden
  - Mehr Thread-Wechsel im gleichen Zeitintervall
- Da jeder Wechsel Prozessor-Zeit kostet, bleibt im gleichen Zeitintervall weniger Prozessor-Zeit für Threads an sich
  - Utilization nimmt ab

  === First Come, First Served (FCFS)
  FCFS ist _nicht präemptiv_. Threads geben Prozessor nur ab, wenn sie auf _waiting_ wechseln oder fertig sind.
  Durchschnittliche Wartezeit hängt von der Reihenfolge des Eintreffens der Threads ab.


#figure(
  image("../assets/fcfs.png", width: 80%),
  caption: [FCFS-Strategie],
) <fig-fcfs>


=== Shortest Job First (SJF)
Wählt den Thread aus mit dem kürzesten nächsten Prozessor-Burst. Bei gleicher Länge wählt Scheduler nach FCFS. Kann kooperativ
und präemptiv eingesetzt werden und ergibt die optimale Wartezeit, da der kürzeste Prozessor-Burst die anderen Threads minimal
blockiert.

Diese Strategie kann aber nur korrekt implementiert werden, wenn die Längen bekannt sind. Mit einer Abschätzung historischer
Daten kann SJF annähernd implementiert werden.

#figure(
  image("../assets/sjf.png", width: 80%),
  caption: [SJF-Strategie],
) <fig-sjf>

=== Round-Robin
Beim Round-Robin-Verfahren definiert der Scheduler eine Zeitscheibe (time slice) von ca. 10 bis 100 ms.
Das Grundprinzip ist FCFS, aber ein Thread kann nur solange laufen, bis seine Zeitscheibe erschöpft ist,
dann kommt er wieder in die Ready-Queue. Benötigt er nicht die volle Time-Slice, beginnt der nächste Thread
früher. Die Wahl dieser Zeitscheibe boeeinflusst das Verhalten massiv.


#figure(
    image("../assets/round-robin.png", width: 80%),
    caption: [Round-Robin-Verfahren mit Time-Slice 30ms],
) <fig-round-robin>

=== Priority-Based
Jeder Thread erhält Nummer, seine Priorität. Threads mit gleicher Priorität werden nach FCFS ausgewählt.
SJF ist ein Spezialfall von Priority-Based-Scheduling.

Diese Systeme sind Anfällig auf Starvation. Mit z.B. Aging kann Abhilfe geschafft werden (z.B. erhöhe Priorität um 1 in bestimmten
Abständen).

=== Multi-Level
Threads werden nach Kriterien in Level aufgeteilt (z.B. Priorität, Prozesstyp, Hintergrund- oder Vordergrund).
Für jedes Level gibt es eine Ready-Queue, jedes Level kann nach eigenem Verfahren gescheduled werden.
Queues können z.B. priorisiert werden, oder sie können auch Zeitscheiben enthalten, z.B. $80%$ Vordergrund-Threads mit Round-Robin,
$20%$ Hintergrund-Threads mit FCFS.

=== Multi-Level Scheduling mit Feedback
Beim Multi-Level Scheduling mit Feedback gibt es für jede Priorität eine Ready-Queue.
Threads aus Ready-Queues mit höherer Priorität werden immer bevorzugt. Erschöpft ein
Thread seine Zeitscheibe, wird seine Priorität um 1 verringert und der Thread landet in der
Ready-Queue mit niedriger Priorität. Die Zeitscheiben mit niedriger Priorität werden grösser.
Somit werden Threads mit kurzen Prozessor-Bursts bevorzugt.

== Prioritäten in POSIX
=== Der Nice-Wert
Jeder Prozess hat einen Nice-Wert $n_p$ (in Linux jeder Thread). Wenn $n_p$ kleiner ist (p ist weniger nett),
soll der Thread bevorzugt werden vom System. Auf Linux liegt der Nice-Wert zwischen -20 und 19.

`nice [-n increment] utility [argument...]`

Wenn kein `increment` $i$ angegeben: $n_u >= n_p$, ansonsten $n_u = n_p + i$

```c
int nice (int i)
```
Addiert $i$ zum Nice-Wert des aufrufenden Prozesses $p$.

Kann abgefragt werden mit

$
int getpriority (int which, id_t who)
$

und gesetzt werden mit
$
int setpriority (int which, id_t who, int prio)
$
