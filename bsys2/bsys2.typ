#align(center, text(size: 22pt, weight: "bold")[Betriebssysteme 2])

#set par(justify: true)
#set text(lang: "de", region: "ch")
#set page(numbering: "1")
#set heading(numbering: "1.1.1")

= Speichern von Strings
```c
char const c[4] = { 'H', 'a', 'i', '\0' };
char const * s = "Hai";
```
Nicht ganz identisch. `sizeof` reagiert unterschiedlich (beim Pointer Grösse von char, beim Array 4 \* `sizeof(char)`).
Konstante Strings werden ausserdem speziell gespeichert.

#include "chapters/operating-systems.typ"
#include "chapters/dateisystem-api.typ"
#include "chapters/prozesse.typ"
#include "chapters/dynamic-libraries.typ"
