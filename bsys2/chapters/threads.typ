= Motivations
Ein Prozess kann nur auf einem Prozessor laufen.

== Prozessmodell
Jeder Prozess hat virtuell den ganzen Rechner zur Verfügung.

== Threadmodell
Threads haben auf _alle_ Ressourcen im Prozess gleichermassen Zugriff:
- Code (text section)
- Globale Variablen (data section)
- Heap
- Geöffnete Dateien
- MMU-Daten

Jeder Thread hat aber einen eigenen Kontext und einen eigenen Stack ($->$ Thread Control Block (TCB)).

== Amdahls Regel
Speedup-Faktor:
$
f <= T/T' = T/(T_s + (T - T_S)/n)
$

Unabhängig von der Zeit: Serieller Anteil $s$:
$
f <= 1/(s + (1 - s)/n)
$

== POSIX Thread-API
```c
int pthread_create (pthread_t *thread_id, pthread_attr_t const * attributes, void * (*start_function) (void *), void *argument)
```
Erstellt einen Thread und gibt bei Erfolg $0$ zurück, sonst Fehlercode. Via `attributes` kann z.B. die Stack-Grösse festgelegt werden.
`argument` ist typischerweise ein Pointer auf eine Datenstruktur auf dem Heap.
*Vorsicht:* Legt man diese Struktur auf dem Stack an, muss man sicherstellen,
dass der Stack während der Lebensdauer des Threads nicht abgebaut wird.

=== Beispiel
  ```c
  struct T {
    int value;
  };
  void * my_start (void *arg) {
    struct T * p = arg;
    printf("%d\n", p->value);
    free(arg);
    return 0;
  } 

  void start_my_thread (void) {
    struct T  * t = malloc(sizeof(struct T));
    t->value = 1;
    pthread_t tid;
    pthread_create(&tid, 0, &my_start, t);
  }
  ```


=== Attribute
```c
pthread_attr_t attr;
pthread_attr_init(&attr);
pthread_attr_setstacksize(&attr, 1 << 16);
pthread_create(..., &attr, ...);
pthread_attr_destroy(&attr);
```
Der Grund dafür ist, dass `pthread_attr_t` je nach Implementation mehr Speicher benötigen kann.

== Lebensdauer eines Threads
Bis:
- Springt aus `start_function` zurück
- Ruft `pthread_exit` auf
- Ein anderer Thread ruft `pthread_cancel` auf
- Sein Prozess wird beendet

== Thread-Local Storage (TLS)
TLS stellt globale Variablen _per Thread_ zur Verfügung.

Schritte:
+ Anlegen eines Keys für die TLS-Variable
+ Speichern des Keys in einer globalen Variable
+ Auslesen des Keys aus der globalen Variable
+ Auslesen / Schreiben des Werts anhand des Keys

```c
pthread_key_t error;
void *thread_function (void *) {
  pthread_setspecific (error, malloc(sizeof(int)));
  int * e = pthread_getspecific(error);
  *e = 25;
}
int main() {
  pthread_key_create (&error, NULL);
  pthread_t tid;
  pthread_create (&tid, NULL, &thread_function, NULL);
  pthread_join (tid, NULL);
}
```


