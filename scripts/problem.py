#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# SPDX-License-Identifier: Apache-2.0

"""Shared loading and validation of problem files.

A problem is a `problems/NN_name.md` file whose YAML front matter carries the
metadata, and whose body is *only* the prose. For instance:

    ---
    author: stephane-caron
    title: Flexible rod
    ---

    Consider the flexible rod ...

The `# Title` heading and the `*Author:*` line are generated from metadata.
See also `build.py`, which prepends them before handing the body to pandoc, and
`generate_readme.py`, which uses the same metadata for the README list.
"""

from __future__ import annotations

import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
PROBLEMS_DIR = ROOT / "problems"
DATA_DIR = ROOT / "data"

FRONT_MATTER_RE = re.compile(r"\A---\n(.*?)\n---\n?", re.DOTALL)


class ProblemError(Exception):
    """Raised on malformed front matter or an unresolved author."""


def _load_yaml(path: Path):
    if not path.exists():
        raise ProblemError(f"missing data file {path.relative_to(ROOT)}")
    return yaml.safe_load(path.read_text())


class Problem:
    def __init__(self, path: Path, authors: dict):
        self.path = path
        self.slug = path.stem
        rel = path.relative_to(ROOT)

        text = path.read_text()
        match = FRONT_MATTER_RE.match(text)
        if not match:
            raise ProblemError(
                f"{rel}: missing YAML front matter (--- ... ---) at top of file"
            )
        meta = yaml.safe_load(match.group(1)) or {}
        self.body = text[match.end():].lstrip("\n")

        self.title = meta.get("title")
        if not self.title:
            raise ProblemError(f"{rel}: front matter is missing a 'title' field")

        author_field = meta.get("author")
        if author_field is None:
            raise ProblemError(f"{rel}: front matter is missing an 'author' field")
        author_ids = [author_field] if isinstance(author_field, str) else list(author_field)
        self.authors = []
        for author_id in author_ids:
            if author_id not in authors:
                raise ProblemError(
                    f"{rel}: unknown author id '{author_id}' "
                    "(add it to data/authors.yaml)"
                )
            self.authors.append(authors[author_id])

    @property
    def author_links(self) -> str:
        """Author names as markdown links, e.g. ``[Full Name](github-url)``."""
        return ", ".join(f"[{a['name']}]({a['github']})" for a in self.authors)

    def rendered_markdown(self) -> str:
        """The body with the generated title heading and author line prepended."""
        return f"# {self.title}\n\n*Author:* {self.author_links}\n\n{self.body}"


def load_all() -> list[Problem]:
    """Load and validate every problem, ordered by filename."""
    authors = _load_yaml(DATA_DIR / "authors.yaml") or {}
    problems = [
        Problem(path, authors)
        for path in sorted(PROBLEMS_DIR.glob("*.md"))
    ]
    if not problems:
        raise ProblemError("no problems found in problems/*.md")
    return problems
