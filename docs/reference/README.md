# Reference

The committed part of the notes tree: standing material on how the clock works.
Everything else under `docs/` is private and gitignored, so nothing here links out of `reference/`.

`internal/` holds pages written here, describing the system as it stands; they are rewritten in place when the code or the parts move.
`external/` holds sources someone else wrote that the project cites; they are never edited, only replaced with a newer version.

| File | What It Is |
|---|---|
| [`internal/architecture.md`](internal/architecture.md) | The tasks, the one protected object they share, and what crosses each boundary |
| [`internal/ada-runtime.md`](internal/ada-runtime.md) | What the `ada_esp32s3` bare-metal runtime provides and where it has gaps |
| [`internal/hardware.md`](internal/hardware.md) | The reference build's parts, pinout and I2C addresses |
| [`internal/bom.md`](internal/bom.md) | Where to buy each part, what a swap costs, and the LCD voltage trap |
