# Arbeitsnotizen Issue #8 — Pads Teil 2

**Stand:** 2026-07-22

## Belegung der vier restlichen Banks

| Hardware-Modus | Noten | Belegung in Mixxx | LED |
|---|---|---|---|
| Slicer | 0x18–0x1F | **Beatjump** −8/−4/−2/−1/+1/+2/+4/+8 Beats (Mixxx hat keinen Slicer) | orange, hell beim Sprung |
| Cue Loop | 0x20–0x27 | `hotcue_1–8_cueloop` (nativ, 2.4+): Loop ab Hot Cue, nutzt Saved Loop falls vorhanden, sonst `beatloop_size` | Hot-Cue-Farbe |
| Saved Loops | 0x28–0x2F | Hot Cues **9–16**: bei aktivem Loop gedrücktes leeres Pad speichert den Loop als Cue (natives Mixxx-Verhalten); erneut drücken reaktiviert ihn | Cue-Farbe |
| Slicer Loop | 0x38–0x3F | **Feste Beatloops** 1/8–16 (`beatloop_X_toggle`/`_enabled`) | cyan, hell bei aktiver Größe |
| Pitch Play | 0x30–0x37 | Halbton-Offsets −4…+3 über das `pitch`-CO; Shift = Original-Tonart | blau (−) / weiß (0) / rot (+), aktiver Offset hell |

- Shift auf Cue-Loop- und Saved-Loops-Pads = jeweiligen Hot Cue löschen.
- **Abweichung von Serato dokumentiert:** Slicer/Slicer Loop existieren in Mixxx nicht; Beatjump und feste Loops sind die nützlichsten Ersatzbelegungen. Falls Mixxx später einen Slicer bekommt, Banks entsprechend umbauen.
- `beatloop_X_enabled` als LED-Quelle in mitgelieferten Mappings verifiziert (Denon MC3000/MC4000).
- Pitch-Play-LEDs über eine `pitch`-Connection, die alle 8 Pads aktualisiert (aktiv = hell, sonst gedimmt).

## Offene Punkte

- Gerätetest aller vier Banks; besonders: speichert ein leeres Saved-Loop-Pad bei aktivem Loop wirklich den Loop (Cue-Typ „Loop")?
- Hot Cues 9–16 erscheinen in der Mixxx-GUI nur, wenn das Skin 16 Cues anzeigt — im Zweifel egal, die Pads funktionieren unabhängig davon.
