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
  In interactive mode the user is prompted to install.
</p>

## Installation

```r
remotes::install_github("anthonynorth/using@*release")
```

## Usage

Using is intended for use without being attached via `library(using)`. This
helps with detecting dependency declarations for [`capsule`](https://github.com/milesmcbain/capsule) or [`renv`](https://github.com/rstudio/renv/).

```r
using::pkg(capsule)
using::pkg(dplyr, min_version = "0.8.0")
using::pkg(h3jsr, min_version = "1.0.0", repo = "https://github.com/obrl-soil/h3jsr")
```

## Interactive use

In interactive sessions the user will be prompted to install a qualifying version of the package if one can be found at `repo` or CRAN if repo is missing. 

```
> using::pkg("rdeck", min_version = "0.2.5", repo = "http://github.com/anthonynorth/rdeck")
A suitable version of package {"rdeck"} was not found. Would you like to install now? 

1: yes
2: no

Selection: 1
Cloning into 'C:\Users\msmcbain\AppData\Local\Temp\RtmpgduuhY/3327d724-3531-412e-b21b-c7a1621e13d7'...
```
