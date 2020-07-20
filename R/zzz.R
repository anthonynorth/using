.onAttach <- function(libname, pkgname)
{
  msg <-
    paste0("{using} should not be attached.\n",
           "Use the namespace prefix for all dependency declarations.\n",
           "E.g. using::pkg(...)")

  packageStartupMessage(msg)

  invisible()
}
