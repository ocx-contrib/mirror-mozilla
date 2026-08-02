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

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
