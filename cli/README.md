# oofui

Editable native Roblox UI, with a CLI and project skill.

During prerelease, copy the one-line install command from the oof/ui docs site.
It downloads the audited `.tgz` and adds `oofui` to npm's global bin directory.
No shell profile edit or piped installer is needed when npm's bin is on PATH.
The package has no runtime npm dependencies or install scripts.

A global install is optional: use `npx --yes <download URL> init`, and use that
same prefix in place of `oofui` for every subsequent command. Npm publication
is still pending; do not assume `npx oofui@latest` is available yet.

```sh
oofui init
oofui component add progressbar
oofui skill add
oofui info --json
oofui add inventory --dry-run
oofui build
oofui studio open
```

Node 22.12+, Wally and Rojo are required for building. Run `rokit install` to
install the pinned Roblox tools. `init` creates or merges a Rojo game, pins React
dependencies in Wally, and installs the project skill. It does not replace game
code. Repeat adds preserve local edits; review conflicts before `--overwrite`.

Core includes Default and Light. Paid themes and Pro Plus kits are fetched only
through authenticated store routes. Run `oofui auth login --origin <store URL>
--token-stdin` with your access code provided securely on stdin. Credentials are
stored outside the project. Paid source goes in ignored `.oofui/private`; Rojo
mounts it alongside free source without copying it into a public directory.

`oofui studio open` uses Roblox's Studio CLI and tracks one disposable process.
Save wanted Studio edits before `oofui studio close`. Build success is not a
runtime test: press Play and inspect the UI and client Output.
