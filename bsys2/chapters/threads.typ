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


