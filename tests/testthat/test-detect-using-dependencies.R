test_that("detecting using works", {

  ## test rmd
  rmd_deps <- detect_dependencies(test_path("test_inputs/deps_using_rmd.Rmd"))

  expect_equal(
    rmd_deps$package,
    c("qfes", "ffdi", "datapasta", "slippymath"))

  expect_equal(
    rmd_deps$min_version,
    c("0.2.1", "0.1.3", NA, "0.1.0"))

  expect_equal(
    rmd_deps$repo,
    c("https://github.com/qfes/qfes.git",
      "https://qfes@dev.azure.com/qfes/packages/_git/ffdi",
      "https://github.com/milesmcbain/datapasta",
      NA))

  ## test R
  r_deps <- detect_dependencies(test_path("test_inputs/deps_using.R"))

  expect_equal(
    r_deps$package,
    c("qfes", "ffdi"))

  ## test dupes
  dupe_deps <- detect_dependencies(test_path("test_inputs/deps_using_dupes.R"))

  expect_equal(
    dupe_deps$package,
    c("qfes", "ffdi", "rdeck", "ffdi", "rdeck"))


  ## test none
  none_deps <- detect_dependencies(test_path("test_inputs/deps_vanilla.R"))

  expect_true(nrow(none_deps) == 0)
  expect_equal(names(none_deps),
               c("package", "min_version", "repo"))

  ## test parse fail
  expect_error(detect_dependencies(test_path("test_inputs/deps_parse_fail.R")),
               "Could not detect usage of using::pkg in due to invalid R code.")

  ## test unsupported file
  expect_error(detect_dependencies(test_path("test_inputs/deps_md.md")),
               "detect_dependencies only supported for .R and .Rmd")

  ## test only 1 file path supported
  expect_error(detect_dependencies(c(test_path("test_inputs/deps_using.R"),
                                     "test_inputs/deps_parse_fail.R")),
               "file_path must be single file path not a vector of length > 1")

  ## test file not found
  expect_error(detect_dependencies(test_path("test_inputs/does_not_exist.R")),
               "could not find file")

})
