#!/usr/bin/env bash
# PreToolUse(Bash): bloqueia `git commit` com código de produção staged sem nenhum teste staged.
# Bypass consciente: FLOW_SKIP_TDD=1 (docs, config, refactor puro).
exec python3 -I -c '
import json, os, re, subprocess, sys
d = json.load(sys.stdin)
cmd = d.get("tool_input", {}).get("command", "")
if not re.search(r"\bgit\s+commit\b", cmd) or os.environ.get("FLOW_SKIP_TDD") == "1":
    sys.exit(0)
files = subprocess.run(["git", "diff", "--cached", "--name-only"], capture_output=True, text=True).stdout.split()
is_test = lambda f: re.search(r"(^|/)(tests?|__tests__|spec)/|\.(test|spec)\.[a-z]+$|_test\.(go|py)$|(^|/)test_[^/]+\.py$", f)
is_code = lambda f: re.search(r"\.(js|jsx|ts|tsx|go|py|rs|java|kt|rb|php|cs|vue|svelte)$", f) and not is_test(f)
code = [f for f in files if is_code(f)]
if code and not any(is_test(f) for f in files):
    sys.stderr.write("TDD-GUARD: commit com código de produção sem teste staged:\n  " + "\n  ".join(code) +
        "\nEscreva o teste (RED) primeiro. Se não se aplica, use FLOW_SKIP_TDD=1.\n")
    sys.exit(2)
'
