# geckodriver/tests/smoke.star — stable across upstream geckodriver releases.
# Asserts the contract (exit codes, version shape, argument-validation
# behaviour), never help/version prose.
#
# geckodriver is a WebDriver SERVER: its success path binds a TCP port and
# blocks forever, and `ocx.run` has no timeout — so a "start it and see"
# assertion would hang the leg rather than fail it. Every check below is
# therefore offline, bounded and terminating: the binary parses its arguments,
# rejects the invalid ones with its own sysexits code, and exits. It also
# needs no Firefox — nothing here launches a browser.
# See ocx.mirror testing-practices.md.

GECKO = "geckodriver.exe" if ocx.target_platform.os == ocx.os.Windows else "geckodriver"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE. Not the vendor
# banner and not the exact version — the digits are the contract.
r_version = ocx.run(GECKO, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3a: the --log level set. geckodriver rejects an unknown level with
# EX_USAGE (64) — its own sysexits mapping, not the shell's — and enumerates
# the valid levels. Those are typed values a user passes to `--log`, i.e.
# stable identifiers, not prose. Asserted ONE WORD AT A TIME on purpose: a
# multi-word substring would be the wrong assertion against any output the
# runner decides to colorize, since SGR lands per token.
#
# `config` is the interesting one — it is a Gecko-specific level that exists in
# no generic log-level enum, so it is real evidence this is geckodriver and not
# some other binary that happened to ship under the name.
r_log = ocx.run(GECKO, "--log", "bogus")
expect.eq(r_log.exit_code, 64)
expect.contains(r_log.stderr, "fatal")
expect.contains(r_log.stderr, "config")
expect.contains(r_log.stderr, "trace")

# Tier 3b: geckodriver's OWN value validation, a different code path from the
# clap enum above — `--allow-origins` values are parsed as absolute URLs, and a
# bare word is rejected before the server ever reaches its bind call. Same
# EX_USAGE (64). Verified identical on v0.36.0 (oldest in range) and v0.37.1.
r_origins = ocx.run(GECKO, "--allow-origins", "notanorigin")
expect.eq(r_origins.exit_code, 64)
expect.contains(r_origins.stderr, "--allow-origins")

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).
