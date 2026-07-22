# Arbeitsnotizen Issue #7 — RGB-Engine + Pads Teil 1

**Stand:** 2026-07-22

## Entscheidungen

- **Keine Pad-Modus-Zustandsmaschine nötig:** Jeder Pad-Modus hat eigene Notenbereiche (Hot Cue 0x00–0x07, Loop Roll 0x08–0x0F, Sampler 0x10–0x17, Shift-Ebene +0x40) auf dem Pad-Kanal des Decks. Alle Modi bleiben parallel verbunden; die Hardware routet Tasten und LEDs selbst nach aktivem Modus. Auch keine LED-Reinitialisierung beim Moduswechsel nötig — die LED-Zustände aller Modi liegen dauerhaft auf ihren Adressen.
- **Pad-Eingaben über `midi.makeInputHandler`** statt XML-Bindings (hätte ~160 zusätzliche XML-Einträge bedeutet). Regler/Tasten der Deck-Sektion bleiben in der XML — Mischform ist auch upstream üblich.
- **RGB-Engine:** `ColorMapper` mit allen 64 hellen Palettenfarben (Bitmuster `00rrggbb`, Stufen 0/33/66/100 % → 0x00/0x55/0xAA/0xFF). Dim-Variante = Wert + 0x40. Farbkonstanten zentral in `Mixon4.COLORS`.
- Hot Cues: `components.HotcueButton` mit `colorMapper` — Pad-Farbe folgt automatisch `hotcue_N_color` (inkl. Farbwechsel in der Mixxx-GUI). Shift-Note (+0x40) = `hotcue_N_clear` als eigener Handler (die interne shift()-Mechanik bleibt ungenutzt, wie überall im Mapping).
- Loop Rolls: `beatlooproll_X_activate`, Größen 1/32–4 Beats; Pads dauerhaft gedimmt blau, hell während des Rolls (outKey = inKey).
- Sampler: `components.SamplerButton` (Druck = abspielen bzw. markierten Track in leeren Slot laden; Shift = Stopp bzw. Auswerfen). LED: aus = leer, gedimmt weiß = geladen, grün = spielt. Alle 4 Decks steuern Sampler 1–8.

## Offene Punkte

- Gerätetest: Hot-Cue-Farbtreue (Mixxx-Farbe vs. Pad), Loop-Roll-Grundglühen, Sampler-Zustandsfarben, Shift-Funktionen (Clear/Stop/Eject).
- Velocity-/Aftertouch-Nachrichten der Pads (Bn/An auf Pad-Kanälen) weiterhin bewusst unbelegt; `volumeByVelocity` des SamplerButton wäre ein späteres Extra.
- Falls die Pads beim Moduswechsel doch dunkel werden (Hardware löscht evtl. beim Umschalten), müsste eine Reinitialisierung über die Modus-Tasten-Noten (0x16–0x1D, Deck-Kanal) nachgerüstet werden — erst am Gerät prüfen.
