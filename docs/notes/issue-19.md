# Arbeitsnotizen Issue #2 (GitHub) — Echtes Pitch Play

**Stand:** 2026-11-18

## Umsetzung
- Pad-Druck: `keylock` an (falls aus), `pitch` auf den Halbton-Offset des Pads, dann `hotcue_N_gotoandplay` des Basis-Cues – Neuanspielen ab dem Cue in der gewählten Tonhöhe.
- **Basis-Cue:** Standard Hot Cue 1; Shift + Pad 1–8 (0x70–0x77) wählt Hot Cue 1–8. Der gewählte leuchtet auf der Shift-Ebene weiß (hell = gesetzt, gedimmt = noch nicht gesetzt). Die LEDs folgen `hotcue_N_status`.
- **Ohne gesetzten Basis-Cue:** nur Tonhöhe ändern (bisheriges Verhalten).
- **Keylock:** wird beim ersten Pitch-Play-Druck eingeschaltet, sonst würde die Tonart-Änderung über das Tempo laufen. Es wird nicht automatisch wieder ausgeschaltet.
- LED-Schema der Offsets unverändert (blau/weiß/rot, aktiver Offset hell).
- Shift + Pad setzte bisher die Tonart zurück – das macht jetzt das weiße Pad (Offset 0) in der Normalebene.

## Offene Punkte
- Gerätetest: schnelles Melodiespiel über die 8 Pads, Verhalten bei laufendem Loop.
