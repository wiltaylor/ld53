# LUDUM DARE 53

Theme: Delivery
Platform: Nintendo Entertainment System (NES)

## Description

You are a delivery driver with unrealistic deadlines set by an evil AI. To meet your deadlines you need to duck and weave through traffic while launching your packages at peoples houses.

## Controls

- Left/Right: Steer left and right
- Up: Accelerate
- Down: Brake
- A: Throw package Left
- B: Throw package Right
- Start: Pause
- Select: Honk Horn in frustration

## Game Goals

- Avoid crashing into other cars
- Deliver packages to houses designated with flashing rectangles
- Bonus points if you can launch the package through the window of the house (got to have some job satisfaction right?).
- The game will keep getting faster and tricker to deliver packages as you play. Try to get the highest score you can.

## How to Play

- Download the rom from itch.io and play in your favorite NES emulator.
- Alternatively you can play online on my itch io page which has a web based emulator.
- If you have a flash cart you can play on real hardware (I have not tested this as I don't have one to test on).

## How to Build

- Before you can build you need the following tools installed:
  - [cc65](https://cc65.github.io/)
  - [Just](https://github.com/casey/just)
  - [FCEUX](https://www.fceux.com/web/home.html) (or your favorite NES emulator) to run the game. FCEUX has a pretty good debugger.

- Then build with:

```shell
just build
```

You will then have a game.nes file in the source directory. You can run this with your emulator.

> There is also a nix flake which has a nix shell you can run with all the tools used to develop the game installed.

## License

Copyright (c)  Wil Taylor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
