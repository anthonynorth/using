#' Optionally add version constraints to library calls
#'
#' This is function is deprecated. See [using::pkg()].
#'
#' @title using
#' @param ... arguments to pass to [using::pkg()]
#'
#' @return `{character | logical}`
#' attached packages, or boolean if `logical.return is TRUE`
#'
#' @examples
#' \dontrun{
#' using::pkg(capsule)
#' using::pkg(dplyr, min_version = "0.8.0")
#' using::pkg(h3jsr, min_version = "1.0.0", repo = "https://github.com/obrl-soil/h3jsr")
#' }
#'
#' @export
using <- function(...) {
  .Deprecated("pkg")
  pkg(...)
}
