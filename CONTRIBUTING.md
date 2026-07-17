# Contributing

This repository is a collection of standalone problems written in Markdown with LaTeX math, compiled by pandoc into per-problem PDFs plus an index website. New robotics brain teasers are welcome!

## Setup

The toolchain (pandoc, the [Tectonic](https://tectonic-typesetting.github.io/) LaTeX engine, librsvg, Python and the linters) is pinned with [pixi](https://pixi.sh/). Install pixi, then let it take care of setting up the software for you:

```bash
pixi install
```

All commands below are run through `pixi run` so they use that environment.

## Adding a problem

1. **Add yourself to `data/authors.yaml`** (once), with your full name and GitHub profile URL, under a short `author-id`.
2. **Copy `templates/problem.md`** to `problems/NN_your_problem.md`.  The `NN_` numeric prefix sets the ordering; use the next free number.
3. **Fill in the front matter** at the top of the file:
   - `title:` the problem title.
   - `author:` your id from `data/authors.yaml` (or a list of ids).
4. **Write your problem**. You can follow the template structure.
5. **Regenerate the README problem list** so it picks up your entry:
   ```bash
   pixi run readme
   ```
6. **Build and check locally:**
   ```bash
   pixi run build   # compile all PDFs + the HTML index into build/
   pixi run open    # open the index in your browser
   pixi run lint    # spelling, links, and README freshness
   ```
7. **Commit and open a pull request.** CI will run the same pixi `lint` and `build` steps as above.

## Data model

- `data/authors.yaml` is the author directory. Problems reference authors by id, so a name or profile change is made in exactly one place.

## Licensing

Problems are shared under a [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/) license. Attribution is listed via the `author` tag and [authors.yaml](data/authors.yaml).
