# Arbeitsnotizen Issue #2 — Mixer & Master

**Stand:** 2026-07-22

## Entscheidungen

- **Wichtige Erkenntnis zur Deck-Umschaltung:** Die Hardware wechselt beim Deck-Toggle selbst den MIDI-Kanal (links 4↔6, rechts 5↔7). Ein statisches Mapping Kanal→`[ChannelN]` deckt daher alle 4 Decks ab — es braucht keinen Software-Deck-Toggle in den Components (relevant für Issue #10: dort nur LED-Reinit beim Wechsel prüfen).
- Alle Regler als `components.Pot` — Soft-Takeover ist dort eingebaut (aktiviert sich nach dem ersten empfangenen Wert; der Identify-Request beim Start liefert die Startpositionen).
- EQ auf `[EqualizerRack1_[ChannelN]_Effect1]` parameter1–3 (Low/Mid/High), Filter auf `[QuickEffectRack1_[ChannelN]] super1`.
- VU-Meter über `engine.makeUnbufferedConnection` (Kanäle: `[ChannelN],vu_meter`; Master: `[Main],vu_meter_left/right`, verifiziert in mitgelieferten Mappings). Drosselung durch LED-Cache: `sendLed()` sendet nur bei geändertem 7-Bit-Wert — der Controller mappt die Wertebereiche selbst auf LED-Stufen, daher genügt `value*127`.
- LED-Cache in `sendLed()` zentralisiert; `allLedsOff()` leert den Cache zuerst, damit beim Beenden garantiert alles gesendet wird.
- Crossfader-Kurve über den Mixxx-Helper `script.crossfaderCurve(value, 0, 127)` (setzt `[Mixer Profile],xFaderCurve` passend zum Modus).
- Sampler-Volume-Regler setzt die Lautstärke aller Sampler (`[App],num_samplers`).
- LOAD-LED zeigt `track_loaded`; PFL als Toggle-Button mit LED.
- CF-Zuweisung A/T/B: Hardware sendet 127 auf der Note der gewählten Position → `orientation` 0/1/2.

## Offene Punkte

- Gerätetest ausstehend (Checkliste im Issue).
- `vu_meter` auf `[ChannelN]`: Name aus 2.5-Konvention abgeleitet — falls die Kanal-Meter am Gerät stumm bleiben, Alias `VuMeter` probieren.
- Filter-Center-Notes (0x22/0x23) und Filter-FX-Taste (0x01) bewusst unbelegt (Makro-FX → Issue #9).
- Fader Start (Shift+Fader, 9n 5D/5E) unbelegt → Issue #10.
