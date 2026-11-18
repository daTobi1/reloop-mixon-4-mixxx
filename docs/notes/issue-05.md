# Arbeitsnotizen Issue #5 — Pitch, Keys, Slip

**Stand:** 2026-07-22

## Entscheidungen

- Pitchfader: 14-Bit-Pitch-Bend (`0xE4`–`0xE7`), umgerechnet mit `script.midiPitch(control, value, status)` und **negiert** — dieselbe Konvention wie in den mitgelieferten Mappings „Reloop Beatmix 2-4" und „Reloop Terminal Mix" (Reloop-Fader senden invertiert). XML-Binding nur mit `<status>0xEn</status>`, ohne `midino` (wie im Beatmix-XML).
- Soft-Takeover für `rate` explizit aktiviert (`engine.softTakeover`), zusätzlich liefert der Identify-Request beim Start die Fader-Position.
- Keylock (0x10) = Toggle mit LED. Die Hardware meldet den Druck erst beim Loslassen („on button release") — für einen Toggle unerheblich.
- **Keylock-Hold (0x25, 2 s, Hardware-Timer): Pitch-Reset** (`rate = 0`) — pragmatische Belegung, da Reloop die gedachte Funktion nicht dokumentiert.
- Key Sync (0x11) = `sync_key` (Tonart an das andere Deck angleichen), Doppeldruck (0x24, 250 ms, Hardware-seitig erkannt) = `reset_key` (zurück zur Original-Tonart).
- Slip (0x0F) = `slip_enabled`-Toggle mit LED.
- Pitch-LED (0x15) leuchtet, wenn `rate` von 0 abweicht (Schwelle 0.001).

## Offene Punkte

- ~~Shift-Varianten Keylock (0x50) / Key Sync (0x51) unbelegt~~ → Shift + Keylock schaltet seit PR #3 den Pitch-Bereich (6/8/10/16/24/50 %). Shift + Key Sync (0x51) weiterhin frei.
- Gerätetest: Pitch-Richtung prüfen (Fader runter = schneller?). Falls invertiert: Vorzeichen in `Mixon4.deck*.pitch` drehen.
