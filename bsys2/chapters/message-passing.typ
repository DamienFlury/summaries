= Message Passing
== Direkte Kommunikation
Bei der direkten Kommunikation werden Nachrichten von Prozess $P_1$ an Prozess $P_2$
adressiert. Dabei muss $P_1$ den Empfänger kennen: `send (P2, message)`.
Bei symmetrischer direkter Kommunikation muss $P_2$ den Sender kennen: `receive
(P1, message)`, bei asymmetrischer Kommunikation nicht, er erhält die ID in einem
out-Parameter: `idreceive (id, message)`.

== Indirekte Kommunikation
Es existieren spezifische OS-Objekte: Mailboxen, Ports oder Queues.
