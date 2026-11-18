# Arbeitsnotizen Issue #1 (GitHub) — Slicer-Emulation

**Stand:** 2026-11-18

## Umsetzung
- **Fenster:** 8 Beats, verankert am Beat, in dem der Abspielkopf steht (`playposition` × `track_samples` minus `beat_distance` × Beatlänge). Beatlänge in Samples = 60 / `file_bpm` × `track_samplerate` × 2.
- **Verankern:** beim Drücken der Modus-Taste SLICER (Deck-Kanal, Note 0x19) bzw. SLICER LOOP (0x1D), sonst beim ersten Pad-Druck. Liegt der Abspielkopf außerhalb des Fensters (Spulen, neuer Titel), wird neu verankert.
- **Sprung:** `beatjump` um (Ziel-Segment − aktuelles Segment) ganze Beats. So bleibt die Phase im Beat erhalten (nahtlos, wie quantisiert) – unabhängig vom Quantize-Schalter.
- **Slicer:** Ein Timer (50 ms) zieht das Fenster in 8-Beat-Schritten nach, wenn die Wiedergabe es verlässt.
- **Slicer Loop:** Das Fenster bleibt stehen. Beim ersten gehaltenen Pad wird `slip_enabled` eingeschaltet (vorheriger Zustand gemerkt), beim Loslassen des letzten Pads wieder aus → Rückkehr an die Slip-Position.
- **LEDs:** laufendes Segment hell, übrige gedimmt (Slicer magenta 0x33/0x73, Slicer Loop violett 0x23/0x63); ohne Fenster aus. `Mixon4.sendLed` cached, also kein MIDI-Flooding durch den Timer.
- **Entscheidung:** Die bisherigen Belegungen ziehen auf die Shift-Ebene um: Shift + Slicer = Beatjump (0x58–0x5F), Shift + Slicer Loop = feste Loops (0x78–0x7F).

## Grenzen
- Keine Segment-Anzeige in der Wellenform.
- Präzision hängt vom Beatgrid ab (schlechtes Grid → Sprünge daneben).

## Offene Punkte
- Gerätetest mit sauberem und schlechtem Beatgrid.
- Prüfen, ob die Modus-Tasten 0x19/0x1D wirklich auf dem Deck-Kanal ankommen (sonst verankert erst der erste Pad-Druck – funktioniert trotzdem).
