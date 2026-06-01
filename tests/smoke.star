# Stable smoke test — assert on the contract (exit code, version shape,
# functional behavior, env-var honoring), never on help/version prose.
# sccache reworks its stats labels and banners freely; the version digits,
# the --show-stats exit code, and the SCCACHE_DIR wiring are the contract.
SCCACHE = "sccache.exe" if ocx.target_platform.os == ocx.os.Windows else "sccache"

# Tier 1 + 2: liveness + version SHAPE (semver digits, not a vendor string).
r_version = ocx.run(SCCACHE, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior. --show-stats reads the local cache state and
# exits 0 — a deterministic op that exercises real init, stronger than --version.
r_stats = ocx.run(SCCACHE, "--show-stats")
expect.ok(r_stats)

# Tier 4: SCCACHE_DIR honoring. Point the cache at a scratch dir and prove the
# executable read the env var: --show-stats reports that exact path as the
# cache location. (--show-stats does not lazily create the dir, so we assert on
# the reported location, not on dir creation — a stable behavioral signal.)
ocx.mkdir("sccache-cache")
cache = ocx.scratch_root + "/sccache-cache"
r_env = ocx.run(SCCACHE, "--show-stats", env={"SCCACHE_DIR": cache})
expect.ok(r_env)
expect.contains(r_env.stdout, cache)
