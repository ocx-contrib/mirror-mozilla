# NOTICE

This repository packages and redistributes upstream software published by
[Mozilla](https://github.com/mozilla). The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `sccache` | `ghcr.io/ocx-contrib/mozilla/sccache` | `Apache-2.0` |
| `geckodriver` | `ghcr.io/ocx-contrib/mozilla/geckodriver` | `MPL-2.0` |

---

## `sccache`

Upstream: <https://github.com/mozilla/sccache>
Published to `ghcr.io/ocx-contrib/mozilla/sccache`.

| Component | SPDX | Holder |
|---|---|---|
| sccache (`sccache`) | **Apache-2.0** | Mozilla Foundation and sccache contributors |

Permissive; redistribution of the compiled binary is granted provided the
license and any NOTICE text are retained. Upstream's release tarball ships its
own `LICENSE` alongside the executable, and `strip_components: 1` keeps that
file at the bundle's content root — so the Apache-2.0 text travels with every
mirrored artifact rather than being reproduced only here. The terms are those
of <https://github.com/mozilla/sccache/blob/main/LICENSE>. The published
binaries statically link third-party Rust crates under permissive licenses,
enumerated in upstream's `Cargo.lock`.

The sccache name is used for catalog identification under nominative fair use.
The logo shipped with this package is an OCX-authored lettermark, not an
official sccache mark — upstream ships no logo.

---

## `geckodriver`

Upstream: <https://github.com/mozilla/geckodriver>
Published to `ghcr.io/ocx-contrib/mozilla/geckodriver`.

| Component | SPDX | Holder |
|---|---|---|
| geckodriver (`geckodriver`) | **MPL-2.0** | Mozilla Foundation and geckodriver contributors |

Weak (file-level) copyleft. MPL-2.0 §3.2 grants redistribution of the
executable form, and its share-alike duty attaches to **modified MPL-covered
source files** — of which this mirror has none: upstream's own release binaries
are republished unchanged. The terms are those of
<https://github.com/mozilla/geckodriver/blob/master/LICENSE>.

**Corresponding source, per version.** MPL-2.0 §3.2(a) requires that recipients
of the executable be informed how to obtain the Source Code Form. geckodriver
is developed in `mozilla-central` and each release is tagged in the GitHub
repository, so for any mirrored version `X.Y.Z` the source is at:

- <https://github.com/mozilla/geckodriver/releases/tag/vX.Y.Z> — the release tag
- <https://hg.mozilla.org/mozilla-central/file/tip/testing/geckodriver> — the
  canonical source tree (`testing/geckodriver`), as the binary's own
  `--version` output states

The geckodriver name is used for catalog identification under nominative fair
use. The logo shipped with this package is an OCX-authored original mark, not
an official Mozilla or geckodriver mark — upstream ships no logo, and Mozilla's
Firefox marks are deliberately not reused here.

geckodriver drives Firefox but does not contain it: no Mozilla browser binary
is redistributed by this package.

---

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
