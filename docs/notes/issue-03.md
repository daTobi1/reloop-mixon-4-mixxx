# Arbeitsnotizen Issue #3 — Transport

**Stand:** 2026-07-22

## Entscheidungen

- **Kein Shift-State-Tracking nötig:** Die Hardware sendet die Shift-Zweitbelegung auf eigenen Notenadressen (+0x40) mit eigenen LED-Adressen. Jede Funktion ist deshalb ein eigenes Component; die `shift()`/`unshift()`-Mechanik des Frameworks bleibt ungenutzt. Gilt voraussichtlich auch für Pads und FX (gleiche Adressstruktur).
- Belegung (Mixxx-Konventionen, deckungsgleich mit den Component-Defaults):
  - Play (0x0C) = `components.PlayButton` (LED: `play_indicator`)
  - Shift+Play (0x4C) = Reverse (gehalten), LED: `reverse`
  - Cue (0x0D) = `components.CueButton` (`cue_default`, LED: `cue_indicator`, blinkt Mixxx-gesteuert)
  - Shift+Cue (0x4D) = `start_stop` (an den Anfang und stoppen), LED: `cue_indicator`
  - Sync (0x0E) = `components.SyncButton`: kurz = Beatsync, gehalten = Sync-Lock an, erneut = aus (LED: `sync_enabled`)
  - Shift+Sync (0x4E) = Quantize-Toggle pro Deck, LED: `quantize`
- Die Quantize-Taste im Global-Bereich (0x9A/0x02, 2-s-Hold) bleibt für Issue #10.

## Beobachtungen aus dem Test von Issue #2

- Master-VU-Meldung des Nutzers („leuchten nicht") war kein Bug: alte Sitzung/fehlendes Summensignal; nach Neustart ok. Log bestätigte fehlerfreie Connections (`[Main],vu_meter_left/right` existieren in 2.5.6).
- Deck-Umschaltung der Hardware wechselt die MIDI-Kanäle selbst (4↔6, 5↔7) — statisches Mapping deckt 4 Decks ab.

## Offene Punkte

- Gerätetest (Checkliste im Issue): Play/Cue/Sync inkl. LEDs, Cue-Blinken, Sync-Hold-Verhalten.
