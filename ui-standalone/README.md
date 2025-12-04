# Standalone SCADA-Style UI Kit

This folder packages the CC: Tweaked UI toolkit from **cc-mek-scada** as its own self-contained project. You can copy the `ui-standalone` directory into a fresh repository or onto a computer/monitor to get a fully interactive demonstration of the UI controls, theme system, and layout/navigation helpers.

## What is included
- `graphics/` — the full UI library (core primitives, theme palettes, widgets, and controls) copied directly from cc-mek-scada.
- `demo/ui/` — helper modules that define styles, shared state, and a multi-page layout with buttons, toggles, and navigation.
- `demo/ui_demo.lua` — runner that wires keyboard/mouse/monitor input into the demo layout.
- `startup.lua` — entrypoint so the demo launches automatically when this folder is used as a standalone repo or dropped onto a computer.

## How to use as a separate repo
1. Copy the entire `ui-standalone` directory into a new repository (or onto a CC computer).
2. Ensure the copied folder is the root of that repository/device.
3. Boot the computer (or run `startup.lua`) to launch the demo. If a monitor is attached it will mirror the UI with touch support; the terminal UI remains fully interactive.

The packaged UI kit mirrors the original cc-mek-scada graphics library and can be extended with new layouts or themes without depending on the rest of the SCADA system.
