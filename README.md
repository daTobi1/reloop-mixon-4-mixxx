# Reloop Mixon 4 → Mixxx

Vollständiges Controller-Mapping für den [Reloop Mixon 4](https://www.reloop.com/reloop-mixon-4) in [Mixxx](https://mixxx.org) 2.5+ — inklusive komplettem LED-Feedback (RGB-Pads, Jog-LED-Ring, Loop-LEDs, VU-Meter). Basiert auf der offiziellen Reloop-MIDI-Map und dem Mixxx-Components-Framework. Ziel ist die Aufnahme in das offizielle Mixxx-Projekt (GPL v2+).

## Installation

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install.ps1
```

Danach Mixxx starten und unter *Optionen → Einstellungen → Controller* für das Mixon-4-MIDI-Gerät das Mapping **„Reloop Mixon 4"** auswählen. Alternativ die beiden Dateien aus `controllers/` von Hand nach `%LOCALAPPDATA%\Mixxx\controllers` kopieren.

Architektur: [`docs/architecture.md`](docs/architecture.md) · MIDI-Referenz: [`docs/hardware/midi-map.md`](docs/hardware/midi-map.md)

## Belegung

**Transport & Deck**

| Bedienelement | Funktion | Shift |
|---|---|---|
| Play | Play/Pause (LED) | Reverse solange gehalten |
| Cue | Mixxx-Cue (LED blinkt nach Mixxx-Logik) | An Trackanfang und stoppen |
| Sync | kurz = Beatsync, halten = Sync-Lock (LED) | Quantize-Toggle (Deck) |
| Jog-Teller Oberfläche | Scratchen (33⅓ RPM, Auslauf-Ramp) | — |
| Jog-Teller Rand | Nudge (Temposchubs) | — |
| Jog-LED-Ring | Track-Fortschritt (16 Segmente) | — |
| Pitchfader | Tempo, 14 Bit, Soft-Takeover (Pitch-LED bei ≠ 0) | Fader-Start (hoch = Play, runter = Stopp) |
| Keylock | Tonhöhen-Sperre (LED); 2 s halten = Pitch-Reset | — |
| Key Sync | Tonart ans andere Deck angleichen; Doppeldruck = Original-Tonart | — |
| Slip | Slip-Modus (LED) | — |
| Load | markierten Track laden (LED = Track geladen) | — |
| Deck-Taste | Deck 1↔3 bzw. 2↔4 (macht die Hardware selbst) | — |

**Loops**

| Bedienelement | Funktion | Shift |
|---|---|---|
| Auto Loop | Beatloop setzen/lösen (LED = Loop aktiv) | Reloop (letzten Loop reaktivieren) |
| Loop-Encoder | Loop-Größe halbieren/verdoppeln | — |
| Loop-LEDs | Größenanzeige: blinkend = 1/32–1/2, leuchtend = 1–16 Beats | — |
| Param − / + | Beatjump zurück/vor | aktiven Loop verschieben |

**Mixer & Master**

| Bedienelement | Funktion |
|---|---|
| Gain / High / Mid / Low | Kanal-Trim und 3-Band-EQ |
| Filter-Regler | QuickEffect-Superknob (Filter) |
| Filter-FX-Taste | Kanal der FX-Einheit zuweisen (Deck 1/3 → FX1, 2/4 → FX2) |
| Kanalfader / Crossfader | Lautstärke / Crossfade inkl. Kurven-Regler und A/Thru/B-Schalter |
| CUE (PFL) | Kopfhörer-Vorhören (LED), dazu Cue-Mix/Cue-Vol-Regler |
| Kanal-VU (5 LEDs) / Master-VU (2×8 LEDs) | Pegelanzeige aus Mixxx |
| Sampler-Regler | Lautstärke aller Sampler |
| Quantize (2 s halten) | Quantize aller 4 Decks umschalten |

**Browser**

| Bedienelement | Funktion | Shift |
|---|---|---|
| TRAX drehen | Bibliothek scrollen | 10 Zeilen pro Raste |
| TRAX drücken | Eintrag öffnen/aktivieren | — |
| BACK | Fokus zurück (Seitenleiste) | — |

**Performance-Pads (8 Modi, RGB)**

| Modus | Funktion | Shift auf Pad |
|---|---|---|
| Hot Cue | Hot Cues 1–8 setzen/anspringen, Pad-Farbe = Cue-Farbe | Cue löschen |
| Loop Roll | Rolls 1/32–4 Beats (blau, hell im Roll) | — |
| Sampler | Sampler 1–8 abspielen/laden (weiß = geladen, grün = spielt) | Stopp bzw. Auswerfen |
| Slicer | **Beatjump** −8/−4/−2/−1/+1/+2/+4/+8 (Mixxx hat keinen Slicer; Emulation geplant) | — |
| Cue Loop | Loop ab Hot Cue 1–8 (nutzt Saved Loop, sonst aktuelle Loop-Größe) | Cue löschen |
| Saved Loops | Hot Cues 9–16: aktiver Loop + leeres Pad = Loop speichern; erneut = reaktivieren | Cue löschen |
| Pitch Play | Halbton-Offsets −4…+3 (blau/weiß/rot, aktiv = hell; echtes Pitch Play geplant) | Original-Tonart |
| Slicer Loop | **Feste Beatloops** 1/8–16 als Umschalter (cyan, aktiv = hell) | — |

**FX-Sektion (je Seite eine Einheit)**

| Bedienelement | Funktion |
|---|---|
| Regler 1–3 | Meta-Regler der 3 Effekt-Slots; bei Fokus: Parameter 1–3 des fokussierten Effekts |
| ON 1–3 | Slot an/aus (LED); lang halten = nur solange aktiv |
| TAP (halten) + ON | Effekt-Slot fokussieren |
| Parameter-Encoder | Dry/Wet der Einheit; drücken = 50 % |

## Optionen (in `Reloop-Mixon-4.scripts.js`)

- `Mixon4.OPTIONS.twoDeckMode` — `true` sperrt Deck 3/4 an der Hardware
- `Mixon4.JOG.wheelResolution` — Scratch-Kalibrierung (Standard 720 Ticks/Umdrehung)

## Entwicklung

```powershell
npm install        # einmalig (ESLint)
npm run lint       # Code-Prüfung nach Mixxx-nahen Regeln
```

Debug-Hilfe: `scripts\debug-midi.ps1` startet Mixxx mit `--controllerDebug`; eingehende MIDI-Nachrichten landen dann im Log (`%LOCALAPPDATA%\Mixxx\mixxx.log`).

Entwicklungsnotizen je Sektion: `docs/notes/`. Upstream-Plan: [`docs/upstream-checklist.md`](docs/upstream-checklist.md).

## Status & Grenzen

Getestet auf echter Hardware (Firmware v2218) mit Mixxx 2.5.6 unter Windows 11; alle Sektionen end-to-end verifiziert.

- Mixxx hat keinen nativen Slicer → die beiden „Slicer"-Pad-Banks sind mit Beatjumps bzw. festen Beatloops belegt (Emulation in Arbeit).
- Die Pitch-Play-Bank ändert die Tonhöhe des laufenden Tracks; echtes Pitch Play (Neuanspielen ab Hot Cue) in Arbeit.
- Jog-`wheelResolution` empirisch kalibriert (von Reloop nicht dokumentiert).
- Pad-Velocity/Aftertouch bewusst unbelegt.

## Lizenz

GPL v2 (oder später), kompatibel zu Mixxx.
