using_install_package <- function(package, min_version = NULL, repo = NULL) {

  repo <-
    ifelse(
      is.null(repo),
      yes = "CRAN",
      no = repo
    )

  version_satisfied <-
    ifelse(
      repo == "CRAN",
      yes = using_install_cran(package, min_version),
      no = using_install_git(package, min_version, repo)
    )

  if (!version_satisfied) {
    stop(
      "Could not install ",
      package,
      " version ",
      min_version,
      " or greater from ",
      repo
    )
  }

}

using_install_cran <- function(package, min_version) {

  if (is_satisfiable_cran(package, min_version)) {
    utils::install.packages(package)
    TRUE
  }
  else {
    FALSE
  }

}

is_satisfiable_cran <- function(package, min_version) {

  ## if no version specified set to absolute min
  min_version <- ifelse(is.null(min_version),
                        "0.0.0",
                        min_version)

  available_packages <-
    as.data.frame(utils::available.packages(), stringsAsFactors = FALSE)


  cran_version <-
    available_packages[available_packages$Package == package, ]$Version

  if (length(cran_version) == 0) return(FALSE)

  utils::compareVersion(cran_version, min_version) >= 0

}

using_install_git <- function(package, min_version, repo) {

  temp_dir <- tempdir()
  random_dir <- uuid::UUIDgenerate()
  pkg_dir <- file.path(temp_dir, random_dir)
  dir.create(pkg_dir)
  on.exit(unlink(pkg_dir, recursive = TRUE))



  system2(
    "git",
    args = c("clone", repo, "--depth", "1", "--no-hardlinks", pkg_dir)
  )

  description_file <- read.dcf(file.path(pkg_dir, "DESCRIPTION"))

  if (utils::compareVersion(description_file[1, "Version"], min_version) < 0) {
    return(FALSE)
  }

  remotes::install_local(pkg_dir)

  ## need to update the package metadata with remote repo since remotes will not
  ## record a repo for local install we do this so renv can pick it up when
  ## documenting dependencies
  add_remote_meta(package, repo)

  TRUE
}

get_pkg_path <- function(package) {

  rds_path <- attr(utils::packageDescription(package), "file")
  pkg_path <- paste0(
    strsplit(rds_path, package)[[1]][1],
    package
  )
  pkg_path

}

## Code below is taken from package {remotes} (https://github.com/r-lib/remotes)
## and modified.
## The code has license is GPL >= 2
## Copyright holders are RStudio and Mango Solutions.

add_remote_meta <- function(package, repo) {

  pkg_path <- get_pkg_path(package)
  meta <- c(
    RemoteType = "xgit",
    RemoteUrl = repo
  )

  source_desc <- file.path(pkg_path, "DESCRIPTION")
  binary_desc <- file.path(pkg_path, "Meta", "package.rds")

  if (file.exists(source_desc)) {
    desc <- read.dcf(source_desc)
    desc <- cbind(desc, t(meta))
    write.dcf(desc, source_desc)
  }
  if (file.exists(binary_desc)) {
    pkg_desc <- base::readRDS(binary_desc)
    desc <- as.list(pkg_desc$DESCRIPTION)
    desc <- utils::modifyList(desc, as.list(meta))
    pkg_desc$DESCRIPTION <- stats::setNames(
      as.character(desc),
      names(desc)
    )
    base::saveRDS(pkg_desc, binary_desc)
  }
}
