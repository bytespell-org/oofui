# oofui

Editable native Roblox UI, with a CLI and project skill.

Install the standalone CLI from [the installation guide](https://oofui.bytespell.com/#/docs/installation).
No Node, npm, or Bun installation is needed. The installer adds the CLI to your
user account and sets up missing pinned Rojo/Wally tools. Rerun it to update.
Windows x64, macOS Apple silicon/Intel, and Linux x64 with glibc are supported.
Wally requires Rosetta on Apple silicon; Linux needs curl and unzip.

The npm package remains optional for users with Node 22.12+. It has no runtime
npm dependencies or install scripts. Npm registry publication remains pending;
use the tarball linked from the installation guide.

```sh
oofui init
oofui component add progressbar
oofui skill add
oofui info --json
oofui add inventory --dry-run
oofui build
oofui studio open
```

Run `oofui setup --yes` to set up missing Roblox tools. Existing compatible
Rojo/Wally installations are reused; managed tools are private to oofui. `init` creates or merges a Rojo game, pins React
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

## Updating installed source

Install the current CLI from the docs site; this leaves your game files alone.
Save your work, then run `oofui add <items...> --dry-run` to preview an update.
Repeat without `--dry-run` to apply it. Unchanged files stay unchanged; a conflict
stops the whole install before writing. Use `oofui view <item>` to inspect incoming
source and merge local changes. `--overwrite` replaces conflicting files and
dependencies, so preserve wanted edits first. Rebuild and test in Studio afterward.
