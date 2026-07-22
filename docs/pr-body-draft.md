## Summary

Adds a complete controller mapping for the **Reloop Mixon 4** (4-deck MIDI DJ controller) with full LED feedback. The mapping is based on the official Reloop MIDI implementation chart and built on the `midi-components-0.0.js` framework.

## What is mapped

- **Transport:** play/pause, cue, sync (short = beatsync, hold = sync lock), with LEDs
- **Jog wheels:** touch-sensitive scratching, nudging, and the 16-segment jog LED ring (track progress)
- **Pitch:** 14-bit pitch bend with soft-takeover, keylock, key sync (double-press = reset), slip, pitch LED
- **Loops:** auto loop, loop-size encoder, beatjump, loop move; the 5 loop LEDs follow the beatloop size (the hardware labels them 1/32â€“1/2 blinking and 1â€“16 solid)
- **Mixer/master:** gain, 3-band EQ, quick-effect filter, channel faders, crossfader (+curve, A/thru/B assign), PFL, headphone mix/gain, sampler volume; channel and master VU meter LEDs
- **Performance pads (all 8 modes, RGB):** hot cue, loop roll, sampler, beatjump (labelled "slicer"), cue loop, saved loops (hotcues 9â€“16), pitch play, fixed beatloops (labelled "slicer loop")
- **FX:** both effect units (metaknobs, effect enable with LEDs, focus via TAP, dry/wet on the parameter encoder), channel FX assign via the filter-FX buttons
- **Browser:** TRAX encoder (shift = page scroll), load, back; global quantize toggle; fader start

## Notes / known limitations

- Mixxx has no native slicer, so the two "slicer" pad banks are mapped to beatjumps and fixed beatloops respectively â€” the most useful equivalents. Documented in the mapping.
- The pitch-play bank shifts the running track's key; a from-hotcue re-trigger variant is planned as a follow-up.
- Jog `wheelResolution` was calibrated empirically (not documented by Reloop).
- Pad velocity/aftertouch messages are intentionally unused.

## Testing

Tested on real hardware (Reloop Mixon 4, firmware v2218) with Mixxx 2.5.6 on Windows 11. All sections verified end-to-end; incoming MIDI cross-checked against the official chart with `--controllerDebug`. ESLint clean against Mixxx-style rules.

Development history and per-feature notes: https://github.com/daTobi1/reloop-mixon-4-mixxx
