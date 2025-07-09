= Signals
Signale ermöglichen es, einen Prozess von aussen zu unterbrechen. Sie sind im Gegensatz zu
Interrupts softwarebasiert. Wenn ein Signal an einen Prozess geschickt wird, verhält sich
das OS, als wenn ein Interrupt geschickt wurde:
- Der laufende Prozess wird unterbrochen
- Auswahl der _Signal_-Handler-Funktion und ausführen
- Fortsetzen des Prozesses (falls Signal-Handler den Prozess nicht beendet)

Signale können vom Hardware/OS kommen (ungültige Instruktion, Segmentation
fault, Division durch 0) oder von anderen Prozessen (Ctrl + C, Aufruf von
`kill`)

== Auf Signale reagieren
Jeder Prozess hat pro Signal (`sigkill`, `sigterm`, etc.) einen Handler. Zu Prozessbegin gibt es für jedes Signal einen von drei Default-Handlern:
- Ignore-Handler: Ignoriert das Signal
- Terminate-Handler: Beendet das Programm
- Abnormal-Terminate-Handler: Beendet das Programm und erzeugt Core Dump
Alle Signal-Handler können überschrieben werden, ausser `sigkill` und `sigstop`.

== Wichtige Signale
=== Programmfehler
Diese Werdenn vom OS erzeugt und nutzen den Abnormal-Terminate-Handler by default:
- `SIGFPE`: Fehler in arithmetischer Operation
- `SIGILL`: Ungültige Instruktion
- `SIGSEGV`: Ungültiger Speicherzugriff (Segmentation Fault)
- `SIGSYS`: Ungültiger Systemaufruf

=== Prozesse abbrechen
- `SIGTERM`: Normale, höfliche Anfrage an Prozess, sich zu beenden
- `SIGINT`: Nachdrücklichere Aufforderung (Generiert bei Ctrl-C)
- `SIGQUIT`: Wie `SIGINT`, aber abnormale Terminierung (Ctrl-\)
- `SIGABRT`: Wie `SIGQUIT`, wird bevorzugt vom Prozess an sich selbst geschickt (z.B. bei Programmierfehler)
- `SIGKILL`: Letzte Zuflucht, kann vom Prozess nicht blockiert, ignoriert oder abgefangen werden

=== Stop and Continue
- `SIGSTP`: Versetzt Prozess in _stopped_, ähnlich wie _waiting_ (Ctrl-Z)
- `SIGSTOP`: Wie `SIGSTP`, aber kann nicht ignoriert oder abgefangen werden
- `SIGCONT`: Setzt Prozess fort, wird auf der Shell mit `fg`, bzw. `bg` erzeugt

== Signale von Shell senden
- `kill 1234 2345`: `SIGTERM`
- `kill -KILL 1234`: `SIGKILL`
- `kill -l`: Listet alle möglichen Signale auf

== Signal-Handler überschreiben

