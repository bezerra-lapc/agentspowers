#!/usr/bin/env bash
# PreToolUse(Bash): bloqueia push direto para main/master, force push, --no-verify e troca de core.hooksPath.
exec python3 -I -c '
import json, re, sys
cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
if re.search(r"\bgit\s+push\b", cmd) and (
    re.search(r"(\s|:)(main|master)(\s|$)", cmd) or re.search(r"\s(-f|--force)(\s|$)", cmd)):
    sys.stderr.write("NO-PUSH-MAIN: push para main/master ou force push bloqueado. Use a branch da iniciativa e abra PR (/flow:finish).\n")
    sys.exit(2)
if re.search(r"\bgit\b[^;&|\n]*(--no-verify\b|core\.hooksPath)", cmd):
    sys.stderr.write("NO-VERIFY: hook do git que rejeita é sinal, não obstáculo. Corrija a causa; se o hook parecer errado, pare e fale com o usuário (methodology §13).\n")
    sys.exit(2)
'
