# Forum-Beitrag (Entwurf) fÃ¼r das Mixxx-Discourse

**Wo posten:** https://mixxx.discourse.group/ â†’ Kategorie **Controller mappings**
**Titel:** `Reloop Mixon 4 â€” mapping with full LED feedback (testers welcome)`

---

Hi everyone,

I've written a complete Mixxx mapping for the **Reloop Mixon 4** and would love some feedback and testers before submitting it upstream.

**What works** (tested on real hardware, firmware v2218, Mixxx 2.5.6 / Windows 11):

- Transport (play/cue/sync with LEDs), touch-sensitive jog scratching + jog LED ring
- 14-bit pitch with soft-takeover, keylock, key sync, slip
- Loops: auto loop, size encoder, beatjump, loop move; the 5 loop LEDs follow the beatloop size (matching the hardware's 1/32â€“1/2 blinking / 1â€“16 solid labels)
- Full mixer + master with channel and master VU meter LEDs
- All 8 performance-pad modes with RGB feedback (hot cue, loop roll, sampler, beatjump, cue loop, saved loops, pitch play, fixed loops)
- Both FX units (metaknobs, enable LEDs, focus via TAP, dry/wet on the parameter encoder)
- Library browsing, quantize, fader start

**Known limitations:** Mixxx has no native slicer, so the two "slicer" pad banks are mapped to beatjumps and fixed beatloops. The pitch-play bank currently shifts the running track's key (a from-hotcue re-trigger is planned).

Repository with the mapping and detailed per-feature notes:
https://github.com/daTobi1/reloop-mixon-4-mixxx

If any Mixon 4 owners can give it a spin and report back, I'll fold in the feedback and then open a pull request. Thanks!

---

**Nach dem Posten:** Thread-URL hier notieren und in der Mapping-XML im `<forums>`-Feld eintragen (ersetzt den vorlÃ¤ufigen GitHub-Link), bevor der PR geÃ¶ffnet wird.
