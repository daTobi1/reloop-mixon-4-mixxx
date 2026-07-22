# Arbeitsnotizen Issue #10 — Feinschliff & Upstream-Vorbereitung

**Stand:** 2026-07-22

## Umgesetzt

- **Browser:** TRAX-Encoder → `[Library],MoveVertical` (Shift: 10 Zeilen — dafür wird der globale Shift-Zustand jetzt getrackt, da der Encoder als einziges Bedienelement keine eigene Shift-Adresse hat), TRAX-Push → `GoToItem`, BACK → `MoveFocusBackward` mit LED beim Druck.
- **Quantize-Taste** (global, feuert nach 2-s-Hold hardwareseitig): Quantize aller 4 Decks gemeinsam umschalten (Zielzustand = Gegenteil von Deck 1).
- **Fader-Start** (Shift+Kanalfader, Noten 0x5D/0x5E): hoch = Play, auf null = Stopp.
- **2-Deck-Modus** als Option `Mixon4.OPTIONS.twoDeckMode` (sendet beim Start die Deck-Restriktions-SysEx).
- **Deck-Umschaltung:** bestätigt keine Software-Logik nötig — Hardware wechselt die Kanäle; alle 4 Kanäle sind statisch gemappt und ihre LEDs werden kontinuierlich versorgt.
- **ESLint:** Flat-Config (`eslint.config.mjs`) mit Mixxx-nahen Regeln (camelcase, eqeqeq, indent 4, prefer-const/template, no-var, quotes double, semi, comma-dangle), `npm run lint` sauber. `node_modules`/`package-lock.json` in `.gitignore`.
- **README:** komplette Belegungstabelle aller Sektionen, Installations- und Entwicklungsanleitung.
- **Upstream:** `docs/upstream-checklist.md` mit Ablauf (Fork, res/controllers, Manual, Forum-Thread, PR-Text inkl. bekannter Grenzen).

## Bewusst nicht umgesetzt

- **Velocity-Taste** (2-s-Hold): schaltet die Anschlagdynamik der Pads hardwareintern um; die Note ist nur informativ. Unsere Pad-Handler werten `value > 0`, funktionieren also in beiden Zuständen.
- Shift-Ebene der FX-Tasten (Framework-Effektauswahl per Shift+Regler) — bei Bedarf nachrüstbar.
- Phono/Line-Tasten (Deck 3/4): reine Hardware-Eingangsumschaltung des Audio-Interfaces.

## Quantize-Diagnose (2026-07-22)

- Nutzer meldete: Hot-Cue-Taste 2 s halten bewirkt nichts.
- MIDI-Debug-Log (`--controllerDebug`) beweist: Beim 2-s-Halten sendet der Controller `status 0x9A (ch 0x0A), ctrl 0x02, val 0x7F` dann `0x00` — **exakt die Quantize-Adresse**. Nachricht kommt also an.
- Handler ist konfliktfrei an (0x9A, 0x02) gebunden; `makeInputHandler` funktioniert im Mapping nachweislich (Pads). Schlussfolgerung: Handler feuert, Quantize wird umgeschaltet — nur ist die GUI-Rückmeldung skinabhängig/unscheinbar.
- Debug-Log `quantize toggled -> N` (nur bei `Mixon4.debugging`) in den Handler eingebaut, um es zweifelsfrei zu machen.

## Offen

- Regressionstest aller Sektionen am Gerät (Checkliste im Issue) — danach kann Issue #10 zu.
- USB-Vendor-/Product-ID (aus Log bekannt: HID 26ad:8eb6) ggf. in den XML-`<devices>`-Block für Auto-Erkennung beim Upstream-PR.
