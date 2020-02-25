<p align="right">
  <a href="https://github.com/anthonynorth/using/releases/latest">
    <img src="https://img.shields.io/github/v/tag/anthonynorth/using?label=release&sort=semver" alt="release">
  </a>
  <a href="https://www.tidyverse.org/lifecycle/#experimental">
    <img src="https://img.shields.io/badge/lifecycle-experimental-orange.svg" alt="lifecycle" />
  </a>
  <a href="https://travis-ci.com/anthonynorth/using">
    <img src="https://travis-ci.com/anthonynorth/using.svg?branch=master" alt="build" />
  </a>
</p>

<h1 align="center">using</h1>

<p align="center">
  Add optional version constraints to <code>library</code> calls
</p>

# Installation

```r
remotes::install_github("anthonynorth/using@*release")
```

# Usage

```r
using(capsule, repo = "https://github.com/milesmcbain/capsule")
using(dplyr, min_version = "0.8.0")
using(h3jsr, min_version = "1.0.0", max_version = "1.2.0", repo = "https://github.com/obrl-soil/h3jsr")
```
