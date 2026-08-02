# sccache/tests/smoke.star — stable across upstream releases.
# Assert on the contract (exit code, version shape, computed result, env-var
# honoring), never on help/version prose. sccache is free to reword its banner;
# the version digits, the --show-stats exit code and the SCCACHE_DIR wiring are
# the contract.
#
# Container safety: sccache is a client/server tool, but `--show-stats` reads
# the local cache state DIRECTLY and spawns no daemon — verified on the real
# v0.10.0 and v0.17.0 musl binaries (no `sccache` process afterwards, and a
# follow-up `--stop-server` answers "couldn't connect to server"). So there is
# nothing to clean up, and no `--stop-server` call here: it exits 2 when no
# server is running and would red every leg. Never `--start-server`.
SCCACHE = "sccache.exe" if ocx.target_platform.os == ocx.os.Windows else "sccache"

# Tier 1 + 2: liveness + version SHAPE (semver digits, not a vendor string).
r_version = ocx.run(SCCACHE, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior. --show-stats reads real cache state and exits 0,
# exercising far more init than --version. The two tokens asserted are stats
# KEYS, not prose — byte-identical in v0.10.0 (the version floor) and v0.17.0,
# and they are what would disappear if the stats path regressed.
r_stats = ocx.run(SCCACHE, "--show-stats")
expect.ok(r_stats)
expect.contains(r_stats.stdout, "Compile requests")
expect.contains(r_stats.stdout, "Cache location")

# Tier 4: SCCACHE_DIR honoring. Point the cache at a scratch dir and prove the
# executable read the env var — --show-stats reports that dir as the cache
# location. Asserted on the LEAF name, not the full path: sccache prints the
# OS-native path (backslashes on Windows) while ocx.scratch_root is
# `/`-normalized, so a whole-path compare would red the two Windows legs alone.
# The leaf is enough — no default cache location on any platform contains it.
# (--show-stats does not lazily create the dir, so the reported location is the
# signal, not dir creation.)
ocx.mkdir("sccache-cache")
r_env = ocx.run(SCCACHE, "--show-stats", env={"SCCACHE_DIR": ocx.scratch_root + "/sccache-cache"})
expect.ok(r_env)
expect.contains(r_env.stdout, "sccache-cache")
