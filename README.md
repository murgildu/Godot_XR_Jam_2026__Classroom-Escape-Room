# Classroom Escape Room

A small virtual reality escape room that introduces the fundamentals of RSA cryptography.

A project by [MURGILDU](https://murgildu.github.io/), the XR laboratory at EHU's Faculty of Informatics, created for the [Godot XR Game Jam — September 2026](https://itch.io/jam/godot-xr-game-jam-sep-2026). The jam's theme is **ADRIFT**.

> **Status:** in development. This README describes the intended design and scope; it does not imply that all features have been implemented.
So few development time is generating PTSD on us!!!!  Requirements, controls, and instructions for running the game will be documented once a playable build is available.

## Motivation

We want to introduce students to RSA cryptography through a short, interactive experience. The game is designed as an introductory or pre-lab activity for the basic aljebra subject: it helps students identify the initial data, understand how the operations depend on one another, and observe how an encrypted message can be recovered.

The machines perform the calculations automatically. The player's task is to **decide which operation comes next and take the USB drive to the appropriate machine**. This keeps the interaction focused on understanding the procedure, without requiring manual calculations or repeatedly typing long numbers in VR.

## Game concept

You have entered a professor's office to steal a USB drive containing the exams. Removing it accidentally triggers the security system: the door locks and a countdown begins.

The USB drive is protected. To unlock it, you must recover a code encrypted with RSA. The professor's notes contain their public key and a few clues, while the machines around the room let you reconstruct the decryption process.

You have **10 minutes** to recover the code, unlock the USB drive, and release the door through the security terminal. 

We interpret *Adrift* as a feeling of disorientation: at first, you are surrounded by data and tools whose purpose you do not understand. Each discovery helps you piece together a path to the exit.

## How to play

1. The game begins after a brief introduction and explanation of the controls.
2. Find the USB drive and read the professor's notes.
3. Connect the USB drive to the terminal to reveal the encrypted message.
4. Decide which machine to use and insert the USB drive into its reader.
5. The machine uses the available data, performs its operation, and displays the result and the formula used.
6. Retrieve the USB drive and continue until you recover the code.
7. Return to the terminal and use the recovered code to unlock the USB drive and open the door.

The USB drive carries your progress: it stores the initial data and the results obtained along the way. The screens let you review those results without having to memorize them.

If a machine does not yet have the required data, it explains what is missing and preserves your progress. For example: “I need p and q to calculate phi.” Returning to a completed machine lets you view its result again.

**Victory:** unlock the USB drive and release the door before time runs out. **Defeat:** the countdown reaches zero; the player can restart.

## What is RSA?

RSA is an asymmetric cryptographic system: it uses a mathematically related public key and private key. In this game's simplified model:

- The public key is `(n, e)` and can be used to encrypt a message.
- The private key is represented by `(n, d)` and can be used to decrypt it.
- `n` is the product of two distinct prime numbers, `p` and `q`.

If `m` is the original message and `c` is the encrypted message:

```text
Encryption: c = m^e mod n
Decryption: m = c^d mod n
```

The `mod` operation returns the remainder of a division. For example, `23 mod 7 = 2`.

The player does not initially know `d`. Recovering it requires the following steps:

| Stage | Operation | Result |
| --- | --- | --- |
| Factorization | Factor n = p × q | The primes p and q |
| Calculate phi | phi = (p − 1) × (q − 1) | The auxiliary value φ(n), called phi in the game |
| Modular inverse | Find d such that e × d mod phi = 1 | The private exponent d |
| Modular exponentiation | m = c^d mod n | The original message m |

The modular inverse exists when `e` and `phi` are coprime. Finding it means finding an integer that satisfies the condition above.

> **Educational simplification:** we use small numbers and RSA without the additional mechanisms of a real encryption scheme. Factorization is deliberately easy. The goal is to understand the mathematics, not to demonstrate a practical attack against correctly used RSA. Real applications use much larger moduli and schemes such as RSA-OAEP; see the [RSA specification](https://www.rfc-editor.org/rfc/rfc8017.html).

## Example walkthrough: solving the game

> **Spoilers:** this section documents the solution for the team and teaching staff.

The initial values are:

```text
n = 1022117      public modulus
e = 17           public exponent
c = 398724       encrypted message
```

The professor's notes provide `n` and `e`. The terminal displays `c` when it reads the USB drive. The game records these values so the machines can use them automatically.

### 1. Factorization machine

The player takes the USB drive to the factorization machine. It uses `n` and displays:

```text
1022117 = 1009 × 1013
p = 1009
q = 1013
```

**Learning outcome:** the public modulus is the product of two primes. Recovering them allows the procedure to continue.

### 2. Phi calculation machine

With the factors available, the player chooses the machine that calculates `(p − 1) × (q − 1)`:

```text
phi = (1009 − 1) × (1013 − 1)
phi = 1008 × 1012
phi = 1020096
```

**Learning outcome:** the factors allow us to obtain an auxiliary value needed to calculate the private exponent.

### 3. Modular inverse machine

This machine uses `e = 17` and `phi = 1020096` to find `d`:

```text
d = 180017
```

The screen can explain why it works:

```text
17 × 180017 = 3060289
3060289 = 3 × 1020096 + 1
```

The remainder is `1`, so `180017` is a modular inverse of `17` modulo `1020096`.

**Learning outcome:** we have recovered the private exponent. This value is not yet the unlock code.

### 4. Modular exponentiation machine

The player takes the USB drive to the machine that uses the encrypted message `c`, the private exponent `d`, and the modulus `n`:

```text
m = 398724^180017 mod 1022117
m = 467815
```

**Learning outcome:** applying the decryption operation recovers the original message. In our story, that message is the unlock code.

The calculation must use modular exponentiation, without first computing the full power.

```text
467815^17 mod 1022117 = 398724
```

### 5. Exit terminal

The player returns the USB drive to the terminal and confirms the unlock using the recovered code, `467815`. The terminal simulates opening the protected content and releases the door.

## Game jam scope

We are a team of three with very limited working hours available. Our priority is a small experience that can be played from beginning to end.

| Team member | Contribution |
| --- | --- |
| **Urko Munguia** | Lead author, responsible for most of the development. A student just starting the first year of a Computer Science degree, taking on the project with no prior Godot experience. |
| **Inigo Lopez-Gazpio** | Project supervision and mentoring through MURGILDU. |
| **Andoni Mujika** | Mathematician that provided initial RSA decryption idea, original theme included a knock-out to the professor to steal usb, which was obviously not implemented as unacceptable behavior :D. |

Taking part in the jam is also a learning opportunity for the team. With such a short deadline and most of the development carried out by Urko, we reuse existing visual assets so we can focus our effort on interaction, the educational sequence, and delivering a complete experience.

## Reused assets and licenses

We reuse assets from [Bastiaan Olij's ehu-vr-demo](https://codeberg.org/BastiaanOlij/ehu-vr-demo), including environment elements. The room is used as a static environment asset. The GridMap elements use an asset library from [Kenney](https://kenney.nl/).

Reusing these assets requires preserving the corresponding attribution notices and license files. Time constraints explain this scope decision; they do not change the assets' terms of use or the jam rules.

We release our own work under a MIT license

## Use of AI

We have used **Codex CLI** and **Claude** to help brainstorm and discuss ideas, improve text and code, and produce project documentation, always under human supervision.

The team remains responsible for design decisions, content review, and the final result. This statement describes our use so far and will be updated if it changes during development.

## Classroom use

After playing, we suggest discussing three questions with students:

1. Why did finding p and q allow us to recover the private exponent?
2. What is the difference between d and the final code, 467815?
3. What would change if factoring n were infeasible with the available resources?

The goal is for students to explain why they chose each machine and how its result contributes to the next step.
