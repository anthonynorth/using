prompt_install <- function(package) {

  to_install <-
    utils::menu(choices = c("yes", "no"),
                title = paste("A suitable version of package",
                              paste0("{",package,"}"),
                              "was not found. Would you like to install now?"))

  if (to_install == 1) TRUE else FALSE

}
