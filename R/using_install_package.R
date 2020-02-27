##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param package
##' @param min_version
##' @param repo
##' @return
##' @author Miles McBain
##' @export
using_install_package <- function(package, min_version, repo = NULL) {

  repo <- ifelse(is.null(repo),
                 yes = "CRAN",
                 no = repo)

  version_satisfied <-
    ifelse(
      repo == "CRAN",
      yes = using_install_cran(package, min_version),
      no = using_install_git(package, min_version, repo)
    )

  if (!version_satisfied) stop("could not a install", package,
                               "version", min_version, "or greater from", repo)

}

using_install_cran <- function(package, min_version) {

  if (is_satisfiable_cran) {
    install.packages(package)
    TRUE
  }
  else FALSE

}

is_satisfiable_cran <- function(package, min_version) {

  available_packages <-
    as.data.frame(utils::available.packages(), stringsAsFactors = FALSE)

  cran_version <-
    available_packages[available_packages$Package == package, ]$Version

  utils::compareVersion(cran_version, min_version) >= 0

}

using_install_git <- function(package, min_version, repo) {

  temp_dir <- tempdir()
  random_dir <- uuid::UUIDgenerate()
  pkg_dir <- file.path(temp_dir, random_dir)
  dir.create(pkg_dir)

  system2("git",
          args = c("clone", repo, "--depth", "1", "--no-hardlinks", pkg_dir))

  description_file <- read.dcf(file.path(pkg_dir, "DESCRIPTION"))

  if (utils::compareVersion(description_file[1,"Version"], min_version) < 0) return(FALSE)

  remotes::install_local(pkg_dir)

  TRUE
}
