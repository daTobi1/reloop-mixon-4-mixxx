# Arbeitsnotizen Issue #4 — Jog Wheels

**Stand:** 2026-07-22

## Entscheidungen

- `components.JogWheelBasic` verwendet (in 2.5.6 vorhanden): `inputTouch` (Note 0x07) schaltet Scratch an/aus, `inputWheel` (CC 0x06) tickt beim Scratchen bzw. nudgt sonst über das `jog`-CO.
- **Encoder-Skalierung überschrieben:** Der Mixon 4 sendet Offset-64-Relativwerte (0x41 = +1 vorwärts, 0x3F = −1 rückwärts). Der `JogWheelBasic`-Default erwartet Zweierkomplement und hätte Richtung und Betrag verfälscht → `inValueScale: value - 0x40`.
- Tunables zentral in `Mixon4.JOG`: `wheelResolution: 720` (von Reloop nicht dokumentiert — **am Gerät kalibrieren**, falls eine physische Umdrehung beim Scratchen nicht einer Plattenumdrehung entspricht), Alpha 1/8, Beta Alpha/32, 33⅓ RPM.
- Jog-LED-Ring: Hardware-„Behaviour 1" (Track Progress, Werte 0x00–0x10). Verbindung an `playposition` + `track_loaded`; bei geladenem Track mindestens Segment 1, ohne Track aus. Drosselung über den LED-Cache (nur 17 mögliche Werte → es wird nur bei Segmentwechsel gesendet, kein Timer nötig).

## Offene Punkte

- Shift+Jog (schneller Suchlauf): Die PDF nennt für den Jog-Encoder keine eindeutige Shift-Adresse. Am Gerät prüfen, was beim Drehen mit gehaltenem Shift gesendet wird (MIDI-Log), dann nachrüsten.
- `wheelResolution` kalibrieren (Testpunkt im Issue).
- Verhalten „Vinyl-Stopp beim Pausieren" beobachten: LED-Ring soll beim Pausieren stehen bleiben, nicht flackern.

## Testpunkte am Gerät

1. Teller-Oberfläche berühren + drehen = Scratchen (Richtung korrekt? Geschwindigkeit 1:1?)
2. Rand drehen ohne Touch = sanftes Nudgen des laufenden Tracks
3. Loslassen nach Scratch: Track läuft mit sauberem Ramp weiter
4. LED-Ring füllt sich mit dem Track-Fortschritt (16 Segmente), leer ohne Track
