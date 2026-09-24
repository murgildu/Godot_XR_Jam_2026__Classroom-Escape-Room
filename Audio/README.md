# Audio

These original, procedurally synthesized effects play once at the USB's snap zone.
Normal docking and storage use XR Tools' `stash_sound` property. On an incorrect-order insertion, `Screen.gd` replaces the docking sound on the same spatial audio player with the error cue.

| File | Duration | Use |
| --- | --- | --- |
| `usb_insert_exaggerated.wav` | 5 seconds | Machine docks: mechanical slide and latch, electronic startup, and connection chime. |
| `usb_stash_soft.wav` | 0.38 seconds | Player storage sphere: a quiet fabric brush and padded plastic tap when storing the USB. |
| `usb_wrong_order.wav` | 0.60 seconds | Phi, modular inverse, and modular exponentiation docks: three gentle descending electronic notes when the previous step is missing. |

The effects above are mono, 48 kHz, 16-bit PCM WAV. Created for this project without third-party recordings or samples; covered by the repository's MIT license.

## Machine introductions

These are the clearer, slower robotic descriptions, synthesized with FFmpeg's
Flite `kal16` voice. Each clip is a 10-second, mono, 48 kHz, 16-bit PCM WAV,
with pauses between phrases and no echo.

| File | Description |
| --- | --- |
| `01_factorization.wav` | Factorization machine. I split the public number into two prime numbers. Their product gives the original number. |
| `02_phi_calculation.wav` | Phi calculation machine. I subtract one from each prime. Multiply those two results. This gives phi. |
| `03_modular_inverse.wav` | Modular inverse machine. I calculate the private exponent. I use the public exponent, and phi. |
| `04_modular_exponentiation.wav` | Modular exponentiation machine. I use the private key to decrypt your message. This reveals your escape code. |

Each of the four playable machines in `stages/TestScene/test_scene.tscn` has an
`IntroductionArea` instance of `Scenes/MachineIntroduction.tscn`, centred on its
USB slot. The shared script `Scripts/machine_introduction.gd` detects only physics
layer 20 and the `player_body` group. On the player's first entry into the
1.5-metre trigger, the machine plays its assigned `narration` through a spatial
audio player. Leaving and returning does not replay it; reloading the scene resets
it. USB insertion remains available during narration.

To change a clip, assign the area's `narration` property. To change the range,
edit the sphere radius in `MachineIntroduction.tscn`.
