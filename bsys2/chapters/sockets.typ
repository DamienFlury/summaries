= Sockets
Berkeley Sockets sind eine Abstraktion über Kommunikationsmechanismen z.B. UDP und TCP über IP, Unix-Domain-Sockets.
Ein Socket repräsentiert jeweils einen Endpunkt auf einer Maschine.
Socketws benötigen einen Namen, z.B. IP-Adresse und Port-Nummer.

```c
int socket (int domain, int type, int protocol);
```
Erzeugt Socket als Datei. Sockets sind nach Erzeugung zunächst unbenannt. Alle Operationen auf Sockets blockieren
per default (kann umkonfiguriert werden). Gibt File-Deskriptor zurück.

Argumente:
- `domain`: Die Adress-Domäne:
  - `AF_UNIX`: Innerhalb der Machine, Adresse = Pfade im Dateisystem
  - `AF_INET`: Internet-Kommunikation (ipv4), Adresse = IP-Adrese mit Port
  - `AF_INET6`: ipv6 oder ipv4
- `type`: Art der Kommunikation:
  - `SOCK_DGRAM`: Datagram-Socket

== Schliessen eines Sockets
```c int close (int socket)```
 schliesst Socket für den _aufrufenden_ Prozess, hat ein anderer Prozess den Socket noch geöffnet,
 bleibt die Verbindung bestehen.

== Shutdown eines Sockets
```c int shutdown(int socket, int mode)```
schliesst den Socket für _alle_ Prozesse und baut Verbindung ab.

== Normale Abfolge
+ `socket`
+ `setsockopt`
+ `struct sockaddr_in`
+ `bind`
+ `listen`
+ `while(accept >= 0)`
