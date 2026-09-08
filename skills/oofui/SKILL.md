---
name: oofui
description: Build and refine native Roblox UI with oof/ui in Rojo and React-Luau projects. Discover, install, compose, and theme its components and Pro Plus game kits using the project CLI and verify the result in Roblox Studio.
---

# oof/ui

Use this skill for Roblox UI built with oof/ui. Preserve the game's architecture
and requested scope. The CLI installs editable source; it does not invent game
data or grant product licenses.

## Start from the project

Run `oofui info --json` to read the Rojo project, source path, and installed items.
If the command is unavailable, use the install command provided by the oof/ui
docs site or the project's README. Avoid assuming an unpublished npm version is
available. For a new project run `oofui init`; it also installs this skill.

Use `oofui list`, `oofui docs <item>`, and `oofui view <item>` to inspect the
actual API. Accept aliases such as `progressbar` and `progress-bar`. Install with
`oofui add <items...>`; `oofui component add progressbar` is the explicit form.
Use `--dry-run` to inspect writes. If existing code conflicts, inspect and merge
the user's changes; do not automatically use `--overwrite`.

## Compose native UI

Read [the composition reference](references/composition.md) when adding a screen.
Import the installed library through `ReplicatedStorage.OofUi` and React from
`ReplicatedStorage.Packages`. Component props are lowercase and are documented in
the module's `Props` type; native instance props retain Roblox casing.

Mount `StyleProvider` inside the `ScreenGui`. Keep gameplay UI inside
`CoreUISafeInsets`, disable automatic safe-area extension, and use the default
player and Humanoid camera for game previews. Theme changes belong in
`createTheme({ theme = Ui.styles.themes.<id>, overrides = ... })`.

Choose an existing kit when it fits: Inventory, Quest Log, Season Pass, Daily
Rewards, Item Shop, Crafting, Collection, Upgrades, Inventory Bar, Player Card,
and Currency View. Check access before promising a paid kit. A free installation
can compose its own inventory using free primitives; do not fetch private code
through previews or copy a paid implementation into a free component.

For paid items, `oofui auth login` verifies the purchase with the store. The
owner supplies the access code through stdin outside the chat transcript.
Credentials stay in the user's CLI config, and paid source lives in ignored
`.oofui/private`. Never commit that folder or treat `oofui.json` as entitlement.
Paid kits emit intent callbacks; keep authoritative item ownership, purchases,
currency, rewards, and request validation in the game's server code.

Use real game item images or a `renderPreview(itemId)` ViewportFrame composition.
Do not assume the seller's private Roblox image IDs are accessible to a buyer.
Use readable type, compact related groups, responsive grids and a clear selected
item. Avoid unrelated decoration or giant empty panels around small content.

## Verify the delivered game

Run `oofui doctor`, then `oofui build`. A Rojo build checks packaging, not runtime.
Use `oofui studio open` to open one owned disposable copy, press Play and inspect
the client Output, visual hierarchy, narrow layout, and actual interactions.
Use available Studio tools for inspection and input. Save wanted edits, then
`oofui studio close`; never kill unrelated Studio processes.

Report source/build, native behavior, and visual checks separately. If Studio
is unavailable, leave that verification explicitly pending. Do not claim a
successful runtime from a screenshot of another project.
