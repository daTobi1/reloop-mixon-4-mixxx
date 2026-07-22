# Arbeitsnotizen Issue #1 — Grundgerüst

**Stand:** 2026-07-20

## Entscheidungen

- XML lädt `midi-components-0.0.js` (wird mit Mixxx ausgeliefert) schon jetzt mit, damit ab Phase 2 das Components-Framework ohne XML-Änderung nutzbar ist.
- `init()` sendet zuerst LED-Reset, dann `F0 0A 01 F7` (Deck 3&4 freigeben), dann den Identify Request. Die Antworten des Controllers (Reglerpositionen als normale MIDI-Nachrichten) werden in Phase 1 noch ignoriert — Bindings folgen ab Phase 2; für Soft-Takeover in Phase 5 relevant.
- `allLedsOff()` arbeitet mit gezielten Adresslisten statt Brute-Force über alle Noten/Kanäle; nur die Pad-Kanäle werden komplett (0x00–0x7F) durchlaufen, weil dort jede Note eine Pad-LED ist.
- Mode-Button-LEDs (Hot Cue, Sampler, …), Filter-FX-LED, Shift-LED und Deck-LED sind laut MIDI-Map hardwareseitig („HW") — nicht ansteuerbar, daher nicht in den Reset-Listen.
- Dateinamen nach Mixxx-Konvention mit Bindestrichen (`Reloop-Mixon-4.midi.xml` / `.scripts.js`), Funktionspräfix `Mixon4`.

## Offene Punkte / für spätere Phasen

- Gerätetest steht aus (Checkliste im Issue): Lädt Mixxx 2.5.6 das Mapping fehlerfrei? Gehen die LEDs beim Beenden aus? → Nutzer testet am Gerät.
- Unklar, ob der Jog-Ring zusätzlich zur CC-06-Adresse die Shift-Adresse 46 zum Löschen braucht — am Gerät prüfen (Phase 4).
- Vendor-/Product-ID des USB-Geräts noch nicht erfasst; könnte später in den `<devices>`-Block der XML (für Auto-Erkennung upstream). Am Gerät auslesen (Geräte-Manager).
- Velocity-/Aftertouch-Nachrichten der Pads (Bn/An auf Pad-Kanälen) bewusst unbelegt.

## Nützliche Fakten

- RGB-Farbwert der Pads: `16·R + 4·G + B` (R/G/B 0–3), +64 = gedimmte Palette. Beispiele: 0x30 Rot, 0x0C Grün, 0x03 Blau, 0x3F Weiß.
- Relativ-Encoder senden 0x3F (rückwärts) / 0x41 (vorwärts).
