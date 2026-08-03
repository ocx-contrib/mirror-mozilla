# mirror-mozilla

OCX mirrors for [Mozilla](https://github.com/mozilla) tools. One repository, one
spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [sccache](https://github.com/mozilla/sccache) | [`sccache/mirror.yml`](sccache/mirror.yml) | `ghcr.io/ocx-contrib/mozilla/sccache` | `ocx.sh/mozilla/sccache` | `Apache-2.0` |
| [geckodriver](https://github.com/mozilla/geckodriver) | [`geckodriver/mirror.yml`](geckodriver/mirror.yml) | `ghcr.io/ocx-contrib/mozilla/geckodriver` | `ocx.sh/mozilla/geckodriver` | `MPL-2.0` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/sccache` (as `mirror-sccache`). `mozilla/sccache` is the grouped
> successor — upstream's org handle *is* the vendor identity, so it names the
> namespace directly.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
sccache/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
geckodriver/            same shape
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`sccache` publishes six platform entries: both Linux arches, both macOS arches
and both Windows arches. Upstream's Linux builds target musl and are linked
**fully statically** — no `PT_INTERP`, no `DT_NEEDED` on either arch — and
upstream ships **no gnu variant** for x86_64 or aarch64 (the only
`-unknown-linux-gnu` asset is s390x, an unrelated arch). `os.features` states
what an artifact requires *of the host*, so both Linux keys are **bare**:
tagging them `+libc.musl` would be a false requirement that hid them from every
glibc host. The `alpine:3.20` container leg in `mirror-base.yml` is what turns
that claim into evidence; the measurement itself is recorded above the
`assets:` block in `sccache/mirror.yml`.

The anchored `^sccache-v…\.tar\.gz$` patterns are load-bearing: they exclude
the `sccache-dist-*` distributed-build server bundles (a different product),
the redundant Windows `.zip` twins and the `.sha256` sidecars. Resolution is
verified both ways across every in-range release — with one recorded upstream
gap: **v0.13.0 ships no `x86_64-apple-darwin` tarball**, so that one version
publishes five platforms.

`geckodriver` measures the same way — both Linux arches are fully static, no
`PT_INTERP` and no `DT_NEEDED` on v0.36.0 or v0.37.1 — so it too takes bare
Linux keys with the alpine leg. It restates `platforms:` anyway, because it is
mid **staged rollout**: linux ships first and the darwin/windows keys sit in
the spec as comments, in both `assets:` and `platforms:`, uncommented one pass
at a time. A platform declared without a matching `assets:` key still boots a
runner and reports success having tested nothing, which is why the two blocks
move together.

Upstream's geckodriver naming is bespoke Mozilla (`linux64`, `linux-aarch64`,
`macos`, `win64`, `win-aarch64`), not Rust target triples, and every Linux
asset has a `.tar.gz.asc` signature sibling — the `$`-anchored patterns are
what keep those out. 32-bit `linux32`/`win32` are not carried: OCX's
`Architecture` enum supports only `amd64` and `arm64`, and upstream dropped
`linux32` entirely after v0.36.0 anyway.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `<pkg>/mirror.yml` | hand | yes — see below |
| `<pkg>/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `<pkg>/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci \
  --spec sccache/mirror.yml \
  --spec geckodriver/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

Upstream's sccache tarball is `sccache-v<v>-<target>/{sccache,LICENSE,README.md}`
— a version- and target-stamped wrapper with no `bin/` subdirectory. That name
changes with every version and platform, so no static `metadata.json` could
point PATH at it; `strip_components: 1` puts the executable at the content root
and PATH is a bare `${installPath}`. `bin_scan` only looks *below* an
`${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec load with
exit 65. `mirror-base.yml` therefore sets `bin_scan: off` and
`sccache/metadata.json` hand-lists `binaries: ["sccache"]` — the blessed shape
for this layout.

geckodriver reaches the same place from the other direction: its archives have
**no wrapper directory at all** — the tarball's single member is the executable
— so it sets `strip_components: 0` (stripping one component off a flat archive
would discard the only entry) and likewise hand-lists its `binaries`.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).
