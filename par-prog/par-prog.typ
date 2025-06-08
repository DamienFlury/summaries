#set page("a4", flipped: true, columns: 3)
#let info(header: [], content) = block(fill: aqua, radius: 2pt, width: 100%, [
  #pad(x: .5em, top: 0.5em, text(weight: "bold", [#header]))
  #v(-.8em)
  #line(length: 100%)
  #v(-.8em)
  #pad(x: .5em, bottom: 0.5em, [#content])
])

#info(header:[Moore's Law], [Transistor count doubles every two years.])

= Different types of parallelism
- Hyperthreading: Two Reg-Sets per core
- Multi-Core: Multiple Cores per CPU
- Multi-Processor: Multiple CPUs per machine
- Compute-Cluster

= Parallelism vs Concurrency
#table(columns: 2, table.header([*Parallelism*], [*Concurrency* (Nebenläufigkeit)]),
[Decomposition of a program into several sub programs, which run simultaneously on several processors $=>$ Faster Programs],
[Interleaved (time shared) execution that accesses shared resources $=>$ Simpler programs.
Sometimes with time slicing (but not necessarily).])
