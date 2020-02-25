#' Optionally add version constraints to library calls
#'
#' @title using
#' @param package `{character | name}` package name
#' @param min_version `{package_version | character}` min package version
#' @param max_version `{package_version | character}` max package version
#' @param repo `{character}` repo url
#' @param ... additional arguments to pass to [base::library()]
#'
#' @return `{character | logical}`
#' attached packages, or boolean if `logical.return is TRUE`
#'
#' @examples
#' \dontrun{
#' using(magrittr)
#' using(h3jsr, min_version = "1.0.0", repo = "https://github.com/obrl-soil/h3jsr")
#' using("rlang", max_version = "0.4.0")
#' }
#'
#' @md
#' @export
using <- function(package,
                  min_version = NULL,
                  max_version = NULL,
                  repo = NULL,
                  ...) {
  package <- deparse(substitute(package))
  require(package, character.only = TRUE, quietly = TRUE)

  stopifnot(
    is.null(min_version) || inherits(
      min_version, c("character", "package_version")
    ),
    is.null(max_version) || inherits(
      max_version, c("character", "package_version")
    ),
    is.null(repo) || inherits(repo, "character")
  )

  version <- utils::packageVersion(package)

  error_message <- function(mode) {
    constraint <- ifelse(
      mode == "min",
      paste("<", min_version),
      paste(">", max_version)
    )

    paste0(
      "package '", package, "' version ", constraint,
      if (!is.null(repo)) paste0("\n  repo: ", repo)
    )
  }

  if (!is.null(min_version) && version < min_version) {
    stop(error_message("min"))
  } else if (!is.null(max_version) && version > max_version) {
    stop(error_message("max"))
  }

  params <- c(
    list(
      package = package,
      character.only = TRUE
    ),
    list(...)
  )

  do.call(library, params)
}
