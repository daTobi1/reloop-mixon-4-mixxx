# Upstream-Checkliste: Mapping an mixxxdj/mixxx beitragen

Ziel: Pull Request, der das Reloop-Mixon-4-Mapping offiziell in Mixxx aufnimmt.

## Voraussetzungen (aus den Mixxx-Contribution-Richtlinien)

- [ ] Mapping vollständig am Gerät getestet (Regressionstest aller Sektionen)
- [ ] ESLint sauber (`npm run lint`; Mixxx lintet `res/controllers` im CI)
- [ ] Dateinamen nach Konvention: `Reloop-Mixon-4.midi.xml` / `Reloop-Mixon-4.scripts.js` ✓
- [ ] GPL-v2+-kompatibel, keine Fremdcode-Kopien ohne Lizenzangabe ✓ (nur offizielle Reloop-MIDI-Spezifikation als Datenquelle)

## Ablauf

1. [x] Fork von `mixxxdj/mixxx` (→ `daTobi1/mixxx`), Branch `reloop-mixon-4-mapping` von `main`
2. [x] Beide Dateien nach `res/controllers/` kopiert (upstream-angepasste `<info>`: `mixxxVersion="2.5.0+"`, ohne `<wiki>`); Branch liegt fertig auf dem Fork
3. [ ] **Forum-Thread im Mixxx-Discourse** (Kategorie Controller mappings) posten — Entwurf: `docs/forum-post-draft.md`. Danach Thread-URL ins `<forums>`-Feld der Mapping-XML eintragen (auf dem Fork-Branch)
4. [ ] Nutzer-Feedback aus dem Forum einarbeiten
5. [ ] PR öffnen (Text steht in `docs/pr-body-draft.md`):
   ```
   gh pr create -R mixxxdj/mixxx --base main \
     --head daTobi1:reloop-mixon-4-mapping \
     --title "Add Reloop Mixon 4 controller mapping" \
     --body-file docs/pr-body-draft.md
   ```
6. [ ] Optional: Manual-Seite (`mixxxdj/manual`) und Eintrag in der Hardware-Kompatibilitätsliste
7. [ ] Review-Feedback einarbeiten (Maintainer verlangen oft Kleinigkeiten wie JSDoc oder Konstanten-Umbau)

**Aktueller Stand (2026-07-22):** Fork und Branch stehen bereit. Nutzer postet zuerst den Forum-Thread; PR wird danach geöffnet.

## Bekannte Grenzen für den PR-Text

- Slicer-/Slicer-Loop-Bank als Beatjump/feste Loops belegt (Mixxx hat keinen Slicer); Emulation in Arbeit (Issue #18)
- Pitch-Play-Bank ändert die Tonhöhe des laufenden Tracks; echtes Pitch Play in Arbeit (Issue #19)
- Jog-Auflösung (`wheelResolution`) empirisch kalibriert, von Reloop nicht dokumentiert
- Velocity/Aftertouch der Pads bewusst unbelegt
