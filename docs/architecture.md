# Architektur: Mixxx-Controller-Mapping für Reloop Mixon 4

**Stand:** 2026-07-20 · **Ziel-Mixxx-Version:** 2.5.x (entwickelt/getestet gegen 2.5.6) · **Lizenz:** GPL v2+ (Upstream-Beitrag an mixxxdj/mixxx angestrebt)

## 1. Ziel

Ein vollständiges Mixxx-Controller-Mapping für den Reloop Mixon 4 inklusive kompletter LED-Ansteuerung (RGB-Pads, Jog-LED-Ring, Loop-LEDs, VU-Meter, Transport-/Status-LEDs). Grundlage ist die offizielle MIDI-Map von Reloop (`docs/hardware/Reloop-Mixon4_MIDI-Map.pdf`).

## 2. Gewählter Ansatz

Klassisches Mixxx-Mapping nach offiziellen Konventionen: eine XML-Definitionsdatei plus ein JavaScript auf Basis des Mixxx-**Components-Frameworks**. Verworfene Alternativen:

- *Externe Middleware* (eigener Prozess, der MIDI übersetzt): Mixxx bietet dafür keine stabile externe Schnittstelle; LED-Feedback würde doppelte Zustandshaltung erfordern.
- *Entwicklung direkt im Mixxx-Fork*: schwerfälliger Entwicklungszyklus; ein späterer Upstream-PR ist auch aus diesem Repo heraus möglich.

## 3. MIDI-Kanal-Layout (aus der offiziellen Map)

| Bereich | MIDI-Kanal (0-basiert) | Anmerkung |
|---|---|---|
| Deck-Steuerung (Transport, Jog, Loop, Pitch, EQ/Filter, Fader) | 4 / 5 / 6 / 7 für Deck 1–4 | Shift-Ebene über separate Notennummern (+0x40) |
| Performance-Pads | 0 / 1 / 2 / 3 für Deck 1–4 | Note-On = Druck, Bn = Velocity, An = Aftertouch |
| FX-Einheit 1 / 2 | 8 / 9 | Deck 1+3 → FX1, Deck 2+4 → FX2 |
| Mixer global, Crossfader, Master, Navigation, Shift | 10 (0x0A) | |

Weitere Besonderheiten:

- **Pitchfader:** 14-Bit über Pitch-Bend (`En`), hohe Auflösung.
- **SysEx:** `F0 0A 00/01 F7` sperrt/erlaubt Deck 3&4; `F0 00 20 7F 03 01 F7` („Identify Request") lässt den Controller alle aktuellen Reglerpositionen senden.
- **Deck-Umschaltung:** Deck-Taste wechselt 1↔3 bzw. 2↔4; LED hardwareseitig.

## 4. LED-Ausgabe (Feedback)

| LED-Gruppe | Mechanik | Quelle in Mixxx |
|---|---|---|
| RGB-Pads (16 pro Seite) | Note-On mit 7-Bit-Farbwert: 0–63 = Vollfarbe (2 Bit je R/G/B), 64–127 = gedimmte Variante | Hot-Cue-Farben (`hotcue_X_color`) via `ColorMapper`, Modus-Zustände |
| Jog-LED-Ring (17 Segmente) | CC 0x06, Werte 0x00–0x10 (Track-Fortschritt), 0x11–0x21 (Spindel), 0x7F (alle an) | `playposition`, gedrosselt auf ~15 Updates/s |
| Loop-LEDs | Note 0x09, Werte 0x00–0x0C (aus, 1–5, alle, Blinken) | `beatloop_size` / Loop-Status |
| VU-Meter Kanal (6 LEDs) | CC 0x1E (Shift 0x5E), Wertebereiche pro LED-Stufe | `[ChannelN],vu_meter`-CO |
| VU-Meter Master L/R (9 LEDs) | CC 0x05/0x06 auf Kanal 10 | Main-Meter-COs |
| Transport-/Status-LEDs (Play, Cue, Sync, Keylock, Slip, Pitch-LED …) | Note-On auf LED-Adresse; Shift-Ebene hat eigene Adressen (+0x40) | `play_indicator`, `cue_indicator`, `sync_enabled`, `keylock` … via `engine.makeConnection` |

**Lebenszyklus:** Beim `init` sendet das Mapping den Identify-Request-SysEx → Controller meldet alle Positionen → Soft-Takeover ohne Parametersprünge. Beim `shutdown` werden alle LEDs ausgeschaltet.

## 5. Software-Schichten

```
┌────────────────────────────────────────────────────┐
│ 4. Zustands-/Modus-Manager                         │
│    Shift-Ebene · Deck-Umschaltung · Pad-Modus-FSM  │
├────────────────────────────────────────────────────┤
│ 2. Components-Schicht (Eingabe)   │ 3. LED-Engine  │
│    4× Deck, Mixer, Browser, 2× FX │    (Ausgabe)   │
├────────────────────────────────────────────────────┤
│ 1. MIDI-Spezifikationsschicht (Konstanten)         │
│    Kanäle, Noten/CC-Adressen, Farbtabelle          │
└────────────────────────────────────────────────────┘
```

1. **MIDI-Spezifikationsschicht:** Alle Adressen aus der Reloop-Map als benannte Konstanten (`MIXON4.CHANNELS`, `MIXON4.LEDS`, …). Keine magischen Zahlen im übrigen Code. Menschen­lesbare Aufbereitung der PDF in `docs/hardware/midi-map.md`.
2. **Components-Schicht:** Vier `Deck`-Objekte (Transport, JogWheel, Loop-Sektion, Pitch, EQ/Filter, Kanalfader), Mixer/Master, Browser (TRAX-Encoder, Load, Back), zwei FX-Einheiten. Shift über die `shift()`/`unshift()`-Mechanik des Components-Frameworks.
3. **LED-Engine:** Zentrale `sendLed(channel, note, value)`-Hilfen, RGB-Farbmapping über Mixxx' `ColorMapper` auf die 64-Farben-Palette des Controllers (Dim-Variante = Wert + 64), Timer-gedrosselte Meter-/Jog-Updates, vollständige Reinitialisierung aller Pad-LEDs bei Moduswechsel.
4. **Zustands-/Modus-Manager:** Pad-Modus-Zustandsmaschine für die 8 Modi (Hot Cue, Loop Roll, Sampler, Slicer, Cue Loop, Saved Loops, Pitch Play, Slicer Loop), Deck-Umschaltung 1↔3 / 2↔4, kontextabhängige Parameter-Tasten.

## 6. Dateistruktur

```
controllers/
  Reloop-Mixon-4.midi.xml       ← Geräte-Definition + Eingabe-Bindings
  Reloop-Mixon-4.scripts.js     ← Components, LED-Engine, Modus-Manager
docs/
  architecture.md               ← dieses Dokument
  hardware/Reloop-Mixon4_MIDI-Map.pdf
  hardware/midi-map.md          ← maschinenlesbare Aufbereitung der PDF
  notes/issue-XX.md             ← Arbeitsnotizen je Issue
scripts/
  install.ps1                   ← kopiert das Mapping nach %LOCALAPPDATA%\Mixxx\controllers
```

## 7. Fehlerbehandlung & Tests

- Defensive Guards in allen MIDI-Handlern (unbekannte Adressen werden geloggt, nicht geworfen).
- LED-Updates idempotent: Engine cached den letzten gesendeten Wert je LED und sendet nur Änderungen (schont den MIDI-Bus).
- Test je Phase manuell am Gerät (Checkliste im jeweiligen Issue); statische Prüfung mit ESLint nach Mixxx-Regeln.
- `shutdown()` muss auch bei Teilinitialisierung sicher durchlaufen (LEDs aus).

## 8. Phasenplan

Jede Phase ist ein eigenes GitHub-Issue mit Beschreibung, Teilschritten, betroffenen Dateien und Notizort (`docs/notes/issue-XX.md`):

1. Grundgerüst: XML-Skelett, Script-Registrierung, SysEx-Handshake, LED-aus beim Beenden, `midi-map.md`
2. Mixer & Master inkl. VU-Meter-LEDs
3. Transport (Play/Cue/Sync) inkl. Shift-Ebene und LEDs
4. Jog Wheels: Scratch, Nudge, Jog-LED-Ring
5. Pitch (14 Bit), Keylock, Key Sync, Slip inkl. LEDs
6. Loop-Sektion inkl. Loop-LEDs mit Blink-Zuständen
7. Pads Teil 1 + RGB-LED-Engine: Hot Cue, Loop Roll, Sampler
8. Pads Teil 2: Slicer, Cue Loop, Saved Loops, Pitch Play, Slicer Loop
9. FX-Sektion (beide Einheiten)
10. Feinschliff & Upstream-Vorbereitung: Browse/Load, Deck-Umschaltung, Soft-Takeover, ESLint, Doku, PR-Checkliste

## 9. Upstream-Kriterien

- Dateinamen und Struktur nach Mixxx-Konvention (`Reloop-Mixon-4.midi.xml` / `.scripts.js`)
- Components-Framework statt Ad-hoc-Handler, ESLint-konform (Mixxx-Regelsatz)
- GPL v2+ kompatibel, keine Fremdcode-Kopien ohne Lizenzangabe
- Ziel: Pull Request an `mixxxdj/mixxx` nach Abschluss von Phase 10
