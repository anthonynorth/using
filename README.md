<p align="right">
  <a href="https://github.com/anthonynorth/using/releases/latest">
    <img src="https://img.shields.io/github/v/release/anthonynorth/using?sort=semver&style=flat-square" alt="release">
  </a>
  <a href="https://www.tidyverse.org/lifecycle/#experimental">
    <img src="https://img.shields.io/badge/lifecycle-experimental-orange?style=flat-square" alt="lifecycle" />
  </a>
  <a href="https://travis-ci.com/anthonynorth/using">
    <img src="https://img.shields.io/travis/com/anthonynorth/using?style=flat-square" alt="build">
  </a>
</p>

<h1 align="center">using</h1>

<p align="center">
  Add version constraints and remote git repositories to <code>library()</code> calls. 
  In interactive mode a the user is prompted to install.
</p>

## Installation

```r
remotes::install_github("anthonynorth/using@*release")
```

## Usage

```r
using(capsule)
using(dplyr, min_version = "0.8.0")
using(h3jsr, min_version = "1.0.0", repo = "https://github.com/obrl-soil/h3jsr")
```
