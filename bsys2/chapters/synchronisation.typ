= Synchronisation von Threads
Einzelne Instruktionen können unter Umständen nicht atomar durchgeführt werden:
```asm
mov [2000], rax ; atomar, weil natürlich aligned (2000 % 8 == 0)
mov [2009], rax ; nicht atomar, weil nicht aligned

```

== Idee: Abschalten von Interrupts
Auf Ein-Prozessor-Systemen effektiv, für Systeme mit mehreren Prozessoren nicht praktikabel.
Ausserdem gefährlich, da das OS den Thread nicht unterbrechen kann.

== Spezielle Instruktionen
- Test-And-Set
- Compare-And-Swap
Die Hardware garantiert, dass keine zwei dieser Instruktionen gleichzeitig ausgeführt werden, auch über
mehrere Prozessoren hinweg.

Mithilfe dieser Instruktionen können Locks implementiert werden.

=== Test-And-Set
```c
int test_and_set (int *target) {
  int value = *target;
  *target = 1;
  return value;
}
```

Verwendung:
```c
while (tas (&lock) == 1) {}
/* critical section */
lock = 0;
```

=== Compare-And-Swap
```c
int compare_and_swap (int *a, int expected, int new_a) {
  int value = *a;
  if (value == expected) {
    *a = new_a;
  }
  return value;
}
```

Verwendung:
```c
while (cas (&lock, 0, 1) === 1) {}
/* critical section */
lock = 0;
```

== Semaphoren
- Post: Erhöht z um 1
- Wait: Wenn $z > 0$: Verringert $z$ um 1, ansonsten versetzt den Thread in _waiting_, bis ein anderer Thread $z$ erhöht.

== Priority Inversion
Priority Inversion entsteht, wenn ein hoch-priorisierter Thread auf eine Ressource wartet, die von einem niedriger
priorisierten Thread gehalten wird, oder wenn ein Thread mit Priorität zwischen diesen beiden Threads den Prozessor erhält.

== Priority Inheritance
Der Thread, der eine Ressource hält, bekommt die höchste Priorität aller Threads, die auf diese Ressource warten.
