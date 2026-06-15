# HatchAWhale — Roblox Project

## Project structure

This is a **Rojo**-managed Roblox game project. Source files in `src/` map to Roblox services defined in `default.project.json`.

| Folder | Roblox service |
|---|---|
| `src/ServerScriptService/` | ServerScriptService |
| `src/StarterPlayerScripts/` | StarterPlayer > StarterPlayerScripts |
| `src/ReplicatedStorage/` | ReplicatedStorage |

Files follow Rojo naming conventions:
- `*.server.lua` → Script (server)
- `*.client.lua` → LocalScript (client)
- `*.lua` → ModuleScript

## How to sync changes into Roblox Studio

1. Install the [Rojo CLI](https://rojo.space/docs/v7/installation/) if not already installed.
2. In this repo directory, run:
   ```
   rojo serve default.project.json
   ```
3. In Roblox Studio, open the **Rojo plugin** and click **Connect** (default port 34872).
4. Studio will hot-reload any file changes made on disk in real time.

## Adding new scripts

1. Create the `.lua` file under the correct `src/` subfolder.
2. Register it in `default.project.json` under the matching service block, e.g.:
   ```json
   "MyScript": {
     "$path": "src/ServerScriptService/MyScript.server.lua"
   }
   ```
3. Rojo will pick it up automatically on the next save.

## Development branch

Active feature work goes on branches prefixed `claude/`. Always push to the designated feature branch, never directly to `main`.
