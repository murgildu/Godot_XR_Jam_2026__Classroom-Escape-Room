# Audio

The original, procedurally synthesized USB effects play once at the USB's snap zone.
Normal docking and storage use XR Tools' `stash_sound` property. On an incorrect-order insertion, `Screen.gd` replaces the docking sound on the same spatial audio player with the error cue.

| File | Duration | Use |
| --- | --- | --- |
| `usb_insert_exaggerated.wav` | 5 seconds | Machine docks: mechanical slide and latch, electronic startup, and connection chime. |
| `usb_stash_soft.wav` | 0.38 seconds | Player storage sphere: a quiet fabric brush and padded plastic tap when storing the USB. |
| `usb_wrong_order.wav` | 0.60 seconds | Phi, modular inverse, and modular exponentiation docks: three gentle descending electronic notes when the previous step is missing. |
| `professor_dive_alarm.wav` | 12 seconds | Recorded WWII submarine dive klaxon, repeated through the professor inspection warning. |
| `professor_door_knock.wav` | 1.2 seconds | Three hollow wooden knocks, played spatially at the classroom door when an inspection is resolved. |

The effects above are mono, 48 kHz, 16-bit PCM WAV. The USB effects and door knocks were created for this project without third-party recordings or samples and are covered by the repository's MIT license. The dive alarm uses a public-domain recording credited below.

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

## Professor inspections

`Scripts/ProfessorInspection.gd` starts after the first hand pickup of the USB.
The first inspection follows a random 20–40 second delay. A 12-second warning
shows the belt instruction and the three-minute penalty while the dive alarm
plays. At the deadline, only the actual USB snapped into the belt passes.
A caught player immediately loses 180 seconds; reaching zero uses the normal
game-over flow. Surviving results play the door knock and remain visible for
10 seconds. A second inspection follows 45–75 seconds later, with a maximum
of two inspections per run.

Machine narration and docking audio are lowered by 12 dB during the warning and
result, then restored. Winning or losing cancels the event, stops its sounds,
hides its message, and restores the mix. Restarting resets the schedule.

### Dive alarm source

`professor_dive_alarm.wav` is adapted from
[WWII submarine dive klaxon](https://commons.wikimedia.org/wiki/File:WWII_submarine_dive_klaxon.ogg),
credited to the **United States Navy**. Wikimedia Commons identifies it as a
recording aboard a WWII U.S. Navy submarine, originally hosted by the U.S.
Department of Defense, and marks it **public domain** as a U.S. government work.
Source and status checked on 2026-09-25.

The recording retains its original pitch and speed. It is resampled to 48 kHz,
attenuated by 6 dB, and given short fades at the edit boundaries. The complete
3.77-second recording is padded to four seconds and repeated three times for
the 12-second warning. No synthetic alarm layers or film samples are used.

The door knocks remain original procedural sounds made from damped resonances
and short noise impacts.
