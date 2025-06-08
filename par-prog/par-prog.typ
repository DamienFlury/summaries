#set page("a4", flipped: true, columns: 3)
#let info(header: [], content) = block(fill: aqua.lighten(50%), radius: 2pt, width: 100%, [
  #pad(x: .5em, top: 0.5em, text(weight: "bold", [#header]))
  #v(-.8em)
  #line(length: 100%)
  #v(-.8em)
  #pad(x: .5em, bottom: 0.5em, [#content])
])

// #set table(stroke: none)

#info(header:[Moore's Law], [Transistor count doubles every two years.])

= Different types of parallelism
- Hyperthreading: Two Reg-Sets per core
- Multi-Core: Multiple Cores per CPU
- Multi-Processor: Multiple CPUs per machine
- Compute-Cluster

#table(columns: 2, table.header([*Parallelism*], [*Concurrency* (Nebenläufigkeit)]),
[Decomposition of a program into several sub programs, which run simultaneously on several processors $=>$ Faster Programs],
[Interleaved (time shared) execution that accesses shared resources $=>$ Simpler programs.
Sometimes with time slicing (but not necessarily).])

#table(columns: 2, table.header([*Process*], [*Thread*]),
[Heavyweight, OS only needs process context to run a program correctly, own address space.],
[Lightweight, a process can have multiple threads, parallel sequence in a program, same address space, separate stack and registers.])

#figure(
  image("assets/overview.png", width: 80%),
  caption: [Memory utilization/resources],
) <fig-overview>
Multiple threads can write in the same memory locations $=>$ Needs explicit synchronization.

/ Multiplexing: Interleaved execution by using context switching.

= Context switching
- Synchron: Waits for condition
  - Queues itself as waiting and gives processor free
- Asynchron: Timing
  - After a defined time, the thread should release the processor
  - Prevents a thread from permanently occupying the processor

= Multitasking (scheduling)
- Cooperative (rarely used nowadays)
  - Threads must explicitly initiate context switches at intervals
- Preemptive (nowadays standard)
  - Scheduler interrupts the running thread asynchronously via timer interrupt
  - Time sliced scheduling: Each thread has the processor for maximum time interval

= Thread states
Running, Waiting, Ready
