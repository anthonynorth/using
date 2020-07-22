##' detect usage of using::pkg in a source file
##'
##' Intended for use when building lock files (e.g. for {renv}) from source
##' files.
##'
##' returns a data.frame of all information in using::pkg calls with columns:
##' `package`, `min_version`, `repo`. The value of a row may be NA if the
##' argument was not supplied.
##'
##' Each result row is guaranteed to be unique, however the result data frame may
##' contain near duplicates, e.g. using::pkg(janitor, min_version = "2.0.1") and
##' using::pkg(janitor, min_version = "1.0.0") would each create a row in the
##' result data frame if they appeared in the same file, due to differing
##' min_version.
##'
##' Each using::pkg call is parsed based on it's literal expression and no variable
##' substitution is done. So using(janitor, min_version = janitor_ver) would
##' place "janitor_ver" in the min_row column of the result for this dependency.
##'
##' @title detect_dependencies
##' @param file_path a length 1 character vector file path to an .R or .Rmd file
##' @return a data.frame summarising found using::pkg calls in the supplied file.
##' @author Miles McBain
##' @export
detect_dependencies <- function(file_path) {
  if (length(file_path) > 1) stop("file_path must be single file path not a vector of length > 1")

  if (!file.exists(file_path)) stop("could not find file ", file_path)

  file_type <-
    tolower(
      regmatches(
        file_path,
        regexpr("\\.[A-Za-z0-9]{1,3}$", file_path)
      )
    )

  if (!(file_type %in% c(".r", ".rmd"))) stop("detect_dependencies only supported for .R and .Rmd")

  deps <- switch(file_type,
    .r = parse_detect_deps(file_path, parse),
    .rmd = parse_detect_deps(file_path, parse_rmd),
    NULL
  )

  deps[!duplicated(deps), ]
}

parse_detect_deps <- function(file_path, file_parser) {
  syntax_tree <- tryCatch(file_parser(file = file_path),
    error = function(e) stop("Could not detect usage of using::pkg in due to invalid R code. The parser returned: \n", e$message)
  )

  get_using(syntax_tree)
}

parse_rmd <- function(file_path) {
  R_temp <- tempfile(fileext = ".R")
  on.exit(unlink(R_temp))

  withr::with_options(
    list(knitr.purl.inline = TRUE),
    knitr::purl(file_path,
      output = R_temp,
      quiet = TRUE
    )
  )

  parse(file = R_temp)
}


is_using_node <- function(ast_node) {
  node_list <- as.list(ast_node)
  name_node <- as.character(node_list[[1]])

  length(name_node) == 3 &&
    name_node[[1]] == "::" &&
    name_node[[2]] == "using" &&
    name_node[[3]] == "pkg"
}

extract_using_data <- function(ast_node) {
  node_list <- as.list(ast_node)
  node_list <- node_list[-1]
  char_nodes <- stats::setNames(
    lapply(node_list, as.character),
    names(node_list)
  )


  do.call(
    function(package = NA_character_,
             min_version = NA_character_,
             repo = NA_character_) {
      data.frame(
        package = package,
        min_version = min_version,
        repo = repo,
        stringsAsFactors = FALSE
      )
    },
    char_nodes
  )
}

get_using <- function(syntax_tree) {
  get_using_recurse <- function(syntax_tree_expr) {
    if (is.call(syntax_tree_expr)) {
      if (is_using_node(syntax_tree_expr)) {
        return(extract_using_data(syntax_tree_expr))
      } else {
        make_data_frame(lapply(syntax_tree_expr, get_using_recurse))
      }
    } else {
      return(NULL)
    }
  }

  make_data_frame(lapply(syntax_tree, get_using_recurse))
}

make_data_frame <- function(x) {
  result_dfs <- x[!unlist(lapply(x, is.null))]

  if (length(result_dfs) > 0) {
    do.call(rbind, c(result_dfs, stringsAsFactors = FALSE))
  } else {
    data.frame(
      package = character(0),
      min_version = character(0),
      repo = character(0), stringsAsFactors = FALSE
    )
  }
}
