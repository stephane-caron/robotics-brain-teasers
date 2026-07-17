#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Compile the problems and assemble the HTML index.

By default it renders every problem to `build/problems/*.pdf` and assembles
`build/index.html`. With `--html` it renders standalone HTML versions instead.
"""

from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

from problem import ROOT, load_all, ProblemError

PROBLEMS = ROOT / "problems"
FIGURES = ROOT / "figures"
TEMPLATES = ROOT / "templates"
BUILD = ROOT / "build"

# PDF settings (mirror of the former Makefile PDF_PARAMETERS).
PDF_ARGS = [
    "--pdf-engine=tectonic",
    "-V", "documentclass:article",
    "-V", "fontsize:12pt",
    f"--include-in-header={TEMPLATES / 'header.tex'}",
]

# HTML5 settings.
HTML_ARGS = ["--katex=", "--standalone", "--to=html5"]

# Figures are referenced relative to the repo root (e.g. figures/foo.svg)
COMMON_ARGS = ["-f", "markdown", f"--resource-path={ROOT}"]


def pandoc(problem, args, out: Path) -> None:
    cmd = ["pandoc", *COMMON_ARGS, *args, "-o", str(out)]
    print(f"{' '.join(cmd)}  < {problem.path.relative_to(ROOT)}")
    subprocess.run(cmd, input=problem.rendered_markdown(), text=True, check=True)


def prepare_build_dir() -> None:
    (BUILD / "problems").mkdir(parents=True, exist_ok=True)
    shutil.copytree(FIGURES, BUILD / "figures", dirs_exist_ok=True)


def assemble_index() -> None:
    header = (TEMPLATES / "header.html").read_text()
    footer = (TEMPLATES / "footer.html").read_text()
    items = "\n".join(
        f'            <li><a href="problems/{pdf.name}">{pdf.stem}</a></li>'
        for pdf in sorted((BUILD / "problems").glob("*.pdf"))
    )
    (BUILD / "index.html").write_text(f"{header}{items}\n{footer}")


def build_pdfs(problems) -> None:
    prepare_build_dir()
    for problem in problems:
        pandoc(problem, PDF_ARGS, BUILD / "problems" / f"{problem.slug}.pdf")
    for asset in ("katex.min.css", "katex.min.js"):
        shutil.copyfile(TEMPLATES / asset, BUILD / asset)
    assemble_index()


def build_html(problems) -> None:
    prepare_build_dir()
    for problem in problems:
        pandoc(problem, HTML_ARGS, BUILD / "problems" / f"{problem.slug}.html")


def main() -> None:
    try:
        problems = load_all()
    except ProblemError as error:
        print(f"build: error: {error}", file=sys.stderr)
        sys.exit(1)

    if "--html" in sys.argv[1:]:
        build_html(problems)
    else:
        build_pdfs(problems)


if __name__ == "__main__":
    main()
