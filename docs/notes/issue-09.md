# Arbeitsnotizen Issue #9 — FX-Sektion

**Stand:** 2026-07-22

## Entscheidungen

- `components.EffectUnit` (Framework-Container) je Hardware-Einheit: Kanal 8 → Mixxx EffectUnit 1, Kanal 9 → EffectUnit 2.
- Bedienkonzept (Framework-Standard):
  - **Effekt-Regler 1–3** steuern die Meta-Regler der drei Slots.
  - **ON 1–3** schalten die Slots (PowerWindow-Verhalten: kurz = Toggle, lang gehalten = nur solange aktiv). LEDs folgen `enabled`.
  - **TAP gedrückt halten + ON-Taste** fokussiert den Slot; danach steuern die drei Regler die **Parameter 1–3 des fokussierten Effekts**. TAP ist damit der `effectFocusButton` des Frameworks — kein BPM-Tap (Sync übernimmt das Beatmatching).
  - **PARAMETER-Encoder** = Dry/Wet-Mix der Einheit (relativ, 0x3F/0x41), **Push** = Mix auf 50 %.
- **FX-Zuweisung der Kanäle:** Die FILTER-FX-Taste am Kanalzug (Note 0x01, Deck-Kanal) schaltet `group_[ChannelN]_enable` der zugehörigen Einheit (Deck 1/3 → FX1, Deck 2/4 → FX2). Ihre LED ist hardwareseitig.
- Eingaben komplett über `midi.makeInputHandler` (wie Pads); LED-Ausgaben der ON-Tasten macht das Framework über die zugewiesenen `midi`-Adressen selbst.
- Soft-Takeover für Effekt-Parameter bringt die EffectUnit-Klasse mit.

## Offene Punkte

- Shift-Ebene der FX-Tasten (vermutlich Noten 0x40+) unbelegt — Framework-Shift würde Effektauswahl per Regler-Drehung bieten; bei Bedarf in Issue #10 nachrüsten.
- Gerätetest: Effekte laden (in Mixxx-GUI Effekte in die Slots legen), ON-LEDs, Fokus-Bedienung (TAP halten + ON), Mix-Encoder, Kanal-Zuweisung über FILTER-FX-Taste.
