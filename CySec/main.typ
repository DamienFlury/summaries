#set page(flipped: true, columns: 3)

= Access Control
== Standart Access Control Systeme
=== Preventive
Unauthorisierte Aktivität wird bereits im Vornherein verhindert.

- Zaun, Schloss, Biometrie, Encrpytion, Firewalls, security-awareness training, ...

=== Detective
Ungewollte/unauthorisierte Aktivität wird entdeckt. Detective Access Control funktioniert nach der Tat und kann Aktivität nur entdecken, wenn/nachdem sie passiert ist.

- Wächter, Überwachungskameras, Intrusion Detection Systeme (IDSs), Bewegungsmelder ...

=== Corrective
Wird nach der Tat angewendet, um das System zurück in den normalen Zustand zu versetzen. Beispiel: Backup

- System-Reboot, Antivirus-Software (die den Virus entfernt), Backup, ...

== Weitere Access Control Systeme
#figure(
  image("./access-control-types.png"),
  caption: [Access Control Types],
)
=== Deterrent Access Control
Ähnlich wie Preventive Access Control. Hier wird der Angreifer vor der Tat 
abgeschreckt.
- Policies, Security Awareness Training, Schloss, Zaun, Security Badges, Sicherheitsbeamte, Sicherheitskameras ...


=== Compensating Access Control
Wenn andere Access Control Systeme nicht ausreichen, wird dieses System eingesetzt. Es unterstützt und verstärkt die anderen Systeme.
- Policy, die besagt, dass alle PII (Personal Identifiable Information) verschlüsselt werden muss. Zum Beispiel wird PII in einer Datenbank gespeichert, die verschlüsselt ist, jedoch werden die Daten in Klartext über das Netzwerk übertragen. Hier kann ein Compensation Control System verwendet werden.

=== Recovery Access Control
Eine Erweiterung von Corrective Access Control, mit fortgeschritteneren oder komplexeren Möglichkeiten.
- Backups, System Imaging, Server Clustering, Antivirus Software, Database/VM-Shadowing, hot/cold sites, ...

=== Directive Access Control
Hier wird dem Subjekt gesagt, was er tun soll, und was nicht. Beispiel: "Bitte geben Sie Ihr Passwort ein."
- Policies, Excape Route Exit Signs, Systemüberwachung, ...


== Zugriff auf Assets konrtollieren

#figure(
  image("./access-control-layers.png"),
  caption: [Access Control Layers]
)

=== Physical Controls
Physikalische Barrieren innerhalb einer Einrichtung:
- Schloss, Zaun, Türen, Fenster, ...
=== Technical/logical Controls
Hardware/Software-Mechanismen, die den Zugriff auf Systeme und Daten kontrollieren:
- Passwörter, Biometrie, Firewalls, Intrusion Detection Systems, Routers, ...
=== Administrative Controls
Policiesm, Verfahren und Richtlinien einer Organisation, die den Zugriff auf Systeme und Daten kontrollieren:
- Security Awareness Training, Security Policies, Security Procedures, Security Guidelines, Personalkontrollen, ...

= Schritte der Zugriffskontrolle
#figure(
  image("./access-control-steps.png"),
  caption: [Access Control Steps]
)


== Identifikation
Unter Identifikaton versteht man den Prozess, bei dem das Subjekt seine Identität "behauptet" (claimt). Dabei müssen alle Subkekte eindeutige Identitäten haben. Die Identiät eines Subjekts ist normalerweise Public Information.

- Username, Smart Card, Token Device, Phrase, Gesichtserkennung, Fingerabdruck, ...

== Authentication
Bei der Authentication wird eine weitere Information benötigt, die zur Identität des Subjekts gehört. Dies ist meist ein Passwort. Identifikation und Authentisierung werden oft zusammen als einen einzigen Two-Step Prozess betrachtet.

Authentisierungsinformationen sind privat.

#figure(
  image("./authentication_authorisation.png"),
  caption: [Authentisierung und Authorisation],
  placement: auto
)

=== Passwort
Passwörter sind normalerweise statisch und die schwächste form der Authentisierung. Einfache Passwörter sind leicht zu erraten, komplexere Passwörter sind schwer zu merken und werden aufgeschrieben. Passwörter werden normalerweise hashed gespeichert.

Starke Passwörer:
- Keine Identifikationsinformationen (Name, Geburtsdatum, ...)
- Keine Wörter aus dem Wörterbuch
- Keine Namen von Personen, etc. aus Social Network-Verbindungen
- Verwendung von nicht-standart Gross- und Kleinbuchstaben (z.B. "stRongsecuRity")
- Verwendung von Zahlen und Sonderzeichen (z.B. "stR0ng\$ecuR1tee")

=== Passphrases
Statt normalen Passwörtern bieten Passphrases eine bessere Alternative. Sie sind einfacher zu merken und Benutzer tendieren dazu, längere Passphrases zu verwenden. (Bsp: "1P\@ssedTheCySecEx\@m")

=== Cognitive Passwords
Cognitive Passwords sind Passwörter, die auf dem Wissen des Benutzers basieren. Zum Beispiel:
- "Wie heisst Ihr erstes Haustier?"
- "Was ist Ihr Lieblingsfilm?"

Am besten erlauben Cognitive Passwords dem User selbst eine Frage zu stellen, die nur er beantworten kann.

=== Smart Cards
- Smart Cards sind so gross wie eine Kreditkarte und enthalten einen Circuit Chip.
- Smart Cards beinhalten Informationen über den Benutzer, die für die Identifikation und/oder Authentisierung verwendet werden.
- Die meisten Smart Cards haben einen Mikroprozessor und ein oder mehrere Zertifikate. Die Zertifikate werden für assymetric Cryptography verwendet. So können z.B. Daten verschlüsselt werden, oder E-Mails digital signiert werden.
- Smart Cards sind tamper-resistant, d.h. sie sind schwer zu manipulieren.

=== Token
Ein Token Device/Hardware Token ist ein kleines Gerät, das Passwörter generiert. Ein Authentication Server speichert die Details des Tokens, somit weiss der Server immer, welche Zahl gerade auf dem Token angezeigt wird.

- Synchronous Dynamic Password Tokens:
  - Hardware Tokens, die asynchrone dynamische Passwords generieren. Sie sind Time-based und synchronisiert mit einem Authentication Server.
- Asynchronous Dynamic Password Tokens:
  - Ohne Zeit-Synchronisation. Das Hardware Token generiert Passwörter, die auf einem Algorithmus und einem aufzählendem Counter (Incrementing Counter) basieren.
  - Wenn ein Incrementing Counter verwendet wird, wird ein dynamisches Onetime Password generiert, welches dasselbe bleibt bis zur Authentisierung.

=== One Time Passwords
- Dynamische Passwörter, die nach einmaliger Verwendung neu generiert werden.
- OTP-Generators sind Token Devices.
- Der PIN kann via eine Applikation auf z.B. dem Smartphone generiert werden.
- TOTP (Time-based One Time Password):
  - Verwendet einen Timestamp, bleibt valid für eine bestimmte Zeit (z.B. 30 Sekunden).
  - Ähnlich wie die synchronous dynamic Passwords, verwendet durch Tokens.
- HOTP (HMAC-based One Time Password):
  - Beinhaltet eine Hash-Funktion, um one time Passwords zu generieren. Es werden HOTP-Werte mit sechs bis acht Ziffern generiert.
  - Ähnlich wie die asynchronous dynamic Passwords, verwendet durch Tokens. HOTP-Werte bleiben valid bis zur Verwendung.

=== Hijacked People
- Customer, der in die Bank-Website eingeloggt ist
- Der Hacker hat ihre Session übernommen und hat die Credentials gesnifft
- Der Hacker hat nun Access zu den Bank-Konten

=== Authentication Factors
- Type 1: Something you know
  - Passwort, PIN, Passphrase, Cognitive Passwords
- Type 2: Something you have
  - Smart Card, Token, Memory Card, USB-Drive
- Type 3: Something you are / you do 
  - Biometrie, Fingerabdruck, Gesichtserkennung, Stimmerkennung, Iris-Pattern, Retina-Pattern, Palm Topology, Heart/Pulse-Patterns, Keystroke-Patterns, ...
- Somewhere you are
  - GPS, IP-Adresse, MAC-Adresse, ...
- Somewhere you aren't
  - Geofencing, ...
  - Zugriff kann verweigert werden, wenn der Benutzer sich nicht am gewöhnlichen Ort befindet.

=== Multifactor Authentication
- Zwei oder mehrere Faktoren
- Wenn zweimal derselbe Faktor verwendet wird, ist dies nicht sicherer, als nur ein Faktor (Siehe @auth-factors).
- Beispiel: Bancomat

#figure(
  image("./auth-factors-comparison.png"),
  caption: [Authentication Factors Comparison],
)<auth-factors>

== Authorisation
- Nachdem das Subjekt sich authentisiert hat, wird ihm Zugriff auf bestimmte Ressourcen gewährt (Authorisierung).
- Identifikation und Authentisierung sind all-or-nothing, während Authorisierung granular ist.

=== Access Control Models
- Discretional Access Control (DAC)
  - Der Eigentümer der Ressource entscheidet, wer Zugriff hat.
  - Der Eigentümer kann die Rechte an andere Benutzer delegieren.
  - Beispiel: Windows File System
- Role Based Access Control (RBAC)
  - Zugriff wird nicht direkt dem Benutzer zugeordnet
  - User Accounts sind in Rollen plaziert und Administratoren weisen Rollen Zugriffsrechte zu.
  - Rollen sind normalerweise nach Job-Funktionen definiert.
  - Beispiel: Active Directory
- Rule Based Access Control (RuBAC)stylebeinhalten können
  - Flexibler als RuBAC, da verschiedenen Subjekten unterschiedliche Rechte zugewiesen werden können.
  - Beispiel: XACML (eXtensible Access Control Markup Language)
- Mandatory Access Control (MAC)
  - Zugriff wird durch die Sicherheitsrichtlinien des Systems bestimmt.
  - Labels für Subjekte und Objekte.
  - Beispiel: Military Systems. Ein Benutzer hat das Label "Top Secret", somit darf er auf Dokumente mit demselben Label zugriffen.

=== Authorisation Mechanisms
- Implicit Deny
  - Basic Principle of Access Control
  - Meistverwendeter Mechanismus
  - Zugriff wird verweigert, wenn keine explizite Erlaubnis erteilt wurde.
- Constrained Interface
  - UI wird so gestaltet, dass nur erlaubte Aktionen sichtbar sind.
  - Benutzer mit voller Berechtigung sehen alle Optionen.
- Access Control Matrix (ACM)
  - Tabelle, welche Subjekte, Objekte und Zugriffsrechte beinhaltet.
  - Wenn ein Subjekt eine Aktion auf ein Objekt ausführen will, wird die Matrix überprüft.
  - ACLs (Access Control Lists) sind Object Focused, sie identifizieren die Zugriffsrechte zu Subjekten für irgendein spezifisches Objekt.
- Capability Tables
  - Subjekt-Focused, sie identifizieren Objekte, auf welche die Subjekte zugreifen können.
- Content-Dependent Access Control
  - Zugriff wird basierend auf dem Inhalt des Objekts verweigert.
  - Beispiel: Database-View. Eine View ruft spezifische Columns fvon einer oder mehreren Tabellen (Virtual Table) ab.
  - Beispiel: Eine Benutzertabelle enthält Name, E-Mail, Kreditkartennummer. Ein Benutzer hat nur Zugriff auf Name und E-Mail.
- Need to know
  - Zugriff wird nur gewährt, wenn der Benutzer für seine Work-Tasks und Job-Functions das Wissen benötigt.
  - Beispiel: Ein Benutzer in der Buchhaltung benötigt keine Zugriff auf die Kundendatenbank
- Least Privilege
  - Benutzer erhalten nur die Rechte, die sie für ihre Arbeit benötigen.
  - Wichtig, dass alle Benutzer Well-Defined Job-Beschreibungen haben, welche das Personal versteht.
  - Für Data: Create, Read, Update, Delete (CRUD)
  - Beispiel: Ein Benutzer in der Buchhaltung benötigt nur Lesezugriff auf die Kundendatenbank.
- Separation of Duties and Responsibilities
  - Verhindert, dass ein Benutzer alleine eine kritische Aufgabe ausführen kann.
  - Beispiel: Ein Benutzer kann eine Transaktion erstellen, jedoch nicht genehmigen.

== Auditing und Accountability
=== Auditing
- Überwachung von Aktivitäten eines Subjekts
  - Somit kann ein Subjekt bei einem Missbrauch zur Rechenschaft gezogen werden.

=== Accountability
- Wichtig, dass die Identität eines Subjekts bewiesen werden kann.
- Verantwortlichkeit
  - Ein Subjekt ist für seine Aktivitäten verantwortlich.
  - Ein Subjekt kann zur Rechenschaft gezogen werden, wenn es gegen die Richtlinien verstösst.

== Common access control attacks
- Access Aggregation Attacks (Passive Attack)
  - Mehrere nicht-sensitive Informationen werden zusammengeführt, um sensible Informationen zu erhalten.
- Password Attacks (Brute-Force Attack)
  - Online: Attacks gegen Onlinekonten
  - Offline: Stehlen einer Account-Datenbank und Cracken der Passwörter
- Dictionary Attacks (Brute-Force Attack)
  - Verwendung von Wörterbüchern, um Passwörter zu erraten
  - Scannen oft für one-upped Passwörter, wie _Password_, _password1_, _passXword_, ...
- Birthday Attacks
  - Kollisionsangriff auf Hash-Funktionen (Siehe @hash-functions)
  - Geburtstagsparadoxon: Wahrscheinlichkeit, dass zwei Personen am selben Tag Geburtstag haben
  - Kann durch Hashing-Algorithmen mit genügend Bits oder durch #link("https://de.wikipedia.org/wiki/Salt_(Kryptologie)")[Salting] verringert werden.

== Hash Function
#figure(
  image("./hash-function.png"),
  placement: auto,
  caption: [Hash Function]
)<hash-functions>

