#import "@preview/touying:0.7.3": *
#import themes.university: *
#import "@preview/cetz:0.5.0"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *
#import cosmos.clouds: *
#show: show-theorion


#show: university-theme.with(
  aspect-ratio: "16-9",
  // align: horizon,
  // config-common(handout: true),
  config-common(frozen-counters: (theorem-counter,)), // freeze theorem counter for animation
  config-info(
    title: [Smart Energy],
    // subtitle: [Subtitle],
    author: [Severin Nauer, Damien Flury],
    date: datetime.today(),
    institution: [Ostschweizer Fachhochschule],
    logo: emoji.school,
  ),
)

#title-slide()

= Herkömmliche Energieverteilung
- *Zentrale Erzeugung:* Wenige, riesige Kraftwerke (Kohle, Gas, Atom).
  - Speisen erzeugte Energie in das ganze Stromnetz.
  - Einbahnstrasse
- *Blindes Netz:* Das Netz weiss nicht, wer wieviel Strom benötigt.
  - Keine Echtzeitdaten von Konsument an Energielieferant.
- *Peak-Hours:* Riesige Infrastruktur für Peak-Hours.
  - Wird nicht immer verwendet.
  - Muss ständig aufrechterhalten werden.

#align(center)[
  #text(size: 0.65em)[
    #diagram(
      spacing: (16mm, 6mm),
      node-stroke: 0.6pt + gray.darken(40%),
      node-corner-radius: 4pt,
      node-inset: 6pt,
      edge-stroke: 1pt,
      label-size: 0.75em,

      node((0, 0), [#emoji.factory *Kraftwerk*]),
      node((2, 0), [#emoji.lightning *Stromnetz* \ "blind"]),
      node((4, 0), [#emoji.house *Konsument*]),

      edge((0, 0), (2, 0), [Strom], "->", stroke: orange.darken(10%)),
      edge((2, 0), (4, 0), [Strom], "->", stroke: orange.darken(10%)),
      edge((4, 0), (0, 0), [#strike[Daten] -- keine Rückmeldung], "-->", stroke: (paint: gray, dash: "dashed"), bend: -20deg),
    )
  ]
]

= Die Lösung: Smart Energy
- *Dezentralisiert:* Auch Endkunden können Energie erzeugen und ins Netz speisen.
  - Viele Akteure, statt weniger Riesen.
  - Wind, Solar, Wasser $->$ Nachhaltiger.
- *Zwei-Wege-System:* Strom *und Daten* fliessen in beide Richtungen.
- *IoT:* Sensoren messen, wo wieviel Energie benötigt wird.
- *Software* ersetzt den Bau von teuren Kraftwerken für Peak-Hours.

= Fallbeispiel: Lokale Energiegesellschaft (LEG)
- *Seit 1. Januar 2026* möglich
- *Erzeugte Energie* kann innerhalb der Gemeinde weiterverkauft werden
- *Smart Meter* (Intelligenter Stromzähler) misst im 15-Minuten-Takt, wie viel Strom produziert & verbraucht wird.
- *Software* berechnet:
  - Wieviel Strom wurde produziert?
  - Wieviel Strom muss vom Reststrom dazugekauft werden?
- *Abrechnung* läuft über ein digitales Portal
- *Rabatt* auf *lokalen* Strom, der nicht weit transportiert werden muss (20% -- 40%).

#image("zusammenfassung-leg.png")

= Das LEG-Ökosystem auf einen Blick

#let strom-col = orange.darken(10%)
#let daten-col = blue.darken(15%)

#align(center + horizon)[
  #text(size: 0.65em)[
    #diagram(
      spacing: (14mm, 7mm),
      node-stroke: 0.6pt + gray.darken(40%),
      node-corner-radius: 4pt,
      node-inset: 6pt,
      edge-stroke: 1pt,
      label-size: 0.75em,

      node((2, -1), [#emoji.factory *Netzbetreiber*]),
      node((0, 0), [#emoji.sun *Prosumer* \ erzeugt & verbraucht]),
      node((2, 0), [#emoji.lightning *Gemeindenetz (LEG)*], fill: orange.lighten(85%)),
      node((4, 0), [#emoji.house *Konsument*]),
      node((0, 1), [Smart Meter \ misst im 15-Min-Takt]),
      node((4, 1), [Smart Meter \ misst im 15-Min-Takt]),
      node((2, 1), [#emoji.laptop *Digitale Plattform* \ ML-Prognosen & Automatisierung], fill: blue.lighten(85%)),
      node((2, 2), [Digitales Portal: Abrechnung, Rabatt 20--40%]),

      edge((2, -1), (2, 0), [Reststrom], "->", stroke: strom-col, label-side: left),
      edge((0, 0), (2, 0), [Strom], "<->", stroke: strom-col),
      edge((2, 0), (4, 0), [Strom], "->", stroke: strom-col),
      edge((0, 0), (0, 1), stroke: (paint: daten-col, thickness: 0.7pt, dash: "dotted")),
      edge((4, 0), (4, 1), stroke: (paint: daten-col, thickness: 0.7pt, dash: "dotted")),
      edge((0, 1), (2, 1), [Daten], "->", stroke: daten-col),
      edge((4, 1), (2, 1), [Daten], "->", stroke: daten-col),
      edge((2, 1), (2, 2), [Abrechnung], "->", stroke: daten-col),
    )

    #v(0.5em)
    #text(size: 0.75em)[
      #box(line(length: 1.2em, stroke: 1pt + strom-col), baseline: -0.25em) Stromfluss
      #h(1.5em)
      #box(line(length: 1.2em, stroke: 1pt + daten-col), baseline: -0.25em) Datenfluss
    ]
  ]
]

= Wirtschaftlicher Mehrwert
- *Traditionelles Geschäftsmodell:*
  - Umsatz durch reinen Verkauf von Kilowattstunden
  - Hohe Fixkosten durch teure Infrastruktur
- *Digitales Geschäftsmodell (LEG):*
  - Wertschöpfung durch *Datenorchestrierung* und Plattform-Bereitstellung
  - Netzbetreiber spart Kosten für den Netzausbau
  - *Software as a Service* generiert kontinuierlich Mehrwert

= Die Rolle der Daten
- Daten werden direkt über das öffentliche Stromnetz geteilt.
- *Datenanalyse* macht Stromverbrauch transparent.
- *Maschinelles Lernen* ermöglicht präzise Vorhersagen von Angebot & Nachfrage.
- *Automatisierung:* Algorithmen und digitale Plattformen übernehmen das Berechnen der Transaktionen innerhalb der Gemeinde.

= Herausforderungen & Risiken
- *Datenschutz:* Verbrauchsdaten im 15-Minuten-Takt erlauben Rückschlüsse auf das Privatleben.
  - Wer ist wann zu Hause? Wann wird gekocht, geduscht, gearbeitet?
- *Cybersecurity:* Vernetzte Infrastruktur bedeutet grössere Angriffsfläche.
  - Stromnetz ist kritische Infrastruktur -- Ausfälle treffen alle.
- *Regulierung:* Rechtlicher Rahmen entwickelt sich langsamer als die Technik.
  - LEG erst seit 1. Januar 2026 möglich.
- *Akzeptanz & Investitionen:* Smart-Meter-Rollout kostet.
  - Endkunden müssen dem System (und der Abrechnung) vertrauen.

= Fazit
- Smart Energy transformiert starres Netz in ein dynamisches digitalisiertes Ökosystem.
- Wirtschaftlicher Mehrwert entsteht nicht durch mehr Strom, sondern durch *intelligentere Verteilung*.

