# Working on oof/ui Core

Inspect `git status` first and preserve unrelated work. Install the pinned
Rokit tools with `rokit install` and dependencies with `wally install`.

`default.project.json` builds the library. `showcase.project.json` builds a
deterministic example game. Keep generated Packages and build output out of Git.
Use `rojo serve showcase.project.json` for source-driven iteration.

Use Roblox Studio's official CLI to open one built place. On macOS:

```sh
/Applications/RobloxStudio.app/Contents/MacOS/RobloxStudio \
  --task EditFile --localPlaceFile "$PWD/build/showcase.rbxlx"
```

On Windows, use the installed `RobloxStudioBeta.exe` with the same arguments.
Inspect existing windows before launching. Record the process you start, reuse
it for that session, and close that window after saving wanted changes. Never
kill unrelated Studio processes or leave multiple disposable windows behind.

Mount StyleProvider inside its ScreenGui. Preserve native Roblox controls,
input, selection, and state on theme changes. Verify each installed theme in
Studio; a Rojo build alone is not runtime or visual proof.

This is a history-free Core export. It contains no paid theme modules. Keep
Pro source private when developing a game that licenses the separate pack.

Use the maintained [oofui skill](skills/oofui/SKILL.md) for application work.
The CLI source is in `cli`; run `npm test` for its integration tests.
Never add paid modules or original paid artwork to this repository. Purchaser
source goes in the ignored `.oofui/private` folder, mounted by Rojo. This public
snapshot has no inherited private authoring history.
