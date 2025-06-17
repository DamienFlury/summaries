#import "@preview/colorful-boxes:1.4.3": *

#set page("a4", flipped: true, columns: 3, margin: 1em)
#let alert(fill: blue, header: [], content) = block(fill: fill, radius: 2pt, width: 100%, [
  #pad(x: .5em, top: 0.5em, text(weight: "bold", [#header]))
  #v(-.8em)
  #pad(x: .5em, bottom: 0.5em, [#content])
])
#let info(header: [], content) = colorbox(title: header, color: "blue", radius: 2pt, width: auto, [#content])

#let warn(header: [], content) = colorbox(title: header,   color: (
    fill: yellow.lighten(70%),
    stroke: yellow.darken(40%)
  ), radius: 2pt, width: auto, [#content])

#set par(justify: true)

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

= JVM
- Single process system
- Runs as long as threads are running (not until main() is done!), unless marked as daemon-thread
- `System.exit() / Runtime.exit()`: Uncontrolled stop of all threads
- Threads realized by `Thread`-class and `Runnable`-interface
  - `void run()` can be overridden for custom behaviour
- `thread.start()` starts a Thread, JVM calls `run()` (do not call run manually!)
- If exception is unhandled, other Threads still continue
- Just like any other application threads
- Scheduling of threads handled by the OS
- Allows setting priorities to threads $->$ still managed by OS
- The current thread can be accessed with `Thread.currentThread()`
#warn(header: [Non-deterministic], [
  Threads run without any rules, interleaved or parallel. Many JVMs execute
  System Outputs without interleaving (but not specified!).
])
```java
var t1 = new Thread(() -> { System.out.println("Hi from t1"); })
t1.setDaemon(true) // Stops running when main-thread is finished
t1.start();
```
Instead of passing a lambda to `new Thread()` we can naturally also create a
class, implement `Runnable` and pass it instead (functional interfaces).

Alternatively we can also just derive a custom class from `Thread` (not recommended).

== Join
With `t2.join()`, we can block t1 as long as t2 is running.

== Interrupts
When `t2.interrupt()` is called, the thread doesn't terminate directly. It only
stops when t2 calls `join`, `wait` or `sleep`.

#warn(header: [Join currentThread], [If `Thread.currentThread().join()` is called, the thread ends up in a deadlock.])

== Java Thread Lifecycle
- Blocked
- New
- Runnable
- Terminated
- Timed_Waiting: `sleep(timeout), join(timeout)`
- Waiting: `join()`

#figure(
  image("assets/thread-states.png", width: 80%),
  caption: [Thread states],
) <fig-thread-states>

/ Synchronization: Restriction of concurrency

== Challenges of communication between threads
- Thread Interference
- Memory consistency errors

/ Critical section: Section that needs to be executed by only one thread at a time (atomic)

A java method can be forced to execute mutually exclusive with `synchronized`:
```java
public synchronized void deposit(int amount) {
  this.balance += amount;
}
// or:
public void deposit(int amount) {
  synchronized(this) {
    this.balance += amount;
  }
}
```
A lock is acquired at the start of the synchronized block and freed:
- After the block
- At return
- If an unhandled exception is thrown

Nested locks are possible, but if locked on the same object is technically rendundant.

== Wait
`wait()` temporarily releases the monitor.
#figure(
  image("assets/wait-instruction.png", width: 80%),
  caption: [Wait],
) <fig-wait-instruction>

== notify vs notifyAll
```java
class BankAccount {
  private int balance = 0;
  public synchronized void withdraw(int amount)
  throws InterruptedException {
    while (amount > balance) {
      wait();
    }
    balance -= amount;
  }
  public synchronized void deposit(int amount) {
    balance += amount;
    notifyAll(); // notifyAll needed because notify only alerts one thread and others might still want to withdraw too
  }
}
```
A while is necessary because with an if, the thread doesn't check the condition again after being woken up.
If `wait`, `notify` and `notifyAll` are called outside synchronized blocks: IllegalMonitorStateException.

/ Spurious wakeup: A thread wakes up without being notified, interrupted or timing out (rare in practice)

== When is a single notify sufficient?
*Both* must hold:
1. Only one semantic condition (uniform waiters):
  - Condition interests every waiting thread
2. Change applies to only one
  - Only one single thread can continue

== Semaphore
- `acquire()` (P):
  - if count <= 0: Wait
    - Thread dormant until
      - other thread invokes `release` and the thread is the next one
      - Thread is interrupted (Throws InterruptedException)
- `release()` (V):
  - Free a permit
  - Increment counter
  - *No requirement that a thread must have acquired a permit to release it*
`new Semaphore(N, true)`: FIFO-queue for fairness, slower than (potentially) unfair variant

Java doesn't use OS semaphores $->$ expensive

`acquire(int permits)`, `release(int permits)` for multiple acquires, releases at once

== Lock with conditions
```java
private Lock monitor = new ReentrantLock(true);
private Condition nonFull = monitor.newCondition();
private Condition nonEmpty = monitor.newCondition();
// ...
nonFull.signal();
nonFull.signalAll();
nonEmpty.signal();
nonEmpty.signalAll();
```
A specific condition can be either single signaled with `cond.signal()`, or multi signaled with `cond.signalAll()`.
Wait with `cond.await()`.

== Read-Write Locks
```java
ReadWriteLock rwLock = new ReentrantReadWriteLock(true);
rwLock.readLock().lock();
rwLock.readLock().unlock();
rwLock.writeLock().lock();
rwLock.writeLock().unlock();
```

== Monitor vs. Locks + Conditions
- Monitor:
  - Simplicity, no complex wait-notify logic
  - Performance is critical
- Locks + Conditions:
  - More control over synchronisation required (e.g. fair locking)
  - More fine grained control on which Threads to wake up (instead of all)

= Race Conditions
== Data Races
- Happens when at least one threads writes while others read (single process) and
- Threads aren't using exclusive locks

== Race condition without Data Race
```java
account.setBalance(account.getBalance() + 100);
```
This can still lead to lost updates, even when account is synchronized, due to non atomic increment.

== Race Conditions and Data Races
#table(columns: 3, table.header([], [*Race Condition*], [*No Race Condition*]),
[*Data Race*], [Erroneous behaviour], [Program works correctly, but formally incorrect],
[*No Data Race*], [Erroneous behaviour], [Correct behaviour])

== Synchronize everything?
- Expensive
- Other concurrency problems still exist
- Cache invalid, Optimization hindrances, ...

Synchronization can be skipped, if:
- Immutability is used/Read-Only Objects
- Confinement (Einsperrung): Objects belong to only one thread at a time

=== Confinement
- Thread Confinement: Object belongs to only one thread
- Object Confinement: Object is encapsulated in already synchronized objects

== Threadsafe
A datatype/method is #emph[threadsafe], if it behaves correctly when used from
multiple threads, without requiring additional coordination from the caller.
Therefore a threadsafe callee cannot put any synchronization requirements on the caller.

== Threadsafe Java collections
Old Java-Collections like `Vector`, `Stack`, `Hashtable` are threadsafe. Modern
collections (`HashSet`, `TreeSet`, `ArrayList`, `LinkedList`, `HashMap`,
`TreeMap`) are *not* threadsafe. $->$ `ConcurrentHashMap`,
`ConcurrentLinkedQueue`, `CopyOnWriteArrayList`.

Concurrent collections have strong concurrency guarantees, but have weakly conisistent iterators! There's no `ConcurrentModificationException` and concurrent updates are likely not seen by others.

= Deadlocks
== Nested Locks
```java
synchronized(listA) {
  synchronized(listB) {
    listB.addAll(A);
  }
}

synchronized(listB) {
  synchronized(listA) {
    listA.addAll(B);
  }
}
```

== Livelocks
Livelocks are deadlocks which still execute wait instructions and consume CPU.
```java
b = false;
while(!a) {
}
b = true;

a = false;
while(!b) {
}
a = true;
```

== Deadlock avoidance
- Linear lock hierarchy
- Coarse granular locks:
  - Only one lock holder; e.g. entire bank is blocked while lock holder does work

= Starvation
```java
do {
  success = account.withdraw(100);
} while(!success)
```
Starvation is a fairness problem and depends on scheduling.

== Starvation avoidance
- Enforce fairness

= Correctness Criteria
- No raceconditions
- No deadlocks
- No starvation

= .NET
An exception in a thread leads to the program to stop

Threads can be made daemon threads by calling `t.IsBackground = true`.

- `Monitor.Wait(obj)`
- `Monitor.PulseAll(obj)`

= Concurrency at scale
Many Threads slow down the system:
- Longer time intervals in between threads
- Many thread starts/stops
- Number limited
- Memory:
  - Stack for each thread
  - Full register backup at swap

== Tasks
Tasks try to solve the problem of threads. They define potentially parallel
work packages, they are purely passive objects describing the functionality.
Tasks can run in parallel, but they don't have to.

\#worker-threads = \#processors + \#pending IO-calls

=== Limitations
Tasks must run to completion, before its worker thread is free to grab another task.

Task must not wait for each other (except subtasks), otherwise potential deadlock (because current task in queue depends on the work of the next task in queue)


=== Java
```java
var threadPool = new ForkJoinPool();
Future<Integer> future = threadPool.submit(() -> {
  int value = ...;
  return value;
});
Integer result = future.get(); // blocking
```

`future.cancel(boolean mayInterruptIfRunning)`: Will fail, if task completed, cancelled or cannot be cancelled for some other reason 

==== Recursive Task
```java
class CountTask extends RecursiveTask<Integer> {
  @Override
  protected Integer compute() {
    var left = new CountTask(lower, middle);
    var right = new CountTask(middle, upper);
    left.fork();
    right.fork();
    return left.join() + right.join();
  }
}

// ...
var threadPool = new ForkJoinPool();
int result = threadPool.invoke(new CountTask(2, N))
```

Default Pool: `ForkJoinPool.commonPool()`:
`int result = new CountTask(2, N).invoke();`

==== Avoid Over-Parallelizing
```java
protected Integer compute() {
  if (upper - lower > THRESHOLD) {
    // parallel count
  } else {
    // sequential count
  }
}
```

==== Work Stealing
A free worker thread can steal scheduled tasks of another worker-thread.

==== Special features
- Fire and forget might not finish (Worker threads are daemon threads)
- Automatic degree of parallelism

=== .NET
```cs
Task<int> task = Task.Run(() => {
  var left = Task.Run(() => Count(leftPart));
  var right = Task.Run(() => Count(rightPart));
  return left.Result + right.Result; // task.Result is blocking
});
```

==== Parallel statements
```cs
Parallel.Invoke(
  () => MergeSort(l, m),
  () => MergeSort(m, r),
);
```
==== Parallel Foreach
```cs
Parallel.ForEach(list, 
  file => Convert(file)
);
```
==== Parallel For
```cs
Parallel.For(0, array.Length,
  i => DoComputation(array[i])
);
```

==== Task Continuations
```cd
Task.Run(LongOperation)
  .ContinueWith(task2)
  .ContinueWith(task3)
  .Wait();
```

==== Multi-Continuation
```cd
Task.WhenAll(task1, task2)
  .ContinueWith(continutation);
```

=== Java
```java
CompletableFuture
  .supplyAsync(() -> longOp())
  .thenApplyAsync(v -> 2 * v)
  .thenAcceptAsync(v -> println(v));
```


== GUIs
Graphical user interfaces should run on their own UI thread.

=== Premises
- No long running operations in UI thread
- No access to UI-elements by other threads
  - .NET/Android: Exception
  - Java Swing: Race Condition

=== Java 
```java
button.addActionListener(event -> {
  var url = textField.getText();
  CompletableFuture.runAsync(() -> {
    var text = download(url);
    SwingUtilities.invokeLater(() -> {
      textArea.setText(text);
    })
  })
})
```

=== .NET
```cs
void buttonClick() {
  var url = textBox.Text;
  Task.Run(() => {
    var text = Download(url);
    Dispatcher.InvokeAsync(() => {
      label.Content = text;
    })
  })
}
```
Or simpler with async/await:
```cs
// ...
var url = textBox.Text;
var text = await DownloadAsync(url);
label.Content = text;
```
An async method runs synchronously until it reaches its first `await`-expression $->$ Method is suspended until the awaited task is complete.
All code right #emph[after] the `await`-expression runs asynchronously. All code up to including the first `await`-expression is called synchronously.
At the `await`-expression, the thread returns to the caller, while the rest of the function is run asynchronously.

With a UI thread as the caller thread, the model is a bit different. Here, the await call is run in a different TPL thread (normal), but after its completion,
the rest of the function is passed back to the UI thread again (so we can update the UI afterwards).

`void` should only be used in event handlers, only `Task` can be waited on. Async functions also have no support for `ref` and `out` parameters.

```cs
public async Task<bool> IsPrimeAsync(long number) {
  return await Task.Run(() => {
    for (long i = 2; i * i <= number; i++) {
      if (number % 2 == 0) { return false; }
    }
    return true;
  });
}
```

=== Async/Await thoughts 
- One Async method, two scenarios (non UI thread vs. UI thread)
- Viral effect: Caller must also be async
  - Complicates debugging
  - Runtime overhead, code segmentation
- Should be orthogonal:
  - Caller should decide, not callee
  - Many libraries offer asynchronous and synchronous version of the same functionality


= Memory model
== Causes of problems
- Weak consistency: Memory in different order by different threads (except when synchronized and at memory barriers)
- Optimizations by compiler, runtime and CPU: Instructions are reordered or eliminated

$->$ No sequential consistency.

== Java guarantees
=== Atomicity
A single read/write is atomic (primitives up to 32 bit, object references). Long and double are only atomic with the #emph[volatile] keyword!

=== Visibility
Atomicity does not imply visibility! One thread may not see updates of another thread at all (or possibly much later).
```java
// thread 1:
while(doRun) { // this possibly never stops.
}
// thread 2:
doRun = false;
```

Guaranteed visible between threads are:
- Lock release & acquire:
  - Memory writes before release are visible after acquire
- Volatile variable
  - Memory writes up to including the volatile variable are visible when reading the variable
- Thread/Task-Start and join
  - Start: input to thread, Join: thread result
- Initialization of final variables
  - Visible after completion of constructor


#figure(
  image("assets/visibility-unlock-lock.png", width: 80%),
  caption: [Visibility lock $->$ unlock]
) <fig-visibility-unlock-lock>


```java
private volatile boolean doRun = true;
// thread 1:
while(doRun) { // this possibly never stops.
}
// thread 2:
doRun = false;
```

Visibility also implies partial order.

```java
volatile boolean a = false, b = false;

// thread 1:
a = true;
while(!b) {}

// thread 2:
b = true;
while(!b) {}
```
This code works, no reordering is done because of `volatile` $->$ total order

=== Atomic operations
getAndSet(): Returns old value, writes new value.
```java
public class SpinLock {
  private final AtomicBoolean locked = new AtomicBoolean(false);
  public void acquire() {
    while(locked.getAndSet(true)) {}
  }
  public void release() {
    locked.set(false);
  }
}
```

==== Compare and set
`boolean compareAndSet(boolean expect, boolean update)`
- Sets update only if read value is as expected (atomic)
- Returns true if successful


==== Lock free stack (Treiber 1986)
```java
AtomicReference<Node<T>> tope = new AtomicReference<>();
void push(T value) {
  var newNode = new Node<T>(value);
  Node<T> current;
  do {
    current = top.get();
    newNode.setNext(current);
  } while(!top.compareAndSet(current, newNode));
}
```


== .NET
- Volatile Write: Release semantics:
  - Preceding memory accesses are not moved below
  - Subsequent memory accesses can be moved above
- Volatile Read: Acquire semantics:
  - Subsequent memory accesses are not moved above
  - Preceding memory accesses can be moved below


#figure(
  image("assets/volatile-dotnet.png", width: 80%),
  caption: [volatile semantics in .NET],
) <fig-volatile-dotnet>

=== Memory Barrier
To prevent reordering, we need to use `Thread.MemoryBarrier()`;

```cs
volatile bool a = false, b = false;

// thread 1:
a = true;
Thread.MemoryBarrier();
while(!b) {}

// thread2:
b = true;
Thread.MemoryBarrier();
while(!a) {}
```

= Cluster Programming
- Highest possible parallel acceleration
- Lots of CPU cores (instead of GPU cores)
- GPU often limiting because of SIMD
- Nodes close to each other
- Fast interconnect

== Programming models
=== SPMD
- Single program, multiple data
- high level programming model
- Single Program: All tasks execute their copy of the same program simultaneously.
- Multiple Data: All tasks may use different data
- Most commonly used for multi-node clusters

=== MPMD
- Multiple Program: Tasks may execute different programs simultaneously. Can be threads, message passing, data parallel or hybrid.

== Memory Model: Hybrid Model
- Most modern supercomputers use a hybrid architecture (shared + distributed)
- All processors can share memory
- Can also request data from other computers (programmatically)

== Message Passing Interface (MPI)
- Distributed programming model
- Industry standard (C, Fortran, .NET, Java, etc.)
- Process: Program + Data
- Multiple processes, working on the same task
- Each process only has direct access to its own data
- Usually one process per core

== Message
- Id of sender
- Id of receiver
- Data type to be sent
- Number of data items
- Data itself
- Message type identifier


#figure(
  image("assets/mpi-scatter-bcast.png", width: 80%),
  caption: [Scatter/Gather vs Broadcast],
) <fig-mpi-scatter-bcast>

// start p.19


