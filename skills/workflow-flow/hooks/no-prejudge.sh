#!/usr/bin/env bash
# PreToolUse(Agent): bloqueia prompts de revisão e dry-run que pré-julgam achados.
exec python3 -I -c '
import json, re, sys
ti = json.load(sys.stdin).get("tool_input", {})
prompt = (ti.get("prompt") or "")
if not re.search(r"REVIEW BRIEF|DRY-RUN BRIEF|dry-run|audit|review|revis", prompt, re.I):
    sys.exit(0)
bad = re.search(r"n[ãa]o sinalize|isso n[ãa]o [ée] (um )?problema|ignore (isso|esse|este|o )|j[áa] sabemos que|don.t flag|not a problem|ignore this", prompt, re.I)
if bad:
    sys.stderr.write("NO-PREJUDGE: o prompt do revisor contém instrução que pré-julga achados (\"%s\"). Remova e envie só o brief.\n" % bad.group(0))
    sys.exit(2)
'
