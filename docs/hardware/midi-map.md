# Reloop Mixon 4 — MIDI-Map (Arbeitsreferenz)

Aufbereitet aus der offiziellen `Reloop-Mixon4_MIDI-Map.pdf` (gleicher Ordner). Alle Werte hexadezimal, MIDI-Kanäle 0-basiert. `9n` = Note-On auf Kanal n, `Bn` = Control Change, `En` = Pitch Bend, `An` = Aftertouch.

## Kanal-Layout

| Bereich | Deck 1 | Deck 2 | Deck 3 | Deck 4 |
|---|---|---|---|---|
| Deck-Steuerung (Transport, Jog, Loop, EQ, Fader, Pitch) | 4 | 5 | 6 | 7 |
| Performance-Pads | 0 | 1 | 2 | 3 |
| FX-Einheit (1 → Deck 1/3, 2 → Deck 2/4) | 8 | 9 | 8 | 9 |
| Global (Crossfader, Master, Navigation, Shift, Quantize) | 0A | 0A | 0A | 0A |

**Shift-Ebene:** Eingaben und LEDs der Zweitbelegung liegen auf `Basisadresse + 0x40` (z. B. PLAY 0x0C → Shift 0x4C). Ausnahmen sind unten vermerkt.

## Deck-Kanäle (4–7)

### Regler/Fader (Bn)

| CC | Funktion | Werte |
|---|---|---|
| 00 | Gain | 0–127 |
| 01 | EQ High | 0–127 |
| 02 | EQ Mid | 0–127 |
| 03 | EQ Low | 0–127 |
| 04 | Filter | 0–127 |
| 05 | Kanalfader | 0–127 |
| 06 | Jog-Encoder | relativ: 3F rückwärts / 41 vorwärts |
| 08 | Loop-Encoder | relativ: 3F / 41 |

### Tasten (9n) — LED-Spalte: per Software steuerbare LED-Adresse

| Note | Funktion | LED | Shift-Note | Shift-LED | Hinweis |
|---|---|---|---|---|---|
| 01 | Filter FX | HW | 01 | HW | LED hardwareseitig |
| 02 | Load | 02 | — | — | |
| 03 | CUE (PFL) | 03 | — | — | |
| 04/05/06 | CF-Zuweisung A/T/B | — | — | — | Schalter |
| 07 | Jog Touch | — | — | — | |
| 08 | Auto Loop | 08 | — | — | |
| 0A / 0B | Param − / + | 0A / 0B | 4A / 4B | 4A / 4B | Shift-Belegung: KeySync-Hold-Variante |
| 0C | Play/Pause | 0C | 4C | 4C | |
| 0D | Cue | 0D | 4D | 4D | |
| 0E | Sync | 0E | 4E | 4E | |
| 0F | Slip | 0F | 4F | HW | |
| 10 | Key Lock | 10 | 50 | 50 | sendet bei Loslassen · Shift = Pitch-Bereich umschalten |
| 11 | Key Sync | 11 | 51 | 51 | bei Loslassen |
| 12 | Deck-Umschaltung | HW | 52 (Shift) | HW | wechselt 1↔3 bzw. 2↔4 |
| 13 / 14 | Phono / Line | — | — | — | nur Deck 3/4 |
| 16–1D | Pad-Modus-Tasten | HW | 56–5D | HW | Hot Cue, Loop Roll, Sampler, Slicer, Cue Loop, Saved Loops, Pitch Play, Slicer Loop |
| 22 / 23 | Filter Center / Makro-FX Center | — | — | — | 0 = Mitte |
| 24 | Key Sync Doppeldruck | 24 | — | — | innerhalb 250 ms |
| 25 | Key Lock Hold | 25 | 65 | 65 | 2 s halten |
| 00 | Velocity-Modus | — | — | — | 2 s halten, VC an/aus |

### Pitch & Sonstiges

| Nachricht | Funktion | Hinweis |
|---|---|---|
| En D1/D2 | Pitchfader | 14 Bit (Pitch Bend) |
| 9n 15 (LED) | Pitch-LED | 0 = aus, 127 = an |
| 9n 5D / 5E | Fader Start Up/Down | nur mit Shift |

## Pad-Kanäle (0–3)

Pro Modus 8 Pads; Note-On = Druck, `Bn` gleiche Adresse = Velocity, `An` = Aftertouch. Shift-Ebene = Note + 0x40.

| Modus | Pad-Noten (Basis) | Shift | Belegung im Mapping |
|---|---|---|---|
| Hot Cue | 00–07 | 40–47 | Shift = Hot Cue löschen |
| Loop Roll | 08–0F | 48–4F | |
| Sampler | 10–17 | 50–57 | Shift = Stopp/Auswerfen |
| Slicer | 18–1F | 58–5F | Slicer-Emulation · Shift = Beatjump |
| Cue Loop | 20–27 | 60–67 | Shift = Hot Cue löschen |
| Saved Loops | 28–2F | 68–6F | Shift = Hot Cue löschen |
| Pitch Play | 30–37 | 70–77 | ab Basis-Hot-Cue anspielen · Shift = Basis-Cue wählen |
| Slicer Loop | 38–3F | 78–7F | Slicer mit festem Fenster + Slip · Shift = feste Loops |

**Pad-LEDs (RGB):** Note-On an die Pad-Adresse mit 7-Bit-Farbwert:

- Wert 0–63 (hell): Bits `00rrggbb` — `Wert = 16·R + 4·G + B` mit R/G/B ∈ 0–3 (0 %, 33 %, 66 %, 100 %)
- Wert 64–127 (gedimmt): gleiche Bit-Logik + 64, Stufen 0 %, 6 %, 13 %, 20 %
- Beispiele: 0x30 = Rot, 0x0C = Grün, 0x03 = Blau, 0x3F = Weiß, 0x33 = Magenta, 0x3C = Gelb, 0x00 = aus

## FX-Kanäle (8/9)

| Adresse | Funktion | LED |
|---|---|---|
| Bn 00–02 | Effekt-Regler 1–3 | — |
| Bn 03 | Parameter-Encoder (relativ 3F/41) | — |
| 9n 03 | Encoder-Push | — |
| 9n 00–02 | ON 1–3 | 00–02 |
| 9n 04 | TAP | 04 |

## Global-Kanal (0A)

| Adresse | Funktion | Hinweis |
|---|---|---|
| Bn 00 | Crossfader | |
| Bn 01 | CF-Kurve | 0 links / 64 Mitte / 127 rechts |
| Bn 02 | Sampler-Volume | |
| Bn 03 | Cue-Mix (Kopfhörer) | |
| Bn 04 | TRAX-Encoder | relativ 3F/41 |
| Bn 07 | Cue-Vol (Kopfhörer) | |
| 9n 00 | TRAX-Push | |
| 9n 01 | Back | LED 01 |
| 9n 02 | Quantize | 2 s halten |
| 9n 03 | Shift | LED hardwareseitig |

## LED-Ausgabe (Software → Controller)

### Transport-/Status-LEDs
Note-On an die LED-Adresse (siehe Tabellen oben), Wert 0 = aus, 127 = an.

### Loop-LEDs (Deck-Kanäle, Note 09)

| Wert | Anzeige |
|---|---|
| 00 | aus |
| 01–05 | LED 1–5 |
| 06 | alle an |
| 07–0B | LED 1–5 blinkend |
| 0C | alle blinkend |

**Gerätebeschriftung (am Gerät verifiziert):** Jede der 5 LEDs trägt zwei Aufdrucke — **blinkend** = 1/32, 1/16, 1/8, 1/4, 1/2 · **leuchtend** = 1, 2, 4, 8, 16 Beats.

**Zuordnung im Mapping** (Loop-Größe → LED-Wert): 1/32→0x07, 1/16→0x08, 1/8→0x09, 1/4→0x0A, 1/2→0x0B (Blink-Reihe) · 1→0x01, 2→0x02, 4→0x03, 8→0x04, 16→0x05 (Dauer-Reihe) · >16→0x06 (alle an), <1/32→0x0C (alle blinkend). Der aktive Loop wird über die Auto-Loop-Tasten-LED angezeigt, nicht über die Kette.

### Jog-LED-Ring (Deck-Kanäle, CC 06; Shift-Adresse 46)

| Wert | Verhalten |
|---|---|
| 00–10 | Modus „Track Progress": 0 = aus, 01 = Segment 1, … 10 = Segmente 1–16 |
| 11–21 | Modus „Spindel-Position": genau ein Segment (11 = aus, 12 = Segment 1, … 21 = Segment 16) |
| 7F | alle 16 Segmente an |

### VU-Meter Kanal (Deck-Kanäle, CC 1E; Shift 5E)

| Wert | LEDs |
|---|---|
| 00 | 0 |
| 01–19 | 1 |
| 1A–33 | 2 |
| 34–4D | 3 |
| 4E–67 | 4 |
| 68–7F | 5 |

### VU-Meter Master (Kanal 0A; links CC 05, rechts CC 06; Shift 45/46)

| Wert | LEDs |
|---|---|
| 00 | 0 |
| 01–10 | 1 |
| 11–21 | 2 |
| 22–32 | 3 |
| 33–43 | 4 |
| 44–54 | 5 |
| 55–65 | 6 |
| 66–76 | 7 |
| 77–7F | 8 |

## SysEx

| Bytes | Funktion |
|---|---|
| F0 0A 00 F7 | Deck 3&4 sperren (2-Deck-Modus) |
| F0 0A 01 F7 | Deck 3&4 freigeben |
| F0 00 20 7F 03 01 F7 | Identify Request — Controller sendet die aktuelle Position aller Regler als normale MIDI-Nachrichten (Basis für Soft-Takeover) |
