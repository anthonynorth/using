#' Optionally add version constraints to library calls
#'
#' @title using
#' @param package `{character | name}` package name
#' @param min_version `{package_version | character}` min package version
#' @param repo `{character}` repo url
#' @param ... additional arguments to pass to [base::library()]
#'
#' @return `{character | logical}`
#' attached packages, or boolean if `logical.return is TRUE`
#'
#' @examples
#' \dontrun{
#' using(capsule)
#' using(dplyr, min_version = "0.8.0")
#' using(h3jsr, min_version = "1.0.0", repo = "https://github.com/obrl-soil/h3jsr")
#' }
#'
#' @md
#' @export
using <- function(package,
                  min_version = NULL,
                  repo = NULL,
                  ...) {
  package <- deparse(substitute(package))
  require(package, character.only = TRUE, quietly = TRUE)

  stopifnot(
    is.null(min_version) || inherits(
      min_version, c("character", "package_version")
    ),
    is.null(repo) || inherits(repo, "character")
  )

  version <- utils::packageVersion(package)

  if (!is.null(min_version) && version < min_version) {
    error_message <- paste0(
      "package '", package, "' version < ", min_version,
      if (!is.null(repo)) paste0("\n  repo: ", repo)
    )
    stop(error_message)
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
