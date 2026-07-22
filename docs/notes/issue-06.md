# Arbeitsnotizen Issue #6 — Loop-Sektion

**Stand:** 2026-07-22

## Entscheidungen

- Auto-Loop (0x08) = `beatloop_activate` (setzt/löst Beatloop der aktuellen Größe), LED = `loop_enabled`.
- Shift+Auto-Loop auf Note 0x48 vermutet (+0x40-Muster; die PDF lässt die Shift-Spalte hier leer) = `reloop_toggle` (letzten Loop reaktivieren). **Am Gerät verifizieren** — falls die Hardware nichts sendet, bleibt die Funktion einfach ungenutzt.
- Loop-Encoder (CC 0x08): `loop_double`/`loop_halve` bei 0x41/0x3F; Werte weiter weg von 0x40 (schnelles Drehen) werden wie ±1 behandelt.
- Param −/+ (0x0A/0x0B) = `beatjump_backward/forward` (Standard-Sprungweite `beatjump_size`, in Mixxx einstellbar), LEDs blinken beim Druck mit.
- Shift+Param (0x4A/0x4B) = aktiven Loop um `beatjump_size` Beats verschieben (`loop_move`).
- Loop-LED-Anzeige (**korrigiert nach Gerätetest 2026-07-22**): Die 5 LEDs sind doppelt beschriftet — blinkend = 1/32…1/2, leuchtend = 1…16 Beats. Es leuchtet/blinkt genau die LED der aktuellen `beatloop_size`; außerhalb des Bereichs alle an (>16) bzw. alle blinkend (<1/32). Der aktive Loop wird allein über die Auto-Loop-Tasten-LED angezeigt. Erste Fassung („mehr LEDs = größerer Loop, Blinken = aktiv") war falsch — der Nutzer bemerkte den Faktor-4-Versatz zur Mixxx-Anzeige.

## Offene Punkte

- Gerätetest: sendet Shift+Auto-Loop wirklich 0x48? Loop-LEDs: folgt die Kette dem Encoder, blinkt sie nur bei aktivem Loop?
- „Gedrückt + gedreht = Loop verschieben" aus dem ursprünglichen Issue-Text entfällt: Der Loop-Encoder hat laut PDF keinen Push — Verschieben liegt stattdessen auf Shift+Param.
