# GlazeWM-AutoTile-AHK
A standalone AutoHotkey V2 Script to automatically set tiling split directions based on window aspect ratio.
# Pre-requisites
- This script assumes you have glazewm.exe in your PATH.
# Usage
- Run it standalone, or specify for it to run with GlazeWM in your  GlazeWM `config.yaml` as items under `startup_commands` and `shutdown_commands`
# Working Principle
- Tiling direction is re-evaluated any time the window focus changes.
- This works via a hook (instead of something like a timer)
- Any time the window focus changes, the window/container's tiling direction is evaluated based on its aspect ratio. On a 16:9 or less display, the ideal aspect ratio (at which we switch between horizontal and vertical) is 1:1. On a 32:9 or greater display, our ideal aspect ratio is 3:2. In between, we scale linearly.
- The effect is that an ultrawide 32:9 display will tile horizontally in three columns (instead of four) before begining to tile vertically.
# Tips
- You can still invoke `glazewm command toggle-tiling-direction` for a one-time override. It won't go back to the automatically determined value until you un-focus and re-focus that window/container.
