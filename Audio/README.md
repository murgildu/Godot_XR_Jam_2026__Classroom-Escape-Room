# Audio

These original, procedurally synthesized effects play once at the USB's snap zone.
Normal docking and storage use XR Tools' `stash_sound` property. On an incorrect-order insertion, `Screen.gd` replaces the docking sound on the same spatial audio player with the error cue.

| File | Duration | Use |
| --- | --- | --- |
| `usb_insert_exaggerated.wav` | 5 seconds | Machine docks: mechanical slide and latch, electronic startup, and connection chime. |
| `usb_stash_soft.wav` | 0.38 seconds | Player storage sphere: a quiet fabric brush and padded plastic tap when storing the USB. |
| `usb_wrong_order.wav` | 0.60 seconds | Phi, modular inverse, and modular exponentiation docks: three gentle descending electronic notes when the previous step is missing. |

All files are mono, 48 kHz, 16-bit PCM WAV. Created for this project without third-party recordings or samples; covered by the repository's MIT license.
