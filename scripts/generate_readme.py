#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# SPDX-License-Identifier: Apache-2.0

"""Regenerate the "Problems" list in README.md from problem front matter.

Each problem in ``problems/*.md`` carries YAML front matter (see
``scripts/problem.py``) with ``title`` and ``author``. This script resolves the
author ids against ``data/authors.yaml``, then rewrites the block between the
``<!-- BEGIN PROBLEMS -->`` / ``<!-- END PROBLEMS -->`` markers in README.md.

Loading goes through the shared validator, so this doubles as a content check
in CI: unknown ids or missing front-matter fields make it exit non-zero.

Usage:
    python3 scripts/generate_readme.py            # rewrite README.md in place
    python3 scripts/generate_readme.py --check    # fail if README.md is out of date
"""

from __future__ import annotations

import re
import sys

from problem import ROOT, load_all, ProblemError

README = ROOT / "README.md"
PAGES_BASE = "https://stephane-caron.github.io/robotics-brain-teasers"

BEGIN = "<!-- BEGIN PROBLEMS -->"
END = "<!-- END PROBLEMS -->"


def fail(message: str) -> "NoReturn":  # noqa: F821
    print(f"generate_readme: error: {message}", file=sys.stderr)
    sys.exit(1)


def render_list(problems) -> str:
    lines = []
    for p in problems:
        pdf = f"{PAGES_BASE}/problems/{p.slug}.pdf"
        lines.append(f"- [{p.title}](problems/{p.slug}.md) ([PDF]({pdf}))")
    return "\n".join(lines)


def splice(readme_text: str, block: str) -> str:
    if BEGIN not in readme_text or END not in readme_text:
        fail(f"README.md is missing the {BEGIN} / {END} markers")
    pattern = re.compile(re.escape(BEGIN) + r".*?" + re.escape(END), re.DOTALL)
    return pattern.sub(f"{BEGIN}\n{block}\n{END}", readme_text)


def main() -> None:
    check = "--check" in sys.argv[1:]

    try:
        problems = load_all()
    except ProblemError as error:
        fail(str(error))

    updated = splice(README.read_text(), render_list(problems))

    if check:
        if updated != README.read_text():
            fail("README.md is out of date; run `pixi run readme` and commit")
        print("generate_readme: README.md is up to date")
        return

    README.write_text(updated)
    print(f"generate_readme: wrote {len(problems)} problems to README.md")


if __name__ == "__main__":
    main()
